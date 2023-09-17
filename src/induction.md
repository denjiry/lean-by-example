# induction

`induction` は，帰納法のためのタクティクです．

自然数を例に説明します．Lean では自然数は次のように帰納的に定義されています.

```lean
inductive Nat
  | zero : Nat
  | succ (n : Nat) : Nat
```

`succ` は後者関数と呼ばれる関数で，`n + 1 := succ n` です．

`n : Nat` についてゴール `P n ⊢ Q n` があったとします．このとき `induction n` を行うと，コンストラクタ `zero` と `succ` のそれぞれに対して，対応するゴールを生成します．つまり

* `P 0 ⊢ Q 0`
* `(P (succ a)) (P a → Q a) ⊢ Q (succ a)`

の２つのゴールです．

```lean
{{#include ../Examples/Mathlib/Induction.lean:first}}
```

## induction'

Mathlib4 依存のタクティクですが，`induction'` というタクティクもあります．こちらは箇条書きによる，より簡潔な書き方が可能です．

```lean
{{#include ../Examples/Mathlib/Induction.lean:dash}}
```