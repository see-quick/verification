------------------------------ MODULE ProducerConsumerWithoutWeakFairness ------------------------------

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

(* --specification without weak fairness *)
Spec ==
    /\ Init
    /\ [][Next]_<<queue, prodEnabled, consEnabled>>

(* --correctness properties *)
Prop1 ==
    Len(queue) <= MaxLen

\* LIVENESS property
\*  If there is ever a point after which the consumer is always enabled and 
\*  there are items in the queue, then it must be the case that eventually 
\*  the consumer always has the opportunity to consume infinitely often.
StarvationFreeConsumer ==
    []<>(consEnabled /\ Len(queue) > 0) =>
    []<>(\E x \in 0..MaxLen: consEnabled /\ Len(queue) = x => <>(Len(queue) < x))

\* eventually, there is a stabilization or reduction in the queue length that is sustained.
CheckLivelock ==
    <>[](\E n \in 0..MaxLen: Len(queue) <= n)




====================================================================================
