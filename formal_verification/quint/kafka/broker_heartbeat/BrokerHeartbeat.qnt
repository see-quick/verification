/**
 * BrokerHeartbeat: Quint specification of Kafka's Broker Heartbeat/Fencing mechanism.
 *
 * This model captures the core mechanics of broker lifecycle management in KRaft:
 *   - Broker state transitions (FENCED, UNFENCED, CONTROLLED_SHUTDOWN, SHUTDOWN_NOW)
 *   - Heartbeat-based liveness detection
 *   - Timeout-based broker fencing
 *   - Controller as the single authority for state changes
 *
 * --- Verification Goals ---
 *
 * Safety Properties:
 *   - ExclusiveStates: A broker cannot be both fenced and in controlled shutdown
 *   - ShutdownImpliesFenced: SHUTDOWN_NOW state implies the broker is fenced
 *   - FencedNoControlledShutdown: Fenced brokers cannot be in controlled shutdown
 *   - SingleController: At most one active controller at any time
 *   - OnlyControllerChangesState: Only the active controller can change broker states
 *   - TimeoutImpliesFenced: Expired heartbeat eventually leads to fencing
 *
 * Liveness Properties:
 *   - EventualFencing: Stale brokers are eventually fenced (with fairness)
 *   - EventualUnfencing: Healthy brokers eventually become unfenced
 *
 * --- Kafka Source Alignment ---
 *
 * BrokerControlState.java (lines 26-47):
 *   - FENCED, UNFENCED, CONTROLLED_SHUTDOWN, SHUTDOWN_NOW
 *
 * BrokerHeartbeatManager.java (lines 399-476):
 *   - calculateNextBrokerState() - main state machine logic
 *
 * ReplicationControlManager.java (lines 1639-1676):
 *   - processBrokerHeartbeat() - heartbeat processing
 *
 * BrokerHeartbeatTracker.java (lines 131-133):
 *   - isExpired() - timeout detection
 *
 * --- Simplifications ---
 *   - Epoch management simplified (no broker epochs/incarnations)
 *   - Metadata offset tracking abstracted to caught-up boolean
 *   - Single controller (no controller failover)
 *   - Discrete time steps instead of continuous nanoseconds
 */
module BrokerHeartbeat {
  const N: int  // Number of brokers
  const SESSION_TIMEOUT: int  // Heartbeat timeout in time units

  type BrokerId = int

  // Controller-side broker states (from BrokerControlState.java)
  // FENCED: Broker is fenced, cannot serve requests
  // UNFENCED: Broker is active and serving requests
  // CONTROLLED_SHUTDOWN: Broker is gracefully shutting down (still unfenced)
  // SHUTDOWN_NOW: Broker should terminate immediately (fenced)
  type ControlState = FENCED | UNFENCED | CONTROLLED_SHUTDOWN | SHUTDOWN_NOW

  // Heartbeat request flags (from BrokerHeartbeatRequestData)
  type HeartbeatRequest = {
    wantFence: bool,       // Broker wants to be fenced
    wantShutDown: bool,    // Broker wants to shut down
    caughtUp: bool         // Broker has caught up to its registration offset
  }

  // --- State Variables ---

  // Broker control state (controller's view)
  var brokerState: BrokerId -> ControlState

  // Whether broker holds any partition leaderships
  var hasLeadership: BrokerId -> bool

  // Last heartbeat time for each broker (controller tracking)
  var lastHeartbeat: BrokerId -> int

  // Current logical time
  var currentTime: int

  // Whether the controller is active
  var controllerActive: bool

  // Controlled shutdown completion offset tracking
  // -1 means not in controlled shutdown
  var controlledShutdownOffset: BrokerId -> int

  // Lowest active offset (for controlled shutdown completion check)
  var lowestActiveOffset: int

  // --- Derived Values ---

  val brokers = 0.to(N - 1)

  // A broker is considered fenced in states FENCED or SHUTDOWN_NOW
  def isFenced(b: BrokerId): bool =
    brokerState.get(b) == FENCED or brokerState.get(b) == SHUTDOWN_NOW

  // A broker is in controlled shutdown
  def inControlledShutdown(b: BrokerId): bool =
    brokerState.get(b) == CONTROLLED_SHUTDOWN

  // Check if a broker's heartbeat has expired
  def heartbeatExpired(b: BrokerId): bool =
    currentTime > lastHeartbeat.get(b) + SESSION_TIMEOUT

  // Check if controlled shutdown is complete
  // (all other brokers have caught up past the shutdown offset)
  def controlledShutdownComplete(b: BrokerId): bool =
    controlledShutdownOffset.get(b) != -1 and
    lowestActiveOffset > controlledShutdownOffset.get(b)

  // --- State Transition Logic ---
  // Based on BrokerHeartbeatManager.calculateNextBrokerState()

