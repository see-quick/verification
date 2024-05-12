------------------------------ MODULE ProducerConsumerWithoutWeakFairnessMultiple ------------------------------

EXTENDS Integers, Sequences

(* --constants *)
CONSTANTS MaxLen, NumProducers, NumConsumers

(* --state variables *)
VARIABLES queue, prodEnabled, consEnabled, prodCount, consCount

(* --initial state *)
Init ==
    /\ queue = << >>
    /\ prodEnabled = [p \in 1..NumProducers |-> TRUE]
    /\ consEnabled = [c \in 1..NumConsumers |-> FALSE]
    /\ prodCount = [p \in 1..NumProducers |-> 0]
    /\ consCount = [c \in 1..NumConsumers |-> 0]

(* --producer action *)
Produce(p) ==
    /\ prodEnabled[p]
    /\ Len(queue) < MaxLen
    /\ queue' = Append(queue, "item")
    /\ prodEnabled' = [prodEnabled EXCEPT ![p] = IF Len(queue') < MaxLen THEN TRUE ELSE FALSE]
    /\ consEnabled' = [c \in 1..NumConsumers |-> TRUE]
    /\ prodCount' = [prodCount EXCEPT ![p] = prodCount[p] + 1]
    /\ UNCHANGED consCount

(* --consumer action *)
Consume(c) ==
    /\ consEnabled[c]
    /\ Len(queue) > 0
    /\ queue' = Tail(queue)
    /\ consEnabled' = [consEnabled EXCEPT ![c] = IF Len(queue') > 0 THEN TRUE ELSE FALSE]
    /\ prodEnabled' = [p \in 1..NumProducers |-> TRUE]
    /\ consCount' = [consCount EXCEPT ![c] = consCount[c] + 1]
    /\ UNCHANGED prodCount

(* --next state relation *)
Next ==
    \/ \E p \in 1..NumProducers: Produce(p)
    \/ \E c \in 1..NumConsumers: Consume(c)

(* --specification *)
Spec ==
    /\ Init
    /\ [][Next]_<<queue, prodEnabled, consEnabled, prodCount, consCount>>
    \* WEAK FAIRNESS preventing livelock to happen
    \* /\ WF_<<queue, prodEnabled, consEnabled, prodCount, consCount>>(Next)

StarvationFreeConsumers ==
    []<>(\E c \in 1..NumConsumers: consEnabled[c] /\ Len(queue) > 0) =>
    []<>(\E c \in 1..NumConsumers: consEnabled[c] /\ Len(queue) > 0 => 
        <>(\E x \in 0..MaxLen: consEnabled[c] /\ Len(queue) = x => <>(Len(queue) < x)))

\*   Ensure that the system eventually reaches a state where 
\*   the queue length remains constant as a simpler check for no livelock.
CheckLivelock ==
    <>[](\E n \in 0..MaxLen: Len(queue) = n)

NoDeadlock ==
    \/ \E p \in 1..NumProducers: prodEnabled[p] /\ Len(queue) < MaxLen
    \/ \E c \in 1..NumConsumers: consEnabled[c] /\ Len(queue) > 0
====================================================================================
