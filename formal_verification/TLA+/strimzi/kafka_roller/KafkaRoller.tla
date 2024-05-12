---------------------------- MODULE KafkaRoller ----------------------------

EXTENDS Integers, Sequences, FiniteSets

CONSTANTS
  ControllerNodes,         \* Set of nodes with the controller role
  BrokerNodes,             \* Set of nodes with the broker role
  CombinedNodes,           \* Set of nodes with both controller and broker roles
  MaxRestartAttempts,      \* Maximum number of restart attempts allowed per node
  MaxRetries               \* Maximum number of retries allowed per node

\* The set of all nodes in the system
Nodes == ControllerNodes \union BrokerNodes \union CombinedNodes

VARIABLES
  nodeState,               \* The state of each node
  activeController,        \* The node that is currently the active controller (the quorum leader)
  restartingNodes,         \* The set of nodes currently undergoing a restart
  reconfiguringNodes       \* The set of nodes currently being reconfigured

vars == <<nodeState, activeController, restartingNodes, reconfiguringNodes>>

\* The possible states a node can be in, as described in the KafkaRoller 2.0 spec
NodeStates == {"UNKNOWN", "NOT_RUNNING", "NOT_READY", "RESTARTED", "RECONFIGURED",
               "RECOVERING", "SERVING", "LEADING_ALL_PREFERRED"}

\* Initialize the system state
Init ==
  LET
    \* Assign roles to each node based on the corresponding sets
    nodeRoles == [n \in Nodes |->
                   IF n \in ControllerNodes THEN {"controller"}
                   ELSE IF n \in BrokerNodes THEN {"broker"}
                   ELSE IF n \in CombinedNodes THEN {"controller", "broker"}
                   ELSE {}]
  IN
    \* Ensure no node is initialized directly into a RESTARTED state.
    /\ nodeState = [n \in Nodes |->
         [state |-> "UNKNOWN",
          roles |-> nodeRoles[n],
          restartAttempts |-> 0,
          retries |-> 0]]
    /\ activeController \in {n \in Nodes : "controller" \in nodeState[n].roles}
    /\ restartingNodes = {}
    /\ reconfiguringNodes = {}

\* ValidTransitions, returns the set of valid next states for a given current state.
ValidTransitions(state) == 
  CASE state = "UNKNOWN" -> {"NOT_RUNNING", "NOT_READY", "RECOVERING", "SERVING"}
  [] state = "NOT_RUNNING" -> {"RESTARTED", "SERVING"}
  [] state = "NOT_READY" -> {"RESTARTED", "SERVING"}
  [] state = "RESTARTED" -> {"NOT_RUNNING", "NOT_READY", "RECOVERING", "SERVING"}
  [] state = "RECONFIGURED" -> {"NOT_RUNNING", "NOT_READY", "RESTARTED", "SERVING"}
  [] state = "RECOVERING" -> {"SERVING"}
  [] state = "SERVING" -> {"RESTARTED", "RECONFIGURED", "LEADING_ALL_PREFERRED"}
  [] state = "LEADING_ALL_PREFERRED" -> {}

\* Observe the state of a node and non-deterministically transition to a new state
ObserveNode(n) ==
  /\ LET validStates == ValidTransitions(nodeState[n].state)
     IN nodeState' = [nodeState EXCEPT ![n].state = CHOOSE s \in validStates : TRUE]
  /\ UNCHANGED <<activeController, restartingNodes, reconfiguringNodes>>

\* Restart a node if it hasn't exceeded the maximum restart attempts
RestartNode(n) ==
  LET
    controllerNodes == {m \in Nodes : "controller" \in nodeState[m].roles}
    restartingControllers == {m \in restartingNodes : "controller" \in nodeState[m].roles}
    activeControllers == {m \in controllerNodes : m \notin restartingControllers}
    operationalControllers == Cardinality(activeControllers)
    requiredOperational == (Cardinality(controllerNodes) \div 2) + 1
  IN
    /\ n \in Nodes \* Only applicable to nodes that are part of the system
    /\ nodeState[n].restartAttempts < MaxRestartAttempts
    /\ "RESTARTED" \in ValidTransitions(nodeState[n].state)
    /\ operationalControllers > requiredOperational \* Ensure quorum is not breached
    /\ nodeState' = [nodeState EXCEPT
         ![n].state = "RESTARTED",
         ![n].restartAttempts = nodeState[n].restartAttempts + 1]
    /\ restartingNodes' = restartingNodes \union {n}
    /\ UNCHANGED <<activeController, reconfiguringNodes>>


