let usage = {|Usage : cs6120 COMMANDE [programme.json|-]

  json                         Lire et réémettre le JSON Bril (fichier ou stdin)

Commandes à raccorder au fil des leçons :
  benchmark                    Benchmark L2 (aucune entrée)
  mini | blocks | cfg          Petit outil, basic blocks, CFG (L2)
  tdce | lvn                   Optimisations locales (L3)
  dataflow                     Analyse de flot de données (L4)
  dominators | tree | frontier Dominance (L5)
  into-ssa | out-of-ssa        Conversions SSA (L6)|}

let usage_error () =
  prerr_endline usage;
  exit 2

let read_program = function
  | "-" -> Bril.read stdin
  | path -> Bril.load path

(* Les branchements CLI sont indépendants des interfaces des exercices. *)
let run command file =
  match command with
  | "json" -> Bril.write_json stdout (Bril.to_json (read_program file))
  | "mini" | "blocks" | "cfg" | "tdce" | "lvn" | "dataflow"
  | "dominators" | "tree" | "frontier" | "into-ssa" | "out-of-ssa" ->
      raise (Exercise.Not_implemented command)
  | _ -> usage_error ()

let () =
  try
    match Array.to_list Sys.argv with
    | [_; ("-h" | "--help")] -> print_endline usage
    | [_; "benchmark"] -> raise (Exercise.Not_implemented "benchmark")
    | [_; cmd] -> run cmd "-"
    | [_; cmd; file] -> run cmd file
    | _ -> usage_error ()
  with
  | Exercise.Not_implemented command ->
      Printf.eprintf "TODO · commande %s à raccorder dans bin/main.ml\n" command;
      exit 3
  | Bril.Invalid_bril message | Yojson.Json_error message | Sys_error message ->
      prerr_endline message;
      exit 1
