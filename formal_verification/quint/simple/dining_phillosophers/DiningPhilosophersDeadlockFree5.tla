# Usage statistics is OFF. We care about your privacy.
# If you want to help our project, consider enabling statistics with config --enable-stats=true.

Output directory: /Users/morsak/Documents/Work/verification/formal_verification/quint/_apalache-out/server/2025-03-14T10-34-31_3049362898670883813
# APALACHE version: 0.47.2 | build: def5e8e                       I@10:34:31.466
Starting server on port 8822...                                   I@10:34:31.470
The Apalache server is running on port 8822. Press Ctrl-C to stop.
PASS #0: SanyParser                                               I@10:34:32.417
-------------------- MODULE DiningPhilosophersDeadlockFree5 --------------------

EXTENDS Integers, Sequences, FiniteSets, TLC, Apalache, Variants

VARIABLE
  (*
    @type: Set(Int);
  *)
  DiningPhilosophersDeadlockFree5_DiningPhilosophers_forks

VARIABLE
  (*
    @type: Set(<<Int, Int>>);
  *)
  DiningPhilosophersDeadlockFree5_DiningPhilosophers_taken

VARIABLE
  (*
    @type: (Int -> Str);
  *)
  DiningPhilosophersDeadlockFree5_DiningPhilosophers_states

(*
  @type: (() => Int);
*)
DiningPhilosophersDeadlockFree5_DiningPhilosophers_N == 5

(*
  @type: ((Int) => Int);
*)
DiningPhilosophersDeadlockFree5_DiningPhilosophers_leftFork(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_35) ==
  DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_35

(*
  @type: (() => Set(Int));
*)
DiningPhilosophersDeadlockFree5_DiningPhilosophers_philosophers ==
  0 .. DiningPhilosophersDeadlockFree5_DiningPhilosophers_N - 1

(*
  @type: ((Int) => Bool);
*)
DiningPhilosophersDeadlockFree5_DiningPhilosophers_becomeHungry(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_151) ==
  DiningPhilosophersDeadlockFree5_DiningPhilosophers_states[
      DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_151
    ]
      = "THINKING"
    /\ DiningPhilosophersDeadlockFree5_DiningPhilosophers_states'
      := [
        DiningPhilosophersDeadlockFree5_DiningPhilosophers_states EXCEPT
          ![DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_151] = "HUNGRY"
      ]
    /\ DiningPhilosophersDeadlockFree5_DiningPhilosophers_taken'
      := DiningPhilosophersDeadlockFree5_DiningPhilosophers_taken
    /\ DiningPhilosophersDeadlockFree5_DiningPhilosophers_forks'
      := DiningPhilosophersDeadlockFree5_DiningPhilosophers_forks

(*
  @type: ((Int) => Int);
*)
DiningPhilosophersDeadlockFree5_DiningPhilosophers_rightFork(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_45) ==
  (DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_45 + 1)
    % DiningPhilosophersDeadlockFree5_DiningPhilosophers_N

(*
  @type: ((Int) => Int);
*)
DiningPhilosophersDeadlockFree5_DiningPhilosophers_leftPhilosopher(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_57) ==
  (DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_57 - 1
    + DiningPhilosophersDeadlockFree5_DiningPhilosophers_N)
    % DiningPhilosophersDeadlockFree5_DiningPhilosophers_N

(*
  @type: ((Int) => Int);
*)
DiningPhilosophersDeadlockFree5_DiningPhilosophers_rightPhilosopher(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_67) ==
  (DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_67 + 1)
    % DiningPhilosophersDeadlockFree5_DiningPhilosophers_N

(*
  @type: (() => Bool);
*)
DiningPhilosophersDeadlockFree5_DiningPhilosophers_init ==
  DiningPhilosophersDeadlockFree5_DiningPhilosophers_forks' := {}
    /\ DiningPhilosophersDeadlockFree5_DiningPhilosophers_taken' := {}
    /\ DiningPhilosophersDeadlockFree5_DiningPhilosophers_states'
      := [
        DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_126 \in
          DiningPhilosophersDeadlockFree5_DiningPhilosophers_philosophers |->
          "THINKING"
      ]

