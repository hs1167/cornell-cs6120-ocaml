let check name ok =
  if not ok then failwith name;
  Printf.printf "OK  %s\n" name

let round_trip name json =
  check name (Yojson.Safe.equal json (Bril.to_json (Bril.of_json json)))

let malformed name text expected =
  match Bril.of_json (Yojson.Safe.from_string text) with
  | _ -> failwith (name ^ " : entrée acceptée")
  | exception Bril.Invalid_bril message -> check name (message = expected)

let () =
  let path = Sys.argv.(1) in
  let program = Bril.load path in
  check "lecture du fichier officiel add.json"
    (Yojson.Safe.equal (Yojson.Safe.from_file path) (Bril.to_json program));
  round_trip "programme vide" (`Assoc ["functions", `List []]);
  round_trip "types, label, positions, opération inconnue et entier 64 bits"
    (Yojson.Safe.from_string {|{
      "version": 1, "functions": [{
        "name": "f", "args": [{"name":"p","type":{"ptr":"int"}}], "type":"int",
        "instrs":[{"label":"start","pos":{"row":1,"col":1}},
                  {"op":"const","dest":"x","type":"int","value":9223372036854775807},
                  {"op":"future_op","custom":[true,null],"funcs":["g"],"labels":["start"]}]
      }]}|});
  malformed "champ functions obligatoire" {|{}|} "$ : champ manquant : functions";
  malformed "instrs doit être une liste" {|{"functions":[{"name":"f","instrs":0}]}|}
    "$.functions[0].instrs : tableau attendu";
  malformed "ambiguïté entre label et op"
    {|{"functions":[{"name":"f","instrs":[{"label":"x","op":"nop"}]}]}|}
    "$.functions[0].instrs[0] : un seul des champs label et op est requis"
