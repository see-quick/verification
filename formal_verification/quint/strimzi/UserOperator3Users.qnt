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
   // We assume a x of potential users (defined outside of this model :)
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
    status: str
  }
  // EVENT MODEL
  // ----------------------------------------------------------------------------
  // Events represent changes to KafkaUser resources. They are used to drive the
  // operator's reconciliation loop.
  type Event =
    | UserCreated(KafkaUserSpec)
    | UserUpdated(KafkaUserSpec)
    | UserDeleted(str)   // deletion event carries the username

  // ============================================================================
  // GLOBAL STATE
  // ============================================================================
  // GlobalState encapsulates the entire state of the operator.
  type GlobalState = {
    users: str -> UserResource,
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
    globalState' = { users: Map(), eventQueue: [], processedEvents: 0 }
  }

   // ============================================================================
  // ACTIONS FOR GENERATING EVENTS
  // ============================================================================
  // Each action appends its corresponding event to the eventQueue.
  // Action: createUser appends a creation event for user u.
  action createUser(u) = all {
    globalState' = {
      globalState.with("eventQueue", globalState.eventQueue.concat([UserCreated({ username: u, roles: ["user"] })]))
    }
  }

  // Action: updateUser appends an update event for user u.
  action updateUser(u) = all {
    if (u.in(globalState.users.keys()))
      globalState' = {
        globalState.with("eventQueue", globalState.eventQueue.concat([UserUpdated({ username: u, roles: globalState.users.get(u).spec.roles.concat(["admin"]) })]))
      }
    else
      // just ignore if user not exist
      globalState' = globalState
  }

  // Action: deleteUser appends a deletion event for user u.
  action deleteUser(u) = all {
    globalState' = {
      globalState.with("eventQueue", globalState.eventQueue.concat([UserDeleted(u)]))
    }
  }

  // ============================================================================
  // STEP FUNCTION
  // ============================================================================
  // The step action nondeterministically chooses between generating an event and processing an event.
  // If the choice is "reconcile" but the eventQueue is empty, it falls back to generating an event.
  action step = {
    nondet choice = oneOf(Set("create", "update", "delete", "reconcile"))
    if (choice == "create") {
      nondet u = PotentialUsers.oneOf()
      createUser(u)
    } else if (choice == "update") {
      nondet u = PotentialUsers.oneOf()
      updateUser(u)
    } else if (choice == "delete") {
      nondet u = PotentialUsers.oneOf()
      deleteUser(u)
    } else { // "reconcile"
      if (length(globalState.eventQueue) > 0)
        globalState' = processEvent({ globalState.with("eventQueue", tail(globalState.eventQueue)) }, head(globalState.eventQueue))
      else
        globalState' = globalState
        // do nothing
    }
  }

  // ============================================================================
  // RECONCILIATION LOGIC (UserControllerLoop)
  // ============================================================================
  def reconcileUser(user: UserResource, ev: Event): UserResource =
    match ev {
      | UserCreated(spec) =>
          if (not(user.account.created)) {
            spec: spec,
            account: { username: spec.username, roles: spec.roles, created: true },
            status: "Ready"
          } else user
      | UserUpdated(spec) =>
          { spec: spec,
            account: { username: spec.username, roles: spec.roles, created: user.account.created },
            status: "Ready" }
      | UserDeleted(username) =>
          { spec: user.spec,
            account: { username: user.account.username, roles: [], created: false },
            status: "Deleted" }
    }

  def processEvent(state: GlobalState, ev: Event): GlobalState =
    match ev {
      | UserCreated(spec) =>
          if (spec.username.in(state.users.keys()))
            {
              users: state.users.put(spec.username, reconcileUser(state.users.get(spec.username), ev)),
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
              eventQueue: state.eventQueue,
              processedEvents: state.processedEvents + 1
            }
      | UserUpdated(spec) =>
          if (spec.username.in(state.users.keys()))
            {
              users: state.users.put(spec.username, reconcileUser(state.users.get(spec.username), ev)),
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
              eventQueue: state.eventQueue,
              processedEvents: state.processedEvents + 1
            }
      | UserDeleted(username) =>
          if (username.in(state.users.keys()))
            {
              users: state.users.put(username, reconcileUser(state.users.get(username), ev)),
              eventQueue: state.eventQueue,
              processedEvents: state.processedEvents + 1
            }
          else state
    }

  // ============================================================================
  // HELPER FUNCTIONS
  // ----------------------------------------------------------------------------
  // lastState returns the last element of a non-empty list of GlobalState.
  def lastState(L: List[GlobalState]): GlobalState =
      L.foldl(head(L), (s, x) => x)

  // ============================================================================
  // HEALTH, READINESS, AND METRICS PREDICATES
  // ----------------------------------------------------------------------------
  // matchUser checks whether an account matches the desired spec.
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
         | UserCreated(spec) => spec.username.in(PotentialUsers)
         | UserUpdated(spec) => spec.username.in(PotentialUsers)
         | UserDeleted(u)    => u.in(PotentialUsers)
       }
     )) == length(globalState.eventQueue)

  // A helper predicate that returns true if, for every potential user,
  // either the user is not present in the state or, if present, its status is "Ready" or "Deleted".
  def isStable(state: GlobalState): bool =
    PotentialUsers.forall(u =>
      (not(u.in(state.users.keys()))) or 
      (state.users.get(u).status == "Ready") or 
      (state.users.get(u).status == "Deleted")
  );


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
    weakFair(step, globalState) implies always(eventually(
      (length(globalState.eventQueue) == 0) and isStable(globalState)
    ))
 }
