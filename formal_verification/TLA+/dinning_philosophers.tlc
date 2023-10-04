------------------ MODULE DiningPhilosophers ------------------

EXTENDS Naturals

CONSTANTS Thinking, Hungry, Eating

VARIABLES philosopher, fork

(* Initial state *)
Init == 
    /\ philosopher = [i \in 1..2 |-> Thinking]
    /\ fork = [i \in 1..2 |-> i]  (* i-th fork is in front of the i-th philosopher *)

(* Philosopher i tries to pick up forks *)
TryToEat(i) ==
    /\ philosopher[i] = Hungry
    /\ fork[i] = i
    /\ philosopher = [philosopher EXCEPT ![i] = Eating]
    /\ fork = [fork EXCEPT ![i] = 0] (* philosopher i has the fork *)

(* Philosopher i finishes eating and starts thinking *)
FinishEating(i) ==
    /\ philosopher[i] = Eating
    /\ philosopher = [philosopher EXCEPT ![i] = Thinking]
    /\ fork = [fork EXCEPT ![i] = i]  (* philosopher i releases the fork *)

(* Next possible actions *)
Next ==
    \/ \E i \in 1..2: TryToEat(i)
    \/ \E i \in 1..2: FinishEating(i)

(* Safety property: No two philosophers are eating at the same time *)
Safety == 
    ~(\E i, j \in 1..2 : i /= j /\ philosopher[i] = Eating /\ philosopher[j] = Eating)

================================================================

