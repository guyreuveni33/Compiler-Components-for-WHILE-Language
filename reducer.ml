(*
  Reducers (interpreters) for lambda-calculus.
*)

open Utils
open Parser


exception OutOfVariablesError


let possible_variables = List.map (fun x -> char_to_string (char_of_int x)) ((range 97 123) @ (range 65 91))


let fresh_var used_vars : string = 
  if StringSet.is_empty (StringSet.diff (string_set_from_list(possible_variables)) used_vars) 
  then raise (OutOfVariablesError)
  else StringSet.choose (StringSet.diff (string_set_from_list(possible_variables)) used_vars)


let rec fv = function
  | Variable x -> StringSet.singleton x
  | Abstraction (x, t) -> StringSet.remove x (fv t)
  | Application (t1, t2) -> StringSet.union (fv t1) (fv t2)

let extract_some = function
  | Some x -> x 

let rec substitute (x : string) (s : term) (t : term) : term =
  match t with
  | Variable y -> if y = x then s else t
  | Abstraction (y, t1) ->
      if y = x then
        t
      else if StringSet.mem y (fv s) then
        let z = fresh_var (StringSet.union (fv s) (fv t1)) in
        let t1_subst = substitute y (Variable z) t1 in
        substitute x s (Abstraction (z, t1_subst))
      else
        Abstraction (y, substitute x s t1)
  | Application (t1, t2) -> Application (substitute x s t1, substitute x s t2)


let rec reduce_cbv term =
  match term with
  | Variable _ -> None
  | Abstraction (_, _) -> None 
  | Application (Abstraction (x, t1), t2) when is_value t2 ->
      Some (substitute x t2 t1)
  | Application (t1, t2) ->
      (match reduce_cbv t1 with
      | Some t1' -> Some (Application (t1', t2))
      | None ->
          if is_value t2 then None
          else match reduce_cbv t2 with
               | Some t2' -> Some (Application (t1, t2'))
               | None -> None)

and is_value term =
  match term with
  | Abstraction (_, _) -> true 
  | Variable _ -> true 
  | _ -> false 

let rec reduce_cbn term =
  match term with
  | Variable _ -> None
  | Abstraction (_, _) -> None 
  | Application (Abstraction (x, t1), t2) ->
      Some (substitute x t2 t1)
  | Application (t1, t2) ->
      (match reduce_cbn t1 with
      | Some t1' -> Some (Application (t1', t2))
      | None -> 
          (match t1 with
          | Abstraction (_, _) -> Some (Application (t1, t2))
          | _ -> None))
