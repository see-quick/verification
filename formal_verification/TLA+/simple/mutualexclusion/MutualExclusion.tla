------------------------- MODULE MutualExclusion -------------------------

EXTENDS Naturals, FiniteSets

CONSTANTS ProcSet

(* State Variables *)
VARIABLES state, inCriticalSection

(* Initial state: No process is in the critical section *)
Init ==
    /\ state = [p \in ProcSet |-> "noncritical"]
    /\ inCriticalSection = {}

(* Action for a process to try to enter the critical section *)
TryEnterCriticalSection(p) ==
    /\ state[p] = "noncritical"
    /\ state' = [state EXCEPT ![p] = "trying"]
    /\ inCriticalSection' = inCriticalSection

(* Action for a process to enter the critical section *)
EnterCriticalSection(p) ==
    /\ state[p] = "trying"
    /\ inCriticalSection = {}
    /\ state' = [state EXCEPT ![p] = "critical"]
    /\ inCriticalSection' = {p}

(* Action for a process to exit the critical section *)
ExitCriticalSection(p) ==
    /\ state[p] = "critical"
\*    /\ FALSE  \* (If we add this line, the TLC will reach deadlock)
    /\ state' = [state EXCEPT ![p] = "noncritical"]
    /\ inCriticalSection' = {}

(* Define the next state in terms of possible actions *)
Next ==
    \/ \E p \in ProcSet: TryEnterCriticalSection(p)
    \/ \E p \in ProcSet: EnterCriticalSection(p)
    \/ \E p \in ProcSet: ExitCriticalSection(p)

Spec == Init /\ [][Next]_<<state, inCriticalSection>>

(* Safety property: At most one process is in the critical section *)
Safety ==
    Cardinality(inCriticalSection) <= 1

=============================================================================
