(* Tests for the lambda calculus parser and reducers. *)

open Utils
open Parser
open Reducer

let rec evaluate ~verbose reduce t =
  if verbose then Printf.printf "%s\n" (format_term t);
  match reduce t with
  | None -> 
    if verbose then Printf.printf " =/=>\n\n";
    t
  | Some t' -> 
    if verbose then Printf.printf " ==>\n\n";
    evaluate ~verbose reduce t'

let s1 = "
let tru = (\\t.(\\f.t)) in
let fls = (\\t.(\\f.f)) in
let and = (\\b.(\\c. ((b c) fls))) in
((and tru) tru)
"

let s2 = "
let tru = (\\t.(\\f.t)) in
let fls = (\\t.(\\f.f)) in
let and = (\\b.(\\c. ((b c) fls))) in
((and fls) tru)
"

let s3 = "
((\\id1.(t1 id1)) (\\id2.(t1 t2)))
"

let s4 = "(\\x.x)"

let s5 = "(\\x.(\\y.(\\x.(x y))))"

let s6 = "((\\x.(x x)) ((\\y.y) z))"

let s7 = "
let f = (\\x.(\\y.(x y))) in
let g = (\\z.(\\w.(z w))) in
let h = (\\u.u) in
((f (g h)) a)
"

let () =
  Printf.printf "\nEvaluating:\n%s\nin cbn semantics:\n\n" s1;
  ignore (evaluate ~verbose:true reduce_cbn (parse s1));
  Printf.printf "\n\nEvaluating:\n%s\nin cbv semantics:\n\n" s2;
  ignore (evaluate ~verbose:true reduce_cbv (parse s2));

  Printf.printf "\n\nTesting on:\n%s\nReduce cbv\n\n" s3;
  ignore (evaluate ~verbose:true reduce_cbv (parse s3));
  Printf.printf "\n\nTesting on:\n%s\nReduce cbn\n\n" s3;
  ignore (evaluate ~verbose:true reduce_cbn (parse s3));

  Printf.printf "\n\nTesting Identity Function on:\n%s\nReduce cbv\n\n" s4;
  ignore (evaluate ~verbose:true reduce_cbv (parse s4));
  Printf.printf "\n\nTesting Identity Function on:\n%s\nReduce cbn\n\n" s4;
  ignore (evaluate ~verbose:true reduce_cbn (parse s4));

  Printf.printf "\n\nTesting Shadowing on:\n%s\nReduce cbv\n\n" s5;
  ignore (evaluate ~verbose:true reduce_cbv (parse s5));
  Printf.printf "\n\nTesting Shadowing on:\n%s\nReduce cbn\n\n" s5;
  ignore (evaluate ~verbose:true reduce_cbn (parse s5));

  Printf.printf "\n\nTesting Nested Applications on:\n%s\nReduce cbv\n\n" s6;
  ignore (evaluate ~verbose:true reduce_cbv (parse s6));
  Printf.printf "\n\nTesting Nested Applications on:\n%s\nReduce cbn\n\n" s6;
  ignore (evaluate ~verbose:true reduce_cbn (parse s6));

  Printf.printf "\n\nTesting Composition and Application on:\n%s\nReduce cbv\n\n" s7;
  ignore (evaluate ~verbose:true reduce_cbv (parse s7));
  Printf.printf "\n\nTesting Composition and Application on:\n%s\nReduce cbn\n\n" s7;
  ignore (evaluate ~verbose:true reduce_cbn (parse s7));
