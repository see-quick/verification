-------------- MODULE Stack --------------
EXTENDS Naturals, Sequences

VARIABLES stack

Init == stack = << >>

Push(x) == stack' = Append(stack, x)

Pop == /\ Len(stack) > 0
       /\ stack' = SubSeq(stack, 1, Len(stack) - 1)

Next == \E x \in 1..10: Push(x) \/ Pop

(* Safety properties (something bad happen) *)
(* The stack never contains more than N elements (assuming a max size N for the stack) *)
StackMaxSize == Len(stack) <= N
(* The stack is never negative in length *)
StackNonNegative == Len(stack) >= 0
(* After a Pop, the stack should be smaller *)
StackShrinksAfterPop == /\ Pop
                        /\ Len(stack') < Len(stack)
(* After a Push, the stack should be larger *)
StackGrowsAfterPush == /\ \E x \in 1..10 : Push(x)
                        /\ Len(stack') > Len(stack)

=========================================
