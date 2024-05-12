---- MODULE SimpleCounter ----
EXTENDS Integers, TLC

VARIABLES counter

Init == 
    counter = 0

Next == 
    \/ counter < 10 /\ counter' = counter + 1
    \/ counter = 10 /\ counter' = counter

DelayedNext == TLCSet("pause", TRUE) /\ Next

Spec == 
    Init /\ [][DelayedNext]_counter

MAX_COUNTER == 
    counter <= 10

==== 