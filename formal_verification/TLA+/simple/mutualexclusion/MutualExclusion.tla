---------------------------- MODULE MutualExclusion ----------------------------

EXTENDS TLC, Integers

CONSTANTS PROCESSES

VARIABLES state, pc

(* --definition of the initial state *)
Init == 
    /\ state = [p \in PROCESSES |-> "idle"]
    /\ pc = [p \in PROCESSES |-> "try"]

(* --definition of the process model *)
Try(p) ==
    /\ pc[p] = "try"
    /\ state[p] = "idle"
    /\ state' = [state EXCEPT ![p] = "waiting"]
    /\ pc' = [pc EXCEPT ![p] = "critical"]

Critical(p) ==
    /\ pc[p] = "critical"
    /\ state[p] = "waiting"
    /\ state' = [state EXCEPT ![p] = "using"]
    /\ pc' = [pc EXCEPT ![p] = "release"]

Release(p) ==
    /\ pc[p] = "release"
    /\ state[p] = "using"
    /\ state' = [state EXCEPT ![p] = "idle"]
    /\ pc' = [pc EXCEPT ![p] = "try"]

(* --definition of the next-state relation *)
Next == 
    \/ \E p \in PROCESSES : Try(p)
    \/ \E p \in PROCESSES : Critical(p)
    \/ \E p \in PROCESSES : Release(p)

(* --definition of the safety property *)
MutualExclusion == 
    \A p1, p2 \in PROCESSES : 
        (p1 /= p2) => ~(state[p1] = "using" /\ state[p2] = "using")

(* --definition of the temporal properties *)
Spec == 
    Init /\ [][Next]_<<state, pc>> /\ WF_<<state, pc>>(Next)

=============================================================================
