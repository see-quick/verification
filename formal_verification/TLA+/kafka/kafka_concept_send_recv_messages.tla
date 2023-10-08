------------------ MODULE SimpleKafka ------------------

EXTENDS Naturals, Sequences

(*-- CONSTANTS --*)
MaxMsgs == 3 (* Maximum number of messages a producer can send *)

(*-- VARIABLES --*)
VARIABLES
    producerCount, (* Number of messages produced *)
    brokerQueue,   (* Broker's queue of messages *)
    consumerCount  (* Number of messages consumed *)

(*-- Initial State --*)
Init ==
    /\ producerCount = 0
    /\ brokerQueue = <<>>  (* Empty sequence *)
    /\ consumerCount = 0

(*-- Producer sends a message to the broker --*)
Produce ==
    /\ producerCount < MaxMsgs
    /\ producerCount' = producerCount + 1
    /\ brokerQueue' = Append(brokerQueue, producerCount + 1)
    /\ UNCHANGED consumerCount

(*-- Consumer retrieves a message from the broker --*)
Consume ==
    /\ Len(brokerQueue) > 0
    /\ consumerCount' = consumerCount + 1
    /\ brokerQueue' = Tail(brokerQueue)
    /\ UNCHANGED producerCount

(*-- Possible Actions --*)
Next ==
    \/ Produce
    \/ Consume

(*-- Safety Property: Consumer should never consume more messages than the producer produced --*)
Safety == consumerCount <= producerCount

================================================================
