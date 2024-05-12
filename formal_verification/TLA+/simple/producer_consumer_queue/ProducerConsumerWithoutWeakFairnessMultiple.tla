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

StarvationFreeConsumers ==
    []<>(\E c \in 1..NumConsumers: consEnabled[c] /\ Len(queue) > 0) =>
    []<>(\E c \in 1..NumConsumers: consEnabled[c] /\ Len(queue) > 0 => 
        <>(\E x \in 0..MaxLen: consEnabled[c] /\ Len(queue) = x => <>(Len(queue) < x)))

CheckLivelock ==
    <>[](\E n \in 0..MaxLen: Len(queue) = n)

====================================================================================