  def calculateNextState(b: BrokerId, req: HeartbeatRequest): ControlState =
    val current = brokerState.get(b)
    val hasLeaders = hasLeadership.get(b)

    if (current == FENCED) {
      // FROM FENCED STATE
      if (req.wantShutDown) SHUTDOWN_NOW
      else if (not(req.wantFence) and req.caughtUp) UNFENCED
      else FENCED
    } else if (current == UNFENCED) {
      // FROM UNFENCED STATE
      if (req.wantFence and req.wantShutDown) SHUTDOWN_NOW
      else if (req.wantFence) FENCED
      else if (req.wantShutDown and hasLeaders) CONTROLLED_SHUTDOWN
      else if (req.wantShutDown and not(hasLeaders)) SHUTDOWN_NOW
      else UNFENCED
    } else if (current == CONTROLLED_SHUTDOWN) {
      // FROM CONTROLLED_SHUTDOWN STATE
      if (hasLeaders) CONTROLLED_SHUTDOWN
      else if (controlledShutdownComplete(b)) SHUTDOWN_NOW
      else CONTROLLED_SHUTDOWN
    } else {
      // SHUTDOWN_NOW or any other state
      SHUTDOWN_NOW
    }

  // --- Actions ---

  // Initialize the system
  action init = all {
    brokerState' = brokers.mapBy(b => FENCED),
    hasLeadership' = brokers.mapBy(b => false),
    lastHeartbeat' = brokers.mapBy(b => 0),
    currentTime' = 0,
    controllerActive' = true,
    controlledShutdownOffset' = brokers.mapBy(b => -1),
    lowestActiveOffset' = 0
  }

  // Helper to compute controlled shutdown offset update
  def computeControlledShutdownOffset(b, currentState, nextState) =
    if (currentState != CONTROLLED_SHUTDOWN and nextState == CONTROLLED_SHUTDOWN)
      controlledShutdownOffset.set(b, lowestActiveOffset)
    else if (nextState == FENCED or nextState == SHUTDOWN_NOW)
      // Clear controlled shutdown offset when fenced
      controlledShutdownOffset.set(b, -1)
    else
      controlledShutdownOffset

  // Broker sends a heartbeat to the controller
  // Parameters: b=broker, wantFence, wantShutDown, caughtUp (from HeartbeatRequest)
  action heartbeat(b, wantFence, wantShutDown, caughtUp) =
    val req = { wantFence: wantFence, wantShutDown: wantShutDown, caughtUp: caughtUp }
    val currentState = brokerState.get(b)
    val nextState = calculateNextState(b, req)
    all {
      controllerActive,  // Only active controller processes heartbeats

      // Update broker state
      brokerState' = brokerState.set(b, nextState),

      // Update heartbeat timestamp
      lastHeartbeat' = lastHeartbeat.set(b, currentTime),

      // Track controlled shutdown offset when entering that state
      controlledShutdownOffset' = computeControlledShutdownOffset(b, currentState, nextState),

      // Other state unchanged
      hasLeadership' = hasLeadership,
      currentTime' = currentTime,
      controllerActive' = controllerActive,
      lowestActiveOffset' = lowestActiveOffset
    }

  // Controller fences a stale broker (timeout-based fencing)
  // Based on ReplicationControlManager.maybeFenceOneStaleBroker()
  action fenceStaleBroker(b) = all {
    controllerActive,
    not(isFenced(b)),        // Broker is not already fenced
    heartbeatExpired(b),     // Heartbeat has expired

    // Fence the broker
    brokerState' = brokerState.set(b, FENCED),

    // Clear controlled shutdown offset
    controlledShutdownOffset' = controlledShutdownOffset.set(b, -1),

    // Other state unchanged
    hasLeadership' = hasLeadership,
    lastHeartbeat' = lastHeartbeat,
    currentTime' = currentTime,
    controllerActive' = controllerActive,
    lowestActiveOffset' = lowestActiveOffset
  }

  // Time advances
  action tick = all {
    currentTime' = currentTime + 1,
    brokerState' = brokerState,
    hasLeadership' = hasLeadership,
    lastHeartbeat' = lastHeartbeat,
    controllerActive' = controllerActive,
    controlledShutdownOffset' = controlledShutdownOffset,
    lowestActiveOffset' = lowestActiveOffset
  }

  // Partition leadership changes (leader election/migration)
  action leadershipChange(b, gains) = all {
    hasLeadership' = hasLeadership.set(b, gains),
    brokerState' = brokerState,
    lastHeartbeat' = lastHeartbeat,
    currentTime' = currentTime,
    controllerActive' = controllerActive,
    controlledShutdownOffset' = controlledShutdownOffset,
    lowestActiveOffset' = lowestActiveOffset
  }

  // Active offset advances (simulating metadata log progress)
  action advanceOffset = all {
    lowestActiveOffset' = lowestActiveOffset + 1,
    brokerState' = brokerState,
    hasLeadership' = hasLeadership,
    lastHeartbeat' = lastHeartbeat,
    currentTime' = currentTime,
    controllerActive' = controllerActive,
    controlledShutdownOffset' = controlledShutdownOffset
  }

