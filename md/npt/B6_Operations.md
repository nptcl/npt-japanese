% 脱出の操作

nptのドキュメントです。  
参照元：[ANSI Common Lisp npt](index.html)  
前へ：[LISP ABORT](B5_Abort.html)  
次へ：[スタートアップ](B7_StartUp.html)


# 6.1 脱出の操作

脱出の操作を説明ます。

以前、脱出の理由を5つ挙げました。

- `tagbody`/`go`
- `block`/`return-from`
- `catch`/`throw`
- `handler-case`
- `restart-case`

この中で、`tagbody`/`go`と`block`/`return-from`は
レキシカルな環境での使用を前提としているため、
C言語では使用不可とします。

残り3つの操作はC言語でも実装可能です。  
脱出の操作は、発生と終了だけではなく割り込みも考えなくてはいけません。  
脱出の割り込みとは、`unwind-protect`のことです。

まとめると、本章では下記の機能について説明します。

- `catch`/`throw`
- `handler-case`
- `restart-case`
- `unwind-protect`


# 6.2 `catch`/`throw`

脱出の操作で最も簡単なのが`catch`/`throw`です。

`catch`はスタックフレームに対して`symbol`を登録します。  
よって`lisp_push_control`は必ず実行する必要があります。  
登録は下記の関数を使用します。

```c
void lisp_catch(addr symbol);
```

`throw`は下記の関数を使用します。

```c
int lisp_throw_(addr symbol);
```

`throw`関数は現在のスタックフレームから順に遡って行き、
引数`symbol`に対応する`catch`が無い場合は`error`、
存在する場合は`catch`の脱出を行います。  
必ず脱出するため、戻り値は判定するまでもなく0以外です。

脱出中は、どこまで遡るかというスタックフレームの位置情報を保有しており、
現在のスタックフレームが脱出の到達地点に達したかどうかは
下記の関数を使用することで確認できます。

```c
int lisp_break_control(void);
```

現在脱出中でありかつ現在のスタックフレームが
到達地点にいる場合は真（0以外）を返却します。  
`catch`/`throw`の場合は、この関数が真のときに
非脱出に切り替えることで`throw`が完了します。

非脱出に切り替える関数は下記のとおりです。

```c
void lisp_reset_control(void);
```

手順をまとめると次のようになります。

- `lisp_push_control`でスタックフレームの作成
- `lisp_catch`で`symbol`を登録
- `lisp_throw_`で脱出
- `lisp_break_control`で到達点を調査
- 到達していたら`lisp_reset_control`で非脱出に移行

例として下記の文を示します。

```lisp
(catch 'hello
  (throw 'hello 222)
  333)
```

`throw`により`222`が返却されるので、`333`は無視されて
全体の返却値は`222`となります。

```c
int throw_hello_222_(addr x)
{
    lisp_fixnum(x, 222);
    lisp_set_result_control(x);
    if (lisp_intern8_(x, NULL, "HELLO"))
        return 1;

    return lisp_throw_(x);
}

int main_call_(addr x)
{
    addr control;

    lisp_push_control(&control);
    /* (catch 'hello ...) */
    if (lisp_intern8_(x, NULL, "HELLO"))
        goto escape;
    lisp_catch(x);
    /* (throw 'hello 222) */
    if (throw_hello_222_(x))
        goto escape;
    /* (values 333) */
    lisp_fixnum(x, 333);
    lisp_set_result_control(x);
escape:
    if (lisp_break_control())
        lisp_reset_control();
    return lisp_pop_control_(control);
}

int main_lisp(void *ignore)
{
    addr control, x;

    lisp_push_control(&control);
    x = Lisp_hold();
    if (main_call_(x))
        goto escape;
    lisp_result_control(x);
    if (lisp_format8_(NULL, "RESULT: ~A~%", x, NULL))
        goto escape;
escape:
    return lisp_pop_control_(control);
}
```

実行結果は`RESULT: 222`です。


# 6.3 `handler-case`

基本的な構成は`catch`/`throw`と変わりません。  
`condition`の登録は下記の関数を使います。

```c
int lisp_handler_case_(addr name, addr call);
```

そして`throw`にあたるのが`signal`か`error`です。  
例文を下記に示します。

