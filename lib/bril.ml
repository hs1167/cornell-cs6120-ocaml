type fields = (string * Yojson.Safe.t) list
type instr = Label of string * fields | Op of string * fields
type func = { name : string; instrs : instr list; fields : fields }
type program = { functions : func list; fields : fields }

exception Invalid_bril of string

let invalid path message = raise (Invalid_bril (path ^ " : " ^ message))

let object_fields path = function
  | `Assoc fields -> fields
  | _ -> invalid path "objet JSON attendu"

let string path = function
  | `String value -> value
  | _ -> invalid path "chaîne attendue"

let take path name fields =
  match List.assoc_opt name fields with
  | Some value -> (value, List.remove_assoc name fields)
  | None -> invalid path ("champ manquant : " ^ name)

let elements path decode = function
  | `List items ->
      List.mapi (fun i item -> decode (Printf.sprintf "%s[%d]" path i) item) items
  | _ -> invalid path "tableau attendu"

let instr_of_json path json =
  let fields = object_fields path json in
  match List.assoc_opt "label" fields, List.assoc_opt "op" fields with
  | Some label, None ->
      Label (string (path ^ ".label") label, List.remove_assoc "label" fields)
  | None, Some op ->
      Op (string (path ^ ".op") op, List.remove_assoc "op" fields)
  | _ -> invalid path "un seul des champs label et op est requis"

let func_of_json path json =
  let fields = object_fields path json in
  let name, fields = take path "name" fields in
  let instrs, fields = take path "instrs" fields in
  { name = string (path ^ ".name") name;
    instrs = elements (path ^ ".instrs") instr_of_json instrs;
    fields }

let of_json json =
  let functions, fields = take "$" "functions" (object_fields "$" json) in
  { functions = elements "$.functions" func_of_json functions; fields }

let instr_to_json = function
  | Label (name, fields) -> `Assoc (("label", `String name) :: fields)
  | Op (name, fields) -> `Assoc (("op", `String name) :: fields)

let func_to_json (func : func) =
  `Assoc (("name", `String func.name)
          :: ("instrs", `List (List.map instr_to_json func.instrs))
          :: func.fields)

let to_json program =
  `Assoc (("functions", `List (List.map func_to_json program.functions)) :: program.fields)

let read channel = of_json (Yojson.Safe.from_channel channel)
let load path = In_channel.with_open_bin path read

let write_json channel json =
  Yojson.Safe.pretty_to_channel ~std:true channel json;
  output_char channel '\n'
