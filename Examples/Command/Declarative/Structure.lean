/-
# structure
`structure` は構造体を定義するためのコマンドです。構造体とは、複数のデータをまとめて一つの型として扱えるようにしたものです。
-/
namespace Structure --#

structure Point (α : Type) : Type where
  x : α
  y : α

/- 構造体を定義すると、自動的に作られる関数があります。代表的なものは

* フィールドにアクセスするための関数。
* コンストラクタ.

の2つです。フィールドへのアクセサはフィールドの名前で、コンストラクタは `mk` という名前で作られます。
-/

-- アクセサ
#check (Point.x : {α : Type} → (Point α) → α)
#check (Point.y : {α : Type} → (Point α) → α)

def origin : Point Int := { x := 0, y := 0 }

/-- フィールド記法でアクセサを使用する -/
example : origin.x = 0 := by rfl

-- コンストラクタ
#check (Point.mk : {α : Type} → α → α → Point α)

/- コンストラクタに `mk` 以外の名前を使いたい場合、`::` を使って次のようにします。-/

structure Prod (α : Type) (β : Type) where
  gen ::
  fst : α
  snd : β

-- コンストラクタ
#check Prod.gen

/- ## 無名コンストラクタ { #AnonymousConstructor }
無名コンストラクタは、構造体 `T` に対して `T` 型の項を構成する方法のひとつです。これは以下に示すように、`⟨x1, x2, ...⟩` という構文により使うことができます。
-/
set_option linter.unusedVariables false --#

/-- 2つのフィールドを持つ構造体 -/
structure Hoge where
  foo : Nat
  bar : Nat

def hoge : Hoge := ⟨1, 2⟩

/- コンストラクタが入れ子になっていても平坦化することができます。例えば、以下の2つの定義は同じものを定義します。-/

def foo : Nat × (Int × String) := ⟨1, ⟨2, "foo"⟩⟩

def foo' : Nat × (Int × String) := ⟨1, 2, "foo"⟩

#guard foo = foo'

/- 一般の帰納型に対しては使用できません。-/

inductive Sample where
  | fst (foo bar : Nat) : Sample
  | snd (foo bar : String) : Sample

-- 「コンストラクタが一つしかない型でなければ使用できない」というエラーになる
#check_failure (⟨"foo", "bar"⟩ : Sample)

-- コンストラクタを指定しても使用できない
#check_failure (Sample.snd ⟨"foo", "bar"⟩ : Sample)

/- ## 項を定義する
構造体の項を定義したい場合、複数の方法があります。波括弧記法が好まれますが、フィールド名が明らかな状況であれば無名コンストラクタを使用することもあります。-/

-- コンストラクタを使う
def sample0 : Point Int := Point.mk 1 2

-- 波括弧記法を使う
def sample1 : Point Int := { x := 1, y := 2 }

-- 無名コンストラクタを使う
def sample2 : Point Int := ⟨1, 2⟩

-- `where` を使う
def sample : Point Int where
  x := 1
  y := 2

/- ## 値の更新
Lean は純粋関数型言語なので「構造体のフィールドを更新する」ことはできませんが、既存の構造体のフィールドの一部だけを変更した新しい構造体の項を作ることはできます。
-/
section --#
variable {α : Type} [Add α]

/-- `p : Point` の x 座標を 2 倍にする -/
def Point.doubleX (p : Point α) : Point α :=
  { p with x := p.x + p.x}

#check Point.doubleX origin

end --#

/- ## 継承
既存の構造体に新しいフィールドを追加した新しい構造体を定義することができます。多重継承(複数の親を持つ構造体を作ること)も行うことができます。
-/

structure Point3D (α : Type) extends Point α where
  z : α

structure RGBValue where
  red : Nat
  green : Nat
  blue : Nat

structure ColorPoint3D (α : Type) extends Point α, RGBValue where
  z : α

/- ## 舞台裏
構造体は、帰納型の特別な場合であり、コンストラクタが一つしかないケースに対応します。上記の `Point` は以下のように定義しても同じことです。ただしこの場合、アクセサ関数が自動的に作られないため、フィールド記法は自分で実装しないと使用できないほか、波括弧記法が使えません。-/

inductive Point' (α : Type) : Type where
  | mk : (x : α) → (y : α) → Point' α

-- フィールド記法が利用できない
#check_failure Point'.x

-- 無名コンストラクタは使用できる
def origin' : Point Int := ⟨0, 0⟩

-- 波括弧記法は使用できない
#check_failure ({ x := 1, y := 2 } : Point' Int)

end Structure --#
