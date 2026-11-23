# CS6120 · Advanced Compilers en OCaml

Atelier autonome pour les leçons 1 à 6 du cours d’Adrian Sampson, printemps 2025. Dune compile les modules OCaml, Yojson assure les entrées-sorties Bril et les outils officiels servent de référence pour les essais. [Parcours officiel, vidéos et lectures](https://www.cs.cornell.edu/courses/cs6120/2025sp/self-guided/)

## Commencer la leçon 2

Dans un terminal Bash sous Ubuntu/WSL, exécuter les commandes suivantes. Refaire `source ./env.sh` à chaque nouveau terminal.

```bash
cd /home/hs1167/dev/CS6120
source ./env.sh
dune build
dune runtest
dune exec cs6120 -- json examples/add.json
dune exec cs6120 -- json < examples/add.json | brili
turnt examples/add.json
```

La première exécution de `json` affiche l’IR et la seconde l’envoie à l’interpréteur officiel. La sortie attendue est `3`. Turnt la compare à `examples/add.out`.

Ouvrir [la leçon 2](lessons/02_representation/README.md) et [l02.ml](lessons/02_representation/l02.ml). Le module contient les objectifs sous forme de commentaires. À toi de choisir les types, les fonctions, la représentation des blocs et du CFG, ainsi que les tests de ton travail. [Énoncé officiel](https://www.cs.cornell.edu/courses/cs6120/2025sp/lesson/2/#tasks)

## Parcours et fichiers

| Énoncé Cornell | Objectifs | Espace de travail |
| --- | --- | --- |
| [1 · Welcome & Overview](https://www.cs.cornell.edu/courses/cs6120/2025sp/lesson/1/#tasks) | Lire le syllabus et les ressources sur l’évaluation empirique. | [Leçon 1](lessons/01_overview/README.md) |
| [2 · Representing Programs](https://www.cs.cornell.edu/courses/cs6120/2025sp/lesson/2/#tasks) | Écrire un benchmark et un petit outil, le tester avec Turnt, former les basic blocks et construire le CFG. | [Leçon 2](lessons/02_representation/README.md) |
| [3 · Local Analysis & Optimization](https://www.cs.cornell.edu/courses/cs6120/2025sp/lesson/3/#tasks) | Implémenter TDCE et LVN, évaluer la correction et les gains sur un corpus. | [Leçon 3](lessons/03_local/README.md) |
| [4 · Data Flow](https://www.cs.cornell.edu/courses/cs6120/2025sp/lesson/4/#tasks) | Choisir, implémenter et vérifier une analyse. Le solveur générique est un bonus. | [Leçon 4](lessons/04_dataflow/README.md) |
| [5 · Global Analysis](https://www.cs.cornell.edu/courses/cs6120/2025sp/lesson/5/#tasks) | Calculer les dominateurs, l’arbre et les frontières de dominance. Vérifier les résultats. | [Leçon 5](lessons/05_global/README.md) |
| [6 · Static Single Assignment](https://www.cs.cornell.edu/courses/cs6120/2025sp/lesson/6/#tasks) | Convertir vers SSA et hors SSA, vérifier la forme et le comportement puis mesurer le surcoût. | [Leçon 6](lessons/06_ssa/README.md) |

## Architecture

- [lib/bril.mli](lib/bril.mli) expose le lecteur et le sérialiseur JSON ainsi que les valeurs OCaml qu’ils échangent. Les champs supplémentaires comme les positions ou les champs d’extension sont conservés. [Syntaxe JSON](https://capra.cs.cornell.edu/bril/lang/syntax.html) · [Core Bril](https://capra.cs.cornell.edu/bril/lang/core.html)
- [lessons/](lessons/) regroupe le travail OCaml par leçon. Dune compile les modules même avant leur raccordement à la CLI. Tu peux organiser le code et ajouter des interfaces au fil de tes choix.
- [bin/main.ml](bin/main.ml) gère les commandes et les diagnostics. `json` lit un fichier ou stdin et réémet le programme sur stdout. Les autres noms de commandes sont réservés pour les exercices.
- [test/](test/) vérifie le lecteur et le sérialiseur. [examples/](examples/) contient le test Turnt de bout en bout sur [add.json, exemple officiel](https://github.com/sampsyo/bril/blob/1c8604d22a2655ca0d5bdaf4bb70390b5ca23527/test/parse/add.json).
- [scripts/](scripts/) installe les outils de référence et compare deux exécutions. Les outils sont dans `.tools/`, les produits de compilation dans `_build/`. Le dossier `.scratch/` peut accueillir tes résultats temporaires.

## Utiliser la CLI

```bash
source ./env.sh
dune build
cs6120 --help
cs6120 json examples/add.json
bril2json < .tools/bril/test/parse/add.bril | cs6120 json - | bril2txt
bril2json < .tools/bril/benchmarks/core/arithmetic-series.bril | brili -p 7
```

Avec l’argument `7`, `arithmetic-series` affiche `28`. L’option `-p` écrit `total_dyn_inst: 7` sur stderr. Après une modification, `dune exec cs6120 -- …` reconstruit et lance l’outil. [Interpréteur](https://capra.cs.cornell.edu/bril/tools/interp.html) · [Format texte](https://capra.cs.cornell.edu/bril/tools/text.html)

Les noms `benchmark`, `mini`, `blocks`, `cfg`, `tdce`, `lvn`, `dataflow`, `dominators`, `tree`, `frontier`, `into-ssa` et `out-of-ssa` restent disponibles. Initialement, ils signalent un `TODO` sur stderr et sortent avec le code 3. Quand tu veux rendre un exercice exécutable, raccorde son nom dans [bin/main.ml](bin/main.ml) au code que tu as écrit. Tu choisis le format de sortie de tes analyses.

## Vérifier son travail

**Tests d’infrastructure.** `dune runtest --force` vérifie la lecture, l’aller-retour JSON et le rejet d’entrées mal formées. `turnt examples/add.json` teste le passage par la CLI et l’interpréteur. Les deux fonctionnent dès l’ouverture du projet.

**Tests personnels.** Pour la leçon 2, la [configuration Turnt](lessons/02_representation/turnt.toml) lance `cs6120 mini`. Une fois ton outil raccordé, ajoute ton entrée et sa sortie attendue, ou adapte la commande à ton propre exécutable. Avec un fichier nommé `mon_cas.json`, Turnt compare stdout à `mon_cas.out`. Le contenu attendu t’appartient. [Turnt](https://github.com/cucapra/turnt)

```bash
turnt --diff lessons/02_representation/mon_cas.json
```

**Comportement et mesures.** Avec deux programmes JSON et les arguments de leur `@main`, `scripts/compare original.json résultat.json 7` exécute les deux programmes et compare leurs sorties pour cette entrée. Brench mesure la référence dès maintenant. Tu peux ajouter un traitement à sa configuration quand une de tes transformations est prête. [Configuration Brench](brench.toml) · [Benchmarks officiels](https://capra.cs.cornell.edu/bril/tools/bench.html)

```bash
turnt -e brili .tools/bril/benchmarks/core/arithmetic-series.bril
brench brench.toml .tools/bril/benchmarks/core/arithmetic-series.bril
```

Pour la leçon 6, `python3 .tools/bril/examples/is_ssa.py < résultat.json` affiche `yes` ou `no` pour le contrôle des destinations répétées. L’interpréteur installé prend en charge l’extension SSA `set`, `get`, `undef`. [Extension SSA](https://capra.cs.cornell.edu/bril/lang/ssa2.html) · [Vérificateur officiel](https://github.com/sampsyo/bril/blob/1c8604d22a2655ca0d5bdaf4bb70390b5ca23527/examples/is_ssa.py)

## Reproduire l’environnement

L’atelier a été validé dans **Ubuntu 24.04, WSL2, x86_64**, avec OCaml **5.3.0**, Dune **3.24.2** et Yojson **3.0.0**. [cs6120.opam](cs6120.opam) fixe ces versions. Ici, `env.sh` utilise en lecture le switch préinstallé `cs3110`. Un switch local `_opam/` est prioritaire s’il existe.

Sur un autre Ubuntu x86_64, prévoir Bash, opam 2, les prérequis système de compilation OCaml, Python 3.11+ avec `venv` et `ensurepip`, curl et les utilitaires GNU usuels. Depuis la racine du projet, si la chaîne OCaml manque, créer une racine opam privée et un switch local. La commande `--no-depexts` laisse la gestion des paquets système à l’utilisateur.

```bash
source ./env.sh
export OPAMROOT="$PWD/.tools/opam-root"
unset OPAMSWITCH OPAM_SWITCH_PREFIX
opam init --bare --no-setup --yes
opam switch create . ocaml-base-compiler.5.3.0 --deps-only --no-depexts --yes
source ./env.sh
```

Pour installer les outils de référence et vérifier la copie de travail, exécuter ensuite ces commandes. Sur le poste actuel, ces outils sont déjà installés.

```bash
scripts/setup-bril
source ./env.sh
dune build
dune runtest --force
turnt examples/add.json
```

Le script installe Deno **2.5.6** et Turnt **1.12.0** sous `.tools/`, ainsi que les convertisseurs texte/JSON, `brili`, Brench, les tests et les benchmarks de la [révision Bril utilisée](https://github.com/sampsyo/bril/tree/1c8604d22a2655ca0d5bdaf4bb70390b5ca23527). Les archives Bril et Deno sont contrôlées par empreinte au téléchargement. Une fois les dépendances en place, compilation, tests et interprétation fonctionnent hors ligne.
