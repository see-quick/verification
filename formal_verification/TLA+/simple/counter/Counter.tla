------------------- MODULE Counter -------------------

EXTENDS Naturals, Sequences

VARIABLES value, op_sequence

(* --algorithm Counter
variables value = 0, op_sequence = <<>>;
begin
    Increment:
        value := value + 1;
        op_sequence := Append(op_sequence, "increment");

    Decrement:
        if value > 0 then
            value := value - 1;
            op_sequence := Append(op_sequence, "decrement");
        end if;
end algorithm; *)

\* INITIAL state
Init ==
    /\ value = 0
    /\ op_sequence = <<>>

\* Action for increment
Increment ==
    /\ value' = value + 1
    /\ op_sequence' = Append(op_sequence, "increment")

\* Action for decrement
Decrement ==
    /\ value > 0
    /\ value' = value - 1
    /\ op_sequence' = Append(op_sequence, "decrement")

Next ==
    \/ Increment
    \/ Decrement

\* Spec
Spec ==
    Init /\ [][Next]_<<value, op_sequence>>

\* Safety: The counter value is always non-negative
NonNegative ==
    value >= 0

\* Liveness: If incremented, it will eventually be decremented
WillDecrement ==
    <>(\E i \in DOMAIN op_sequence:
        op_sequence[i] = "increment"
        =>
        \E j \in DOMAIN op_sequence: j > i /\ op_sequence[j] = "decrement"
    )

======================================================