---- MODULE TrafficLight ----
EXTENDS Integers, Sequences

(* -- Define the states using an enumeration -- *)
CONSTANTS Green, Yellow, Red

(* -- Declare the variable representing the current state of the traffic light -- *)
VARIABLES light

(* -- Define the initial state -- *)
Init == light = Green

(* -- Describe the transition between states -- *)
Next == \/ (light = Green /\ light' = Yellow)
         \/ (light = Yellow /\ light' = Red)
         \/ (light = Red /\ light' = Green)

(* -- Specify the temporal formula that describes the system behavior -- *)
Spec == Init /\ [][Next]_light

(* -- Add a fairness condition if needed (usually for liveness properties) -- *)
FairSpec == Spec /\ WF_light(Next)

(* -- Optional properties to check -- *)
Properties ==
  /\ []<>(light = Green)  (* Always eventually Green *)
  /\ []<>(light = Yellow) (* Always eventually Yellow *)
  /\ []<>(light = Red)    (* Always eventually Red *)

(* Correctness conditions to check might include that the light is never two colors at once, etc. *)
Invariants == light \in {Green, Yellow, Red}

============================

