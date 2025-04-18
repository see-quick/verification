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
    quotas: KafkaUserQuotas,    // quotas :)
    status: str   // "Pending", "Ready", "Error", or "Deleted"
  }

  type KafkaUserQuotas = {
    producerByteRate: int,
    consumerByteRate: int,
    requestPercentage: int,
    controllerMutationRate: int    // should be real but Quint has only int :)
  }  

  // ============================================================================
  // EVENT MODEL
  // ============================================================================
  type Event =
    | UserCreatedWithSecret(UserResource)
    | UserUpdated(UserResource)
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
    globalState' = { 
      users: Map(), 
      secrets : Set(), 
      eventQueue: [], 
      processedEvents: 0
    }
  }

  // ============================================================================
  // ACTIONS FOR GENERATING EVENTS
  // ============================================================================

  // helper for queueEvent
  def queueEvent(ev: Event): GlobalState =
    { ...globalState, eventQueue: globalState.eventQueue.append(ev) }
 
  def newUser(u: str): UserResource =
    { spec: { username: u, roles: ["user"] },
      account: { username: u, roles: ["user"], created: false },
      quotas: { producerByteRate: 0, consumerByteRate: 0, requestPercentage: 0, controllerMutationRate: 0 },
      status: "Pending"
    }

  // Each action appends its corresponding event to the eventQueue.
  action createUser(u) = globalState' = queueEvent(UserCreatedWithSecret(newUser(u)))
  // Creates user with non-default quotas
  action createUserWithQuotas(u) =
    globalState' = queueEvent(
      UserCreatedWithSecret({
        spec: { username: u, roles: ["user"] },
        account: { username: u, roles: ["user"], created: false },
        quotas: { producerByteRate: 100, consumerByteRate: 200, requestPercentage: 50, controllerMutationRate: 5 },
        status: "Pending"
      })
    )

  action deleteUser(u) = globalState' = queueEvent(UserDeleted(u))

  action updateUser(u) =
    if (u.in(globalState.users.keys()))
      globalState' = queueEvent(UserUpdated({
        spec: { username: u, roles: globalState.users.get(u).spec.roles.append("admin") },
        account: { username: u, roles: globalState.users.get(u).spec.roles.append("admin"), created: true },
        quotas: globalState.users.get(u).quotas,
        status: "Ready"
      }))
    else
      globalState' = globalState

   // Updates user quotas
   action updateUserWithQuotas(u) =
     if (u.in(globalState.users.keys()))
       globalState' = queueEvent(
         UserUpdated({
           spec: globalState.users.get(u).spec,
           account: globalState.users.get(u).account,
           quotas: { producerByteRate: 500, consumerByteRate: 500, requestPercentage: 90, controllerMutationRate: 20 },
           status: globalState.users.get(u).status
         })
       )
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
      createUserWithQuotas(u),
      updateUser(u),
      updateUserWithQuotas(u),
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
      | UserCreatedWithSecret(cr) =>
        { spec: cr.spec,
          account: { username: cr.spec.username, roles: cr.spec.roles, created: true },
          quotas: cr.quotas,
          status: "Ready" }
      | UserUpdated(cr) =>
          if (user.status == "Deleted")
            // Ignore update events for users already deleted.
            user
          else
            { spec: cr.spec,
              account: { username: cr.spec.username, roles: cr.spec.roles, created: cr.spec.username.in(globalState.secrets) },
              quotas: cr.quotas,
              status: if (cr.spec.username.in(globalState.secrets)) "Ready" else "Pending" }
      | UserDeleted(username) =>
          { spec: user.spec,
            account: { username: user.account.username, roles: [], created: false },
            quotas: user.quotas, 
            status: "Deleted" }
    }

  def processEvent(state: GlobalState, ev: Event): GlobalState =
    match ev {
      | UserCreatedWithSecret(cr) =>
        if (cr.spec.username.in(state.users.keys()))
          {
            users: state.users.put(cr.spec.username, reconcileUser(state.users.get(cr.spec.username), ev)),
            secrets: state.secrets.union(Set(cr.spec.username)),
            eventQueue: state.eventQueue,
            processedEvents: state.processedEvents + 1
          }
        else
          {
            users: state.users.put(cr.spec.username, {
                      spec: cr.spec,
                      account: { username: cr.spec.username, roles: cr.spec.roles, created: true },
                      quotas: cr.quotas,
                      status: "Ready"
            }),
            secrets: state.secrets.union(Set(cr.spec.username)),
            eventQueue: state.eventQueue,
            processedEvents: state.processedEvents + 1
          }
      | UserUpdated(cr) =>
        if (cr.spec.username.in(state.users.keys()))
          {
            users: state.users.put(cr.spec.username, reconcileUser(state.users.get(cr.spec.username), ev)),
            secrets: state.secrets,
            eventQueue: state.eventQueue,
            processedEvents: state.processedEvents + 1
          }
        else
          {
            users: state.users.put(cr.spec.username, {
                      spec: cr.spec,
                      account: { username: cr.spec.username, roles: cr.spec.roles, created: true },
                      quotas : cr.quotas,
                      status: "Ready"
            }),
            secrets: state.secrets.union(Set(cr.spec.username)),
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
           | UserCreatedWithSecret(cr) => cr.spec.username.in(PotentialUsers)
           | UserUpdated(cr) => cr.spec.username.in(PotentialUsers)
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

  // ========================================
  // ========= QUOTAS INVARIANTS ============
  // ========================================
  val QuotasNonNegative =
    globalState.users.keys().forall(u =>
      (globalState.users.get(u).quotas.producerByteRate >= 0) and
      (globalState.users.get(u).quotas.consumerByteRate >= 0) and
      (globalState.users.get(u).quotas.requestPercentage >= 0) and
      (globalState.users.get(u).quotas.controllerMutationRate >= 0)
    )

  val QuotasRequestPercentageValid =
    globalState.users.keys().forall(u =>
      (globalState.users.get(u).quotas.requestPercentage >= 0) and
      (globalState.users.get(u).quotas.requestPercentage <= 100)
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
