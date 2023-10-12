---- MODULE Raft ----

(* This is still a high-level model of Raft and lacks many real-world details, including timeouts, heartbeat mechanisms,
    and more. But it captures the essence of leader election and log replication. *)
CONSTANTS Nodes, NULL, MaxTerm

VARIABLES currentTerm, votedFor, leader, logs, commitIndex

Init ==
    /\ currentTerm = [n \in Nodes |-> 0]
    /\ votedFor = [n \in Nodes |-> NULL]
    /\ leader = NULL
    /\ logs = [n \in Nodes |-> <<>>]
    /\ commitIndex = [n \in Nodes |-> 0]

IncreaseTerm(n) ==
    /\ currentTerm[n] = currentTerm[n] + 1
    /\ votedFor[n] = n
    /\ leader' = NULL
    /\ UNCHANGED <<logs, commitIndex>>

ReceiveVote(n, m) ==
    /\ votedFor[m] = n
    /\ UNCHANGED <<leader, currentTerm, logs, commitIndex>>

DeclareLeader(n) ==
    /\ leader' = n
    /\ UNCHANGED <<votedFor, currentTerm, logs, commitIndex>>

AppendLog(n, entry) ==  \* Node 'n' appends 'entry' to its log.
    /\ logs[n] = Append(logs[n], entry)
    /\ UNCHANGED <<votedFor, currentTerm, leader, commitIndex>>

CommitLog(n, index) ==  \* Node 'n' commits the log at position 'index'.
    /\ commitIndex[n] = index
    /\ UNCHANGED <<votedFor, currentTerm, leader, logs>>

\* This ensures that if a log entry is committed in a particular term, no other log entry at the same position can be committed in a different term.
ConsistentCommits ==
    \A n, m \in Nodes, i \in 1..Len(logs[n]) :
        /\ i <= commitIndex[n]
        /\ i <= commitIndex[m]
        => logs[n][i] = logs[m][i]

Next == \E n \in Nodes : IncreaseTerm(n)
       \/ \E n, m \in Nodes : ReceiveVote(n, m)
       \/ \E n \in Nodes : DeclareLeader(n)
       \/ \E n \in Nodes, entry \in DOMAIN logs[n] : AppendLog(n, entry)
       \/ \E n \in Nodes, i \in 1..Len(logs[n]) : CommitLog(n, i)

Spec == Init /\ [][Next]_<<currentTerm, votedFor, leader, logs, commitIndex>>
       /\ ConsistentCommits
====

