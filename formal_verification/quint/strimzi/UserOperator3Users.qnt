module UserOperator3Users {
  // This module instantiates the UserOperatorModel with three potential users.
  import UserOperatorModel(
            PotentialUsers = Set("Alice", "Bob", "Carol")
         ).*
}

module UserOperatorModel {

  // ============================================================================
  // MODEL PARAMETERS
  // ============================================================================
  const PotentialUsers: Set[str]

  // ============================================================================
  // TYPE ALIASES
  // ============================================================================
  // KafkaUserSpec: the desired configuration for a user.
  type KafkaUserSpec = {
      username: str,
      roles: List[str]
  }

  // The actual state of a user account.
  type UserAccount = {
    username: str,
    roles: List[str],
    created: bool
  }

  // A complete KafkaUser resource that holds both the desired spec and the actual account.
  // The 'status' field can be "Pending", "Ready", "Error", or "Deleted".
  type UserResource = {
    spec: KafkaUserSpec,
    account: UserAccount,
    status: str   // "Pending", "Ready", "Error", or "Deleted"
  }

  // ============================================================================
  // EVENT MODEL
  // ============================================================================
  type Event =
    | UserCreatedWithSecret(KafkaUserSpec)
    | UserUpdated(KafkaUserSpec)
    | UserDeleted(str)

  // ============================================================================
  // GLOBAL STATE
  // ============================================================================
  // GlobalState encapsulates the entire state of the operator.
  type GlobalState = {
    users: str -> UserResource,
    secrets: Set[str],
    eventQueue: List[Event],
    processedEvents: int
  }

  // ============================================================================
  // GLOBAL STATE VARIABLE
  // ============================================================================
  // All state is encapsulated in a single global variable.
  var globalState: GlobalState

  // ============================================================================
  // INITIALIZATION ACTION
  // ============================================================================
  action init = all {
    globalState' = { users: Map(), secrets : Set(), eventQueue: [], processedEvents: 0 }
  }

  // ============================================================================
  // ACTIONS FOR GENERATING EVENTS
  // ============================================================================

  // helper for queueEvent
  def queueEvent(ev: Event): GlobalState =
    { ...globalState, eventQueue: globalState.eventQueue.append(ev) }

  // Each action appends its corresponding event to the eventQueue.
  action createUser(u) = globalState' = queueEvent(UserCreatedWithSecret({ username: u, roles: ["user"] }))
  action deleteUser(u) = globalState' = queueEvent(UserDeleted(u))

