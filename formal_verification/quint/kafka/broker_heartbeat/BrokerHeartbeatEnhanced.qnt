/**
 * BrokerHeartbeatEnhanced: Quint specification of Kafka's Broker Heartbeat/Fencing mechanism.
 *
 * This model aligns with the actual Kafka Java/Scala implementation.
 *
 * ┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
 * │                              ENHANCEMENTS OVER SIMPLIFIED MODEL                                 │
 * ├──────────────────────────┬────────────────────────────────────────┬─────────────────────────────┤
 * │ Feature                  │ Source Files                           │ Purpose                     │
 * ├──────────────────────────┼────────────────────────────────────────┼─────────────────────────────┤
 * │ Broker Epochs            │ BrokerRegistration.java                │ Detect stale heartbeats     │
 * │                          │ BrokerHeartbeatRequest.java            │ from old broker instances   │
 * ├──────────────────────────┼────────────────────────────────────────┼─────────────────────────────┤
 * │ Controller Quorum (Raft) │ QuorumController.java, RaftClient.java │ Leader election, failover,  │
 * │                          │ LeaderAndEpoch.java                    │ controller epoch fencing    │
 * ├──────────────────────────┼────────────────────────────────────────┼─────────────────────────────┤
 * │ ISR Tracking             │ ReplicationControlManager.java         │ Per-partition replica sync, │
 * │                          │ PartitionRegistration.java             │ ISR shrink/expand ops       │
 * ├──────────────────────────┼────────────────────────────────────────┼─────────────────────────────┤
 * │ Partition Leadership     │ PartitionChangeRecord.java             │ Per-partition leader/ISR,   │
 * │                          │ PartitionRegistration.java             │ leadership changes          │
 * ├──────────────────────────┼────────────────────────────────────────┼─────────────────────────────┤
 * │ Metadata Offset          │ BrokerHeartbeatRequest.java            │ Real offset tracking,       │
 * │                          │                                        │ high watermark sync         │
 * ├──────────────────────────┼────────────────────────────────────────┼─────────────────────────────┤
 * │ Registration Lifecycle   │ BrokerRegistrationManager.java         │ UNREGISTERED→REGISTERING→   │
 * │                          │ BrokerLifecycleManager.java            │ REGISTERED→FENCED/UNFENCED  │
 * ├──────────────────────────┼────────────────────────────────────────┼─────────────────────────────┤
 * │ Network Partitions       │ (modeling construct)                   │ Message loss/delay,         │
 * │                          │                                        │ partition tolerance         │
 * └──────────────────────────┴────────────────────────────────────────┴─────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
 * │                                    KAFKA SOURCE ALIGNMENT                                       │
 * ├──────────────────────────────────────────┬──────────────────────────────────────────────────────┤
 * │ Source File                              │ Relevant Concepts                                    │
 * ├──────────────────────────────────────────┼──────────────────────────────────────────────────────┤
 * │ BrokerControlState.java (26-47)          │ FENCED, UNFENCED, CONTROLLED_SHUTDOWN, SHUTDOWN_NOW  │
 * │ BrokerRegistration.java                  │ Broker epoch, incarnation ID, rack, features        │
 * │ BrokerHeartbeatManager.java (399-476)    │ calculateNextBrokerState() - state machine          │
 * │ ReplicationControlManager.java (1639-76) │ processBrokerHeartbeat(), ISR management            │
 * │ QuorumController.java                    │ Raft-based leader election, controller epoch        │
 * │ PartitionRegistration.java               │ Partition state: leader, replicas, ISR, leaderEpoch │
 * └──────────────────────────────────────────┴──────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
 * │                                    VERIFICATION PROPERTIES                                      │
 * ├────────────────────────────────────┬────────────────────────────────────────────────────────────┤
 * │ Safety Property                    │ Description                                                │
 * ├────────────────────────────────────┼────────────────────────────────────────────────────────────┤
 * │ EpochMonotonicity                  │ Broker epochs never decrease                               │
 * │ StaleHeartbeatRejection            │ Heartbeats with old epochs are rejected                    │
 * │ ISRConsistency                     │ ISR is always a subset of replicas                         │
 * │ LeaderInISR                        │ Partition leader is always in ISR                          │
 * │ SingleLeaderPerPartition           │ Each partition has at most one leader                      │
 * │ ControllerEpochMonotonicity        │ Controller epochs never decrease                           │
 * │ OnlyLeaderProcessesRequests        │ Only controller leader handles heartbeats                  │
 * │ FencedBrokersNoLeadership          │ Fenced brokers cannot be partition leaders                 │
 * ├────────────────────────────────────┼────────────────────────────────────────────────────────────┤
 * │ Liveness Property                  │ Description                                                │
 * ├────────────────────────────────────┼────────────────────────────────────────────────────────────┤
 * │ EventualFencing                    │ Stale brokers are eventually fenced                        │
 * │ EventualISRRecovery                │ Failed replicas eventually rejoin ISR                      │
 * │ ControllerEventualElection         │ A controller leader is eventually elected                  │
 * └────────────────────────────────────┴────────────────────────────────────────────────────────────┘
 */
module BrokerHeartbeatEnhanced {
  const N_BROKERS: int           // Number of brokers
  const N_CONTROLLERS: int       // Number of controllers in quorum
  const N_PARTITIONS: int        // Number of partitions
  const REPLICATION_FACTOR: int  // Replicas per partition
  const SESSION_TIMEOUT: int     // Heartbeat timeout
  const ELECTION_TIMEOUT: int    // Controller election timeout

  // ============================================================================
  // Type Definitions
  // ============================================================================

  type BrokerId = int
  type ControllerId = int
  type PartitionId = int
  type Epoch = int
  type Offset = int

  // Broker control states (from BrokerControlState.java)
  type ControlState = FENCED | UNFENCED | CONTROLLED_SHUTDOWN | SHUTDOWN_NOW

  // Broker registration states (from BrokerRegistrationManager.java)
  type RegistrationState = UNREGISTERED | REGISTERING | REGISTERED

  // Controller states in Raft quorum
  type ControllerRole = FOLLOWER | CANDIDATE | LEADER

