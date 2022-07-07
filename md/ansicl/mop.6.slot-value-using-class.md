% Generic-Function SLOT-VALUE-USING-CLASS

[UP](mop.6.html)  

---

# Generic-Function **SLOT-VALUE-USING-CLASS**


Generic Function `SLOT-VALUE-USING-CLASS`


## 構文

`slot-value-using-class` *class* *object* *slot* => *value*


## 引数と戻り値

*class* - メタオブジェクトのクラス。これは引数*object*のクラスです。  
*object* - オブジェクト  
*slot* - `effective-slot-definition`メタオブジェクト  
*value* - オブジェクト


## 定義

このジェネリック関数は、
[`slot-value`](7.7.slot-value.html)関数の振る舞いを実装します。
これは第一引数が*object*のクラスであり、
第三引数が`effective-slot-definition`メタオブジェクトに関連するものが指定されて
[`slot-value`](7.7.slot-value.html)によって呼び出されます。

ジェネリック関数[`slot-value-using-class`](mop.6.slot-value-using-class.html)は、
与えられた*object*の与えられたスロット*slot*に含まれる値を返却します。
もしスロットが`unbound`のときは、
[`slot-unbound`](7.7.slot-unbound.html)が呼び出されます。

もし引数*class*が引数*object*のクラスではなかったときか、
あるいはもし引数*slot*が引数*class*に関連付けられている
`effective-slot`の集合に存在しなかった場合は、
結果は未定義です。


## メソッド

`slot-value-using-class` (*class* [`standard-class`](4.4.standard-class.html))
 *object* (*slot* `standard-effective-slot-definition`)  
`slot-value-using-class` (*class* `funcallable-standard-class`)
 *object* (*slot* *standard-effective-slot-definition*)  
`slot-value-using-class` (*class* [`built-in-class`](4.4.built-in-class.html)) *object* *slot*


## Method `slot-value-using-class`

`slot-value-using-class` (*class* [`standard-class`](4.4.standard-class.html))
 *object* (*slot* `standard-effective-slot-definition`)
 => *value*  
`slot-value-using-class` (*class* `funcallable-standard-class`)
 *object* (*slot* *standard-effective-slot-definition*)
 => *value*


### 定義

このメソッドは、`:instance`と`:class`で確保されたスロットに対しての
完全な振る舞いを行うジェネリック関数の実装です。
もしスロットが`:instance`か`:class`ではない
他の確保の値を持っていたときはエラーが通知されます。

このメソッドの上書きは許されていますが、
他のスロットへのアクセスのプロトコルに対しての
標準で用意されている実装も上書きする必要があるかもしれません。


## Method `slot-value-using-class`

`slot-value-using-class` (*class* [`built-in-class`](4.4.built-in-class.html)) *object* *slot*
 => `|`

### 定義

このメソッドはエラーが発生します。


---
[TOP](index.html),  [Github](https://github.com/nptcl/npt-japanese)

