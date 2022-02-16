% hold変数の使い方

nptのドキュメントです。  
参照元：[ANSI Common Lisp npt](index.html)  
前へ：[nptをC言語で使用する](B1_Using.html)  
次へ：[脱出関数](B3_Escape.html)


# 2.1 基本的な作成方法の解説

本書ではnptモジュールを用いてC言語で開発をするための基本を示します。  
主な内容は、hold変数の使い方になります。


# 2.2 エラーの扱いについて

開発をするうえで無視できないのがエラーです。  
しかしエラーの扱いは難しいため、何回かに分けて解説する必要があります。  
本章では基本を説明するということなので、エラー処理については説明しません。

もしエラーが発生した場合はどうなるかを見てみます。  
例として下記の文を実行します。

```c
int main_lisp(void *ignore)
{
	lisp_error8_("Hello", NULL);
	return 0;
}
```

`lisp_error8_`関数は`simple-error condition`を実行するものであり、
Common Lispでは次の文とほぼ等しくなります。

```lisp
(error "Hello")
```

実行結果は下記の通り。

```
$ ./a.out
ERROR: SIMPLE-ERROR
Hello

There is no restarts, abort.


**************
  LISP ABORT
**************
$
```

`SIMPLE-ERROR`が検知され、メッセージが出力されたあとで
`restart`が見つからず`ABORT`されました。  
`LISP ABORT`とはプロセスが強制終了されたことを意味します。

本来であれば`SIMPLE-ERROR`は適切に処理されるのが望ましいのですが、
本章ではこれで十分です。

以降の説明では、エラーが発生した場合に`LISP ABORT`されるとして話を進めます。


# 2.3 例文を用いて説明する

開発の基本的な考え方を示すために、例として階乗の関数を作ります。  
階乗とは、次のようなものを言います。

```
6! = 6*5*4*3*2*1
```

6の階乗は720です。  
Common Lispでは、次のように簡単に実装できます。

```lisp
(defun fact (x)
  (if (not (plusp x))
    1
    (* x (fact (1- x)))))
```

C言語でも実装できます。

```c
int fact(int x)
{
    if (x <= 0)
        return 1;
    else
        return x * fact(x - 1);
}
```

しかしC言語では`bignum`が使えないため、
例えば`fact(123)`は求めることができません。  
参考までに123の階乗は下記のとおりです。

```
1214630436702532967576624324188129585545421708848338231532891816182923
5892362167668831156960612640202170735835221294047782591091570411651472
186029519906261646730733907419814952960000000000000000000000000000
```

本章の目的は、C言語で`bignum`にも対応したコードを作成し、
nptモジュールの使い方に触れていくことにあります。


# 2.4 hold変数

Common Lispのオブジェクトを扱うには、
「hold変数」というオブジェクトを用いて値をやり取りする必要があります。  
hold変数とはレキシカル変数のようなものであり、
C言語上で扱いやすいように作られたLispオブジェクトです。  
この変数の扱いを覚えることが本章の目的でもあります。

使用するためには開始と終了を宣言し、
スタックフレームの確保と解放を行う必要があります。  
下記の関数を用いて行います。

- `lisp_push_control`
- `lisp_pop_control_`

`lisp_push_control`はhold変数の開始を宣言し、
スタックフレーム上に新しい領域を設けます。  
`lisp_pop_control_`はhold変数の終了を宣言し、
対応するhold変数の解放処理を行います。

使用例を下記に示します。

```c
/* 変数宣言 */
addr control, x, y;

lisp_push_control(&control);
x = Lisp_hold();  /* hold変数の確保 */
y = Lisp_hold();  /* hold変数の確保 */
lisp_pop_control_(control);
```

例文で示した通り、hold変数`x`と`y`の確保を`Lisp_hold`関数で行っています。

下記の例では、すでに階乗を求める関数`fact_`が作成されているものとして、
結果の値を表示するコードを示します。

```c
int main_lisp(void *ignore)
{
    addr control, x, y;

    lisp_push_control(&control);
    x = Lisp_hold();
    y = Lisp_hold();
    lisp_fixnum(y, 123);
    fact_(x, y);
    lisp_format8_(NULL, "fact: ~A! = ~A~%", y, x, NULL);
    lisp_pop_control_(control);

    return 0;
}
```

変数`x`と`y`には、`Lisp_hold`関数によりhold変数が代入されます。  
`lisp_fixnum`関数では、hold変数`y`に`123`という数値を代入します。  
`fact_`関数では、hold変数`x`に、`123`の階乗の値を代入します。  
`lisp_format8_`関数では、`format`文を実行します。

あとは`fact_`という関数を作成すれば完了です。


# 2.5 階乗関数の作成

関数を作成するまえに、関数名の規則について説明します。  
関数の名前には、`fact_`や`lisp_format8_`のように、
名前の最後がアンダーバー`_`で終わるものと終わらないものがあります。

簡単に言うと`error`が発生する可能性があるものにアンダーバーが付いています。  
このような関数を「脱出関数」と呼びます。  
脱出についての詳しい説明は別章で行います（[脱出関数](B3_Escape.html)）。  
命名規則は自主的なものなので、アンダーバーを付けるかどうかは自由です。

それでは`fact_`関数の内容を示します。

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
    lisp_funcall8_(y, "1-", value, NULL);
    fact_(y, y);
    lisp_funcall8_(x, "*", value, y, NULL);
    lisp_pop_control_(control);

    return 0;
}
```

最初の`lisp_plus_p`文では、`value`が`0`以下の場合、
hold変数`x`に`1`を代入して終了します。

もし変数`value`の値が`1`以上であった場合は、
`lisp_push_control`以降が実行されます。

hold変数`y`を確保し、`value`から`1`減算した値を格納します。  
`lisp_funcall8_`関数は、文字列で表される関数を実行するものです。

次にhold変数`y`を用いて`fact_`関数を再帰呼出し、
その結果を変数`y`自身に代入します。

得られた結果`y`と、引数である変数`value`の値を掛け算し、
結果を`fact_`の戻り値として返却します。

最後に`lisp_pop_control_`により、
hold変数の解放を行います。


# 2.6 階乗のコードを実行する

まとめると次のようになります。

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
    lisp_funcall8_(y, "1-", value, NULL);
    fact_(y, y);
    lisp_funcall8_(x, "*", value, y, NULL);
    lisp_pop_control_(control);

    return 0;
}

int main_lisp(void *ignore)
{
    addr control, x, y;

    lisp_push_control(&control);
    x = Lisp_hold();
    y = Lisp_hold();
    lisp_fixnum(y, 123);
    fact_(x, y);
    lisp_format8_(NULL, "fact: ~A! = ~A~%", y, x, NULL);
    lisp_pop_control_(control);

    return 0;
}
```

実行結果を下記に示します。

```
$ ./a.out
fact: 123! = 121463043670253296757662432418812958554542170884833823153
2891816182923589236216766883115696061264020217073583522129404778259109
1570411651472186029519906261646730733907419814952960000000000000000000
000000000
```

以上にて、`lisp_push_control`、
`lisp_pop_control_`、`Lisp_hold`による
hold変数の使い方が理解できたと思います。
