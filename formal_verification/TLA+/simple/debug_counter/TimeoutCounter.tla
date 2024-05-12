---- MODULE TimeoutCounter ----

EXTENDS TLC, Integers

VARIABLES counter, lock

Init ==
    counter = 0 /\ lock = FALSE

Next ==
    \/ (counter < 10 /\ counter' = counter + 1 /\ lock' = FALSE)
    \/ (counter = 10 /\ counter' = counter /\ lock' = TRUE)
    \/ (lock /\ counter' = 0 /\ lock' = FALSE)

DelayedNext == TLCSet("pause", TRUE) /\ Next

\* SAFETY property
MaxCounter == 
    counter <= 10

\* LIVENESS property
EventuallyReset ==
    <>(counter = 0)

Spec == 
    Init /\ [][Next]_<<counter, lock>>

========