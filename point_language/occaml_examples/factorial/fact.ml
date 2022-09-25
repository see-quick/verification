(* Fact program w/ main *)

let rec fact n =
  if n = 0 then 1
  else n * fact (n - 1)
;;

(* Additional functions...*)

let main () =
  if Array.length Sys.argv <> 2 then begin
    print_string "Usage: fact <number>";
    print_newline ()
  end else begin
      try
        print_string("Fact ");
        print_int(int_of_string Sys.argv.(1));
        print_string(" is ");
        print_int(fact (int_of_string Sys.argv.(1)));
        print_newline ()
      with Failure "int_of_string" ->
        print_string "Bad integer constant";
        print_newline ()
  end
;;

main ();;