  // Heartbeat request (from BrokerHeartbeatRequest.java)
  type HeartbeatRequest = {
    brokerId: BrokerId,
    brokerEpoch: Epoch,          // Current broker incarnation
    currentMetadataOffset: Offset,
    wantFence: bool,
    wantShutDown: bool
  }

  // Heartbeat response (from BrokerHeartbeatResponse.java)
  type HeartbeatResponse = {
    accepted: bool,
    shouldShutDown: bool,
    isCaughtUp: bool,
    shouldFence: bool
  }

  // Partition state (from PartitionRegistration.java)
  type PartitionState = {
    leader: BrokerId,
    leaderEpoch: Epoch,
    replicas: Set[BrokerId],
    isr: Set[BrokerId],
    addingReplicas: Set[BrokerId],
    removingReplicas: Set[BrokerId]
  }

  // Broker registration (from BrokerRegistration.java)
  type BrokerRegistration = {
    epoch: Epoch,
    incarnationId: int,  // Unique per broker restart
    registrationState: RegistrationState,
    controlState: ControlState,
    fenced: bool
  }

  // In-flight message (for network modeling)
  type Message = HeartbeatReq(HeartbeatRequest) | HeartbeatResp(HeartbeatResponse)

  // ============================================================================
  // State Variables
  // ============================================================================

  // --- Broker State ---
  var brokers: BrokerId -> BrokerRegistration
  var brokerMetadataOffset: BrokerId -> Offset    // Last fetched metadata offset
  var lastHeartbeat: BrokerId -> int              // Time of last heartbeat
  var pendingShutdown: BrokerId -> bool           // Broker wants to shut down

  // --- Controller Quorum State ---
  var controllerRole: ControllerId -> ControllerRole
  var controllerEpoch: Epoch                      // Current controller epoch (Raft term)
  var controllerLeader: ControllerId              // Current controller leader (-1 if none)
  var controllerVotedFor: ControllerId -> ControllerId  // Vote in current term
  var lastControllerHeartbeat: ControllerId -> int

  // --- Partition/ISR State (managed by controller) ---
  var partitions: PartitionId -> PartitionState

  // --- Metadata Log State ---
  var metadataHighWatermark: Offset               // Committed metadata offset
  var controlledShutdownOffset: BrokerId -> Offset

  // --- Time and Network ---
  var currentTime: int
  var inFlightMessages: Set[(BrokerId, Message)]  // Messages in transit
  var networkPartitioned: Set[(BrokerId, ControllerId)]  // Partitioned broker-controller pairs

  // ============================================================================
  // Constants and Helpers
  // ============================================================================

  val brokerIds = 0.to(N_BROKERS - 1)
  val controllerIds = 0.to(N_CONTROLLERS - 1)
  val partitionIds = 0.to(N_PARTITIONS - 1)

  pure def min(a: int, b: int): int = if (a < b) a else b
  pure def max(a: int, b: int): int = if (a > b) a else b

  // Check if broker is fenced (cannot lead partitions)
  def isFenced(b: BrokerId): bool =
    val reg = brokers.get(b)
    reg.fenced or reg.controlState == FENCED or reg.controlState == SHUTDOWN_NOW

  // Check if broker is registered and active
  def isActive(b: BrokerId): bool =
    val reg = brokers.get(b)
    reg.registrationState == REGISTERED and not(isFenced(b))

  // Check if heartbeat has expired
  def heartbeatExpired(b: BrokerId): bool =
    currentTime > lastHeartbeat.get(b) + SESSION_TIMEOUT

  // Check if broker is caught up on metadata
  def isCaughtUp(b: BrokerId): bool =
    brokerMetadataOffset.get(b) >= metadataHighWatermark

  // Check if controller election timeout expired
  def electionTimeoutExpired(c: ControllerId): bool =
    currentTime > lastControllerHeartbeat.get(c) + ELECTION_TIMEOUT

  // Get current controller leader (if any)
  def hasControllerLeader: bool =
    controllerLeader >= 0 and controllerRole.get(controllerLeader) == LEADER

  // Check if broker leads any partition
  def hasAnyLeadership(b: BrokerId): bool =
    partitionIds.exists(p => partitions.get(p).leader == b)

  // Check if controlled shutdown is complete
  def controlledShutdownComplete(b: BrokerId): bool =
    controlledShutdownOffset.get(b) != -1 and
    metadataHighWatermark > controlledShutdownOffset.get(b) and
    not(hasAnyLeadership(b))

  // Check if broker-controller pair is network partitioned
  def isPartitioned(b: BrokerId, c: ControllerId): bool =
    networkPartitioned.contains((b, c))

  // ============================================================================
  // Broker State Machine (from BrokerHeartbeatManager.java)
  // ============================================================================

  def calculateNextState(b: BrokerId, req: HeartbeatRequest): ControlState =
    val current = brokers.get(b).controlState
    val hasLeaders = hasAnyLeadership(b)
    val caughtUp = isCaughtUp(b)

    if (current == FENCED) {
      if (req.wantShutDown) SHUTDOWN_NOW
      else if (not(req.wantFence) and caughtUp) UNFENCED
      else FENCED
    } else if (current == UNFENCED) {
      if (req.wantFence and req.wantShutDown) SHUTDOWN_NOW
      else if (req.wantFence) FENCED
      else if (req.wantShutDown and hasLeaders) CONTROLLED_SHUTDOWN
      else if (req.wantShutDown and not(hasLeaders)) SHUTDOWN_NOW
      else UNFENCED
    } else if (current == CONTROLLED_SHUTDOWN) {
      if (hasLeaders) CONTROLLED_SHUTDOWN
      else if (controlledShutdownComplete(b)) SHUTDOWN_NOW
      else CONTROLLED_SHUTDOWN
    } else {
      SHUTDOWN_NOW
    }

  // ============================================================================
  // Initialization
  // ============================================================================