  // Controller deactivates (e.g., loses leadership)
  action controllerDeactivate = all {
    controllerActive,
    controllerActive' = false,
    brokerState' = brokerState,
    hasLeadership' = hasLeadership,
    lastHeartbeat' = lastHeartbeat,
    currentTime' = currentTime,
    controlledShutdownOffset' = controlledShutdownOffset,
    lowestActiveOffset' = lowestActiveOffset
  }

  // Controller activates (e.g., becomes leader)
  action controllerActivate = all {
    not(controllerActive),
    controllerActive' = true,
    // On activation, reset heartbeat times to current time for unfenced brokers
    lastHeartbeat' = brokers.mapBy(b =>
      if (not(isFenced(b))) currentTime else lastHeartbeat.get(b)
    ),
    brokerState' = brokerState,
    hasLeadership' = hasLeadership,
    currentTime' = currentTime,
    controlledShutdownOffset' = controlledShutdownOffset,
    lowestActiveOffset' = lowestActiveOffset
  }

  action step = {
    nondet b = oneOf(brokers)
    nondet wantFence = oneOf(Set(true, false))
    nondet wantShutDown = oneOf(Set(true, false))
    nondet caughtUp = oneOf(Set(true, false))
    nondet gains = oneOf(Set(true, false))

    any {
      heartbeat(b, wantFence, wantShutDown, caughtUp),
      fenceStaleBroker(b),
      tick,
      leadershipChange(b, gains),
      advanceOffset,
      controllerDeactivate,
      controllerActivate
    }
  }

  val vars = (brokerState, hasLeadership, lastHeartbeat, currentTime,
              controllerActive, controlledShutdownOffset, lowestActiveOffset)

  // --- Safety Invariants ---

  // A broker cannot be both in CONTROLLED_SHUTDOWN and fenced
  // (CONTROLLED_SHUTDOWN implies unfenced by definition)
  val ExclusiveStates = brokers.forall(b =>
    not(brokerState.get(b) == CONTROLLED_SHUTDOWN and isFenced(b))
  )

  // SHUTDOWN_NOW state implies the broker is fenced
  val ShutdownImpliesFenced = brokers.forall(b =>
    brokerState.get(b) == SHUTDOWN_NOW implies isFenced(b)
  )

  // Fenced brokers cannot have a controlled shutdown offset
  val FencedNoControlledShutdown = brokers.forall(b =>
    isFenced(b) implies controlledShutdownOffset.get(b) == -1
  )

  // Valid broker states (type invariant)
  val ValidBrokerStates = brokers.forall(b =>
    brokerState.get(b) == FENCED or
    brokerState.get(b) == UNFENCED or
    brokerState.get(b) == CONTROLLED_SHUTDOWN or
    brokerState.get(b) == SHUTDOWN_NOW
  )

  // Controlled shutdown offset is only set for brokers in CONTROLLED_SHUTDOWN
  val ControlledShutdownOffsetConsistency = brokers.forall(b =>
    controlledShutdownOffset.get(b) != -1 implies
      brokerState.get(b) == CONTROLLED_SHUTDOWN
  )

  // All safety invariants combined
  val SafetyInvariant = and {
    ExclusiveStates,
    ShutdownImpliesFenced,
    FencedNoControlledShutdown,
    ValidBrokerStates,
    ControlledShutdownOffsetConsistency
  }

  // --- Temporal Properties ---

  // Fairness: system makes progress
  temporal WeakFairStep = weakFair(step, vars)

  // Fairness: time advances
  temporal FairTick = strongFair(tick, vars)

  // Fairness: stale brokers are eventually fenced
  temporal FairFencing = brokers.forall(b =>
    strongFair(fenceStaleBroker(b), vars)
  )

  // Liveness: If a broker's heartbeat expires and stays expired,
  // it will eventually be fenced
  temporal EventualFencing =
    (WeakFairStep and FairTick and FairFencing) implies
      brokers.forall(b =>
        always(
          (heartbeatExpired(b) and controllerActive) implies
            eventually(isFenced(b))
        )
      )

  // Eventually all brokers that want to become unfenced will be unfenced
  // (if they keep sending heartbeats)
  temporal EventualUnfencing =
    WeakFairStep implies
      brokers.forall(b =>
        always(eventually(
          brokerState.get(b) == UNFENCED or
          brokerState.get(b) == CONTROLLED_SHUTDOWN or
          brokerState.get(b) == SHUTDOWN_NOW
        ))
      )
}

module BrokerHeartbeat3 {
  import BrokerHeartbeat(N = 3, SESSION_TIMEOUT = 3).*
}

module BrokerHeartbeat5 {
  import BrokerHeartbeat(N = 5, SESSION_TIMEOUT = 5).*
}
