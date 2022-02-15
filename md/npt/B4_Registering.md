% 関数の登録

nptのドキュメントです。  
参照元：[https://nptcl.hatenablog.com/entry/2020/08/21/214057:title]  
前へ：[https://nptcl.hatenablog.com/entry/2020/08/23/134815:title]  
次へ：[https://nptcl.hatenablog.com/entry/2020/08/27/143742:title]


# 4.1 関数の登録

Common Lispの関数を作成する方法を説明します。

ここではC言語の中だけにとどまらず、
Common Lispの機能でも利用できるようなごく普通の関数を、
C言語だけで実装する方法について説明します。

通常、関数の作成は`lambda`と`defun`によって行われますが、
C言語だけでもほぼ同等の関数を作成できます。  
ただし関数の型だけは違っており、
C言語で作成するため`FUNCTION`型ではなく、
`car`のような標準関数と同様に`COMPILED-FUNCTION`型になります。

確認してみます。

```
* (lambda ())
#<FUNCTION LAMBDA #x801256a00>
* #'car
#<COMPILED-FUNCTION CAR>
*
```


# 4.2 関数ポインタを登録する

C言語の関数を使用するには、
関数ポインタに番号を付けて登録する必要があります。

登録できる関数ポインタの数は最大32個です。  
もし足りないのであれば、
コンパイル時に`LISP_POINTER_EXTEND`をdefineして下さい。

例として128個に拡張したコンパイルの実行を下記に示します。

```
$ cc -DLISP_POINTER_EXTEND=128 src/*.c -lm
```

関数ポインタを登録する命令を下記に示します。

```c
void lisp_compiled_rest(int index, lisp_calltype_rest call);
void lisp_compiled_empty(int index, lisp_calltype_empty call);
void lisp_compiled_var1(int index, lisp_calltype_var1 call);
void lisp_compiled_var2(int index, lisp_calltype_var2 call);
void lisp_compiled_var3(int index, lisp_calltype_var3 call);
```

引数`index`は登録する番号であり、通常は0～31の値です。  
引数`call`は脱出関数の関数ポインタです。  
引数によって使う関数が異なります。

汎用的に使用できるのが`lisp_compiled_rest`であり、
`lisp_calltype_rest`は`int (*)(addr)`型です。  
`rest`とはlambdaリストの`(&rest list)`を意味します。  
`empty`は引数無し、`var1`は1つ、`var2`は2つ、`var3`は3つの引数に対応します。

登録するのは脱出関数です。


# 4.3 関数オブジェクトの作成

関数オブジェクトを作成する命令を下記に示します。

```c
int lisp_compiled_function_(addr x, int index, addr symbol);
int lisp_compiled_function8_(addr x, int index, const void *str);
int lisp_compiled_function16_(addr x, int index, const void *str);
int lisp_compiled_function32_(addr x, int index, const void *str);
```

これらの関数はCommon Lisp上で実行するものなので、
関数ポインタの登録関数とは違い、
`main_lisp`関数に制御が渡ってからでないと実行できません。

例として、次の脱出関数をCommon Lispで使用することを考えます。

```c
int function_test_(addr list)
{
    return lisp_format8_(NULL, "TEST = ~A~%", list, NULL);
}
```

まずは関数番号0番に`function_test_`の関数ポインタを登録します。

```c
lisp_compiled_rest(0, function_test_);
```

これで関数生成ができるようになりました。  
関数オブジェクトを作成するには次のようになります。

```c
lisp_compiled_function_(x, 0, NULL);
```

実行して確認するために、確認用の関数`test_output_`を作成します。

```c
int test_output_(void)
{
    addr control, x;

    lisp_push_control(&control);
    x = Lisp_hold();
    lisp_compiled_function_(x, 0, NULL);
    return lisp_pop_control_(control);
}
```

これでhold変数`x`に関数オブジェクトが格納されます。  
更に変更し、作成した関数オブジェクトを`funcall`で実行してみます。

```c
int test_output_(void)
{
    addr control, x, y, z;

    lisp_push_control(&control);
    x = Lisp_hold();
    y = Lisp_hold();
    z = Lisp_hold();
    lisp_compiled_function_(x, 0, NULL);
    lisp_fixnum(y, 10);
    lisp_fixnum(z, 20);
    lisp_funcall_(NULL, x, y, z, NULL);
    return lisp_pop_control_(control);
}
```

脱出は無視しています。

関数`test_output_`は、Common Lispで表すと次のようになります。

```lisp
(funcall #<COMPILED-FUNCTION NIL> 10 20)
```

実行結果は下記のとおりです。

```
TEST = (10 20)
```

登録された関数が動作しているのがわかります。


# 4.4 関数オブジェクトの登録

次は`defun`を実行します。  
つまり関数オブジェクトを作成したら`symbol-function`に登録します。

登録する関数は下記のとおりです。

```c
int lisp_compiled_defun_(int index, addr symbol);
int lisp_compiled_defun8_(int index, const void *str);
int lisp_compiled_defun16_(int index, const void *str);
int lisp_compiled_defun32_(int index, const void *str);
```

例として、以前作成した階乗の関数`fact_`を
`FACT`という名前で登録してみます。  
まずは前章で完成した関数`fact_`を示します。

```c
static int fact_(addr x, addr value)
{
    addr control, y;

    if (! lisp_plus_p(value)) {
        lisp_fixnum(x, 1);
        return 0;
    }

    lisp_push_control(&control);
    y = Lisp_hold();
    if (lisp_funcall8_(y, "1-", value, NULL))
        goto escape;
    if (fact_(y, y))
        goto escape;
    if (lisp_funcall8_(x, "*", value, y, NULL))
        goto escape;
escape:
    return lisp_pop_control_(control);
}
```

関数`fact_`は脱出関数としては完成されているのですが、
登録用に作成しているわけではないため、
そのまま関数ポインタに登録することはできません。

そこで登録用に関数`function_fact_`を作成します。  
内容は関数`fact_`を呼びだして戻り値を設定するというものです。

```c
int function_fact_(addr var)
{
    addr control, x;

    lisp_push_control(&control);
    x = Lisp_hold();
    if (fact_(x, var))
        goto escape;
    lisp_set_result_control(x);
escape:
    return lisp_pop_control_(control);
}
```

関数の戻り値の設定は`lisp_set_result_control`関数で行っています。  
続いて登録の処理を示します。

```c
int main_lisp(void *ignore)
{
    lisp_compiled_var1(1, function_fact_);
    lisp_compiled_defun8_(1, "FACT");

    return lisp_eval_loop_();
}
```

登録には`lisp_compiled_var1`を用いて、
たった1つの引数のみを受け取るようにしています。  
関数番号は1番です。  
次に`lisp_compiled_defun8_`を実行し、
`FACT`という名前で関数を登録します。  
最後に`lisp_eval_loop_`を実行し、
確認のためのeval-loopを呼び出します。

実行するとプロンプトが表示されるので、
`fact`関数を実行してみましょう。

```
$ ./a.out
* (fact 123)
1214630436702532967576624324188129585545421708848338231532891816182923
5892362167668831156960612640202170735835221294047782591091570411651472
186029519906261646730733907419814952960000000000000000000000000000
* (/ (fact 123) (fact 121))
15006
* ^D
$
```

関数`fact`がLispの関数として動作しており、
式の中にも組み込むことができているのがわかります。


# 4.5 クロージャーを使う

ここでのクロージャーとは、
関数オブジェクトに値を保存する機能のことです。

関数オブジェクトは1つの値を持つことができます。  
値の設定は下記の命令を使います。

```c
void lisp_compiled_setvalue(addr pos, addr value);
```

関数オブジェクトを生成したあとで、
値10をクロージャ―に保存するときは次のようになります。

```c
lisp_compiled_function_(x, 0, NULL);
lisp_fixnum(value, 10);
lisp_compiled_setvalue(x, value);
```

設定した値は、関数ポインタを登録した関数が呼び出されたときに、
次の命令を使用して取得できます。

```c
void lisp_compiled_getvalue(addr *ret);
```

この関数には注意しなければならないことがあります。  
値の取得は、`lisp_push_control`を行う前に実施してください。  
スタックフレームの確保ができないのでhold変数は使用できず、
オブジェクトを直接受け取る形になっています。

もしhold変数に格納したい場合は、次のような記述になります。

```c
int function_test_(addr list)
{
    addr control, x;

    lisp_compiled_getvalue(&x);
    lisp_push_control(&control);
    lisp_hold(&x, x);
    ...
    return lisp_pop_control_(control);
}
```


# 4.6 なぜ関数を番号に割り当てるのか

関数ポインタを登録する際に、0～31の番号に割り当てると説明しました。  
例えば下記の実行を行います。

```c
lisp_compiled_rest(0, function_test_);
```

では、なぜ番号に割り当てるのでしょうか。  
理由はコアファイルの読み書きの為です。

当初コアファイルには関数ポインタの値をそのまま記載する予定でした。  
しかし近年のセキュリティ事情によって、オペレーティングシステムに
ASLR (Address Space Layout Randomization)という機能が実装され、
プロセスが起動するたびに関数ポインタが
ランダムに変わるようになりました。  
もし関数ポインタの値をコアファイルに書き込んでしまうと、
次のプロセスが起動したときに全く違うアドレスを指しているため
正常に動作しなくなります。

番号の登録はnpt内部でも使用されており、`lisp_init`関数を実行すると
Common Lispの関数をはじめとする全ての関数の番号が設定されます。

関数ポインタの登録は、対応する関数が実行される前であれば
いつでも実施できます。  
しかしなるべく早い方が良いと考えますので、
推奨としては`lisp_init`関数を実行した直後が適しているのではないかと思います。

一方、下記の関数

```c
lisp_compiled_defun8_(0, "TEST");
```

は、`compiled-function`オブジェクトを作成するというCommon Lispの機能です。  
初期化ではないため`main_lisp`関数以降でないと実行できません。
