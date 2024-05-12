--------------------------- MODULE DeadlockExample ---------------------------

EXTENDS TLC, Integers, Sequences

CONSTANTS Processes, Locks, None

VARIABLES lockState, procState

(* --initialization of variables, mapping locks to no process and process to idle state. *)
Init == 
    /\ lockState = [l \in Locks |-> None]
    /\ procState = [p \in Processes |-> "idle"]

(* --define process attempts to acquire a lock *)
TryLock(p, l) ==
    /\ procState[p] = "idle"
    /\ lockState[l] = None
    /\ procState' = [procState EXCEPT ![p] = "waiting"]
    /\ lockState' = [lockState EXCEPT ![l] = p]

(* --process acquires all necessary locks and runs *)
AcquireLocksAndRun(p) ==
    /\ procState[p] = "waiting"
    /\ (\A l \in Locks : lockState[l] = p)
    /\ procState' = [procState EXCEPT ![p] = "running"]

(* --Next state relation combining all possible actions *)
Next ==
    \/ \E p \in Processes, l \in Locks : TryLock(p, l)
    \/ \E p \in Processes : AcquireLocksAndRun(p)

(* --Deadlock condition *)
Deadlock == 
    \A p \in Processes : procState[p] = "waiting"

NoDeadlock ==
    ~Deadlock

(* --Specification: start from Init and follow Next unless deadlock is detected *)
Spec == Init /\ [][Next]_<<lockState, procState>> 

=============================================================================
