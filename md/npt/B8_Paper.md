% Paperオブジェクト

nptのドキュメントです。  
参照元：[ANSI Common Lisp npt](index.html)  
前へ：[スタートアップ](B7_StartUp.html)


# 8.1 Paperオブジェクト

Paperオブジェクトは、npt固有のデータ形式です。  
`vector`のような一次元配列と、byte形式の配列データを同時に保有することができます。  
nptの実装に合ったオブジェクトを作成するため、
メモリ空間に対して効率がよいという利点があります。

本オブジェクトは、主にC言語上で使用することを目的としています。  
例えば、Common Lispのヒープ上に独自のデータを格納するような場合に便利です。  
操作関数はC言語とCommon Lispのどちらのものも用意されています。


# 8.2 オブジェクト形式

nptのオブジェクトは、下記の3つのいずれかの形で表されます。

- array形式
- body形式
- array-body形式

array形式は一次元`vector`と同じです。  
body形式は、バイト単位のバッファ領域を保有します。  
array-body形式は、array形式とbody形式を組み合わせたものです。

array-body形式には制限があり、arrayとbodyのサイズをどちらも`#xFFFF`以下にしなければなりません。  
それ以上の長さを使いたい場合は、例えばarray形式とbody形式を分けて確保してください。

全てのオブジェクトには、User値と呼ばれる1byteのデータ領域が用意されています。  
User値の使い方は自由ですが、Paperオブジェクトを種類分けするために使うことをお勧めします。  
User値のデフォルト値は`0`です。


# 8.3 array形式

array形式の使い方を説明します。  
array形式は、一次元general arrayである、`vector`と同じです。  
作成は次のようにして行います。

```lisp
(make-paper size 0)
```

第一引数の`size`は配列の要素数です。  
例えば、要素数10のPaperを作成する場合は次のようになります。

```lisp
(make-paper 10 0)
```

初期値は、全要素が`nil`です。

配列の値を取得するには、次のように実行します。

```lisp
(array-paper paper index)
```

値を設定するには、次のように実行します。

```lisp
(array-paper paper index value)
```

下記の実行を`vector`の操作と比較してみます。

```lisp
(setq x (make-paper 10 0))
(array-paper x 3)
(array-paper x 3 "Hello")
```

`vector`では次のようにあらわされます。

```lisp
(setq x (make-array 10))
(aref x 3)
(setf (aref x 3) "Hello")
```

次に、同じことをC言語で行います。  
オブジェクトの作成は次の関数を使用します。

```c
int lisp_paper_(addr x, size_t array, size_t body);
```

実行例を示します。

```c
static int main_call_(void)
{
    addr x;

    x = Lisp_hold();
    if (lisp_paper_(x, 10, 0))
        return 1;

    return 0;
}

int main_lisp(void *ignore)
{
    addr control;

    lisp_push_control(&control);
    (void)main_call_();
    return lisp_pop_control_(control);
}
```

正しく実行するには上記のようにする必要があるのですが、
説明するうえでは不要のため、
戻り値の判定を省略して次のようにあらわします。

```c
addr x;

x = Lisp_hold();
lisp_paper_(x, 10, 0);
```

配列の取得と設定は下記の関数を使用します。

```c
int lisp_paper_getarray_(addr x, addr pos, size_t index);
int lisp_paper_setarray_(addr x, size_t index, addr value);
```

次の例文をC言語で表してみます。

```lisp
(setq x (make-paper 10 0))
(array-paper x 3)
(array-paper x 3 "Hello")
```

```c
addr x, v;

x = Lisp_hold();
v = Lisp_hold();
lisp_paper_(x, 10, 0);
lisp_paper_getarray_(v, x, 3);
lisp_string8_(v, "Hello");
lisp_paper_setarray_(x, 3, v);
```


# 8.4 body形式

body形式の使い方を説明します。  
body形式は、`(unsigned-byte 8)`形式の
一次元specialized arrayと同じです。  
作成は次のようにして行います。

```lisp
(make-paper 0 size)
```

第二引数の`size`は確保するバッファのバイト数です。  
例えば、10byteのPaperを作成する場合は次のようになります。

```lisp
(make-paper 0 10)
```

初期値は不定です。  
array形式とは違い、body形式は値の内容を初期化しません。  
もし初期化が必要な場合は`:fill`引数を使用します。

下記の例では、確保したbody部の`#x00`で初期化します。

```lisp
(make-paper 0 10 :fill t)
```

または、次のように初期値を指定できます。

```lisp
(make-paper 0 10 :fill #xFF)
```

値の範囲は`0`～`#xFF`の間になります。

配列の値を取得するには、次のように実行します。

```lisp
(body-paper paper index)
```

返却される値は、`0`～`#xFF`の整数です。

値を設定するには、次のように実行します。

```lisp
(body-paper paper index value)
```

valueの値は、`0`～`#xFF`の整数である必要があります。

バッファの取得と設定は下記の関数を使用します。

```c
int lisp_paper_getbody_(addr x, size_t index, byte *ret);
int lisp_paper_setbody_(addr x, size_t index, byte value);
```

次の例文をC言語で表してみます。

```lisp
(setq x (make-paper 0 10))
(body-paper x 3)
(body-paper x 3 #xFF)
```

```c
byte value;
addr x;

x = Lisp_hold();
lisp_paper_(x, 0, 10);
lisp_paper_getbody_(x, 3, &value);
lisp_paper_setbody_(x, 3, 0xFF);
```


