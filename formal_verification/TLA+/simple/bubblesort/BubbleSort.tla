---- MODULE BubbleSort ----
EXTENDS Integers, Sequences

(* --description This module specifies the Bubble Sort algorithm for sorting a sequence of integers. *)

VARIABLES seq, sorting_done

(* Helper function to swap elements in the sequence. *)
Swap(s, m, n) ==
    [s EXCEPT ![m] = s[n], ![n] = s[m]]

(* Check if a sequence is sorted. *)
IsSorted(s) ==
    \A i \in 1..(Len(s) - 1) : s[i] <= s[i + 1]

(* Define the initial state where seq is any sequence of integers and sorting is not done. *)
Init ==
    /\ seq = <<5, 3, 8, 1, 2>>
    /\ sorting_done = FALSE

(* Define the sorting process. It involves swapping adjacent elements if they are out of order. *)
Next ==
    \/ \E i \in 1..(Len(seq) - 1) :
          /\ seq[i] > seq[i+1]
          /\ seq' = Swap(seq, i, i+1)
          /\ UNCHANGED sorting_done
    \/ \A i \in 1..(Len(seq) - 1) : seq[i] <= seq[i+1]
          /\ sorting_done' = TRUE
          /\ UNCHANGED seq

(* Safety Invariant: once sorting is done, the sequence should be sorted. *)
SortingInvariant ==
    sorting_done => IsSorted(seq)

(* Liveness Property: Eventually, sorting will be done. *)
EventuallySorted == <>(sorting_done = TRUE)

====
