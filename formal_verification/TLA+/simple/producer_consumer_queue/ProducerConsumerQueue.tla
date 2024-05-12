---- MODULE ProducerConsumerQueue ----
EXTENDS Integers, Sequences

CONSTANT MaxLen  \* Maximum number of items in the queue

VARIABLES queue, prodIndex, consIndex

Init ==
    /\ queue = << >>   \* Start with an empty queue
    /\ prodIndex = 1
    /\ consIndex = 1

Produce ==
    /\ Len(queue) < MaxLen
    /\ queue' = Append(queue, prodIndex) \* Simulate production by appending index
    /\ prodIndex' = prodIndex + 1
    /\ consIndex' = consIndex

Consume ==
    /\ Len(queue) > 0
    /\ queue' = Tail(queue)  \* Remove the first element
    /\ consIndex' = consIndex + 1
    /\ prodIndex' = prodIndex

Next ==
    \/ Produce
    \/ Consume

Fairness ==
    /\ WF_<<queue, prodIndex, consIndex>>(Produce)
    /\ WF_<<queue, prodIndex, consIndex>>(Consume)

\* State constraint that limits the indices
StateConstraint ==
    /\ prodIndex <= 1
    /\ consIndex <= 1

Spec ==
    Init /\ [][Next]_<<queue, prodIndex, consIndex>> /\ Fairness /\ StateConstraint

Invariant ==
    /\ Len(queue) <= MaxLen
    /\ prodIndex >= consIndex  \* Ensures production index is never less than consumption index
    /\ prodIndex - consIndex <= MaxLen  \* Difference should not exceed the max length of the queue
==== 
