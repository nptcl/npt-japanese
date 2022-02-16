% Lisp関数仕様 - システム関数

% Lisp関数仕様 - システム関数

nptのドキュメントです。  
参照元：[ANSI Common Lisp npt](index.html)


# Lisp関数仕様

`npt-system`パッケージの下記の関数を説明します。

- [システム関数](#system-develop)

```lisp
defun gc
defun savecore
defun exit
defun quit
```


- [オブジェクト確認](#object-check)

```lisp
defun specialp
defun array-general-p
defun array-specialized-p
defun closp
defun fixnump
defun bignump
defun ratiop
defun short-float-p
defun single-float-p
defun double-float-p
defun long-float-p
defun callnamep
```


- [オブジェクト生成](#object-make)

```lisp
defun make-character
defun make-fixnum
defun make-bignum
defun make-ratio
defun make-complex
defun make-callname
```


- [型確認](#type-check)

```lisp
defun subtypep-result
defun parse-type
defun type-object
```


- [メモリストリーム](#memory-stream)

```lisp
defun make-memory-input-stream
defun make-memory-output-stream
defun make-memory-io-stream
defmacro with-input-from-memory
defmacro with-output-to-memory
defun get-output-stream-memory
defun memory-stream-p
defun (setf memory-stream-p)
```


- [ソート](#sort)

```lisp
defun simple-sort
defun bubble-sort
defun quick-sort
defun merge-sort
```


- [Paperオブジェクト](#paper)

```lisp
defun make-paper
defun info-paper
defun array-paper
defun body-paper
```


- [その他の関数](#others)

```lisp
defun package-export-list
defun large-number
defun equal-random-state
defun remove-file
defun remove-directory
defun byte-integer
defun fpclassify
defun eastasian-set
defun eastasian-get
defun eastasian-width
```


# <a id="system-develop">■システム関数</a>

`npt-system`パッケージに存在する、システム関数の関数仕様を示します。

```lisp
defun gc
defun savecore
defun exit
defun quit
```


## 関数`gc`

ガベージコレクタを起動します。

```lisp
(defun gc (&key full) ...) -> null

入力: full general-boolean
出力: null nil固定
```

本関数は、ガベージコレクタの依頼を行います。  
関数内でガベージコレクタが実行されるのではなく、
処理系の都合の良いタイミングで実施されます。  
現時点では引数`:full`は無視されます。  
ガベージコレクタの実行は`room`関数で確認できます。

### 実行例

```lisp
* (room)
・・・
GC count:           1                   [times]
・・・
NIL
* (npt-system:gc)
NIL
* (room)
・・・
GC count:           2                   [times]
・・・
NIL
*
```


## 関数`savecore`

Lispを終了させてから、コアファイルを作成します。

```lisp
(defun savecore (pathname-designer) ...) -> null

入力: pathname-designer 出力先パス
出力: null 戻り値無し
```

コアファイルとは、メモリイメージを出力したファイルです。  
npt起動時に`--core`引数および`--corefile`引数を指定すると、
コアファイルを読み込めます。

`savecore`関数は`savecore condition`を実行してLispを終了させます。  
途中で`handler`を捕捉することができます。

本関数が正常に動作した場合はLispが終了するので、
通常はプロセス自体が終了します。  
モジュールとして使用している場合は、C言語の`lisp_argv_run`関数から制御が戻ります。  

### 実行例

```lisp
$ npt
* (defvar *hello* 1234)
*HELLO*
* *hello*
1234
* (npt-system:savecore #p"hello-core-image.core")
Core file: hello-core-image.core
$ ls
hello-core-image.core
$ npt --core --corefile hello-core-image.core
* *hello*
1234
*
```

## 関数`exit`
## 関数`quit`

Lispを終了します。

```lisp
(defun exit (&optional code) ...) -> なし
(defun quit (&optional code) ...) -> なし

入力: code 終了コード、省略時は0
```

`exit`と`quit`は同じです。

本関数はLispを終了させますので、式の返却値はありません。  
引数の終了コードは、通常はプロセスの終了コードに設定されます。  
モジュールとして使用している場合は、C言語の`lisp_argv_run`関数から制御が戻ります。  
返却値は`lisp_result`変数で確認できます。

`exit`/`quit`は`exit condition`を実行してLispを終了させます。  
途中で`handler`を捕捉することができます。

`exit`と`quit`の`symbol`は、`common-lisp-user`パッケージに
`import`された状態で始まります。


### 実行例

```lisp
$ npt
* (quit)
$ echo $?
0
$ npt --eval '(exit 22)'
$ echo $?
22
$
```


# <a id="object-check">■オブジェクト確認</a>

`npt-system`パッケージに存在する、オブジェクト確認の関数仕様を示します。

```lisp
defun specialp
defun array-general-p
defun array-specialized-p
defun closp
defun fixnump
defun bignump
defun ratiop
defun short-float-p
defun single-float-p
defun double-float-p
defun long-float-p
defun callnamep
```

## 関数`specialp`

グローバル変数がspecialかどうかを調査します。

```lisp
(defun specialp (symbol) ...) -> boolean

入力: symbol
出力: boolean
```

レキシカルの状況を考慮せず、変数がspecialかどうかを返却します。  
つまり変数が`defvar`, `defparameter`, `declaim`, `proclaim`の実行により
special変数になった場合に`t`となります。


### 実行例

```lisp
* (specialp 'aaa)
NIL
* (defvar bbb)
BBB
* (specialp 'bbb)
T
* (let (ccc) (declare (special ccc)) (specialp 'ccc))
NIL
```


## 関数`array-general-p`

引数がgeneral arrayかどうかを調べます。

```lisp
(defun array-general-p (object) ...) -> boolean

入力: object
出力: boolean
```

入力が`array`オブジェクトであり、かつgeneral arrayの場合は`t`を返却します。  
`typep`とは違い、npt内部のオブジェクト種別によって判定が変わります。  
入力が`make-array`によって生成され、
かつ`elemennt-type`が`t`のオブジェクトの場合に限り`t`が返却されます。  
例えば`#(10 20 30)`は、`vector`オブジェクトのため、`t`にはなりません。  


### 実行例

```lisp
* (array-general-p (make-array 10))
T
* (array-general-p #(10 20 30))
NIL
* (typep (make-array 10) '(array t))
T
* (typep #(10 20 30) '(array t))
T
```


## 関数`array-specialized-p`

引数がspecialized arrayかどうかを調べます。

```lisp
(defun array-specialized-p (object) ...) -> boolean

入力: object
出力: boolean
```

入力が`array`オブジェクトであり、
かつ`element-type`が`t`以外の場合は`t`が返却されます。


## 関数`closp`

引数が`clos`オブジェクトかどうかを調べます。

```lisp
(defun closp (object) ...) -> boolean

入力: object
出力: boolean
```

入力が`clos`オブジェクトの場合は`t`が返却されます。  
Common Lispでは、全てのCLOSオブジェクトが
`standard-object`に属しているため、
通常であれば次の命令と一致するはずです。

```lisp
(typep 入力 'standard-object)
```


## 関数`fixnump`

引数が`fixnum`オブジェクトかどうかを調べます。

```lisp
(defun fixnump (object) ...) -> boolean

入力: object
出力: boolean
```

入力が`fixnum`オブジェクトの場合は`t`が返却されます。  
通常であれば、`fixnum`型に属する`integer`は
全て`fixnum`オブジェクトであるはずです。  
しかし開発においては、例えば`bignum`型であるにもかかわらず、
`10`や`20`と言った小さな`integer`も作成できます。  
本関数は上記の差異を調査するためのものです。

### 実行例

```lisp
* 10
10
* (fixnump 10)
T
* (make-bignum 20)
20
* (fixnump (make-bignum 20))
NIL
```


## 関数`bignump`

引数が`bignum`オブジェクトかどうかを調べます。

```lisp
(defun bignump (object) ...) -> boolean

入力: object
出力: boolean
```

入力が`bignum`オブジェクトの場合は`t`が返却されます。  

### 実行例

```lisp
* 10
10
* (bignump 10)
NIL
* (make-bignum 20)
20
* (bignump (make-bignum 20))
T
```


## 関数`ratiop`

引数が`ratio`オブジェクトかどうかを調べます。

```lisp
(defun ratiop (object) ...) -> boolean

入力: object
出力: boolean
```

入力が`ratio`オブジェクトの場合は`t`が返却されます。  
通常であれば、分母が`1`の分数は`integer`型であるはずです。  
しかし開発においては、例えば`100/1`が`ratio`オブジェクトで存在する場合があります。  
本関数は上記の差異を調査するためのものです。

### 実行例

```lisp
* 10/5
2
* (ratiop 10/5)
NIL
* (make-ratio 10 5)
10/5
* (ratiop (make-ratio 10 5))
T
```


## 関数`short-float-p`

引数が`short-float`オブジェクトかどうかを調べます。

```lisp
(defun short-float-p (object) ...) -> boolean

入力: object
出力: boolean
```

現在、nptでは`short-float`オブジェクトを生成する方法はありません。


## 関数`single-float-p`

引数が`single-float`オブジェクトかどうかを調べます。

```lisp
(defun single-float-p (object) ...) -> boolean

入力: object
出力: boolean
```


## 関数`double-float-p`

引数が`double-float`オブジェクトかどうかを調べます。

```lisp
(defun double-float-p (object) ...) -> boolean

入力: object
出力: boolean
```


## 関数`long-float-p`

引数が`long-float`オブジェクトかどうかを調べます。

```lisp
(defun long-float-p (object) ...) -> boolean

入力: object
出力: boolean
```


## 関数`callnamep`

引数が`callname`オブジェクトかどうかを調べます。

```lisp
(defun callnamep (object) ...) -> boolean

入力: object
出力: boolean
```

`callname`とは、関数名を表すオブジェクトであり、
通常の`car`と言った`symbol`と、
setf関数を表す`(setf car)`形式をまとめたものです。  
Common Lispにおいて、`callname`オブジェクトを生成する方法はありません。


# <a id="object-make">■オブジェクト生成</a>

`npt-system`パッケージに存在する、オブジェクト生成の関数仕様を示します。

```lisp
defun make-character
defun make-fixnum
defun make-bignum
defun make-ratio
defun make-complex
defun make-callname
```


## 関数`make-character`

`character`オブジェクトを複製します。

```lisp
(defun make-character (character) ...) -> character

入力: character
出力: character
```

入力で受け取った文字オブジェクトを複製して返却します。  
本関数の目的は、キャッシュを避けて新規オブジェクトを生成することです。  
nptでは、文字コードが`#x80`未満であれば同一のオブジェクトが返却されます。  
よって、`eq`は一致します。

```lisp
* (eq #\A #\A)
T
* (eq #\A (read-from-string "#\\A"))
T
```

もし違うオブジェクトが必要なときは本関数で複製します。

```lisp
* (eq #\A (make-character #\A))
NIL
* (eql #\A (make-character #\A))
T
```


## 関数`make-fixnum`

`fixnum`オブジェクトを複製します。

```lisp
(defun make-fixnum (fixnum) ...) -> fixnum

入力: fixnum
出力: fixnum
```

入力で受け取った`fixnum`オブジェクトを複製して返却します。  
本関数の目的は、キャッシュを避けて新規オブジェクトを生成することです。  
nptでは、値が`-1024`から`+1024`の整数であれば、
同一のオブジェクトが返却されます。  
よって、`eq`は一致します。

```lisp
* (eq 11 11)
T
* (eq 11 (read-from-string "11"))
T
```

もし違うオブジェクトが必要なときは本関数で複製します。

```lisp
* (eq 11 (make-fixnum 11))
NIL
* (eql 11 (make-fixnum 11))
T
```


## 関数`make-bignum`

`bignum`オブジェクトを生成します。

```lisp
(defun make-bignum (integer) ...) -> bignum

入力: integer
出力: bignum
```

入力で受け取った整数値から`bignum`オブジェクトを生成します。  
本関数の目的は、小さな整数値の`bignum`オブジェクトを生成することです。  
通常であれば、例えば`10`や`2000`と言った整数は、
`fixnum`オブジェクトが返却されます。  
本関数は強制的に`bignum`オブジェクトを生成するときに使用します。 

★注意  
nptでは、本来`fixnum`の範囲にある整数が
`bignum`オブジェクトで渡されることを想定していません。  
本関数を用いて実施した結果については全て未定義です。

### 実行例

```lisp
* 10
10
* (make-bignum 10)
10
* (fixnump 10)
T
* (bignump 10)
NIL
* (fixnump (make-bignum 10))
NIL
* (bignump (make-bignum 10))
T
```


## 関数`make-ratio`

`ratio`オブジェクトを生成します。

```lisp
(defun make-ratio (numer denom) ...) -> ratio

入力: numer 分子を表すintegerオブジェクト
入力: denom 分母を表すintegerオブジェクト
出力: ratio
```

入力で受け取った整数`numer`, `denom`から、`ratio`オブジェクトを生成します。  
本関数の目的は、約分を無視して`ratio`オブジェクトを生成することです。  
通常であれば、例えば`10/5`と言った分数は、
約分されて`2`という`fixnum`オブジェクトが返却されます。  
本関数は強制的に`ratio`オブジェクトを生成するときに使用します。 

★注意  
nptでは、本来`integer`となるものが`ratio`オブジェクトで渡されることを想定していません。  
本関数を用いて実施した結果については全て未定義です。

### 実行例

```lisp
* 10/5
2
* (ratiop 10/5)
NIL
* (make-ratio 10 5)
10/5
* (ratiop (make-ratio 10 5))
T
```


## 関数`make-complex`

`complex`オブジェクトを生成します。

```lisp
(defun make-complex (real imag) ...) -> complex

入力: real 実数を表すrealオブジェクト
入力: imag 虚数を表すrealオブジェクト
出力: complex
```

入力で受け取った整数`real`, `imag`から、`complex`オブジェクトを生成します。  
本関数の目的は、虚数が`0`の整数型`complex`オブジェクトを生成することです。  
通常であれば、例えば`#c(10 0)`と言った数は、
`10`という`fixnum`オブジェクトが返却されます。  
本関数は強制的に`complex`オブジェクトを生成するときに使用します。 

★注意  
nptでは、本来`integer`となるものが`complex`オブジェクトで渡されることを想定していません。  
本関数を用いて実施した結果については全て未定義です。

### 実行例

```lisp
* #c(10 0)
10
* (complexp #c(10 0))
NIL
* (make-complex 10 0)
#C(10 0)
* (complexp (make-complex 10 0))
T
```


## 関数`make-callname`

`callname`オブジェクトを生成します。

```lisp
(defun make-callname (x) ...) -> callname

入力: x function-name
出力: callname
```

関数名を扱う`callname`オブジェクトを生成します。  
入力は`symbol`型か`(setf symbol)`型を受け取ります。


# <a id="type-check">■型確認</a>

`npt-system`パッケージに存在する、型確認の関数仕様を示します。

```lisp
defun subtypep-result
defun parse-type
defun type-object
```


## 関数`subtypep-result`

`subtypep`の結果を`symbol`で取得します。

```lisp
(defun subtypep-result (left right) ...) -> symbol

入力: left type-specifier
入力: right type-specifier
出力: symbol
```

通常の`subtypep`とは違い、型が排他的かどうかも調査できます。  
返却値は下記の通りです。

- 含まれる場合は`npt-system::include`
- 排他的の場合は`npt-system::exclude`
- 含まれず重複がある場合は`npt-system::false`
- 判定不可能の場合は`npt-system::invalid`


## 関数`parse-type`

型をパースします。

```lisp
(defun parse-type (object) ...) -> type

入力: object type-specifier
出力: type
```

主な目的は型として形が正しいかどうかの調査です。  
返却値は型オブジェクトとなりますが、
通常のCommon Lispで型オブジェクトを利用することはありません。


## 関数`type-object`

型オブジェクトからLispオブジェクトを生成します。

```lisp
(defun type-object (type) ...) -> result

入力: type
出力: result (or cons symbol)
```

入力の型オブジェクトから、型の名前を生成します。


# <a id="memory-stream">■メモリストリーム</a>

`npt-system`パッケージに存在する、メモリストリームの関数仕様を示します。

```lisp
defun make-memory-input-stream
defun make-memory-output-stream
defun make-memory-io-stream
defmacro with-input-from-memory
defmacro with-output-to-memory
defun get-output-stream-memory
defun memory-stream-p
defun (setf memory-stream-p)
```

## 解説

`memory-stream`は、ファイルの代替として用意されたストリームです。  
通常のファイルは`byte`をデータの単位としているため、
本ストリームも`(unsigned-byte 8)`をデータの基本単位としています。  
バイナリストリームであるため、例えば`read-char`関数のような
文字列型のストリーム関数は使用できず、
`read-byte`関数のようなバイナリ型の操作関数が使用できます。

`memory-stream`は`open`関数の`filespec`に使用することができます。

```lisp
(with-open-stream (file (make-memory-input-stream #(#x48 #x65 #x6C #x6C #x6F)))
  (with-open-file (stream file)
    (read-line stream)))
-> "Hello", T
```

ストリームが2つ重複して動作することになりますが、
ファイルポインタは`open`の方が優先され、
`memory-stream`の方は`open`関数によって操作されます。

上記の場合、`with-open-file`内部で実行された`(open file)`の`:input`オペレーションが、
`file`に格納されている`memory-stream`に対して、
最初に`(file-position file :start)`を実行します。  
`read-line`関数によってデータの読み込みが生じたときは、
`stream`のファイルポインタを前進させる処理を行うときに、
`memory-stream`のファイルポインタも同時に前進させます。

`memory-stream`には下記の4つのパラメーターが存在します。

- `:input` 初期値
- `:size` 内部バッファのbyte数
- `:array` 内部バッファ数の初期値
- `:cache` キャッシュの有無

`:input`は`memory-stream`の初期値です。  
必ず`(unsigned-byte 8)`の`sequence`でなければなりません。

`:size`は`memory-sequence`が内部に保有するバッファのサイズです。  
省略時はコンパイル時に`LISP_DEBUG`が指定された場合は`64`byte、
それ以外の場合は`4096`byteです。  
指定した数のバッファが`memory-stream`内部でいくつも生成されることになります。

`:array`は最初に保有する内部バッファの配列数です。  
省略時はコンパイル時に`LISP_DEBUG`が指定された場合は`4`個、
それ以外の場合は`8`個です。  
例えば、`4096`byte×`8`個以上のデータ数が要求された場合、
配列数`8`個から倍の`16`個、`32`個、`64`個、……、と拡張されていきます。

`:cache`はキャッシュの有効・無効を選択します。  
この引数は開発時にデバッグとして使用するためのものです。  
キャッシュとは、`memory-stream`には何の影響もありませんが、
`open`関数に渡されたとき、生成された`file-stream`が
キャッシュを使用するかどうかが選択されます。  
通常のファイルとは違い、`memory-stream`のデータは
全てメモリ上に配置されているため、
キャッシュ機能を`ON`にする必要はありません。  
省略時はコンパイル時に`LISP_DEBUG`が指定された場合は`T`（有効）、
それ以外の場合は`NIL`（無効）です。

`memory-stream`は、入力・出力・入出力の3種類存在しますが、
全て同じオブジェクトを使用しているため
いつでも種類を変更することができます。


## 関数`make-memory-input-stream`

入力専用の`memory-stream`を生成します。

```lisp
(defun make-memory-input-stream (sequence &key size array cache) ...) -> stream

入力: sequence
入力: size (or null (integer 1 *))
入力: array (or null (integer 1 *))
入力: cache t  ;; boolean
出力: stream input-memory-stream
```

`sequence`はストリーム内の初期値に使用されます。  
`size`は内部バッファのサイズであり、初期値は`4096`byteです。  
`array`は初期のバッファ保有数であり、初期値は`8`です。  
`cache`は開発用です。


## 関数`make-memory-output-stream`

出力専用の`memory-stream`を生成します。

```lisp
(defun make-memroy-output-stream (&key input size array cache) ...) -> stream

入力: input sequence
入力: size (or null (integer 1 *))
入力: array (or null (integer 1 *))
入力: cache t  ;; boolean
出力: stream output-memory-stream
```

`input`はストリーム内の初期値に使用されます。  
`size`は内部バッファのサイズであり、初期値は`4096`byteです。  
`array`は初期のバッファ保有数であり、初期値は`8`です。  
`cache`は開発用です。


## 関数`make-memory-io-stream`

入出力対応の`memory-stream`を生成します。

```lisp
(defun make-memroy-io-stream (&key input size array cache) ...) -> stream

入力: input sequence
入力: size (or null (integer 1 *))
入力: array (or null (integer 1 *))
入力: cache t  ;; boolean
出力: stream io-memory-stream
```

`input`はストリーム内の初期値に使用されます。  
`size`は内部バッファのサイズであり、初期値は`4096`byteです。  
`array`は初期のバッファ保有数であり、初期値は`8`です。  
`cache`は開発用です。


## マクロ`with-input-from-memory`

マクロ`with-input-from-string`の`memory-stream`版です。

```lisp
(defmacro with-input-from-memory
  ((stream vector &key size array) declaration* form*) ...)
  -> result
```

`string-stream`とは違い、引数`index`がありません。


## マクロ`with-output-to-memory`

マクロ`with-output-to-string`の`memory-stream`版です。

```lisp
(defmacro with-output-to-memory
  ((var &key input size array) declaration* form*) ...)
  -> result
```

返却値は、`get-output-stream-memory`の戻り値が使用されます。  
`string-stream`とは違い、第2引数の`array`は対応していません。  
戻り値は`(array (unsigned-byte 8))`の配列になります。


## 関数`get-output-stream-memory`

`memory-stream`が保有している全てのデータを配列にして返却します。  

```lisp
(defun get-output-stream-memory (stream) ...) -> vector

入力: stream memory-stream
出力: vector (array (unsigned-byte 8))
```

引数は出力用の`memory-stream`だけではなく、入力と入出力も受け付けます。  
`string-stream`とは違い、値を出力した後でも内容は削除されません。  
返却値は`(array (unsigned-byte 8))`の配列になります。


## アクセス関数`memory-stream-p`

引数が`memory-stream`かどうかを調べます。

```lisp
(defun memory-stream-p (object) ...) -> result

入力: object
出力: result (member :input :output :io nil)
```

`memory-stream`ではない場合は、`nil`を返却します。  
`input-memory-stream`の場合は、`:input`を返却します。  
`output-memory-stream`の場合は、`:output`を返却します。  
`io-memory-stream`の場合は、`:ioを`返却します。


## アクセス関数`(setf memory-stream-p)`

`memory-stream`の種類を変更します。

```lisp
(defun (setf memory-stream-p) (result stream) ...) -> result
入力: stream memory-stream
入力: result  (member :input :output :io)
```

例えば、入力`memory-stream`を、入出力`memory-stream`に変更できます。  
設定値が`:input`で入力、`:output`で出力、`:io`で入出力に変更します。

それぞれの`memory-stream`は全て同一のオブジェクトであり、
種類を変更することによって、`stream`の入出力関数
（例えば`read-byte`など）の使用可否を変更できます。

### 使用例

```lisp
* (setq x (make-memory-output-stream))
#<STREAM MEMORY-OUTPUT #x8012801e0>
* (write-sequence '(65 66 67) x)
(65 66 67)
* (file-position x :start)
T
* (with-open-file (s x) (read-line s))
  -> ★error
* (memory-stream-p x)
:OUTPUT
* (setf (memory-stream-p x) :input)
:INPUT
* (with-open-file (s x) (read-line s))
"ABC"
T
*
```


# <a id="sort">■ソート</a>

`npt-system`パッケージに存在する、ソートの関数仕様を示します。

```lisp
defun simple-sort
defun bubble-sort
defun quick-sort
defun merge-sort
```

## 関数`simple-sort`

選択ソートを行います。

```lisp
(defun simple-sort (sequence call &key key) ...) -> result

入力: sequence
入力: call 関数
入力: key 関数
出力: result sequence
```

不安定であり、実行コストが`O(n^2)`のソートを行います。


## 関数`bubble-sort`

バブルソートを行います。

```lisp
(defun bubble-sort (sequence call &key key) ...) -> result

入力: sequence
入力: call 関数
入力: key 関数
出力: result sequence
```

安定であり、実行コストが`O(n^2)`のソートを行います。


## 関数`quick-sort`

クイックソートを行います。

```lisp
(defun quick-sort (sequence call &key key) ...) -> result

入力: sequence
入力: call 関数
入力: key 関数
出力: result sequence
```

不安定であり、実行コストが`O(n log n)`のソートを行います。


## 関数`merge-sort`

マージソートを行います。

```lisp
(defun merge-sort (sequence call &key key) ...) -> result

入力: sequence
入力: call 関数
入力: key 関数
出力: result sequence
```

安定であり、実行コストが`O(n log n)`のソートを行います。


# <a id="paper">■Paperオブジェクト</a>

`npt-system`パッケージに存在する、Paperオブジェクトの関数仕様を示します。

```lisp
defun make-paper
defun info-paper
defun array-paper
defun body-paper
```

## 関数`make-paper`

Paperオブジェクトを生成します。

```lisp
(defun make-paper (array body &key fill type) ...) -> result

入力: array サイズ
入力: body サイズ
入力: fill 初期値
入力: type User値
出力: result paper
```

Paperオブジェクトとは、`simple-vector`と
バイト形式のバッファをあわせもつオブジェクトです。  
`array`が`nil`か`0`の場合は、body形式で生成されます。  
`body`が`nil`か`0`の場合は、array形式で生成されます。  
`array`と`body`が1以上の場合は、array-body形式で生成されます。  
array-body形式の場合、`array`と`body`はともに`#xFFFF`以下にして下さい。

`:fill`は、body形式の初期値を指定します。  
`nil`か、`t`か、`0x00`～`#xFF`の整数を指定します。  
`nil`の場合は初期化を行いません。  
`t`は0と同じです。

`:type`は、User値です。  
User値とは、形式に関係なく`#x00`～`#xFF`までの値を保有する1byteの領域の事です。  
デフォルト値は0です。  
Paperオブジェクトの種類として利用することをお勧めします。


## 関数`info-paper`

Paperオブジェクトに対して、下記の操作を行います。

- User値の取得と設定
- arrayとbodyの一括取得
- arrayとbodyのサイズ取得

```lisp
(defun info-paper (paper symbol &optional second) ...) -> result

入力: paper
入力: symbol, (member list vector type length)
入力: second
出力: result
```

`symbol`が`type`のときは、User値の取得と設定を行います。  
`second`が指定されていなかった場合は取得です。  
`second`が指定された場合は設定です。

`symbol`が`list`のときは、arrayかbodyの内容をlistで返却します。  
`second`が指定されないか`nil`の場合は、全てのarrayが返却されます。  
`second`が`nil`ではない場合は、全てのbodyが返却されます。

`symbol`が`vector`のときは、arrayかbodyの内容をvectorで返却します。  
`second`が指定されないか`nil`の場合は、全てのarrayが返却されます。  
`second`が`nil`ではない場合は、全てのbodyが返却されます。  
bodyのときは、`(unsigned-byte 8)`形式のspecialized arrayで返却されます。

`symbol`が`vector`のときは、arrayかbodyの長さを返却します。  
`second`が指定されないか`nil`の場合は、arrayの長さが返却されます。  
`second`が`nil`ではない場合は、body長さが返却されます。


## 関数`array-paper`

Paperオブジェクトに対して、arrayの設定と取得を行います。

```lisp
(defun array-paper (paper index &optional value) ...) -> result

入力: paper
入力: index, (integer 0 *)
入力: value
出力: result
```

`value`が指定されていなかった場合は取得です。  
`value`が指定された場合は設定です。


## 関数`body-paper`

Paperオブジェクトに対して、bodyの設定と取得を行います。

```lisp
(defun body-paper (paper index &optional value) ...) -> result

入力: paper
入力: index, (integer 0 *)
入力: value
出力: result
```

`value`が指定されていなかった場合は取得です。  
`value`が指定された場合は設定です。


# <a id="others">■その他の関数</a>

`npt-system`パッケージに存在する、その他の関数の仕様を示します。

```lisp
defun package-export-list
defun large-number
defun equal-random-state
defun remove-file
defun remove-directory
defun byte-integer
defun eastasian-set
defun eastasian-get
defun eastasian-width
```

## 関数`package-export-list`

`package`の`export`リストを取得します。

```lisp
(defun package-export-list (package-designer) ...) -> list

入力: package-designer
出力: list
```

パッケージで`export`されているsymbolの名前のリストを取得します。

## 関数`large-number`

数値を英語で表したときの、3桁区切りのカンマに対応する表記を取得します。

```lisp
(defun large-number (value &optional (cardinal t)) ...) -> string

入力: value 数値
入力: cardinal boolean
出力: string
```

数値を3桁区切りにして、右から`n-1`番目に対応する文字列を返却します。  
下記の数値を考えたとき、

```
1,000,000
```

引数0が右のカンマに対応するので`thousand`です。  
引数1が右から2番目に対応するので`million`です。  
引数`cardinal`が`nil`で序数になります。

### 実行例

```lisp
* (large-number 0)
"thousand"
* (large-number 1)
"million"
* (large-number 1000)
"millinillion"
* (large-number 5555)
"quintilliquinquinquagintaquingentillion"
* (large-number 5555 nil)
"quintilliquinquinquagintaquingentillionth"
```


## 関数`equal-random-state`

`random-state`が等しいかどうかを調べます。

```lisp
(defun equal-random-state (a b) ...) -> boolean

入力: a random-state
入力: b random-state
出力: boolean
```


## 関数`remove-file`

ファイルを削除します。

```lisp
(defun remove-file (pathname &optional (error t)) ...) -> boolean

入力: pathname
入力: errorp
出力: boolean
```

標準関数の`delete-file`と違い、引数`errorp`で失敗の場合を扱うことができます。  
標準では`errorp`が`t`のため、`delete-file`と同じです。  
`errorp`が`nil`の場合は、削除に成功すると`t`を返却し、失敗したら`nil`を返却します。


## 関数`remove-directory`

ディレクトリを削除します。

```lisp
(defun remove-directory (pathname &optional (error t)) ...) -> boolean

入力: pathname
入力: errorp
出力: boolean
```

`errorp`が`t`のときは、削除に失敗したときに`error`が発生します。  
`errorp`が`nil`のときは、削除に成功すると`t`を返却し、失敗したら`nil`を返却します。


## 関数`byte-integer`

CPUのエンディアンを考慮して、`unsigned-byte`の値を連結して整数を返却します。

```lisp
(defun byte-integer (&rest args) ...) -> result

入力: args (unsigned-byte 8)
出力: result (integer 0 *)
```

例えば、非符号付き16bit整数`uint16_t`を考えたとき、
バイト列`#x00 #x01`がいくつになるかを取得するときに使用します。  
CPUがbig endianの場合は、上位バイトが`#x00`で、下位バイトが`#x01`となるため、
返却値は`#x01=1`です。  
一方、CPUがlittle endianの場合は、返却値が`#x0100=256`となります。


## 関数`fpclassify`

浮動小数値の状態と符号を取得します。

```lisp
(defun fpclassify (float) ...) -> type, sign

入力: float
出力: result symbol
出力: result 1か-1
```

`float`が無限大のとき、`type`は`fp-infinite`です。  
`float`が非数のとき、`type`は`fp-nan`です。  
`float`が通常の数のとき、`type`は`fp-normal`です。  
`float`がデノーマル数のとき、`type`は`fp-subnormal`です。  
`float`がゼロのとき、`type`は`fp-zero`です。  
`float`の符号が正のとき、`sign`は`1`です。  
`float`の符号が負のとき、`sign`は`-1`です。

本来、Common Lispでは、無限大と非数を扱うことはできず、
発生した時点で`arithmetic-error` conditionが発生します。


## 関数`eastasian-set`

East Asian Widthのカテゴリ別に、文字数を設定します。

```lisp
(defun eastasian-set (string-designer intplus &optional error) ...) -> boolean) */

入力: string-designer
入力: intplus (integer 0 *)
入力: error boolean
出力: boolean
```

East Asian Widthとは、日本語で言う半角/全角を定義したものです。  
入力の`string-designer`は、`N`, `A`, `H`, `W`, `F`, `NA`の6種類指定できます。  
それぞれのカテゴリに対して、`intplus`で指定した文字数を設定します。

`intplus`には、半角`1`か全角`2`を指定することになると思います。  
`error`が`t`のときは、該当するカテゴリが無かったらエラーが発生します。  
正常終了時には`t`が返却されます。


## 関数`eastasian-get`

East Asian Widthのカテゴリに対応する文字数を取得します。

```lisp
(defun eastasian-get (string-designer) ...) -> (values IntplusNull symbol)

入力: string-designer
出力: intplusNull 文字数かnil
出力: symbol カテゴリのsymbol
```

East Asian Widthとは、日本語で言う半角/全角を定義したものです。  
入力の`string-designer`は、`N`, `A`, `H`, `W`, `F`, `NA`の6種類指定できます。  
それぞれのカテゴリに対応した文字数が返却されます。  
エラーの場合は`NIL`が返却されます。


## 関数`eastasian-width`

East Asian Widthを考慮した長さを返却します。

```lisp
(defun eastasian-width (var) ...) -> (values IntplusNull boolean)

入力: var  (or integer character string)
出力: IntplusNull 文字数かnil
出力: boolean
```

入力`var`には、文字、数値、文字列を指定できます。  
数値の場合は文字コードとみなします。  

### 実行例

```lisp
* (eastasian-width #\A)
1
T
* (eastasian-width #\u3042)
2
T
* (eastasian-width #x3044)
2
T
* (eastasian-width "あいうHello")
11
T
```
