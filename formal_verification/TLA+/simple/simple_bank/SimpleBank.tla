---- MODULE SimpleBank ----
EXTENDS Integers

(* --description This specification models a simple banking system with two accounts.
                  It ensures that the total amount of money remains constant. *)

VARIABLES acc1, acc2

(* Initial state condition *)
Init ==
    /\ acc1 = 10
    /\ acc2 = 20

(* Next state relation *)
Next ==
    \/ /\ acc1 > 0
       /\ acc2' = acc2 + 1
       /\ acc1' = acc1 - 1
    \/ /\ acc2 > 0
       /\ acc1' = acc1 + 1
       /\ acc2' = acc2 - 1

(* Invariant to ensure the total money remains the same *)
MoneyInvariant == acc1 + acc2 = 30

====
