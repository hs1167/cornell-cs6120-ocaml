# Cornell CS6120 · Advanced Compilers

I'm working through Cornell's Advanced Compilers course on my own. I write the compiler exercises in OCaml and use Bril as the intermediate representation. [Cornell's self-guided course](https://www.cs.cornell.edu/courses/cs6120/2025sp/self-guided/)

[Lesson 2 · Representing Programs](lessons/02_representation/README.md) starts with a flat list of instructions for each function and turns it into basic blocks and a control-flow graph. The construction is in [cfg.ml](lessons/02_representation/cfg.ml).

To try it on my branch-and-join benchmark, run this from the repository root with OCaml 5.3.0, Dune 3.24.2 and Yojson 3.0.0 available.

```sh
dune build
dune exec ./lessons/02_representation/cfg.exe -- lessons/02_representation/benchmarks/mon_benchmark.json
```

<a id="parcours-et-fichiers"></a>

The other [lesson directories](lessons/) hold my outline for the course. The [original workshop notes (in French)](README.fr.md) cover environment setup, the Bril interpreter and the test tools.
