% 関数仕様 - エラー

nptのドキュメントです。  
参照元：[ANSI Common Lisp npt](index.html)


# 関数仕様

`lisp.h`に記載されている下記の関数仕様を示します。

```c
■abort
void lisp_abort(void);
void lisp_abortf(const char *fmt, ...);
void lisp_abort8(const void *fmt, ...);
void lisp_abort16(const void *fmt, ...);
void lisp_abort32(const void *fmt, ...);
lisp_abort_calltype lisp_set_abort_handler(lisp_abort_calltype call);
lisp_abort_calltype lisp_set_abort_setjmp_handler(void);
Lisp_abort_Begin
Lisp_abort_End
Lisp_abort_throw

■signal
int lisp_signal_(addr condition);
int lisp_error_(addr condition);

■error
int lisp_error8_(const void *str, ...);
int lisp_error16_(const void *str, ...);
int lisp_error32_(const void *str, ...);

■warn
int lisp_warn8_(const void *str, ...);
int lisp_warn16_(const void *str, ...);
int lisp_warn32_(const void *str, ...);
```


# ■abort

LISP ABORTの関数です。

```c
void lisp_abort(void);
void lisp_abortf(const char *fmt, ...);
void lisp_abort8(const void *fmt, ...);
void lisp_abort16(const void *fmt, ...);
void lisp_abort32(const void *fmt, ...);
lisp_abort_calltype lisp_set_abort_handler(lisp_abort_calltype call);
lisp_abort_calltype lisp_set_abort_setjmp_handler(void);
Lisp_abort_Begin
Lisp_abort_End
Lisp_abort_throw
```


## 関数`lisp_abort`

```c
void lisp_abort(void);
```

LISP ABORTを実行します。  
LISP ABORT実行時には下記の挙動を行います。

- ハンドラーの実行
- `LISP ABORT`という文言の出力
- `exit(1)`の実行（プロセス終了）


## 関数`lisp_abortf`

```c
void lisp_abortf(const char *fmt, ...);

入力: fmt `printf`書式
```

標準エラーにメッセージを出力してからLISP ABORTします。  
Lispは使用しませんので、いつでも実行できます。


## 関数`lisp_abort8`

```c
void lisp_abort8(const void *fmt, ...);
void lisp_abort16(const void *fmt, ...);
void lisp_abort32(const void *fmt, ...);

入力: fmt Unicode文字列
```

`lisp_format_`関数を用いて
`error-output`にエラーメッセージを出力したあと、
LISP ABORTします。  
Lispで処理を行いますので、Common Lispが実行可能状態である必要があります。  
Unicode文字列の詳細は`lisp_string8_`関数をご確認ください。


## 関数`lisp_abort16`

`lisp_abort8`で解説


## 関数`lisp_abort32`

`lisp_abort8`で解説


## 関数`lisp_set_abort_handler`

```c
lisp_abort_calltype lisp_set_abort_handler(lisp_abort_calltype call);

入力: call ハンドラー void (*)(void)型
戻り値: 設定前のハンドラー
```

LISP ABORT実行時に呼び出されるハンドラーを指定します。  
もし引数がNULLの場合は、ハンドラーを削除します。


## 関数`lisp_set_abort_setjmp_handler`

```c
lisp_abort_calltype lisp_set_abort_setjmp_handler(void);

戻り値: 設定前のハンドラー
```

`setjmp`用のハンドラーを設定します。


## マクロ`Lisp_abort_Begin`

```c
#define Lisp_abort_Begin ...
#define Lisp_abort_End ...
#define Lisp_abort_throw() ...
```

LISP ABORTの捕捉を行います。  
この仕組みを使用するためには、`lisp_set_abort_setjmp_handler`を実行して
`setjmp`用のハンドラーを設定する必要があります。

捕捉は`Lisp_abort_Begin`と`Lisp_abort_End`を使い、
次のようにしてコードを囲みます。

```c
Lisp_abort_Begin {
    /* code */
}
Lisp_abort_End;
```

もし`Lisp_abort_throw()`が実行された場合は、
`longjmp`により`Lisp_abort_End`まで制御がジャンプします。

`lisp_set_abort_setjmp_handler`が登録するハンドラーは、
単純に`Lisp_abort_throw()`が実行されるだけのコードであり、
例えば下記のような関数になります。

```c
void abort_setjmp_handler(void)
{
    Lisp_abort_throw();
}
```

通常であればマクロは`setjmp`/`longjmp`に展開されますが、
C++コンパイラでかつ`LISP_ABORT_SETJMP`がdefineされていない場合は
`try`/`catch`に展開されます。

典型的な使用例を下記に示します。

```c
int main(void)
{
    int finish;
    lisp_abort_calltype handler;

    handler = lisp_set_abort_setjmp_handler();
    finish = 0;
    Lisp_abort_Begin {
        lisp_abort();
        finish = 1;
    }
    Lisp_abort_End;
    lisp_set_abort_handler(handler);

    if (finish == 0)
        printf("LISP ABORT\n");

    return 0;
}
```


## マクロ`Lisp_abort_End`

`Lisp_abort_Begin`で解説


## マクロ`Lisp_abort_throw`

`Lisp_abort_Begin`で解説


# ■signal

コンディションを発生させる関数です。

```c
int lisp_signal_(addr condition);
int lisp_error_(addr condition);
```


## 脱出関数`lisp_signal_`

```c
int lisp_signal_(addr condition);

入力: condition インスタンス
戻り値: 脱出時は0以外
```

引数`condition`を`signal`に渡します。  
Common Lispの`signal`と同じです。  
`condition`がhold変数の場合は、内容が使用されます。


## 脱出関数`lisp_error_`

```c
int lisp_error_(addr condition);

入力: condition インスタンス
戻り値: 0以外
```

引数`condition`を`error`に渡します。  
Common Lispの`error`と同じです。  
`condition`がhold変数の場合は、内容が使用されます。


# ■error

エラーの関数です。

```c
int lisp_error8_(const void *str, ...);
int lisp_error16_(const void *str, ...);
int lisp_error32_(const void *str, ...);
```


## 脱出関数`lisp_error8_`

```c
int lisp_error8_(const void *str, ...);
int lisp_error16_(const void *str, ...);
int lisp_error32_(const void *str, ...);

入力: str Unicode文字列
戻り値: 0以外
```

引数`simple-error` conditionを起こします。  
Common Lispの`error`と同じです。  
Unicode文字列の詳細は`lisp_string8_`関数をご確認ください。


## 脱出関数`lisp_error16_`

`lisp_error8_`で解説


## 脱出関数`lisp_error32_`

`lisp_error8_`で解説


## ■warn

警告の関数です。

```c
int lisp_warn8_(const void *str, ...);
int lisp_warn16_(const void *str, ...);
int lisp_warn32_(const void *str, ...);
```


## 脱出関数`lisp_warn8_`

```c
int lisp_warn8_(const void *str, ...);
int lisp_warn16_(const void *str, ...);
int lisp_warn32_(const void *str, ...);

入力: str Unicode文字列
戻り値: 脱出時は0以外
```

引数`simple-warning` conditionを起こします。  
Common Lispの`warn`と同じです。  
Unicode文字列の詳細は`lisp_string8_`関数をご確認ください。


## 脱出関数`lisp_warn16_`

`lisp_warn8_`で解説


## 脱出関数`lisp_warn32_`

`lisp_warn8_`で解説