```c
int main_call_(addr x)
{
    addr control, y;

    lisp_push_control(&control);
    y = Lisp_hold();
    /* handler-case */
    if (lisp_intern8_(x, NULL, "AAA"))
        goto escape;
    if (lisp_eval8_(y, "(lambda (c) (declare (ignore c)) 222)"))
        goto escape;
    if (lisp_handler_case_(x, y))
        goto escape;
    /* (signal 'aaa) */
    if (lisp_eval8_(NULL, "(signal 'aaa)"))
        goto escape;
    /* (values 333) */
    lisp_fixnum(x, 333);
    lisp_set_result_control(x);
escape:
    if (lisp_break_control())
        lisp_reset_control();
    return lisp_pop_control_(control);
}

int main_lisp(void *ignore)
{
    addr control, x;

    lisp_push_control(&control);
    x = Lisp_hold();
    if (lisp_eval8_(NULL, "(define-condition aaa () ())"))
        goto escape;
    if (main_call_(x))
        goto escape;
    lisp_result_control(x);
    if (lisp_format8_(NULL, "RESULT: ~A~%", x, NULL))
        goto escape;
escape:
    return lisp_pop_control_(control);
}
```

実行結果は`RESULT: 222`です。



# 6.4 `restart-case`

構成は`handler-case`と同じです。

`restart`オブジェクトを生成し、
現在のスタックフレームに対して登録することで実現します。  
`restart`オブジェクトは下記の関数で生成します。

```c
void lisp_restart_make(addr x, addr name, addr call, int casep);
```

`restart`の登録は下記の関数を使います。

```c
void lisp_restart_push(addr restart);
```

使用例をあげます。

```c
int main_call_(addr x)
{
    addr control, y;

    lisp_push_control(&control);
    y = Lisp_hold();
    /* restart-case */
    if (lisp_intern8_(x, NULL, "HELLO"))
        goto escape;
    if (lisp_eval8_(y, "(lambda () 222)"))
        goto escape;
    lisp_restart_make(x, x, y, 1);
    lisp_restart_push(x);
    /* (invoke_restart 'hello) */
    if (lisp_eval8_(NULL, "(invoke-restart 'hello)"))
        goto escape;
    /* (values 333) */
    lisp_fixnum(x, 333);
    lisp_set_result_control(x);
escape:
    if (lisp_break_control())
        lisp_reset_control();
    return lisp_pop_control_(control);
}

int main_lisp(void *ignore)
{
    addr control, x;

    lisp_push_control(&control);
    x = Lisp_hold();
    if (main_call_(x))
        goto escape;
    lisp_result_control(x);
    if (lisp_format8_(NULL, "RESULT: ~A~%", x, NULL))
        goto escape;
escape:
    return lisp_pop_control_(control);
}
```

実行結果は`RESULT: 222`です。


# 6.5 `unwind-protect`

`unwind-protect`は、第一引数の式を実行した後、
cleanupフォームを実行する前に下記の値の退避が必要です。

- 脱出情報
- 返却値の情報

脱出情報とは、現在の脱出モードと
脱出先のスタックフレームの情報です。  
返却値の情報とは、`list_result_control`などで取得できる値であり、
`values`の値そのもののため、ひとつではなく複数の値が対象となります。

`unwind-protect`を実行する前に
現在の状態を一括して退避しておき、
`cleanup`フォームを実行した後で状態をロールバックさせます。

下記の関数は、脱出情報と返却値を同時に保存する命令です。

```c
void lisp_save_control(addr *ret);
```

情報はhold変数と同様、スタックフレームを利用して保存します。  
保存後は下記の関数を用いて非脱出に移行します。

```c
void lisp_reset_control(void);
```

もともと非脱出の場合でも実行はできます。

それでは保存が終わりましたので、`cleanup`処理を実施します。  
もし`cleanup`処理中に新たな脱出が生じた場合は、
`lisp_save_control`で保存した情報は無視して、
最新の脱出処理を優先させます。

無事`cleanup`処理が完了したら、下記の関数で復元します。

```c
void lisp_rollback_control(addr value);
```

最後に`lisp_pop_control_`を実行して保存情報を破棄します。

実行例を示します。  
下記の例では、返却値の保存と復元がされたことを示しています。

```c
int main_lisp(void *ignore)
{
    addr control, save, x;

    lisp_push_control(&control);
    x = Lisp_hold();
    /* 100 */
    lisp_fixnum(x, 100);
    lisp_set_result_control(x);
    /* save */
    lisp_save_control(&save);
    lisp_reset_control();
    /* 200 */
    lisp_fixnum(x, 200);
    lisp_set_result_control(x);
    /* rollback */
    lisp_rollback_control(save);
    lisp_result_control(x);
    lisp_format8_(NULL, "RESULT: ~A~%", x, NULL);
    return lisp_pop_control_(control);
}
```

実行結果は`RESULT: 100`です。
