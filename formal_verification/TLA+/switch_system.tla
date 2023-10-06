------------------ MODULE LightSwitch ------------------

EXTENDS Naturals

CONSTANTS ON, OFF

VARIABLE light

(* Initial state *)
Init == light = OFF

(* Turn the light on *)
TurnOn ==
    /\ light = OFF
    /\ light' = ON

(* Turn the light off *)
TurnOff ==
    /\ light = ON
    /\ light' = OFF

(* Next possible actions *)
Next ==
    \/ TurnOn
    \/ TurnOff

(* Safety property: Light should not be turned ON twice consecutively *)
Safety == [] (light = ON => (light' = OFF))

================================================================
