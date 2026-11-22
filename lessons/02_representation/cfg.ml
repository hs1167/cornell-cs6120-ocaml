(* todo: construire les basic blocks puis la représentation cfg avec les 
prédecesseurs et les successeurs *)

(* introduction des types pour représenter les instructions (instr ou label), les bb et les cfg 

type instructions = 
  | Instr of string 
  | Label of string 
  | FlowCtrl of string 


type bb 

type cfg = { vertex : bb list ; edge : (bb * bb) list } (* on represente un graphe G = (V,E) *) *)


(* lire notre programme bril : *)

open Yojson.Basic.Util

let json = Yojson.Basic.from_file Sys.argv.(1)

let functions = to_list (member "functions" json)

  (* on a bien une fonction du style : nom de la fct -> ses instructions *)
let fct_to_their_instrs = (List.map (fun x -> (to_string (member "name" x), to_list (member "instrs" x))) functions)

(* todo: établir une conversion : Yojson.Basic.t -> instrs *)
(* on aura donc le pipeline :
  Yojson.Basic.t -> instrs -> bb list -> CFG   
  (la conversion)   (                   (construction cfg)
                    la construction   
                      des bb
                      )
*)

let is_label element = 
  match member "label" element with
  | `String _ -> true 
  | _ -> false 

let is_terminator element = 
  match member "op" element with
  | `String "br" -> true
  | `String "jmp" -> true
  | `String "ret" -> true 
  | _ -> false 

let rec make_bb ((f,instrs) : string * Yojson.Basic.t list) (acc : Yojson.Basic.t list list) curr = 
  match instrs with
  | [] -> if curr = [] then List.rev acc else List.rev ((List.rev curr) :: acc) 
  | fst_instr :: remains -> 
    if is_terminator fst_instr 
      then make_bb (f,remains) (List.rev (fst_instr :: curr) :: acc) []  
      else (if not (is_label fst_instr) 
        then make_bb (f,remains) acc (fst_instr :: curr)
        else match curr with 
        | [] -> make_bb (f,remains) acc [fst_instr]
        | _ :: _ -> 
          if ((List.filter is_label curr) = curr) 
            then make_bb (f,remains) acc (fst_instr::curr)   
            else make_bb (f,remains) (List.rev (curr) :: acc) [fst_instr])


let main =
  List.find (fun (name, _) -> name = "main") fct_to_their_instrs

let blocks = make_bb main [] []

let () =
  List.iteri
    (fun i block ->
      Printf.printf "\nBlock B%d :\n" i;
      List.iter
        (fun instr ->
          print_endline (Yojson.Basic.to_string instr))
        block)
    blocks

    (* (function_name, instructions) -> (function_name, basic_blocks) *)
let make_bb_generalized = List.map (fun (f,instr) -> (f, make_bb (f,instr) [] [])) fct_to_their_instrs


(* Afficher les basic blocks de chaque fonction, via chatgpt pcq ça me soûle d'écrire ce genre de trucs *)
let () =
  List.iter
    (fun (name, blocks) ->
      Printf.printf "\nFonction %s : %d blocs\n"
        name (List.length blocks);

      List.iteri
        (fun i block ->
          Printf.printf "\n  Block B%d :\n" i;
          List.iter
            (fun instr ->
              Printf.printf "    %s\n"
                (Yojson.Basic.to_string instr))
            block)
        blocks)
    make_bb_generalized



(* il me faudrait une fonction tq : label -> basic bloc dont le début est désigné par ce label 
pour construire plus tard les arêtes correspondates *)

(* on va introduire des identifiants pour les bb pour plus de clarté, il faudra donc ajouter une étape
de numérotation après la fct make_bb <- TODO *)
type bId = int 

type bb = bId * Yojson.Basic.t list 

type edge = bId * bId 

let numerotate = List.map (fun (f, bbs) -> (f, List.mapi (fun i bb -> (i, bb)) bbs)) make_bb_generalized

(* on établit la correspondance entre les labels d'un bloc et son identifiant *)
let label_of_block (b : bb) : (string * bId) list = match b with 
  | (id,b0) -> let lbls = List.filter (is_label) b0 in 
    List.map (fun lbl -> (to_string (member "label" lbl), id)) lbls 

(* par ce qui précède, il ne reste plus qu'à généraliser 
ceci à tous les blocs pour obtenir label_to_blockId    *)

let label_to_blockId (bbs : bb list) : (string * bId) list = List.concat (List.map label_of_block bbs)

(* super généralisation *)
let label_to_blockId_generalized = List.map (fun (f, bbs) -> (f, label_to_blockId bbs)) numerotate

(* on peut maintenant construire les arêtes avec deux cas : fall through ou labels *)


let rec make_edges (bbs : bb list) (keys : (string * bId) list) : edge list = 
  match bbs with
  | [] ->  []
  | (id,b0) :: tl -> 
    match List.rev b0 with
    | [] -> failwith "bloc vide"
    | hd::_ -> 
      match member "op" hd with 
      | `String "br" -> let lbl = to_list (member "labels" hd) in 
        let lbl_string = List.map to_string lbl in 
          let ids = List.map (fun label -> List.assoc label keys) lbl_string in 
            List.map (fun dest_id -> (id, dest_id)) ids @ make_edges tl keys 
      | `String "jmp" -> let lbl = to_list (member "labels" hd) in 
        let lbl_string = List.map to_string lbl in 
          let ids = List.map (fun label -> List.assoc label keys) lbl_string in 
            List.map (fun dest_id -> (id, dest_id)) ids @ make_edges tl keys
      | `String "ret" -> [] @ make_edges tl keys
      | `String _ -> 
        (match tl with 
        | (next_id, _) :: _ -> [(id, next_id)] @ make_edges tl keys
        | [] -> [] @ make_edges tl keys)
      | _ -> failwith "Dernier element sans operation"



let edges_by_function =
  List.map
    (fun (f, bbs) ->
      let keys = List.assoc f label_to_blockId_generalized in
      (f, make_edges bbs keys))
    numerotate

(*bout de code généré à l'ia, car à nouveau ça ne m'enthousiasme pas *)
let () =
List.iter
    (fun (f, edges) ->
      Printf.printf "\nFonction %s :\n" f;
      List.iter
        (fun (src, dst) ->
          Printf.printf "B%d -> B%d\n" src dst)
        edges)
    edges_by_function

type cfg = { vertex : bb list; edges : edge list }

let cfg_generalized : (string * cfg) list =
  List.map
    (fun (f, bbs) ->
      let keys = label_to_blockId bbs in
        let edges = make_edges bbs keys in
        (f, {vertex = bbs; edges = edges})) numerotate

(*merci chatgpt pour les bails de housekeeping*)
let () =
  List.iter
    (fun (f, graph) ->
      Printf.printf "\nCFG de %s :\n" f;
      Printf.printf "Sommets : %d\n" (List.length graph.vertex);

      List.iter
        (fun (src, dst) ->
          Printf.printf "B%d -> B%d\n" src dst)
        graph.edges)
    cfg_generalized