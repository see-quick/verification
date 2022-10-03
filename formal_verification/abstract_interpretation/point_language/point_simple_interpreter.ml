(*
    Simple interpreter of Point language.

    It does not check specific syntax and except
    that program, which is provided is correct!
*)

open Stdlib;;

(* ------------------------------------------------- *)

(* Prints a list *)
let rec print_list = function
    [] -> ()
    | e::l ->
        print_string e ;
        print_string "\n" ;
        print_list l

(* Read a file and separate it with '\n' and output as list of strings *)
let lines file =
  let contents = In_channel.with_open_bin file In_channel.input_all in
  String.split_on_char '\n' contents

(* ------------------------------------------------- *)
(* --------------INTERPRET EVALUATION  ------------- *)
(* TODO: for each program command (i.e., init, translation, rotation, or and  iter) do the semantics... *)

let main () =
    (* DEBUG print input list   *)
(*    print_list(lines("point_language_example_1.txt"));*)
;;

main ()