(*
  @type: ((Int) => Bool);
*)
DiningPhilosophersDeadlockFree5_DiningPhilosophers_canPickBoth(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_83) ==
  ~(DiningPhilosophersDeadlockFree5_DiningPhilosophers_leftFork(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_83)
      \in DiningPhilosophersDeadlockFree5_DiningPhilosophers_forks)
    /\ ~(DiningPhilosophersDeadlockFree5_DiningPhilosophers_rightFork(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_83)
      \in DiningPhilosophersDeadlockFree5_DiningPhilosophers_forks)

(*
  @type: ((Int) => Bool);
*)
DiningPhilosophersDeadlockFree5_DiningPhilosophers_canEat(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_115) ==
  ((<<
          DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_115, (DiningPhilosophersDeadlockFree5_DiningPhilosophers_leftFork(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_115))
        >>
          \in DiningPhilosophersDeadlockFree5_DiningPhilosophers_taken
        /\ <<
          DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_115, (DiningPhilosophersDeadlockFree5_DiningPhilosophers_rightFork(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_115))
        >>
          \in DiningPhilosophersDeadlockFree5_DiningPhilosophers_taken)
      /\ DiningPhilosophersDeadlockFree5_DiningPhilosophers_states[
        (DiningPhilosophersDeadlockFree5_DiningPhilosophers_leftPhilosopher(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_115))
      ]
        /= "EATING")
    /\ DiningPhilosophersDeadlockFree5_DiningPhilosophers_states[
      (DiningPhilosophersDeadlockFree5_DiningPhilosophers_rightPhilosopher(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_115))
    ]
      /= "EATING"

(*
  @type: ((Int) => Bool);
*)
DiningPhilosophersDeadlockFree5_DiningPhilosophers_releaseForks(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_247) ==
  DiningPhilosophersDeadlockFree5_DiningPhilosophers_states[
      DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_247
    ]
      = "EATING"
    /\ DiningPhilosophersDeadlockFree5_DiningPhilosophers_taken'
      := (DiningPhilosophersDeadlockFree5_DiningPhilosophers_taken
        \ { <<
            DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_247, (DiningPhilosophersDeadlockFree5_DiningPhilosophers_leftFork(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_247))
          >>,
          <<
            DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_247, (DiningPhilosophersDeadlockFree5_DiningPhilosophers_rightFork(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_247))
          >> })
    /\ DiningPhilosophersDeadlockFree5_DiningPhilosophers_forks'
      := (DiningPhilosophersDeadlockFree5_DiningPhilosophers_forks
        \ { (DiningPhilosophersDeadlockFree5_DiningPhilosophers_leftFork(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_247)),
          (DiningPhilosophersDeadlockFree5_DiningPhilosophers_rightFork(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_247))
        })
    /\ DiningPhilosophersDeadlockFree5_DiningPhilosophers_states'
      := [
        DiningPhilosophersDeadlockFree5_DiningPhilosophers_states EXCEPT
          ![DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_247] =
            "THINKING"
      ]

(*
  @type: (() => Bool);
*)
DiningPhilosophersDeadlockFree5_DiningPhilosophers_Safety ==
  (\A DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_323 \in DiningPhilosophersDeadlockFree5_DiningPhilosophers_philosophers:
      ~(DiningPhilosophersDeadlockFree5_DiningPhilosophers_states[
          DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_323
        ]
          = "EATING"
        /\ DiningPhilosophersDeadlockFree5_DiningPhilosophers_states[
          (DiningPhilosophersDeadlockFree5_DiningPhilosophers_rightPhilosopher(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_323))
        ]
          = "EATING"))
    /\ (\A DiningPhilosophersDeadlockFree5_DiningPhilosophers_f_339 \in DiningPhilosophersDeadlockFree5_DiningPhilosophers_forks:
      Cardinality({
        DiningPhilosophersDeadlockFree5_DiningPhilosophers_pair_334 \in
          DiningPhilosophersDeadlockFree5_DiningPhilosophers_taken:
          DiningPhilosophersDeadlockFree5_DiningPhilosophers_pair_334[2]
            = DiningPhilosophersDeadlockFree5_DiningPhilosophers_f_339
      })
        <= 1)

