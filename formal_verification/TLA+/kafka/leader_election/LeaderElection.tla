---- MODULE LeaderElection ----

CONSTANTS Nodes,    \* The set of all nodes in the system.
          NULL      \* A value indicating no leader.

VARIABLES leader,   \* The current leader of the system.
          candidates \* Nodes that are available for leadership.

Init ==
    /\ leader = NULL
    /\ candidates = Nodes

Fail ==
    /\ candidates' = candidates \ {CHOOSE n \in candidates: TRUE}
    /\ leader' = IF leader \in candidates' THEN leader ELSE NULL
    /\ candidates \ candidates' /= {} \* Ensure we actually remove a candidate.

Elect ==
    /\ leader = NULL
    /\ leader' \in candidates
    /\ UNCHANGED candidates

Next == Fail \/ Elect

(* SAFETY PROPERTY: There should only ever be one leader at any given time. *)
OneLeader ==
    /\ leader \in Nodes \union {NULL}
    /\ (leader \in Nodes) => (Cardinality({n \in Nodes: n = leader}) = 1)

(* LIVENESS PROPERTY: If there is no leader and there are available candidates, eventually one of them should become the leader. *)
\* <> -> eventually temporal operator
ElectLeader ==
    []((leader = NULL /\ candidates /= {}) => <>(leader \in candidates))


Spec == Init /\ [][Next]_ <<leader, candidates>>
             /\ OneLeader
             /\ ElectLeader

====
