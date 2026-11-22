# Lesson 2 · Representing Programs

I started by counting operations and labels in the first function of a Bril JSON file. The more interesting question was where execution could go next. The two programs are [l02.ml](l02.ml) and [cfg.ml](cfg.ml).

`make_bb` walks one function's instruction list recursively, keeping the original Yojson values. A `br`, `jmp` or `ret` goes into the current block and closes it. A label after an ordinary instruction starts a new block. Consecutive labels at the head of a block stay together, so several names can refer to the same place. At the end of the list, the function keeps any unfinished block. It builds the lists by prepending and reverses them to recover source order.

`List.mapi` numbers the blocks in that order, starting at `B0` for each function. Each block contributes one `(label, block ID)` pair for every label it contains. With that association list, `make_edges` can pattern-match on the last operation of each block. For `br` it looks up both target labels in order, for `jmp` it looks up the jump target, and for `ret` it emits no edge. Any other operation falls through if there is a next block. A `call` stays inside its caller's block. The result for each function is its numbered blocks and a list of directed edges.

## A branch and a join

My benchmark adds 4 and 3, checks whether the sum is greater than 6, then branches. This is the end of [mon_benchmark.bril](benchmarks/mon_benchmark.bril).

```bril
    br test .grand .petit;

.grand:
    print total;
    jmp .fin;

.petit:
    print x;

.fin:
    ret;
```

The entry block is `B0`. In source order, `.grand`, `.petit` and `.fin` are `B1`, `B2` and `B3`. The executable prints the blocks first, then ends with this graph.

```text
CFG de main :
Sommets : 4
B0 -> B1
B0 -> B2
B1 -> B3
B2 -> B3
```

The interpreter prints `7` on this input. The graph includes both arms of the branch. I had to write the jump from `.grand` to `.fin` explicitly, while `.petit` reaches the very same block just by falling through after `print x`.

The [command in the root README](../../README.md) runs this example on its checked-in JSON. The executable expects a function named `main` for its first block dump and an operation at the end of every block. The [other benchmark inputs](benchmarks/) include a loop, three consecutive labels, a function call and code after a return.

[Cornell's Lesson 2 tasks](https://www.cs.cornell.edu/courses/cs6120/2025sp/lesson/2/#tasks) · [Original Bril notes (in French)](AIDE-MEMOIRE.md)
