---- MODULE DoorSystem ----
EXTENDS Integers

CONSTANTS Open, Closed
VARIABLES state

Init == state = Closed

OpenDoor == state = Closed /\ state' = Open
\* INVERSE action...
CloseDoor == state = Open /\ state' = Closed

\* NEXT relation...
Next == OpenDoor \/ CloseDoor

DelayedNext == TLCSet("pause", TRUE) /\ Next

Spec == Init /\ [][DelayedNext]_state

\* No matter what happens, the door will always eventually be closed again. This is useful for safety and security considerations.
AlwaysEventuallyClosed == []<>(state = Closed)

\* This ensures that the door won't stay closed forever, addressing usability.
EventuallyOpened == <>(state = Open)

\* Expresses that once the door is closed, it will stay that way until the next action is to open it; it reflects typical use-case scenarios.
RemainClosedUntilOpen == [](state = Closed => <>(state = Open))

============================
