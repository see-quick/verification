---- MODULE SimpleRaft ----

CONSTANTS Nodes,  \* The set of all nodes.
          NULL    \* Indicates no leader.

VARIABLES currentTerm,  \* The current term (increases over time).
          votedFor,     \* Node each node voted for.
          leader,       \* Current leader.
          logs          \* Log entries for each node.

Init ==
    /\ currentTerm = [n \in Nodes |-> 0]  \* All nodes start in term 0.
    /\ votedFor = [n \in Nodes |-> NULL]  \* Initially, no node has voted for anyone.
    /\ leader = NULL
    /\ logs = [n \in Nodes |-> <<>>]      \* Empty logs for all nodes.

StartElection(n) ==
    /\ currentTerm[n] = currentTerm[n] + 1
    /\ votedFor[n] = n  \* Node votes for itself.
    /\ leader' = NULL   \* No leader yet.
    /\ UNCHANGED <<logs>>

ReceiveVote(n, m) ==  \* Node m votes for node n.
    /\ votedFor[m] = n
    /\ UNCHANGED <<leader, currentTerm, logs>>

DeclareLeader(n) ==
    /\ leader' = n
    /\ UNCHANGED <<votedFor, currentTerm, logs>>

Next == \E n \in Nodes: StartElection(n)
       \/ \E n,m \in Nodes : ReceiveVote(n, m)
       \/ \E n \in Nodes : DeclareLeader(n)

\* Ensure that at most one leader is elected per term.
OneLeaderPerTerm ==
    \A t \in DOMAIN currentTerm : Cardinality({n \in Nodes: leader[n] = t}) <= 1

====

