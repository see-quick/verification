------------------------------ MODULE ProducerConsumerQueue ------------------------------

EXTENDS Integers, Sequences

(* --constants *)
CONSTANTS MaxLen

(* --state variables *)
VARIABLES queue, prodEnabled, consEnabled

(* --initial state *)
Init ==
    /\ queue = << >>
    /\ prodEnabled = TRUE
    /\ consEnabled = FALSE

(* --producer action *)
Produce ==
    /\ prodEnabled
    /\ Len(queue) < MaxLen
    /\ queue' = Append(queue, "item")
    /\ prodEnabled' = IF Len(queue') < MaxLen THEN TRUE ELSE FALSE
    /\ consEnabled' = TRUE

(* --consumer action *)
Consume ==
    /\ consEnabled
    /\ Len(queue) > 0
    /\ queue' = Tail(queue)
    /\ consEnabled' = IF Len(queue') > 0 THEN TRUE ELSE FALSE
    /\ prodEnabled' = TRUE

(* --next state relation *)
Next ==
    \/ Produce
    \/ Consume

(* --fainess conditions *)
Fairness ==
    /\ WF_<<queue, prodEnabled, consEnabled>>(Produce)  \* Weak fairness for Produce
    /\ WF_<<queue, prodEnabled, consEnabled>>(Consume)  \* Weak fairness for Consume

(* --specification *)
Spec ==
    /\ Init
    /\ [][Next]_<<queue, prodEnabled, consEnabled>>
    /\ Fairness

(* --correctness properties *)
Prop1 ==
    Len(queue) <= MaxLen

====================================================================================
