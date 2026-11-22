let () =
  let programme = Bril.read stdin in
  match programme.functions with
  | [] -> print_endline "Le programme ne contient aucune fonction."
  | fonction :: _ ->
      Printf.printf "Fonction : %s\n" fonction.name;
      let instructions = fonction.instrs in
      match instructions with
      | [] -> print_endline "La fonction est vide."
      | Bril.Op (nom, _) :: _ -> Printf.printf "Première instruction : %s\n" nom
      | Bril.Label (nom, _) :: _ -> Printf.printf "Première étiquette : %s\n" nom
