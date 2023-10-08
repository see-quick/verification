-------------- MODULE Stack --------------
EXTENDS Naturals, Sequences

VARIABLES stack

Init == stack = << >>

Push(x) == stack' = Append(stack, x)

Pop == /\ Len(stack) > 0
       /\ stack' = SubSeq(stack, 1, Len(stack) - 1)

Next == \E x \in 1..10: Push(x) \/ Pop

=========================================