(*
  @type: (() => Bool);
*)
q_init == DiningPhilosophersDeadlockFree5_DiningPhilosophers_init

(*
  @type: ((Int) => Bool);
*)
DiningPhilosophersDeadlockFree5_DiningPhilosophers_pickBothForks(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_187) ==
  DiningPhilosophersDeadlockFree5_DiningPhilosophers_states[
      DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_187
    ]
      = "HUNGRY"
    /\ DiningPhilosophersDeadlockFree5_DiningPhilosophers_canPickBoth(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_187)
    /\ DiningPhilosophersDeadlockFree5_DiningPhilosophers_states'
      := DiningPhilosophersDeadlockFree5_DiningPhilosophers_states
    /\ DiningPhilosophersDeadlockFree5_DiningPhilosophers_taken'
      := (DiningPhilosophersDeadlockFree5_DiningPhilosophers_taken
        \union { <<
            DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_187, (DiningPhilosophersDeadlockFree5_DiningPhilosophers_leftFork(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_187))
          >>,
          <<
            DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_187, (DiningPhilosophersDeadlockFree5_DiningPhilosophers_rightFork(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_187))
          >> })
    /\ DiningPhilosophersDeadlockFree5_DiningPhilosophers_forks'
      := (DiningPhilosophersDeadlockFree5_DiningPhilosophers_forks
        \union { (DiningPhilosophersDeadlockFree5_DiningPhilosophers_leftFork(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_187)),
          (DiningPhilosophersDeadlockFree5_DiningPhilosophers_rightFork(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_187))
        })

(*
  @type: ((Int) => Bool);
*)
DiningPhilosophersDeadlockFree5_DiningPhilosophers_eat(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_210) ==
  DiningPhilosophersDeadlockFree5_DiningPhilosophers_states[
      DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_210
    ]
      = "HUNGRY"
    /\ DiningPhilosophersDeadlockFree5_DiningPhilosophers_canEat(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_210)
    /\ DiningPhilosophersDeadlockFree5_DiningPhilosophers_states'
      := [
        DiningPhilosophersDeadlockFree5_DiningPhilosophers_states EXCEPT
          ![DiningPhilosophersDeadlockFree5_DiningPhilosophers_p_210] = "EATING"
      ]
    /\ DiningPhilosophersDeadlockFree5_DiningPhilosophers_taken'
      := DiningPhilosophersDeadlockFree5_DiningPhilosophers_taken
    /\ DiningPhilosophersDeadlockFree5_DiningPhilosophers_forks'
      := DiningPhilosophersDeadlockFree5_DiningPhilosophers_forks

(*
  @type: (() => Bool);
*)
q_inv == DiningPhilosophersDeadlockFree5_DiningPhilosophers_Safety

(*
  @type: (() => Bool);
*)
DiningPhilosophersDeadlockFree5_DiningPhilosophers_step ==
  \E DiningPhilosophersDeadlockFree5_DiningPhilosophers_p \in DiningPhilosophersDeadlockFree5_DiningPhilosophers_philosophers:
    DiningPhilosophersDeadlockFree5_DiningPhilosophers_becomeHungry(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p)
      \/ DiningPhilosophersDeadlockFree5_DiningPhilosophers_pickBothForks(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p)
      \/ DiningPhilosophersDeadlockFree5_DiningPhilosophers_eat(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p)
      \/ DiningPhilosophersDeadlockFree5_DiningPhilosophers_releaseForks(DiningPhilosophersDeadlockFree5_DiningPhilosophers_p)

(*
  @type: (() => Bool);
*)
q_step == DiningPhilosophersDeadlockFree5_DiningPhilosophers_step

================================================================================
