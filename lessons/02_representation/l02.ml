(* TODO : Concevoir et exécuter un benchmark Bril. *)
(* TODO : Inventer un petit outil d’analyse ou de transformation et le tester avec Turnt. *)
(* TODO : Concevoir la représentation des basic blocks et du CFG, puis les construire. *)


(* idée pour construire les basic blocks à partir d'une IR bril ish sous forme de liste d'instructions *)

(* du code sous forme d'IR linéaire (une liste d'instructions en somme) 
contient soit des instructions soit des labels; on crée deux tyes qui correspondront *)

(* type linearcode = 
  | Instr of string  
  | Lbl of string *) 


(* lire notre programme bril : *)

open Yojson.Basic.Util

let json = Yojson.Basic.from_file Sys.argv.(1)

let functions =
  json |> member "functions" |> to_list

let first_fct =
  match functions with
  | f :: _ -> f
  | [] -> failwith "Aucune fonction"

let instructions =
  first_fct |> member "instrs" |> to_list

let first_istr = match instructions with 
  | x :: _ -> x 
  | [] -> failwith "liste vide"

let operation = to_string (member "op" first_istr)
  
let () =
  print_endline operation

let destination = to_string (member "dest" first_istr)

let () =
  print_endline destination

let () =
  Printf.printf "Nombre d'elements : %d\n"
    (List.length instructions)


  (* ici element est un élément du type Yojson.Basic.t (un objet json), ie une instruction ou un label*)
let is_label element = 
  match member "label" element with
  | `String _ -> true 
  | _ -> false 

let label_count = List.length (List.filter is_label instructions)

let () = 
  Printf.printf "Nombre de labels : %d\n"
    label_count


let is_add element = 
  match member "op" element with 
  | `String "add" -> true 
  | _ -> false 


let add_count = List.length (List.filter is_add instructions)

let () = 
  Printf.printf "Nombre de add : %d\n"
    add_count

let is_op op element = 
  match member "op" element with 
  | `String name when name = op -> true
  | _ -> false 

let op_count op = List.length (List.filter (is_op op) instructions)

let () =
  Printf.printf "add : %d\n" (op_count "add");
  Printf.printf "br  : %d\n" (op_count "br");
  Printf.printf "mul : %d\n" (op_count "mul")