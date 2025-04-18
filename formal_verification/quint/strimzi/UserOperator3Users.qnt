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
  // Metadata is abstracted
  type KafkaUserMetadata = {
    name: str
    // labels: str -> str  (abstracted out)
    // annotations: str -> str (abstracted out)
  }

  // TODO: // (abstracted out for now)
  //type KafkaUserAuthentication = {
  //  type: str
  // password, secrets etc. are skipped
  // }

  type KafkaUserQuotas = {
    producerByteRate: int,
    consumerByteRate: int,
    requestPercentage: int,
    controllerMutationRate: int    // should be real but Quint has only int :)
  }

  type KafkaUserSpec = {
    // authentication: KafkaUserAuthentication,    // (abstracted out)
    // authorization: KafkaUserAuthorization,      // (abstracted out)
    quotas: KafkaUserQuotas
  }

  type KafkaUserStatusCondition = {
  //  type: str,                  // (abstracted out)
    status: str,
  //  lastTransitionTime: str,    // (abstracted out)
  //  reason: str,                // (abstracted out)
  //  message: str                // (abstracted out)
  }

  type KafkaUserStatus = {
    conditions: KafkaUserStatusCondition // (abstracted out just one status not a list :) )
  //  observedGeneration: int,                    // (abstracted out)
  //  username: str,                              // (abstracted out)
  //  secret: str                                 // (abstracted out)
  }

  // A complete KafkaUser resource that holds both the desired spec and the actual account.
  type UserResource = {
    metadata: KafkaUserMetadata,
    spec: KafkaUserSpec,
    status: KafkaUserStatus  //   "Pending", "Ready", "Error", or "Deleted"
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
    {
      metadata: { name: u },
      spec: {
        quotas: {
          producerByteRate: 0,
          consumerByteRate: 0,
          requestPercentage: 0,
          controllerMutationRate: 0
        }
      },
      status: { conditions: { status: "Pending" } }
    }

  // Each action appends its corresponding event to the eventQueue.
  action createUser(u) = globalState' = queueEvent(UserCreatedWithSecret(newUser(u)))
  // Creates user with non-default quotas
  action createUserWithQuotas(u) =
    globalState' = queueEvent(
      UserCreatedWithSecret({
        metadata: { name: u },
        spec: {
          quotas: {
            producerByteRate: 100,
            consumerByteRate: 200,
            requestPercentage: 50,
            controllerMutationRate: 5
          }
        },
        status: { conditions: { status: "Pending" } }

      })
    )

  action deleteUser(u) = globalState' = queueEvent(UserDeleted(u))

  action updateUser(u) =
    if (u.in(globalState.users.keys()))
      globalState' = queueEvent(
        UserUpdated({
          metadata: { name: u },
          spec: globalState.users.get(u).spec,
          status: { conditions: { status: "Ready" } }
        })
      )
    else
      globalState' = globalState

   // Updates user quotas
   action updateUserWithQuotas(u) =
     if (u.in(globalState.users.keys()))
       globalState' = queueEvent(
         UserUpdated({
           metadata: { name: u },
           spec: {
             quotas: {
               producerByteRate: 500,
               consumerByteRate: 500,
               requestPercentage: 90,
               controllerMutationRate: 20
             }
           },
           status: { conditions: { status: "Ready" } }
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
              {
                metadata: cr.metadata,
                spec: cr.spec,
                status: { conditions: { status: "Ready" } }
              }
      | UserUpdated(cr) =>
              if (user.status.conditions.status == "Deleted")
                user
              else
                {
                  metadata: cr.metadata,
                  spec: cr.spec,
                  status: {
                    conditions: {
                      status: if (cr.metadata.name.in(globalState.secrets)) "Ready" else "Pending"
                    }
                  }
                }
      | UserDeleted(username) =>
              {
                metadata: user.metadata,
                spec: user.spec,
                status: { conditions: { status: "Deleted" } }
              }
    }

  def processEvent(state: GlobalState, ev: Event): GlobalState =
    match ev {
      | UserCreatedWithSecret(cr) =>
        if (cr.metadata.name.in(state.users.keys()))
          {
            users: state.users.put(cr.metadata.name, reconcileUser(state.users.get(cr.metadata.name), ev)),
            secrets: state.secrets.union(Set(cr.metadata.name)),
            eventQueue: state.eventQueue,
            processedEvents: state.processedEvents + 1
          }
        else
          {
            users: state.users.put(cr.metadata.name, {
              metadata: cr.metadata,
              spec: cr.spec,
              status: { conditions: { status: "Ready" } }
            }),
            secrets: state.secrets.union(Set(cr.metadata.name)),
            eventQueue: state.eventQueue,
            processedEvents: state.processedEvents + 1
          }
      | UserUpdated(cr) =>
          if (cr.metadata.name.in(state.users.keys()))
            {
              users: state.users.put(cr.metadata.name, reconcileUser(state.users.get(cr.metadata.name), ev)),
              secrets: state.secrets,
              eventQueue: state.eventQueue,
              processedEvents: state.processedEvents + 1
            }
          else
            {
              users: state.users.put(cr.metadata.name, {
                metadata: cr.metadata,
                spec: cr.spec,
                status: { conditions: { status: "Ready" } }
              }),
              secrets: state.secrets.union(Set(cr.metadata.name)),
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
          else
            state
  }

  // ========================================
  // ============== INVARIANTS ==============
  // ========================================

  // If a user is "Ready", a secret must exist for them.
  // If a user is "Deleted", no secret must exist for them.
  val UserConsistency = globalState.users.keys().forall(u =>
    ((globalState.users.get(u).status.conditions.status == "Ready") implies globalState.secrets.contains(u))
    and
    ((globalState.users.get(u).status.conditions.status == "Deleted") implies not(globalState.secrets.contains(u)))
  )

  // a secret exists if and only if user is "Ready".
  val SecretsConsistency =
    globalState.users.keys().forall(u =>
      (globalState.secrets.contains(u)) ==
      (globalState.users.get(u).status.conditions.status == "Ready")
    )

  // No user marked as "Deleted" should have a secret.
  val NoSecretsForDeletedUsers =
    globalState.users.keys().forall(u =>
      (globalState.users.get(u).status.conditions.status == "Deleted") implies
      not(globalState.secrets.contains(u))
    )

  // Every "Ready" user must have a corresponding secret.
  val ReadyUsersMustHaveSecrets =
    globalState.users.keys().forall(u =>
      (globalState.users.get(u).status.conditions.status == "Ready") implies
      globalState.secrets.contains(u)
    )

  // Every event in the queue must refer to a known PotentialUser.
  val EventQueueWellFormed =
      length(globalState.eventQueue.select(ev =>
         match ev {
           | UserCreatedWithSecret(cr) => cr.metadata.name.in(PotentialUsers)
           | UserUpdated(cr) => cr.metadata.name.in(PotentialUsers)
           | UserDeleted(u)    => u.in(PotentialUsers)
         }
       )) == length(globalState.eventQueue)

  // ========================================
  // ========= QUOTAS INVARIANTS ============
  // ========================================

  // All quota values must be non-negative.
  val QuotasNonNegative =
    globalState.users.keys().forall(u =>
      (globalState.users.get(u).spec.quotas.producerByteRate >= 0) and
      (globalState.users.get(u).spec.quotas.consumerByteRate >= 0) and
      (globalState.users.get(u).spec.quotas.requestPercentage >= 0) and
      (globalState.users.get(u).spec.quotas.controllerMutationRate >= 0)
    )

  // The requestPercentage quota must be between 0 and 100 inclusive.
  val QuotasRequestPercentageValid =
    globalState.users.keys().forall(u =>
      (globalState.users.get(u).spec.quotas.requestPercentage >= 0) and
      (globalState.users.get(u).spec.quotas.requestPercentage <= 100)
    )

  // ========================================
  // ======== TEMPORAL PROPERTIES ===========
  // ========================================

  // A helper predicate that returns true if, for every potential user,
  // either the user is not present in the state or, if present, its status is "Ready" or "Deleted".
  def isStable(state: GlobalState): bool =
    PotentialUsers.forall(u =>
      (not(u.in(state.users.keys()))) or
      (state.users.get(u).status.conditions.status == "Ready") or
      (state.users.get(u).status.conditions.status == "Deleted")
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