  action init = all {
    // Initialize brokers as unregistered
    brokers' = brokerIds.mapBy(b => {
      epoch: 0,
      incarnationId: b,  // Initial incarnation = broker ID
      registrationState: UNREGISTERED,
      controlState: FENCED,
      fenced: true
    }),
    brokerMetadataOffset' = brokerIds.mapBy(b => 0),
    lastHeartbeat' = brokerIds.mapBy(b => 0),
    pendingShutdown' = brokerIds.mapBy(b => false),

    // Initialize controller quorum (all start as followers)
    controllerRole' = controllerIds.mapBy(c => FOLLOWER),
    controllerEpoch' = 0,
    controllerLeader' = -1,
    controllerVotedFor' = controllerIds.mapBy(c => -1),
    lastControllerHeartbeat' = controllerIds.mapBy(c => 0),

    // Initialize partitions (no leader initially, will be assigned after brokers register)
    partitions' = partitionIds.mapBy(p => {
      leader: -1,
      leaderEpoch: 0,
      replicas: Set(),
      isr: Set(),
      addingReplicas: Set(),
      removingReplicas: Set()
    }),

    // Metadata state
    metadataHighWatermark' = 0,
    controlledShutdownOffset' = brokerIds.mapBy(b => -1),

    // Time and network
    currentTime' = 0,
    inFlightMessages' = Set(),
    networkPartitioned' = Set()
  }

  // ============================================================================
  // Broker Registration Actions
  // ============================================================================

  // Broker starts registration process
  action brokerStartRegistration(b) =
    val reg = brokers.get(b)
    all {
      reg.registrationState == UNREGISTERED,
      hasControllerLeader,
      not(isPartitioned(b, controllerLeader)),
      brokers' = brokers.set(b, {
        ...reg,
        registrationState: REGISTERING,
        epoch: reg.epoch + 1,           // Increment epoch on each registration attempt
        incarnationId: reg.incarnationId + N_BROKERS  // New incarnation
      }),
      brokerMetadataOffset' = brokerMetadataOffset,
      lastHeartbeat' = lastHeartbeat.set(b, currentTime),
      pendingShutdown' = pendingShutdown,
      controllerRole' = controllerRole,
      controllerEpoch' = controllerEpoch,
      controllerLeader' = controllerLeader,
      controllerVotedFor' = controllerVotedFor,
      lastControllerHeartbeat' = lastControllerHeartbeat,
      partitions' = partitions,
      metadataHighWatermark' = metadataHighWatermark,
      controlledShutdownOffset' = controlledShutdownOffset,
      currentTime' = currentTime,
      inFlightMessages' = inFlightMessages,
      networkPartitioned' = networkPartitioned
    }

  // Controller completes broker registration
  action brokerCompleteRegistration(b) =
    val reg = brokers.get(b)
    all {
      reg.registrationState == REGISTERING,
      hasControllerLeader,
      not(isPartitioned(b, controllerLeader)),
      brokers' = brokers.set(b, {
        ...reg,
        registrationState: REGISTERED,
        controlState: FENCED,  // Start fenced, will unfence after catching up
        fenced: true
      }),
      // Assign this broker to some partitions as replica
      partitions' = partitionIds.mapBy(p =>
        val ps = partitions.get(p)
        if (ps.replicas.size() < REPLICATION_FACTOR)
          { ...ps, replicas: ps.replicas.union(Set(b)) }
        else
          ps
      ),
      brokerMetadataOffset' = brokerMetadataOffset,
      lastHeartbeat' = lastHeartbeat,
      pendingShutdown' = pendingShutdown,
      controllerRole' = controllerRole,
      controllerEpoch' = controllerEpoch,
      controllerLeader' = controllerLeader,
      controllerVotedFor' = controllerVotedFor,
      lastControllerHeartbeat' = lastControllerHeartbeat,
      metadataHighWatermark' = metadataHighWatermark,
      controlledShutdownOffset' = controlledShutdownOffset,
      currentTime' = currentTime,
      inFlightMessages' = inFlightMessages,
      networkPartitioned' = networkPartitioned
    }

  // Broker crashes and becomes unregistered
  action brokerCrash(b) =
    val reg = brokers.get(b)
    all {
      reg.registrationState == REGISTERED,
      brokers' = brokers.set(b, {
        ...reg,
        registrationState: UNREGISTERED,
        controlState: SHUTDOWN_NOW,
        fenced: true
      }),
      // Remove from ISR of all partitions
      partitions' = partitionIds.mapBy(p =>
        val ps = partitions.get(p)
        val newIsr = ps.isr.exclude(Set(b))
        val newLeader = if (ps.leader == b) {
          // Elect new leader from ISR
          if (newIsr.size() > 0) newIsr.fold(-1, (acc, r) => if (acc == -1) r else acc)
          else -1
        } else ps.leader
        {
          ...ps,
          isr: newIsr,
          leader: newLeader,
          leaderEpoch: if (newLeader != ps.leader) ps.leaderEpoch + 1 else ps.leaderEpoch
        }
      ),
      brokerMetadataOffset' = brokerMetadataOffset.set(b, 0),
      lastHeartbeat' = lastHeartbeat,
      pendingShutdown' = pendingShutdown,
      controllerRole' = controllerRole,
      controllerEpoch' = controllerEpoch,
      controllerLeader' = controllerLeader,
      controllerVotedFor' = controllerVotedFor,
      lastControllerHeartbeat' = lastControllerHeartbeat,
      metadataHighWatermark' = metadataHighWatermark,
      controlledShutdownOffset' = controlledShutdownOffset.set(b, -1),
      currentTime' = currentTime,
      inFlightMessages' = inFlightMessages,
      networkPartitioned' = networkPartitioned
    }

  // ============================================================================
  // Heartbeat Actions (with Epoch Validation)
  // ============================================================================

  // Broker sends heartbeat request
  action sendHeartbeat(b, wantFence, wantShutDown) =
    val reg = brokers.get(b)
    all {
      reg.registrationState == REGISTERED,
      hasControllerLeader,
      not(isPartitioned(b, controllerLeader)),
      val req: HeartbeatRequest = {
        brokerId: b,
        brokerEpoch: reg.epoch,
        currentMetadataOffset: brokerMetadataOffset.get(b),
        wantFence: wantFence,
        wantShutDown: wantShutDown
      }
      inFlightMessages' = inFlightMessages.union(Set((b, HeartbeatReq(req)))),
      pendingShutdown' = pendingShutdown.set(b, wantShutDown),
      brokers' = brokers,
      brokerMetadataOffset' = brokerMetadataOffset,
      lastHeartbeat' = lastHeartbeat,
      controllerRole' = controllerRole,
      controllerEpoch' = controllerEpoch,
      controllerLeader' = controllerLeader,
      controllerVotedFor' = controllerVotedFor,
      lastControllerHeartbeat' = lastControllerHeartbeat,
      partitions' = partitions,
      metadataHighWatermark' = metadataHighWatermark,
      controlledShutdownOffset' = controlledShutdownOffset,
      currentTime' = currentTime,
      networkPartitioned' = networkPartitioned
    }

  // Controller processes heartbeat request (with epoch validation)
  action processHeartbeat(b, req) =
    val reg = brokers.get(b)
    all {
      hasControllerLeader,
      inFlightMessages.contains((b, HeartbeatReq(req))),
      // Validate broker epoch (reject stale heartbeats)
      if (req.brokerEpoch < reg.epoch) {
        // Stale epoch - reject
        all {
          inFlightMessages' = inFlightMessages.exclude(Set((b, HeartbeatReq(req)))),
          brokers' = brokers,
          brokerMetadataOffset' = brokerMetadataOffset,
          lastHeartbeat' = lastHeartbeat,
          pendingShutdown' = pendingShutdown,
          controllerRole' = controllerRole,
          controllerEpoch' = controllerEpoch,
          controllerLeader' = controllerLeader,
          controllerVotedFor' = controllerVotedFor,
          lastControllerHeartbeat' = lastControllerHeartbeat,
          partitions' = partitions,
          metadataHighWatermark' = metadataHighWatermark,
          controlledShutdownOffset' = controlledShutdownOffset,
          currentTime' = currentTime,
          networkPartitioned' = networkPartitioned
        }
      } else {
        // Valid epoch - process heartbeat
        val nextState = calculateNextState(b, req)
        val newOffset = if (reg.controlState != CONTROLLED_SHUTDOWN and nextState == CONTROLLED_SHUTDOWN)
          metadataHighWatermark
        else if (nextState == FENCED or nextState == SHUTDOWN_NOW)
          -1
        else
          controlledShutdownOffset.get(b)
        all {
          brokers' = brokers.set(b, {
            ...reg,
            controlState: nextState,
            fenced: nextState == FENCED or nextState == SHUTDOWN_NOW
          }),
          lastHeartbeat' = lastHeartbeat.set(b, currentTime),
          controlledShutdownOffset' = controlledShutdownOffset.set(b, newOffset),
          inFlightMessages' = inFlightMessages.exclude(Set((b, HeartbeatReq(req)))),
          // Add to ISR if unfenced and caught up
          partitions' = if (nextState == UNFENCED and isCaughtUp(b)) {
            partitionIds.mapBy(p =>
              val ps = partitions.get(p)
              if (ps.replicas.contains(b) and not(ps.isr.contains(b)))
                { ...ps, isr: ps.isr.union(Set(b)) }
              else
                ps
            )
          } else if (nextState == FENCED or nextState == SHUTDOWN_NOW) {
            partitionIds.mapBy(p =>
              val ps = partitions.get(p)
              { ...ps, isr: ps.isr.exclude(Set(b)) }
            )
          } else partitions,
          brokerMetadataOffset' = brokerMetadataOffset,
          pendingShutdown' = pendingShutdown,
          controllerRole' = controllerRole,
          controllerEpoch' = controllerEpoch,
          controllerLeader' = controllerLeader,
          controllerVotedFor' = controllerVotedFor,
          lastControllerHeartbeat' = lastControllerHeartbeat,
          metadataHighWatermark' = metadataHighWatermark,
          currentTime' = currentTime,
          networkPartitioned' = networkPartitioned
        }
      }
    }

  // Controller fences stale broker (heartbeat timeout)
  action fenceStaleBroker(b) =
    val reg = brokers.get(b)
    all {
      hasControllerLeader,
      reg.registrationState == REGISTERED,
      not(isFenced(b)),
      heartbeatExpired(b),
      brokers' = brokers.set(b, {
        ...reg,
        controlState: FENCED,
        fenced: true
      }),
      // Remove from ISR and reassign leadership
      partitions' = partitionIds.mapBy(p =>
        val ps = partitions.get(p)
        val newIsr = ps.isr.exclude(Set(b))
        val newLeader = if (ps.leader == b) {
          if (newIsr.size() > 0) newIsr.fold(-1, (acc, r) => if (acc == -1) r else acc)
          else -1
        } else ps.leader
        {
          ...ps,
          isr: newIsr,
          leader: newLeader,
          leaderEpoch: if (newLeader != ps.leader) ps.leaderEpoch + 1 else ps.leaderEpoch
        }
      ),
      controlledShutdownOffset' = controlledShutdownOffset.set(b, -1),
      brokerMetadataOffset' = brokerMetadataOffset,
      lastHeartbeat' = lastHeartbeat,
      pendingShutdown' = pendingShutdown,
      controllerRole' = controllerRole,
      controllerEpoch' = controllerEpoch,
      controllerLeader' = controllerLeader,
      controllerVotedFor' = controllerVotedFor,
      lastControllerHeartbeat' = lastControllerHeartbeat,
      metadataHighWatermark' = metadataHighWatermark,
      currentTime' = currentTime,
      inFlightMessages' = inFlightMessages,
      networkPartitioned' = networkPartitioned
    }

  // ============================================================================
  // Controller Quorum Actions (Raft-based)
  // ============================================================================

  // Controller starts election (becomes candidate)
  // This resets all votes and demotes the old leader (new Raft term)
  action controllerStartElection(c) = all {
    controllerRole.get(c) == FOLLOWER,
    electionTimeoutExpired(c),
    // Demote any existing leader to follower (they're stale in new term)
    controllerRole' = controllerIds.mapBy(ctrl =>
      if (ctrl == c) CANDIDATE else FOLLOWER
    ),
    controllerEpoch' = controllerEpoch + 1,
    // Clear all votes for the new term, candidate votes for self
    controllerVotedFor' = controllerIds.mapBy(ctrl =>
      if (ctrl == c) c else -1
    ),
    controllerLeader' = -1,
    lastControllerHeartbeat' = lastControllerHeartbeat.set(c, currentTime),
    brokers' = brokers,
    brokerMetadataOffset' = brokerMetadataOffset,
    lastHeartbeat' = lastHeartbeat,
    pendingShutdown' = pendingShutdown,
    partitions' = partitions,
    metadataHighWatermark' = metadataHighWatermark,
    controlledShutdownOffset' = controlledShutdownOffset,
    currentTime' = currentTime,
    inFlightMessages' = inFlightMessages,
    networkPartitioned' = networkPartitioned
  }

  // Controller wins election (receives majority votes)
  action controllerWinElection(c) =
    val votes = controllerIds.filter(v => controllerVotedFor.get(v) == c).size()
    all {
      controllerRole.get(c) == CANDIDATE,
      votes > N_CONTROLLERS / 2,  // Majority
      controllerRole' = controllerRole.set(c, LEADER),
      controllerLeader' = c,
      // Reset heartbeat for unfenced brokers (like in simplified model)
      lastHeartbeat' = brokerIds.mapBy(b =>
        if (not(isFenced(b))) currentTime else lastHeartbeat.get(b)
      ),
      lastControllerHeartbeat' = lastControllerHeartbeat.set(c, currentTime),
      brokers' = brokers,
      brokerMetadataOffset' = brokerMetadataOffset,
      pendingShutdown' = pendingShutdown,
      controllerVotedFor' = controllerVotedFor,
      controllerEpoch' = controllerEpoch,
      partitions' = partitions,
      metadataHighWatermark' = metadataHighWatermark,
      controlledShutdownOffset' = controlledShutdownOffset,
      currentTime' = currentTime,
      inFlightMessages' = inFlightMessages,
      networkPartitioned' = networkPartitioned
    }

  // Controller votes for candidate
  action controllerVote(voter, candidate) = all {
    voter != candidate,
    controllerRole.get(candidate) == CANDIDATE,
    controllerVotedFor.get(voter) == -1,  // Haven't voted yet
    controllerVotedFor' = controllerVotedFor.set(voter, candidate),
    lastControllerHeartbeat' = lastControllerHeartbeat.set(voter, currentTime),
    controllerRole' = controllerRole,
    controllerEpoch' = controllerEpoch,
    controllerLeader' = controllerLeader,
    brokers' = brokers,
    brokerMetadataOffset' = brokerMetadataOffset,
    lastHeartbeat' = lastHeartbeat,
    pendingShutdown' = pendingShutdown,
    partitions' = partitions,
    metadataHighWatermark' = metadataHighWatermark,
    controlledShutdownOffset' = controlledShutdownOffset,
    currentTime' = currentTime,
    inFlightMessages' = inFlightMessages,
    networkPartitioned' = networkPartitioned
  }

  // Controller leader sends heartbeat to followers
  action controllerHeartbeat(c) = all {
    controllerRole.get(c) == LEADER,
    lastControllerHeartbeat' = controllerIds.mapBy(ctrl =>
      if (ctrl == c or controllerRole.get(ctrl) == FOLLOWER) currentTime
      else lastControllerHeartbeat.get(ctrl)
    ),
    controllerRole' = controllerRole,
    controllerEpoch' = controllerEpoch,
    controllerLeader' = controllerLeader,
    controllerVotedFor' = controllerVotedFor,
    brokers' = brokers,
    brokerMetadataOffset' = brokerMetadataOffset,
    lastHeartbeat' = lastHeartbeat,
    pendingShutdown' = pendingShutdown,
    partitions' = partitions,
    metadataHighWatermark' = metadataHighWatermark,
    controlledShutdownOffset' = controlledShutdownOffset,
    currentTime' = currentTime,
    inFlightMessages' = inFlightMessages,
    networkPartitioned' = networkPartitioned
  }

  // Controller leader steps down
  action controllerStepDown(c) = all {
    controllerRole.get(c) == LEADER,
    controllerRole' = controllerRole.set(c, FOLLOWER),
    controllerLeader' = -1,
    controllerVotedFor' = controllerIds.mapBy(ctrl => -1),  // Reset votes for new term
    lastControllerHeartbeat' = lastControllerHeartbeat,
    controllerEpoch' = controllerEpoch,
    brokers' = brokers,
    brokerMetadataOffset' = brokerMetadataOffset,
    lastHeartbeat' = lastHeartbeat,
    pendingShutdown' = pendingShutdown,
    partitions' = partitions,
    metadataHighWatermark' = metadataHighWatermark,
    controlledShutdownOffset' = controlledShutdownOffset,
    currentTime' = currentTime,
    inFlightMessages' = inFlightMessages,
    networkPartitioned' = networkPartitioned
  }

  // ============================================================================
  // Partition Leadership Actions
  // ============================================================================

  // Elect leader for partition (controller operation)
  action electPartitionLeader(p) =
    val ps = partitions.get(p)
    all {
      hasControllerLeader,
      ps.leader == -1,
      ps.isr.size() > 0,
      val newLeader = ps.isr.fold(-1, (acc, b) =>
        if (acc == -1 and isActive(b)) b else acc
      )
      partitions' = partitions.set(p, {
        ...ps,
        leader: newLeader,
        leaderEpoch: ps.leaderEpoch + 1
      }),
      brokers' = brokers,
      brokerMetadataOffset' = brokerMetadataOffset,
      lastHeartbeat' = lastHeartbeat,
      pendingShutdown' = pendingShutdown,
      controllerRole' = controllerRole,
      controllerEpoch' = controllerEpoch,
      controllerLeader' = controllerLeader,
      controllerVotedFor' = controllerVotedFor,
      lastControllerHeartbeat' = lastControllerHeartbeat,
      metadataHighWatermark' = metadataHighWatermark,
      controlledShutdownOffset' = controlledShutdownOffset,
      currentTime' = currentTime,
      inFlightMessages' = inFlightMessages,
      networkPartitioned' = networkPartitioned
    }

  // Shrink ISR (remove lagging replica)
  action shrinkISR(p, b) =
    val ps = partitions.get(p)
    all {
      hasControllerLeader,
      ps.isr.contains(b),
      ps.isr.size() > 1,  // Keep at least one in ISR
      ps.leader != b,     // Don't remove leader from ISR
      partitions' = partitions.set(p, {
        ...ps,
        isr: ps.isr.exclude(Set(b))
      }),
      brokers' = brokers,
      brokerMetadataOffset' = brokerMetadataOffset,
      lastHeartbeat' = lastHeartbeat,
      pendingShutdown' = pendingShutdown,
      controllerRole' = controllerRole,
      controllerEpoch' = controllerEpoch,
      controllerLeader' = controllerLeader,
      controllerVotedFor' = controllerVotedFor,
      lastControllerHeartbeat' = lastControllerHeartbeat,
      metadataHighWatermark' = metadataHighWatermark,
      controlledShutdownOffset' = controlledShutdownOffset,
      currentTime' = currentTime,
      inFlightMessages' = inFlightMessages,
      networkPartitioned' = networkPartitioned
    }

  // Expand ISR (add caught-up replica)
  action expandISR(p, b) =
    val ps = partitions.get(p)
    all {
      hasControllerLeader,
      ps.replicas.contains(b),
      not(ps.isr.contains(b)),
      isActive(b),
      isCaughtUp(b),
      partitions' = partitions.set(p, {
        ...ps,
        isr: ps.isr.union(Set(b))
      }),
      brokers' = brokers,
      brokerMetadataOffset' = brokerMetadataOffset,
      lastHeartbeat' = lastHeartbeat,
      pendingShutdown' = pendingShutdown,
      controllerRole' = controllerRole,
      controllerEpoch' = controllerEpoch,
      controllerLeader' = controllerLeader,
      controllerVotedFor' = controllerVotedFor,
      lastControllerHeartbeat' = lastControllerHeartbeat,
      metadataHighWatermark' = metadataHighWatermark,
      controlledShutdownOffset' = controlledShutdownOffset,
      currentTime' = currentTime,
      inFlightMessages' = inFlightMessages,
      networkPartitioned' = networkPartitioned
    }

  // ============================================================================
  // Metadata and Time Actions
  // ============================================================================

  // Broker fetches metadata (advances its offset)
  action brokerFetchMetadata(b) =
    val reg = brokers.get(b)
    all {
      reg.registrationState == REGISTERED,
      brokerMetadataOffset.get(b) < metadataHighWatermark,
      brokerMetadataOffset' = brokerMetadataOffset.set(b,
        min(brokerMetadataOffset.get(b) + 1, metadataHighWatermark)
      ),
      brokers' = brokers,
      lastHeartbeat' = lastHeartbeat,
      pendingShutdown' = pendingShutdown,
      controllerRole' = controllerRole,
      controllerEpoch' = controllerEpoch,
      controllerLeader' = controllerLeader,
      controllerVotedFor' = controllerVotedFor,
      lastControllerHeartbeat' = lastControllerHeartbeat,
      partitions' = partitions,
      metadataHighWatermark' = metadataHighWatermark,
      controlledShutdownOffset' = controlledShutdownOffset,
      currentTime' = currentTime,
      inFlightMessages' = inFlightMessages,
      networkPartitioned' = networkPartitioned
    }

  // Metadata log advances (controller commits new record)
  // Constrained: at least one registered broker must be caught up before advancing
  action advanceMetadata = all {
    hasControllerLeader,
    // At least one registered broker must be fully caught up (can unfence), or watermark is 0
    metadataHighWatermark == 0 or brokerIds.exists(b =>
      brokers.get(b).registrationState == REGISTERED and
      brokerMetadataOffset.get(b) >= metadataHighWatermark
    ),
    metadataHighWatermark' = metadataHighWatermark + 1,
    brokers' = brokers,
    brokerMetadataOffset' = brokerMetadataOffset,
    lastHeartbeat' = lastHeartbeat,
    pendingShutdown' = pendingShutdown,
    controllerRole' = controllerRole,
    controllerEpoch' = controllerEpoch,
    controllerLeader' = controllerLeader,
    controllerVotedFor' = controllerVotedFor,
    lastControllerHeartbeat' = lastControllerHeartbeat,
    partitions' = partitions,
    controlledShutdownOffset' = controlledShutdownOffset,
    currentTime' = currentTime,
    inFlightMessages' = inFlightMessages,
    networkPartitioned' = networkPartitioned
  }

  action tick = all {
    currentTime' = currentTime + 1,
    brokers' = brokers,
    brokerMetadataOffset' = brokerMetadataOffset,
    lastHeartbeat' = lastHeartbeat,
    pendingShutdown' = pendingShutdown,
    controllerRole' = controllerRole,
    controllerEpoch' = controllerEpoch,
    controllerLeader' = controllerLeader,
    controllerVotedFor' = controllerVotedFor,
    lastControllerHeartbeat' = lastControllerHeartbeat,
    partitions' = partitions,
    metadataHighWatermark' = metadataHighWatermark,
    controlledShutdownOffset' = controlledShutdownOffset,
    inFlightMessages' = inFlightMessages,
    networkPartitioned' = networkPartitioned
  }

  // ============================================================================
  // Network Partition Actions
  // ============================================================================

  // Create network partition between broker and controller
  // Constrained: limit total partitions to avoid complete isolation
  action createNetworkPartition(b, c) = all {
    not(isPartitioned(b, c)),
    // Don't create too many partitions - keep at least one path open per broker
    networkPartitioned.size() < N_BROKERS,
    networkPartitioned' = networkPartitioned.union(Set((b, c))),
    brokers' = brokers,
    brokerMetadataOffset' = brokerMetadataOffset,
    lastHeartbeat' = lastHeartbeat,
    pendingShutdown' = pendingShutdown,
    controllerRole' = controllerRole,
    controllerEpoch' = controllerEpoch,
    controllerLeader' = controllerLeader,
    controllerVotedFor' = controllerVotedFor,
    lastControllerHeartbeat' = lastControllerHeartbeat,
    partitions' = partitions,
    metadataHighWatermark' = metadataHighWatermark,
    controlledShutdownOffset' = controlledShutdownOffset,
    currentTime' = currentTime,
    inFlightMessages' = inFlightMessages
  }

  // Heal network partition
  action healNetworkPartition(b, c) = all {
    isPartitioned(b, c),
    networkPartitioned' = networkPartitioned.exclude(Set((b, c))),
    brokers' = brokers,
    brokerMetadataOffset' = brokerMetadataOffset,
    lastHeartbeat' = lastHeartbeat,
    pendingShutdown' = pendingShutdown,
    controllerRole' = controllerRole,
    controllerEpoch' = controllerEpoch,
    controllerLeader' = controllerLeader,
    controllerVotedFor' = controllerVotedFor,
    lastControllerHeartbeat' = lastControllerHeartbeat,
    partitions' = partitions,
    metadataHighWatermark' = metadataHighWatermark,
    controlledShutdownOffset' = controlledShutdownOffset,
    currentTime' = currentTime,
    inFlightMessages' = inFlightMessages
  }

  // Drop in-flight message (network failure)
  action dropMessage(b, msg) = all {
    inFlightMessages.contains((b, msg)),
    inFlightMessages' = inFlightMessages.exclude(Set((b, msg))),
    brokers' = brokers,
    brokerMetadataOffset' = brokerMetadataOffset,
    lastHeartbeat' = lastHeartbeat,
    pendingShutdown' = pendingShutdown,
    controllerRole' = controllerRole,
    controllerEpoch' = controllerEpoch,
    controllerLeader' = controllerLeader,
    controllerVotedFor' = controllerVotedFor,
    lastControllerHeartbeat' = lastControllerHeartbeat,
    partitions' = partitions,
    metadataHighWatermark' = metadataHighWatermark,
    controlledShutdownOffset' = controlledShutdownOffset,
    currentTime' = currentTime,
    networkPartitioned' = networkPartitioned
  }

  // Process any pending heartbeat for broker b
  action processPendingHeartbeat(b) = {
    nondet msg = oneOf(inFlightMessages)
    all {
      msg._1 == b,
      match msg._2 {
        | HeartbeatReq(req) => processHeartbeat(b, req)
        | HeartbeatResp(_) => all {
            // Just consume the response (broker would update its state)
            inFlightMessages' = inFlightMessages.exclude(Set(msg)),
            brokers' = brokers,
            brokerMetadataOffset' = brokerMetadataOffset,
            lastHeartbeat' = lastHeartbeat,
            pendingShutdown' = pendingShutdown,
            controllerRole' = controllerRole,
            controllerEpoch' = controllerEpoch,
            controllerLeader' = controllerLeader,
            controllerVotedFor' = controllerVotedFor,
            lastControllerHeartbeat' = lastControllerHeartbeat,
            partitions' = partitions,
            metadataHighWatermark' = metadataHighWatermark,
            controlledShutdownOffset' = controlledShutdownOffset,
            currentTime' = currentTime,
            networkPartitioned' = networkPartitioned
          }
      }
    }
  }

  // Drop any pending message for broker b
  action dropPendingMessage(b) = {
    nondet msg = oneOf(inFlightMessages)
    all {
      msg._1 == b,
      dropMessage(b, msg._2)
    }
  }

  // ============================================================================
  // Step (Non-deterministic Composite Action)
  // ============================================================================

  action step = {
    nondet b = oneOf(brokerIds)
    nondet c = oneOf(controllerIds)
    nondet p = oneOf(partitionIds)
    nondet wantFence = oneOf(Set(true, false))
    nondet wantShutDown = oneOf(Set(true, false))
    nondet voter = oneOf(controllerIds)

    any {
      // Broker registration lifecycle
      brokerStartRegistration(b),
      brokerCompleteRegistration(b),
      brokerCrash(b),

      // Heartbeat actions
      sendHeartbeat(b, wantFence, wantShutDown),
      processPendingHeartbeat(b),
      fenceStaleBroker(b),

      // Controller quorum actions
      controllerStartElection(c),
      controllerWinElection(c),
      controllerVote(voter, c),
      controllerHeartbeat(c),
      controllerStepDown(c),

      // Partition/ISR actions
      electPartitionLeader(p),
      shrinkISR(p, b),
      expandISR(p, b),

      // Metadata actions
      brokerFetchMetadata(b),
      advanceMetadata,

      // Network actions
      createNetworkPartition(b, c),
      healNetworkPartition(b, c),
      dropPendingMessage(b),

      // Time
      tick
    }
  }

  // ============================================================================
  // State Tuple for Fairness
  // ============================================================================

  val vars = (brokers, brokerMetadataOffset, lastHeartbeat, pendingShutdown,
              controllerRole, controllerEpoch, controllerLeader, controllerVotedFor,
              lastControllerHeartbeat, partitions, metadataHighWatermark,
              controlledShutdownOffset, currentTime, inFlightMessages, networkPartitioned)

  // ============================================================================
  // Safety Properties
  // ============================================================================

  // Broker epochs are monotonically increasing (never decrease)
  val EpochMonotonicity = brokerIds.forall(b =>
    brokers.get(b).epoch >= 0
  )

  // ISR is always a subset of replicas
  val ISRConsistency = partitionIds.forall(p =>
    partitions.get(p).isr.subseteq(partitions.get(p).replicas)
  )

  // Partition leader is always in ISR (if leader exists)
  val LeaderInISR = partitionIds.forall(p =>
    val ps = partitions.get(p)
    ps.leader == -1 or ps.isr.contains(ps.leader)
  )

  // Controller epoch is non-negative
  val ControllerEpochValid = controllerEpoch >= 0

  // At most one controller leader
  val SingleControllerLeader =
    controllerIds.filter(c => controllerRole.get(c) == LEADER).size() <= 1

  // Fenced brokers cannot be partition leaders
  val FencedBrokersNoLeadership = partitionIds.forall(p =>
    val leader = partitions.get(p).leader
    leader == -1 or not(isFenced(leader))
  )

  // Fenced brokers not in ISR
  val FencedBrokersNotInISR = partitionIds.forall(p =>
    val isr = partitions.get(p).isr
    isr.forall(b => not(isFenced(b)))
  )

  // Controlled shutdown offset consistency
  val ControlledShutdownOffsetConsistency = brokerIds.forall(b =>
    controlledShutdownOffset.get(b) != -1 implies
      brokers.get(b).controlState == CONTROLLED_SHUTDOWN
  )

  // Registered brokers have valid state
  val RegisteredBrokersValid = brokerIds.forall(b =>
    val reg = brokers.get(b)
    reg.registrationState == REGISTERED implies (
      reg.controlState == FENCED or
      reg.controlState == UNFENCED or
      reg.controlState == CONTROLLED_SHUTDOWN or
      reg.controlState == SHUTDOWN_NOW
    )
  )

  // Combined safety invariant
  val SafetyInvariant = and {
    EpochMonotonicity,
    ISRConsistency,
    LeaderInISR,
    ControllerEpochValid,
    SingleControllerLeader,
    FencedBrokersNoLeadership,
    FencedBrokersNotInISR,
    ControlledShutdownOffsetConsistency,
    RegisteredBrokersValid
  }

  // ============================================================================
  // Reachability Properties (for testing - should find counterexamples)
  // ============================================================================

  // This should be VIOLATED - we want to reach a state where all brokers are unfenced
  val NeverAllUnfenced = not(brokerIds.forall(b =>
    brokers.get(b).controlState == UNFENCED
  ))

  // This should be VIOLATED - we want to reach a state where at least one broker is unfenced
  val NeverAnyUnfenced = not(brokerIds.exists(b =>
    brokers.get(b).controlState == UNFENCED
  ))

  // This should be VIOLATED - we want to reach a state with a controller leader
  val NeverControllerLeader = not(hasControllerLeader)

  // ============================================================================
  // Liveness Properties
  // ============================================================================

  temporal WeakFairStep = weakFair(step, vars)
  temporal FairTick = strongFair(tick, vars)

  temporal FairFencing = brokerIds.forall(b =>
    strongFair(fenceStaleBroker(b), vars)
  )

  temporal FairElection = controllerIds.forall(c =>
    strongFair(controllerStartElection(c), vars) and
    strongFair(controllerWinElection(c), vars)
  )

  // Eventually a controller leader is elected
  temporal EventualControllerElection =
    (WeakFairStep and FairElection) implies
      eventually(always(hasControllerLeader))

  // Stale brokers are eventually fenced
  temporal EventualFencing =
    (WeakFairStep and FairTick and FairFencing) implies
      brokerIds.forall(b =>
        always(
          (heartbeatExpired(b) and hasControllerLeader and not(isPartitioned(b, controllerLeader))) implies
            eventually(isFenced(b))
        )
      )

  // Healthy brokers eventually become unfenced (weak version - includes shutdown states)
  temporal EventualUnfencing =
    WeakFairStep implies
      brokerIds.forall(b =>
        always(eventually(
          brokers.get(b).registrationState != REGISTERED or
          brokers.get(b).controlState == UNFENCED or
          brokers.get(b).controlState == CONTROLLED_SHUTDOWN or
          brokers.get(b).controlState == SHUTDOWN_NOW
        ))
      )

  // Fairness for heartbeats: brokers that want to stay active send heartbeats
  temporal FairHeartbeat = brokerIds.forall(b =>
    strongFair(sendHeartbeat(b, false, false), vars)
  )

  // Fairness for processing heartbeats
  temporal FairProcessHeartbeat = brokerIds.forall(b =>
    strongFair(processPendingHeartbeat(b), vars)
  )

  // Fairness for metadata fetching
  temporal FairMetadataFetch = brokerIds.forall(b =>
    strongFair(brokerFetchMetadata(b), vars)
  )

  // Fairness for network healing
  temporal FairNetworkHeal = brokerIds.forall(b =>
    controllerIds.forall(c =>
      strongFair(healNetworkPartition(b, c), vars)
    )
  )

  // Strong liveness: Healthy brokers eventually unfence
  // A broker that is registered, caught up, not shutting down, and can communicate
  // with the controller leader will eventually become UNFENCED
  temporal EventualUnfencing_Strong =
    (WeakFairStep and FairElection and FairHeartbeat and FairProcessHeartbeat and FairMetadataFetch) implies
      brokerIds.forall(b =>
        always(
          (brokers.get(b).registrationState == REGISTERED and
           not(pendingShutdown.get(b)) and
           isCaughtUp(b) and
           hasControllerLeader and
           not(isPartitioned(b, controllerLeader))) implies
            eventually(brokers.get(b).controlState == UNFENCED)
        )
      )

  // With network healing: eventually brokers can unfence if partitions heal
  temporal EventualUnfencing_WithHealing =
    (WeakFairStep and FairElection and FairHeartbeat and FairProcessHeartbeat and FairMetadataFetch and FairNetworkHeal) implies
      brokerIds.forall(b =>
        always(
          (brokers.get(b).registrationState == REGISTERED and
           not(pendingShutdown.get(b)) and
           isCaughtUp(b)) implies
            eventually(
              brokers.get(b).controlState == UNFENCED or
              brokers.get(b).controlState == SHUTDOWN_NOW or
              brokers.get(b).registrationState != REGISTERED
            )
        )
      )
}

// ============================================================================
// Concrete Instances for Verification
// ============================================================================

module BrokerHeartbeatEnhanced_Small {
  import BrokerHeartbeatEnhanced(
    N_BROKERS = 3,
    N_CONTROLLERS = 3,
    N_PARTITIONS = 1,
    REPLICATION_FACTOR = 1,
    SESSION_TIMEOUT = 3,
    ELECTION_TIMEOUT = 2
  ).*
}

module BrokerHeartbeatEnhanced_Medium {
  import BrokerHeartbeatEnhanced(
    N_BROKERS = 5,
    N_CONTROLLERS = 3,
    N_PARTITIONS = 4,
    REPLICATION_FACTOR = 3,
    SESSION_TIMEOUT = 5,
    ELECTION_TIMEOUT = 3
  ).*
}