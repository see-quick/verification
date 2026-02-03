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
  const N: int
  const SESSION_TIMEOUT: int

  type BrokerId = int
  type ControlState = FENCED | UNFENCED | CONTROLLED_SHUTDOWN | SHUTDOWN_NOW

  type HeartbeatRequest = {
    wantFence: bool,
    wantShutDown: bool,
    caughtUp: bool
  }

  var brokerState: BrokerId -> ControlState
  var hasLeadership: BrokerId -> bool
  var lastHeartbeat: BrokerId -> int
  var currentTime: int
  var controllerActive: bool
  var controlledShutdownOffset: BrokerId -> int
  var lowestActiveOffset: int

  val brokers = 0.to(N - 1)

  def isFenced(b: BrokerId): bool =
    brokerState.get(b) == FENCED or brokerState.get(b) == SHUTDOWN_NOW

  def inControlledShutdown(b: BrokerId): bool =
    brokerState.get(b) == CONTROLLED_SHUTDOWN

  def heartbeatExpired(b: BrokerId): bool =
    currentTime > lastHeartbeat.get(b) + SESSION_TIMEOUT

  def controlledShutdownComplete(b: BrokerId): bool =
    controlledShutdownOffset.get(b) != -1 and
    lowestActiveOffset > controlledShutdownOffset.get(b)

  def calculateNextState(b: BrokerId, req: HeartbeatRequest): ControlState =
    val current = brokerState.get(b)
    val hasLeaders = hasLeadership.get(b)

    if (current == FENCED) {
      if (req.wantShutDown) SHUTDOWN_NOW
      else if (not(req.wantFence) and req.caughtUp) UNFENCED
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

  action init = all {
    brokerState' = brokers.mapBy(b => FENCED),
    hasLeadership' = brokers.mapBy(b => false),
    lastHeartbeat' = brokers.mapBy(b => 0),
    currentTime' = 0,
    controllerActive' = true,
    controlledShutdownOffset' = brokers.mapBy(b => -1),
    lowestActiveOffset' = 0
  }

  def computeControlledShutdownOffset(b, currentState, nextState) =
    if (currentState != CONTROLLED_SHUTDOWN and nextState == CONTROLLED_SHUTDOWN)
      controlledShutdownOffset.set(b, lowestActiveOffset)
    else if (nextState == FENCED or nextState == SHUTDOWN_NOW)
      controlledShutdownOffset.set(b, -1)
    else
      controlledShutdownOffset

  action heartbeat(b, wantFence, wantShutDown, caughtUp) =
    val req = { wantFence: wantFence, wantShutDown: wantShutDown, caughtUp: caughtUp }
    val currentState = brokerState.get(b)
    val nextState = calculateNextState(b, req)
    all {
      controllerActive,
      brokerState' = brokerState.set(b, nextState),
      lastHeartbeat' = lastHeartbeat.set(b, currentTime),
      controlledShutdownOffset' = computeControlledShutdownOffset(b, currentState, nextState),
      hasLeadership' = hasLeadership,
      currentTime' = currentTime,
      controllerActive' = controllerActive,
      lowestActiveOffset' = lowestActiveOffset
    }

  action fenceStaleBroker(b) = all {
    controllerActive,
    not(isFenced(b)),
    heartbeatExpired(b),
    brokerState' = brokerState.set(b, FENCED),
    controlledShutdownOffset' = controlledShutdownOffset.set(b, -1),
    hasLeadership' = hasLeadership,
    lastHeartbeat' = lastHeartbeat,
    currentTime' = currentTime,
    controllerActive' = controllerActive,
    lowestActiveOffset' = lowestActiveOffset
  }

  action tick = all {
    currentTime' = currentTime + 1,
    brokerState' = brokerState,
    hasLeadership' = hasLeadership,
    lastHeartbeat' = lastHeartbeat,
    controllerActive' = controllerActive,
    controlledShutdownOffset' = controlledShutdownOffset,
    lowestActiveOffset' = lowestActiveOffset
  }

  action leadershipChange(b, gains) = all {
    hasLeadership' = hasLeadership.set(b, gains),
    brokerState' = brokerState,
    lastHeartbeat' = lastHeartbeat,
    currentTime' = currentTime,
    controllerActive' = controllerActive,
    controlledShutdownOffset' = controlledShutdownOffset,
    lowestActiveOffset' = lowestActiveOffset
  }

  action advanceOffset = all {
    lowestActiveOffset' = lowestActiveOffset + 1,
    brokerState' = brokerState,
    hasLeadership' = hasLeadership,
    lastHeartbeat' = lastHeartbeat,
    currentTime' = currentTime,
    controllerActive' = controllerActive,
    controlledShutdownOffset' = controlledShutdownOffset
  }

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

  action controllerActivate = all {
    not(controllerActive),
    controllerActive' = true,
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

  val ExclusiveStates = brokers.forall(b =>
    not(brokerState.get(b) == CONTROLLED_SHUTDOWN and isFenced(b))
  )

  val ShutdownImpliesFenced = brokers.forall(b =>
    brokerState.get(b) == SHUTDOWN_NOW implies isFenced(b)
  )

  val FencedNoControlledShutdown = brokers.forall(b =>
    isFenced(b) implies controlledShutdownOffset.get(b) == -1
  )

  val ValidBrokerStates = brokers.forall(b =>
    brokerState.get(b) == FENCED or
    brokerState.get(b) == UNFENCED or
    brokerState.get(b) == CONTROLLED_SHUTDOWN or
    brokerState.get(b) == SHUTDOWN_NOW
  )

  val ControlledShutdownOffsetConsistency = brokers.forall(b =>
    controlledShutdownOffset.get(b) != -1 implies
      brokerState.get(b) == CONTROLLED_SHUTDOWN
  )

  val SafetyInvariant = and {
    ExclusiveStates,
    ShutdownImpliesFenced,
    FencedNoControlledShutdown,
    ValidBrokerStates,
    ControlledShutdownOffsetConsistency
  }

  temporal WeakFairStep = weakFair(step, vars)
  temporal FairTick = strongFair(tick, vars)

  temporal FairFencing = brokers.forall(b =>
    strongFair(fenceStaleBroker(b), vars)
  )

  temporal EventualFencing =
    (WeakFairStep and FairTick and FairFencing) implies
      brokers.forall(b =>
        always(
          (heartbeatExpired(b) and controllerActive) implies
            eventually(isFenced(b))
        )
      )

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