  action updateUser(u) =
      if (u.in(globalState.users.keys()))
        globalState' = queueEvent(UserUpdated({
          username: u,
          roles: globalState.users.get(u).spec.roles.append("admin")
        }))
      else
        globalState' = globalState

  // ============================================================================
  // STEP FUNCTION
  // ============================================================================
  // The step action nondeterministically chooses between generating an event and processing an event.
  // If the choice is "reconcile" but the eventQueue is empty, it falls back to generating an event.
  action step = {
    nondet u = PotentialUsers.oneOf()
    any {
      createUser(u),
      updateUser(u),
      deleteUser(u),
      if (length(globalState.eventQueue) > 0)
        globalState' = processEvent({ ... globalState, eventQueue : tail(globalState.eventQueue) }, head(globalState.eventQueue))
      else
        globalState' = globalState
    }
  }

  // ============================================================================
  // RECONCILIATION LOGIC (UserControllerLoop)
  // ============================================================================
  def reconcileUser(user: UserResource, ev: Event): UserResource =
    match ev {
      | UserCreatedWithSecret(spec) =>
        { spec: spec,
          account: { username: spec.username, roles: spec.roles, created: true },
          status: "Ready" }
      | UserUpdated(spec) =>
          if (user.status == "Deleted")
            // Ignore update events for users already deleted.
            user
          else
            { spec: spec,
              account: { username: spec.username, roles: spec.roles, created: spec.username.in(globalState.secrets) },
              status: if (spec.username.in(globalState.secrets)) "Ready" else "Pending" }
      | UserDeleted(username) =>
          { spec: user.spec,
            account: { username: user.account.username, roles: [], created: false },
            status: "Deleted" }
    }

  def processEvent(state: GlobalState, ev: Event): GlobalState =
    match ev {
      | UserCreatedWithSecret(spec) =>
        if (spec.username.in(state.users.keys()))
          {
            users: state.users.put(spec.username, reconcileUser(state.users.get(spec.username), ev)),
            secrets: state.secrets.union(Set(spec.username)),
            eventQueue: state.eventQueue,
            processedEvents: state.processedEvents + 1
          }
        else
          {
            users: state.users.put(spec.username, {
                      spec: spec,
                      account: { username: spec.username, roles: spec.roles, created: true },
                      status: "Ready"
            }),
            secrets: state.secrets.union(Set(spec.username)),
            eventQueue: state.eventQueue,
            processedEvents: state.processedEvents + 1
          }
      | UserUpdated(spec) =>
        if (spec.username.in(state.users.keys()))
          {
            users: state.users.put(spec.username, reconcileUser(state.users.get(spec.username), ev)),
            secrets: state.secrets,
            eventQueue: state.eventQueue,
            processedEvents: state.processedEvents + 1
          }
        else
          {
            users: state.users.put(spec.username, {
                      spec: spec,
                      account: { username: spec.username, roles: spec.roles, created: true },
                      status: "Ready"
            }),
            secrets: state.secrets.union(Set(spec.username)),
            eventQueue: state.eventQueue,
            processedEvents: state.processedEvents + 1
          }
      | UserDeleted(username) =>
          if (username.in(state.users.keys()))
            {
              users: state.users.put(username, reconcileUser(state.users.get(username), ev)),
              secrets: state.secrets.exclude(Set(username)),
              eventQueue: state.eventQueue,
              processedEvents: state.processedEvents + 1
            }
          else state
  }

  // ============================================================================
  // HEALTH, READINESS, AND METRICS PREDICATES
  // ============================================================================
  def matchUser(spec: KafkaUserSpec, account: UserAccount): bool =
    (account.username == spec.username) and (account.roles == spec.roles) and account.created

  // isHealthy returns true if every managed user is in the "Ready" status.
  def isHealthy(state: GlobalState): bool =
    state.users.keys().forall(key => state.users.get(key).status == "Ready")

  // isReady returns true if at least one event has been processed.
  def isReady(state: GlobalState): bool =
    state.processedEvents > 0

  // userCount returns the number of managed KafkaUser resources.
  def userCount(state: GlobalState): int =
    size(state.users.keys())

  // Safety invariant: The processed events counter is non-negative.
  val ProcessedEventsNonNegative = (globalState.processedEvents >= 0)

  // Safety invariant: For every user in the global state, if the user is "Ready"
  // then the account must be created; if "Deleted", then the account must not be created.
  val UserConsistency = globalState.users.keys().forall(u =>
    ((globalState.users.get(u).status == "Ready") implies globalState.users.get(u).account.created)
    and
    ((globalState.users.get(u).status == "Deleted") implies not(globalState.users.get(u).account.created))
  )

  // Safety invariant: Every event in the event queue references a valid potential user.
  val EventQueueWellFormed =
      length(globalState.eventQueue.select(ev =>
         match ev {
           | UserCreatedWithSecret(spec) => spec.username.in(PotentialUsers)
           | UserUpdated(spec) => spec.username.in(PotentialUsers)
           | UserDeleted(u)    => u.in(PotentialUsers)
         }
       )) == length(globalState.eventQueue)

   // A secret exists if and only if the user account is marked as created.
   val SecretsConsistency =
     globalState.users.keys().forall(u =>
       (globalState.users.get(u).account.created == globalState.secrets.contains(u))
     )

  // extra invariant -> guard secret only orphans
  val NoSecretsForDeletedUsers =
      globalState.users.keys().forall(u =>
        globalState.users.get(u).status == "Deleted"
          implies not(globalState.secrets.contains(u))
      )

  val ReadyUsersMustHaveSecrets =
      globalState.users.keys().forall(u =>
        (globalState.users.get(u).status == "Ready") implies
          (globalState.users.get(u).account.created
              and
            globalState.secrets.contains(u)
          )
      )

  // A helper predicate that returns true if, for every potential user,
  // either the user is not present in the state or, if present, its status is "Ready" or "Deleted".
  def isStable(state: GlobalState): bool =
      PotentialUsers.forall(u =>
        (not(u.in(state.users.keys()))) or
        (state.users.get(u).status == "Ready") or
        (state.users.get(u).status == "Deleted")
    )


  // TODO: this is kinda tricky and it's does not HOLD in TLC need to investigate... :)
  // Temporal Property: Eventually Stable Reconciliation (ESR)
  // -----------------------------------------------------------
  // This property asserts that if the step action is executed in a weakly fair
  // manner (i.e., weakFair(step, globalState)), then it is always the case that
  // eventually the system reaches a stable state. Here, a stable state is one in
  // which:
  //   1. The event queue is empty (i.e., no pending events remain), and
  //   2. Every potential user is either absent from the state, or, if present,
  //      its status is "Ready" or "Deleted" (i.e., the user is considered stable).
  //
  // In temporal logic, this is written as:
  temporal EventuallyStableReconciliationProperty =
      strongFair(step, globalState) implies always(eventually(
        (length(globalState.eventQueue) == 0) and isStable(globalState)
      ))
}
