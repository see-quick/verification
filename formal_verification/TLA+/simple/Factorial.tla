----------------- MODULE Factorial -----------------
EXTENDS Naturals

VARIABLES n, result

(* Recursive factorial function *)
RECURSIVE Fact(_)
Fact(x) ==
    IF x = 0 THEN 1
    ELSE x * Fact(x-1)

(* Initialization *)
Init ==
    /\ n \in 0..5  (* We limit n to a small number for illustration purposes *)
    /\ result = Fact(n)

(* Safety property: The result should be the factorial of n *)
Safety == result = Fact(n)

Spec == Init /\ [][UNCHANGED <<n, result>>]_<<n, result>>

====================================================