\* Reconfigure a node if it is in the "SERVING" state
ReconfigureNode(n) ==
  /\ nodeState[n].state = "SERVING"
  /\ "RECONFIGURED" \in ValidTransitions(nodeState[n].state)
  /\ nodeState' = [nodeState EXCEPT ![n].state = "RECONFIGURED"]
  /\ reconfiguringNodes' = reconfiguringNodes \union {n}
  /\ UNCHANGED <<activeController, restartingNodes>>

\* Transition a node to the "SERVING" state after a restart or reconfiguration
NodeServing(n) ==
  /\ \/ nodeState[n].state = "RESTARTED"
     \/ nodeState[n].state = "RECONFIGURED"
     \/ nodeState[n].state = "RECOVERING"
  /\ "SERVING" \in ValidTransitions(nodeState[n].state)  
  /\ nodeState' = [nodeState EXCEPT ![n].state = "SERVING"]
  /\ UNCHANGED <<activeController>>
  /\ restartingNodes' = restartingNodes \ {n}
  /\ reconfiguringNodes' = reconfiguringNodes \ {n}

\* Retry an operation on a node if it hasn't exceeded the maximum retries
RetryNode(n) ==
  /\ nodeState[n].retries < MaxRetries
  /\ ("RESTARTED" \in ValidTransitions(nodeState[n].state) \/ "RECONFIGURED" \in ValidTransitions(nodeState[n].state))
  /\ nodeState' = [nodeState EXCEPT ![n].retries = nodeState[n].retries + 1]
  /\ UNCHANGED <<activeController, restartingNodes, reconfiguringNodes>>


\* The possible next states of the system
Next ==
  \/ \E n \in Nodes : ObserveNode(n)
  \/ \E n \in Nodes : RestartNode(n)
  \/ \E n \in Nodes : ReconfigureNode(n)
  \/ \E n \in Nodes : NodeServing(n)
  \/ \E n \in Nodes : RetryNode(n)
  
\* The system specification
Spec == Init /\ [][Next]_vars

(* Invariants *)

\* No node should exceed the maximum restart attempts
NodesWithinRestartLimit ==
  \A n \in Nodes : nodeState[n].restartAttempts <= MaxRestartAttempts

\* No node should exceed the maximum retries
NodesWithinRetryLimit ==
  \A n \in Nodes : nodeState[n].retries <= MaxRetries

\* The active controller should not be restarted to maintain quorum
ActiveControllerNotRestarted ==
  activeController \notin restartingNodes

\* A majority of controller nodes should always be maintained
\* This is crucial for maintaining quorum and system availability
ControllerQuorumMaintained ==
  LET controllerNodes == {n \in Nodes : "controller" \in nodeState[n].roles}
  IN Cardinality(controllerNodes \ restartingNodes) >= (Cardinality(controllerNodes) \div 2) + 1

(* Properties to check *)

\* All nodes should eventually reach the "SERVING" or "LEADING_ALL_PREFERRED" state
\* This ensures that the system reaches a stable and operational state
AllNodesServing ==
  <>(\A n \in Nodes : nodeState[n].state = "SERVING" \/ nodeState[n].state = "LEADING_ALL_PREFERRED")

\* Nodes should not get stuck in the "RECOVERING" state indefinitely
\* This helps identify issues where nodes are unable to fully recover
NodesNotStuckRecovering ==
  \A n \in Nodes : nodeState[n].state = "RECOVERING" ~> nodeState[n].state /= "RECOVERING"

\* Assert that the invariants hold throughout the system execution
Invariants ==
  /\ NodesWithinRestartLimit
  /\ ActiveControllerNotRestarted
  /\ ControllerQuorumMaintained
  /\ NodesWithinRetryLimit

\* Assert that the system specification and properties hold
Properties ==
  /\ Spec
  /\ []Invariants
  /\ AllNodesServing
  /\ NodesNotStuckRecovering

====

