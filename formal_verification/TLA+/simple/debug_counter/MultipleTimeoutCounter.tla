---- MODULE MultipleTimeoutCounter ----

EXTENDS TLC, Integers

VARIABLES counter1, counter2, lock1, lock2

Init ==
    /\ counter1 = 0
    /\ counter2 = 0
    /\ lock1 = FALSE
    /\ lock2 = FALSE

Next ==
    \/ (counter1 < 10 /\ counter1' = counter1 + 1 /\ counter2' = counter2 /\ lock1' = lock1 /\ lock2' = lock2)
    \/ (counter1 = 10 /\ counter1' = counter1 /\ lock1' = TRUE /\ counter2' = counter2 /\ lock2' = lock2)
    \/ (lock1 /\ counter1' = 0 /\ lock1' = FALSE /\ counter2' = counter2 /\ lock2' = lock2)
    
    \/ (counter2 < 5 /\ counter2' = counter2 + 1 /\ lock2' = lock2 /\ counter1' = counter1 /\ lock1' = lock1)
    \/ (counter2 = 5 /\ counter2' = counter2 /\ lock2' = TRUE /\ counter1' = counter1 /\ lock1' = lock1)
    \/ (lock2 /\ counter2' = 0 /\ lock2' = FALSE /\ counter1' = counter1 /\ lock1' = lock1)

    \/ (counter1 = 10 /\ counter2 < 5 /\ counter2' = counter2 + 1 /\ lock2' = lock2 /\ counter1' = counter1 /\ lock1' = lock1)

\* SAFETY properties
MaxCounter1 == 
    counter1 <= 10

MaxCounter2 ==
    counter2 <= 5

\* LIVENESS properties
EventuallyReset1 ==
    <>(counter1 = 0)

EventuallyReset2 ==
    <>(counter2 = 0)

Spec == 
    Init /\ [][Next]_<<counter1, counter2, lock1, lock2>>

========
