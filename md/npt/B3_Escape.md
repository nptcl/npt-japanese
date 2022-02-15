% 脱出関数

nptのドキュメントです。  
参照元：[https://nptcl.hatenablog.com/entry/2020/08/21/214057:title]  
前へ：[https://nptcl.hatenablog.com/entry/2020/08/23/001650:title]  
次へ：[https://nptcl.hatenablog.com/entry/2020/08/27/012933:title]


# 3.1 脱出関数とは

脱出関数とは、脱出が行われる可能性のある関数のことです。  
以前、脱出関数とは`error`が生じる可能性のある関数だと説明しました。  
しかし脱出とは`error`だけを意味するものではありません。

脱出とは、現在の処理を中断し、スタックフレームを
強制的に終わらせる命令のことを意味します。  
脱出の要因となる命令は、次の5つ存在します。

- `tagbody` / `go`
- `block` / `return-from`
- `catch` / `throw`
- `handler-case`
- `restart-case`

つまり、実行の流れを大きく変更し、
別のスタックフレームにジャンプすることを脱出と呼びます。

脱出はC言語の`setjmp`/`longjmp`、C++言語の`try`/`catch`のようなものです。  
しかしnptではこれらの機能を使わず、
ただ脱出関数を終了させることで脱出を実現しています。

脱出関数とは何らかの技術のことを言っているのではなく、
C言語で関数を作成するときの決まり事のことです。  
これから説明する決まり事を守ることで、
Common Lispの動作を実現できるようになります。


# 3.2 脱出関数の作成

例文を用いて脱出関数の作成を説明します。

```c
int test(void)
{
    lisp_format8_(NULL, "Start~%", NULL);
    lisp_funcall8_(NULL, "TEST-THROW", NULL);
    lisp_format8_(NULL, "End~%", NULL);

    return 0;
}
```

脱出関数の名前はアンダーバー`_`で終わるので、
例文にある`lisp_format8_`と`lisp_funcall8_`は脱出関数です。

`test`関数では、脱出関数の戻り値を全て無視していますが、
本来であれば正しく処理する必要があります。  
正しい脱出関数に書き換えたものを下記に示します。

```c
int test_(void)
{
    if (lisp_format8_(NULL, "Start~%", NULL))
        return 1;
    if (lisp_funcall8_(NULL, "TEST-THROW", NULL))
        return 1;
    if (lisp_format8_(NULL, "End~%", NULL))
        return 1;

    return 0;
}
```

それぞれの脱出関数が値を返却した場合に
`return 1`を実行することで、
正しい脱出関数`test_`を作成できました。

ここで、`test-throw`関数が次のように定義されているとします。

```lisp
(defun test-throw ()
  (throw 'hello 999))
```

`test_`が`lisp_funcall8_`を実行して
`test-throw`を呼び出したとき、
対応する`catch`が存在するならば`throw`が実施されるので、
`lisp_funcall8_`関数は`1`を返却します。

すると`test_`関数もそのまま`return 1`が実行されるため、
次の`format`文は実行されずに`test_`関数が終了します。

このようにして脱出が実現されます。


# 3.3 `lisp_push_control`がある場合

通常の関数`test`内で`lisp_push_control`が使用されているとします。

```c
int test(void)
{
    addr control, v;

    lisp_push_control(&control);
    v = Lisp_hold();
    lisp_format8_(NULL, "Start~%", NULL);
    lisp_funcall8_(v, "TEST-THROW", NULL);
    lisp_format8_(NULL, "End: ~A~%", v, NULL);
    lisp_pop_control_(control);

    return 0;
}
```

脱出関数に書き換える際、push / popで囲まれている文は、
もし脱出が生じた場合でもすぐに`return 1`を実行するのではなく、
必ずpopしてスタックフレームを解放する必要があります。  
例えば次のように変更します。

```c
int test_(void)
{
    addr control, v;

    lisp_push_control(&control);
    v = Lisp_hold();
    if (lisp_format8_(NULL, "Start~%", NULL))
        goto escape;
    if (lisp_funcall8_(v, "TEST-THROW", NULL))
        goto escape;
    if (lisp_format8_(NULL, "End: ~A~%", v, NULL))
        goto escape;
escape:
    return lisp_pop_control_(control);
}
```

例文のように単純な場合は`goto`を用いても問題ありませんが、
複雑な構文になると分かりづらくなってしまいます。  
そこで、nptの開発では次のような書き換えを行っていました。

```c
static int test_call_(void)
{
    addr v;

    v = Lisp_hold();
    if (lisp_format8_(NULL, "Start~%", NULL))
        return 1;
    if (lisp_funcall8_(v, "TEST-THROW", NULL))
        return 1;
    if (lisp_format8_(NULL, "End: ~A~%", v, NULL))
        return 1;

    return 0;
}

int test_(void)
{
    addr control;

    lisp_push_control(&control);
    (void)test_call_();
    return lisp_pop_control_(control);
}
```

さらに例文では、脱出の判定を行う際に

```c
if (...)
    return 1;
```

という文を多用しますが、
この構文は非常に多くの場所で使用するため、
下記のようなマクロを作成します。

```c
#define Return(x) {if (x) return 1;}
```

このマクロを用いることで、`test_call_`関数は次のように書き換えることができます。

```c
static int test_call_(void)
{
    addr v;

    v = Lisp_hold();
    Return(lisp_format8_(NULL, "Start~%", NULL));
    Return(lisp_funcall8_(v, "TEST-THROW", NULL));
    Return(lisp_format8_(NULL, "End: ~A~%", v, NULL));

    return 0;
}
```

脱出関数を多く作成する予定があるのであれば、
この単純なマクロが非常に使いやすいので
使用を検討してみるのも良いかと思います。

まとめますと、脱出関数は次のような規則を課したものを言います。

- 名前がアンダーバー`_`で終わる（必須ではない）
- 関数の戻り値が`int`
- 戻り値は脱出時に`1`、通常は`0`
- pushに対応するpopは必ず実行する

# 3.4 階乗の例を書き換える

前章（[https://nptcl.hatenablog.com/entry/2020/08/23/001650:title]）では、
階乗を出力する例文を作りました。  
しかし説明の都合上エラー処理を行っていなかったため、
脱出関数の戻り値をすべて無視していました。

正しい脱出関数に書き換えたものを下記に示します。

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

int main_lisp(void *ignore)
{
    addr control, x, y;

    lisp_push_control(&control);
    x = Lisp_hold();
    y = Lisp_hold();
    lisp_fixnum(y, 123);
    if (fact_(x, y))
        goto escape;
    if (lisp_format8_(NULL, "fact: ~A! = ~A~%", y, x, NULL))
        goto escape;
escape:
    return lisp_pop_control_(control);
}
```

例文の`fact_`関数はこれ以上修正の必要が無い完成されたものになります。
