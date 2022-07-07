% Generic-Function SLOT-MAKUNBOUND-USING-CLASS

[UP](mop.6.html)  

---

# Generic-Function **SLOT-MAKUNBOUND-USING-CLASS**


Generic Function `SLOT-MAKUNBOUND-USING-CLASS`


## 構文

`slot-makunbound-using-class` *class* *object* *slot* => *object*


## 引数と戻り値

*class* - メタオブジェクトのクラス。これは引数*object*のクラスです。  
*object* - オブジェクト  
*slot* - `effective-slot-definition`メタオブジェクト


## 定義

このジェネリック関数は、
[`slot-makunbound`](7.7.slot-makunbound.html)関数の振る舞いを実装します。
これは第一引数が*object*のクラスであり、
第三引数が`effective-slot-definition`メタオブジェクトに関連するものが指定されて
[`slot-makunbound`](7.7.slot-makunbound.html)によって呼び出されます。

ジェネリック関数[`slot-makunbound-using-class`](mop.6.slot-makunbound-using-class.html)は、
*object*の*slot*を`unbound`の状態に戻します。
「スロットを`unbound`状態に戻す」という解釈は、
クラスのメタオブジェクトクラスに依存します。

もし引数*class*が引数*object*のクラスではなかったときか、
あるいはもし引数*slot*が引数*class*に関連付けられている
`effective-slot`の集合に存在しなかった場合は、
結果は未定義です。


## メソッド

`slot-makunbound-using-class` (*class* [`standard-class`](4.4.standard-class.html))
 *object* (*slot* `standard-effective-slot-definition`)  
`slot-makunbound-using-class` (*class* `funcallable-standard-class`)
 *object* (*slot* *standard-effective-slot-definition*)  
`slot-makunbound-using-class` (*class* [`built-in-class`](4.4.built-in-class.html)) *object* *slot*


## Method `slot-makunbound-using-class`

`slot-makunbound-using-class` (*class* [`standard-class`](4.4.standard-class.html))
 *object* (*slot* `standard-effective-slot-definition`)
 => *object*  
`slot-makunbound-using-class` (*class* `funcallable-standard-class`)
 *object* (*slot* *standard-effective-slot-definition*)
 => *object*


### 定義

このメソッドは、`:instance`と`:class`で確保されたスロットに対しての
完全な振る舞いを行うジェネリック関数の実装です。
もしスロットが`:instance`か`:class`ではない
他の確保の値を持っていたときはエラーが通知されます。

このメソッドの上書きは許されていますが、
他のスロットへのアクセスのプロトコルに対しての
標準で用意されている実装も上書きする必要があるかもしれません。


## Method `slot-makunbound-using-class`

`slot-makunbound-using-class` (*class* [`built-in-class`](4.4.built-in-class.html)) *object* *slot*
 => `|`

### 定義

このメソッドはエラーが発生します。


---
[TOP](index.html),  [Github](https://github.com/nptcl/npt-japanese)