# 8.5 array-body形式

array-body形式の使い方を説明します。  

```lisp
(make-paper size1 size2)
```

第一引数の`size1`は、array配列の個数です。  
第二引数の`size2`は、bodyバッファのバイト数です。  
例えば、arrayが10要素、bodyが20byteのPaperを作成する場合は次のようになります。

```lisp
(make-paper 10 20)
```

array-body形式を作成する場合は、
`size1`, `size2`どちらの値も`#xFFFF`以下にしてください。  
違反した場合は`simple-error` conditionが発生します。


# 8.6 `info-array`関数

`info-array`関数は、Paperオブジェクトに対して、下記の操作を行います。

- User値の取得と設定
- 内容の一括取得
- 長さを取得


## 8.6.1 User値の取得と設定

User値とはオブジェクトが保有する1byteの情報です。  
取得は`info-paper`関数に、`type`を指定します。

```lisp
(setq x (make-paper 3 4))
-> #<PAPER 0 #x801699220>

(info-array paper 'type)
-> 0
```

User値は、`make-array`の`:type`引数で指定できます。

```lisp
(setq x (make-paper 3 4 :type 123))
-> #<PAPER 123 #x80169b258>

(info-paper x 'type)
-> 123
```

または、`info-array`の引数にて設定できます。

```lisp
(info-paper x 'type 100)
-> 100

(info-paper x 'type)
-> 100

x
-> #<PAPER 100 #x80169b258>
```

C言語では、下記の関数を使用します。

```c
int lisp_paper_gettype_(addr x, byte *ret);
int lisp_paper_settype_(addr x, byte value);
```

実行例を示します。

```c
byte value;
addr x;

x = Lisp_hold();
lisp_paper_(x, 0, 10);
lisp_paper_settype_(x, 123);
lisp_paper_gettype_(x, &value);
printf("%d\n", (int)value);
```


## 8.6.2 内容の一括取得

arrayとbodyの内容は、`list`か`vector`形式で取得できます。  
arrayの内容を取得してみます。  
取得は`info-paper`関数に、`list`か`vector`を指定します。

```lisp
(setq x (make-paper 3 4 :fill 7))
-> #<PAPER 0 #x80174f258>

(info-paper x 'list)
-> (NIL NIL NIL)

(info-paper x 'vector)
-> #(NIL NIL NIL)
```

bodyの内容を取得する場合は、`info-paper`の第三引数に`t`を指定します。

```lisp
(setq x (make-paper 3 4 :fill 7))
-> #<PAPER 0 #x801752c28>

(info-paper x 'list t)
-> (7 7 7 7)

(info-paper x 'vector t)
-> #(7 7 7 7)
```

なお、body部の`vector`は、
`(unsigned-byte 8)`のspecialized array形式で返却されます。


## 8.6.2 長さを取得

arrayとbodyの長さを取得します。  
取得は`info-paper`関数に、`length`を指定します。

```lisp
(setq x (make-paper 3 4))
-> #<PAPER 0 #x801756418>

(info-paper x 'length)
-> 3

(info-paper x 'length t)
-> 4
```

C言語では、下記の関数を使用します。

```c
int lisp_paper_lenarray_(addr x, size_t *ret);
int lisp_paper_lenbody_(addr x, size_t *ret);
```

実行例を示します。

```c
addr x;
size_t array, body;

x = Lisp_hold();
lisp_paper_(x, 5, 6);
lisp_paper_lenarray_(x, &array);
lisp_paper_lenbody_(x, &body);
printf("%d, %d\n", (int)array, (int)body);
```


# 8.7 その他の内容

下記の内容について説明します。

- Paperオブジェクトと型
- `compile-file`の扱い
- その他のC言語関数


## 8.7.1 Paperオブジェクトと型

Paperオブジェクトは、npt内においては通常のLispオブジェクトです。  
`eval`で評価できますし、型も持っています。  

型の評価は下記のようにして行います。

```lisp
(typep x 'npt-system::paper)
```

`built-in-class`のクラスも存在します。

```lisp
(find-class 'npt-system::paper)
-> #<BUILT-IN-CLASS PAPER>
```


## 8.7.2 `compile-file`の扱い

Paperオブジェクトは、`compile-file`で保存できます。  
array部分は`vector`オブジェクトと同様に扱われます。  
body部分は、バッファの内容をそのままfaslファイルに書き込みます。  
User値も同様に保存されます。


## 8.7.3 その他のC言語関数

下記の関数が用意されています。

```c
int lisp_paper_getmemory_(addr x, size_t a, size_t b, void *output, size_t *ret);
int lisp_paper_setmemory_(addr x, size_t a, size_t b, const void *input, size_t *ret);
```

`lisp_paper_getmemory_`は、body部の内容を一括して取得します。  
`lisp_paper_setmemory_`は、body部の内容を一括して設定します。

引数`a`と`b`はbody部の位置を表し、`a`番目から`b`番目直前までの内容を示します。  
`subseq`関数と同様、`b`番目の位置は含まれません。  
`a`番目から開始し、`(- b a)`byte分の内容を処理します。

`a`と`b`の値は、body部のサイズを超えていてもかまいません。  
処理されたバイト数は、引数`ret`に格納されます。  
引数`ret`が`NULL`の場合は無視されます。
