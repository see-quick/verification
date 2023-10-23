----------------- MODULE LightSwitch -----------------

EXTENDS Naturals

VARIABLES isOn

Init == isOn \in {0, 1}

Toggle == IF isOn = 1 THEN isOn' = 0 ELSE isOn' = 1

Next == Toggle

InvariantIsOn == isOn \in BOOLEAN

Spec == Init /\ [][Next]_<<isOn>>

=============================================================================
