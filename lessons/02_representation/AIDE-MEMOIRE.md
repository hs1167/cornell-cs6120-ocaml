# Bril · Les commandes de la leçon 2

**Bril est un langage qui sert de représentation intermédiaire (IR).** Le fichier `.bril` contient le programme que tu étudies. Dans `l02.ml`, OCaml est le langage avec lequel tu écris ton outil pour étudier ce programme. Le lien entre les deux est un format de données que ton outil sait déjà lire, le JSON. [Présentation de Bril](https://capra.cs.cornell.edu/bril/)

## Où lire et écrire

| Pour… | Ouvre… |
| --- | --- |
| Voir comment écrire du Bril à la main | [Syntaxe texte et exemple](https://capra.cs.cornell.edu/bril/tools/text.html) |
| Connaître le sens des instructions comme `add`, `print` ou `br` | [Core Bril](https://capra.cs.cornell.edu/bril/lang/core.html) |
| Comprendre le format lu par OCaml | [Syntaxe JSON](https://capra.cs.cornell.edu/bril/lang/syntax.html) |
| Écrire ton programme de test | [benchmarks/mon_benchmark.bril](benchmarks/mon_benchmark.bril) |
| Écrire ton outil OCaml | [l02.ml](l02.ml) |

## Essayer avec l’exemple fourni

Depuis Bash dans Ubuntu, commence chaque session par les deux premières lignes.

```bash
cd /home/hs1167/dev/CS6120
source ./env.sh

cat .tools/bril/test/parse/add.bril              # lire le programme texte
bril2json < .tools/bril/test/parse/add.bril      # voir ce programme en JSON
brili < examples/add.json                       # exécuter le JSON fourni → 3
bril2txt < examples/add.json                    # revoir la syntaxe texte
dune exec cs6120 -- json examples/add.json      # lire et réémettre le JSON avec OCaml
turnt examples/add.json                         # comparer la sortie à examples/add.out
```

Dans ces commandes, `<` donne à l’outil le contenu du fichier. Le symbole `|` envoie la sortie d’un outil à l’entrée du suivant.

## Écrire et tester ton programme

1. Ouvre [mon_benchmark.bril](benchmarks/mon_benchmark.bril) dans ton éditeur et écris ton programme en syntaxe texte. Le fichier contient initialement un commentaire.
2. Depuis la racine du projet, exécute-le. Pour un `@main` qui attend un argument, ajoute sa valeur après `brili`.

```bash
b=lessons/02_representation/benchmarks/mon_benchmark.bril
bril2json < "$b" | brili
```

3. Écris la sortie que tu attends dans `mon_benchmark.out`, à côté du `.bril`, avec un saut de ligne après chaque ligne affichée. Puis lance le test :

```bash
turnt --diff "$b"
```

Si le programme attend un argument, tu peux indiquer sa valeur à Turnt dans un commentaire Bril, par exemple `# ARGS: 7`. Pour enregistrer une sortie que tu as déjà vérifiée, `turnt --save "$b"` crée ou remplace le `.out`. [Turnt](https://github.com/cucapra/turnt)

## Tester ton outil OCaml

```bash
dune build
dune runtest
bril2json < "$b" | dune exec cs6120 -- json
```

La dernière commande montre le trajet de ton propre programme jusqu’au lecteur OCaml. Lorsque tu auras écrit ton petit outil et raccordé la commande `mini`, tu pourras utiliser `bril2json < "$b" | dune exec cs6120 -- mini` pour lui soumettre le même programme. [Objectifs de la leçon](https://www.cs.cornell.edu/courses/cs6120/2025sp/lesson/2/#tasks)
