-------------- MODULE Counter --------------
EXTENDS Naturals

VARIABLES counter

Init == counter = 0

Increment == counter' = counter + 1
Decrement == counter' = counter - 1

Next == Increment \/ Decrement

===========================================