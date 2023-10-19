---- MODULE DistributedSystemSiple ----

EXTENDS Naturals, Sequences, FiniteSets

CONSTANTS Nodes, NULL, Majority
ASSUME Nodes \subseteq {1,2,3,...} /\ NULL \notin Nodes /\ Majority = (Cardinality(Nodes) \div 2) + 1

VARIABLES Leader, Logs, Timeouts, Heartbeats, Clock, PartitionedNodes

Init ==
    /\ Leader = NULL
    /\ Logs = [n \in Nodes |-> <<>>]
    /\ Timeouts = [n \in Nodes |-> 5]  (* Arbitrary timeout value *)
    /\ Heartbeats = [n \in Nodes |-> Clock]
    /\ Clock = 0
    /\ PartitionedNodes = {}

(* Simulate Network Partition *)
Partition ==
    /\ PartitionedNodes = {}
    /\ PartitionedNodes' = { n \in SUBSET Nodes: Cardinality(n) < Majority }

HealPartition ==
    /\ PartitionedNodes /= {}
    /\ PartitionedNodes' = {}

SendHeartbeat ==
    /\ Leader /= NULL
    /\ Leader \notin PartitionedNodes
    /\ Heartbeats' = [n \in Nodes \ PartitionedNodes |-> Clock]
    /\ Clock' = Clock + 1

DetectFailure ==
    /\ \E n \in Nodes : Clock > Heartbeats[n] + Timeouts[n]
    /\ Leader' = NULL
    /\ UNCHANGED <<Logs, Timeouts, Heartbeats, Clock>>

TryBecomeLeader ==
    /\ Leader = NULL
    /\ \E n \in Nodes \ PartitionedNodes:
         /\ Cardinality(Nodes \ PartitionedNodes) >= Majority
         /\ Logs[n] = CHOOSE maxLog \in UNION {Logs[m] : m \in Nodes \ PartitionedNodes} : maxLog
         /\ Leader' = n
    /\ UNCHANGED <<Logs, Timeouts, Heartbeats, Clock>>

ReplicateLog ==
    /\ Leader /= NULL
    /\ Leader \notin PartitionedNodes
    /\ Logs' = [n \in Nodes \ PartitionedNodes |-> Logs[Leader]]
    /\ UNCHANGED <<Leader, Timeouts, Heartbeats, Clock>>

AppendLog ==
    /\ Leader /= NULL
    /\ Leader \notin PartitionedNodes
    /\ \E entry \in {1, 2, 3, ...}:  (* Assuming log entries are just natural numbers for simplicity *)
         Logs' = [n \in Nodes |-> IF n \notin PartitionedNodes THEN Append(Logs[n], entry) ELSE Logs[n]]
    /\ UNCHANGED <<Leader, Timeouts, Heartbeats, Clock>>

ConsistentReplication ==
    /\ Leader /= NULL
    /\ Leader \notin PartitionedNodes
    /\ \A n \in Nodes \ PartitionedNodes:
         /\ Logs[Leader] = Prefix(Logs[n])  (* Leader's log is a prefix of node n's log *)
    /\ Logs' = [n \in Nodes \ PartitionedNodes |-> Logs[Leader]]
    /\ UNCHANGED <<Leader, Timeouts, Heartbeats, Clock>>

Next ==
    \/ SendHeartbeat
    \/ DetectFailure
    \/ TryBecomeLeader
    \/ AppendLog
    \/ ConsistentReplication
    \/ Partition
    \/ HealPartition

====

