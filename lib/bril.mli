(** Structure du JSON Bril. Les champs supplémentaires restent accessibles
    avec [List.assoc_opt] et sont réémis, y compris les métadonnées. *)
type fields = (string * Yojson.Safe.t) list
type instr = Label of string * fields | Op of string * fields
type func = { name : string; instrs : instr list; fields : fields }
type program = { functions : func list; fields : fields }

exception Invalid_bril of string

val of_json : Yojson.Safe.t -> program
val to_json : program -> Yojson.Safe.t
val instr_to_json : instr -> Yojson.Safe.t
val read : in_channel -> program
val load : string -> program
val write_json : out_channel -> Yojson.Safe.t -> unit
