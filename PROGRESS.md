# Progression · Cornell CS6120

Le workspace est prêt. Les cases ci-dessous suivent le travail personnel. Pour chaque leçon, consigner un cas de test, une observation ou un lien vers les résultats. [Énoncés, commandes et fichiers](README.md#parcours-et-fichiers)

## 1 · Welcome & Overview

- [ ] Lire le syllabus et les ressources sur l’évaluation empirique.
- [ ] Noter une question de compilation à explorer.

Question ou note de lecture —

## 2 · Representing Programs

- [ ] Écrire un nouveau benchmark en OCaml et l’exécuter avec `brili`.
- [ ] Concevoir et implémenter un petit outil d’analyse ou de transformation.
- [ ] Écrire ses propres entrées et sorties attendues, puis les tester avec Turnt.
- [ ] Implémenter et tester la formation des basic blocks.
- [ ] Construire le CFG et vérifier les successeurs.
- [ ] Préparer la description du benchmark et le bilan du travail.

Benchmark, arguments, tests et observations —

## 3 · Local Analysis & Optimization

- [ ] Implémenter et tester la TDCE jusqu’à convergence.
- [ ] Implémenter le LVN et vérifier l’élimination de sous-expressions communes.
- [ ] Évaluer LVN suivi de TDCE sur un corpus et noter les gains et les cas sans gain.
- [ ] Bonus · étendre le LVN aux cas difficiles de l’énoncé.

Corpus, vérification du comportement et mesures —

## 4 · Data Flow

- [ ] Choisir l’analyse et préciser le sens des faits en entrée et en sortie.
- [ ] Implémenter l’analyse et comparer les résultats aux faits attendus.
- [ ] Bonus · implémenter un solveur générique et l’exercer sur plusieurs analyses.

Analyse choisie, cas et résultats —

## 5 · Global Analysis

- [ ] Calculer les dominateurs.
- [ ] Construire l’arbre de dominance.
- [ ] Calculer les frontières de dominance.
- [ ] Concevoir et exécuter une vérification indépendante.

Graphes utilisés et vérification —

## 6 · Static Single Assignment

- [ ] Choisir une variante et implémenter la conversion vers SSA.
- [ ] Vérifier la propriété SSA et comparer les sorties au point intermédiaire.
- [ ] Implémenter la sortie de SSA et vérifier le comportement après l’aller-retour.
- [ ] Mesurer et consigner le surcoût statique ou dynamique.

Variante, arguments, résultats et surcoût —
