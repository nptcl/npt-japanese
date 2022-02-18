% Lisp関数仕様 - sysctl

nptのドキュメントです。  
参照元：[ANSI Common Lisp npt](index.html)


# Lisp関数仕様

`npt-system`パッケージの下記の関数を説明します。

- [sysctl](#sysctl-1)

```lisp
defun sysctl
```

- [sysctl: memory-stream](#sysctl-2)

```lisp
sysctl: memory-stream, size
sysctl: memory-stream, array
sysctl: memory-stream, cache
```

- [sysctl: clos](#sysctl-3)

```lisp
sysctl: clos, slots
```

- [sysctl: recovery](#sysctl-4)

```lisp
sysctl: recovery, no-applicable-method
sysctl: recovery, no-next-method
```

- [sysctl: structure](#sysctl-5)

```lisp
sysctl: structure, check
sysctl: structure, delete
sysctl: structure, type
```

- [sysctl: random-state](#sysctl-6)

```lisp
sysctl: random-state, integer
sysctl: random-state, make
sysctl: random-state, write
```


# <a id="sysctl-1">関数`sysctl`</a>

本関数は下記の操作を行います。

- システムの状態取得と設定
- オブジェクトの状態取得と設定

```lisp
(defun sysctl (type &rest args) ...) -> *

入力: type, オブジェクト
入力: args, 引数
出力: *
```

`type`は次の内容を指定できます。

- `memory-stream`
- `clos`
- `recovery`
- `structure`
- `random-state`


# <a id="sysctl-2">関数`sysctl`: `memory-stream`</a>

`memory-stream`オブジェクトから情報を取得します。  
実行は次のようにして行います。

```lisp
* (setq x (make-memory-io-stream ...))
* (sysctl x ...)
```

続けて次の引数を受け付けます。

- `size`
- `array`
- `cache`


## `sysctl`: `memory-stream`, `size`

`memory-stream`の`size`を取得します。  
`size`は内部バッファのbyte数です。  
実行例を下記に示します。

```lisp
* (setq x (make-memory-io-stream :size 10))
* (sysctl x 'size)
10
T
```


## `sysctl`: `memory-stream`, `array`

`memory-stream`の`array`を取得します。  
`array`は内部バッファの保有数です。  
実行例を下記に示します。

```lisp
* (setq x (make-memory-io-stream :array 20))
* (sysctl x 'array)
20
T
```


## `sysctl`: `memory-stream`, `cache`

`memory-stream`の`cache`を取得します。  
`cache`は`open`関数がキャッシュを利用するかどうかの可否です。  
実行例を下記に示します。

```lisp
* (setq x (make-memory-io-stream :cache t))
* (sysctl x 'cache)
T
T
```


# <a id="sysctl-3">関数`sysctl`: `clos`</a>

`clos`オブジェクトから情報を取得します。  
`clos`オブジェクトとは`make-instance`で生成されるものすべてであり、
`structure-object`, `structure-object`のインスタンスのことです。  
`standard-class`, `structure-class`, `built-in-class`のインスタンスも含まれます。  
ただし、`built-in-class`のクラスのインスタンスに対応するものは
Lispオブジェクトのため含まれません。

実行は次のようにして行います。

```lisp
* (setq x (make-instance ...))
* (sysctl x ...)
```

続けて次の引数を受け付けます。

- `slots`


## `sysctl`: `clos`, `slots`

全てのスロットを取得します。  
実行例は下記の通り。

```lisp
* (sysctl (find-class 'class) 'slots)
(NPT-CLOS::NAME NPT-CLOS::DIRECT-SLOTS NPT-CLOS::DIRECT-SUBCLASSES
 NPT-CLOS::DIRECT-SUPERCLASSES NPT-CLOS:CLASS-PRECEDENCE-LIST NPT-CLOS::EFFECTIVE-SLOTS
 NPT-CLOS::FINALIZED-P NPT-CLOS::PROTOTYPE NPT-CLOS::DEFAULT-INITARGS
 NPT-CLOS::DIRECT-DEFAULT-INITARGS NPT-CLOS::VERSION NPT-CLOS::DOCUMENTATION
 NPT-CLOS::REDEFINED-CLASS)
T
```


# <a id="sysctl-4">関数`sysctl`: `recovery`</a>

`recovery`は指定した内容を初期状態に戻します。  
実行は次のようにして行います。

```lisp
* (sysctl 'recovery ...)
```

引数`'recovery`は`string`として扱われ、`equalp`で判定されます。

続けて次の引数を受け付けます。

- `no-applicable-method`
- `no-next-method`


## `sysctl`: `recovery`, `no-applicable-method`

ジェネリック関数`no-applicable-method`を初期状態に戻します。  
実行は次の通り。

```lisp
* (sysctl 'recovery 'no-applicable-method)
T
T
```

## `sysctl`: `recovery`, `no-next-method`

ジェネリック関数`no-next-method`を初期状態に戻します。  
実行は次の通り。

```lisp
* (sysctl 'recovery 'no-next-method)
T
T
```


# <a id="sysctl-5">関数`sysctl`: `structure`</a>

`structure`は構造体の操作を行います。  
実行は次のようにして行います。

```lisp
* (sysctl 'structure ...)
```

引数`'structure`は`string`として扱われ、`equalp`で判定されます。

続けて次の引数を受け付けます。

- `check`
- `delete`
- `type`


## `sysctl`: `structure`, `check`

指定した名前の、`structure-class`ではない
構造体が存在するかどうかを調査します。

構造体を定義するとき、通常であれば`structure-class`に属するクラスが生成されます。  
しかし`defstruct`の`:type`引数に`list`か`vector`を指定した場合は、
クラスシステムとは別の構造体が生成されるため、
`find-class`のような関数では確認することができません。  
`check`は、そのような構造体の存在を調査します。

実行は下記の通り。

```lisp
* (defstruct (aaa (:type list)))
* (sysctl 'structure 'check 'aaa)
T
T
* (defstruct bbb)
* (sysctl 'structure 'check 'bbb)
NIL
T
```


## `sysctl`: `structure`, `delete`

指定した名前の構造体を削除します。

クラスシステムに存在する`structure-class`と、
存在しない`list`, `vector`型の構造体のどちらのものでも削除します。  
削除は丁寧に行われ、アクセス関数をはじめ、
`constructor`, `copier`, `print-object`を削除します。

実行例を示します。

```lisp
* (defstruct aaa)
* (sysctl 'structure 'delete 'aaa)
T
T
* (find-class 'aaa nil)
NIL

* (defstruct (bbb (:type vector)))
* (sysctl 'structure 'delete 'bbb)
T
T
* (sysctl 'structure 'check 'bbb)
NIL
T
* (fboundp 'make-bbb)
NIL
```


## `sysctl`: `structure`, `type`

指定した名前の構造体の型を返却します。

返却値は次のようになります。

- `class`
- `list`
- `vector`
- (vectorの派生)

実行例を下記に示します。

```lisp
* (defstruct aaa)
* (defstruct (bbb (:type (vector (unsigned-byte 8)))))
* (sysctl 'structure 'type 'aaa)
CLASS
T
* (sysctl 'structure 'type 'bbb)
(VECTOR (UNSIGNED-BYTE 8))
T
```


# <a id="sysctl-6">関数`sysctl`: `random-state`</a>

`random-state`オブジェクトの操作を行います。  
実行は次のようにして行います。

```lisp
* (sysctl 'random-state ...)
```

引数`'random-state`は`string`として扱われ、`equalp`で判定されます。

続けて次の引数を受け付けます。

- `integer`
- `make`
- `write`


## `sysctl`: `random-state`, `integer`

`random-state`の内部状態を整数で出力します。

nptは乱数アルゴリズムに`xorshift`を実装しており、
`random-state`の内部状態に128bitの整数を保有しています。  
本機能はその内部状態をそのまま整数で出力します。  
出力した内部状態は、`make`と`write`で復元できます。

実行例を示します。

```lisp
* (setq *print-base* 16)
* (setq x (make-random-state t))
#<RANDOM-STATE #xF3F85807E6E2837033526396D518DAD1>
* (sysctl 'random-state 'integer x)
F3F85807E6E2837033526396D518DAD1
T
```

## `sysctl`: `random-state`, `make`

指定した引数を内部状態に設定した`random-state`を生成します。

引数は`ldb`で128bit取得しますので、負の値も設定できます。

```lisp
* (setq *print-base* 16)
* (setq x (sysctl 'random-state 'make #xABCD))
#<RANDOM-STATE #xABCD>
T
* (sysctl 'random-state 'integer x)
ABCD
T
```


## `sysctl`: `random-state`, `write`

`random-state`オブジェクトの内部状態を指定します。

引数は`ldb`で128bit取得しますので、負の値も設定できます。

```lisp
* (setq *random-state* (make-random-state t))
#<RANDOM-STATE #x14F392860E2329DE919C083F0B764EC5>
* (setq y (sysctl 'random-state 'integer *random-state*))
27849259905073490890992780948155027141
T
* (random 10)
3
* (random 10)
6
* (random 10)
7
* (sysctl 'random-state 'write *random-state* y)
#<RANDOM-STATE #x14F392860E2329DE919C083F0B764EC5>
T
* (random 10)
3
* (random 10)
6
* (random 10)
7
```
