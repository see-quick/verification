---- MODULE CounterSafety ----
EXTENDS Integers

VARIABLES count

(* Initial state condition *)
Init == count = 0

(* Next state relation *)
Next == \/ (count < 10 /\ count' = count + 1)
         \/ (count = 10 /\ count' = count)

(* --algorithm CounterSafety
variables
    count = 0;

begin
  Increment:
    while count < 10 do
      count := count + 1;
    end while;
end algorithm; *)

\* Safety property
TypeInvariant == count <= 10

====
