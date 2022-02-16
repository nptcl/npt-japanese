% LISP ABORT

nptのドキュメントです。  
参照元：[ANSI Common Lisp npt](index.html)  
前へ：[関数の登録](B4_Registering.html)  
次へ：[脱出の操作](B6_Operations.html)


# 5.1 LISP ABORT

`LISP ABORT`とは、システムエラーによる強制終了のことです。  
C言語の`exit`関数を終了コード`1`で呼び出し、プロセスを終了させます。

もし手動でabortを起こしたい場合は、次の関数を実行します。

```c
lisp_abort();
```

実行結果は次のようになります。

```
$ ./a.out


**************
  LISP ABORT
**************
$ echo $?
1
$
```

実行例のように、`LISP ABORT`という文言が出力された場合は、
プロセスが強制終了されたことを意味します。  
確認している通り、そのときの終了コードは`1`です。

終了時にメッセージを出力したい場合は下記の関数を使用します。

```c
void lisp_abortf(const char *fmt, ...);
void lisp_abort8(const void *fmt, ...);
void lisp_abort16(const void *fmt, ...);
void lisp_abort32(const void *fmt, ...);
```

名前に8, 16, 32が付いている関数は、`lisp_string8_`関数でメッセージを作成します。  
`format`を経由するため、Common Lispが動作している必要があります。

`lisp_abortf`は、引数に`printf`の書式を受け取ります。  
`format`を経由しないため、Common Lispが動作している必要はありません。  
ただし`printf`の引数にLispのオブジェクトを指定することはできません
（できたとしても`%p`くらいだと思います）。  


# 5.2 ハンドラーの設定

`lisp_abort`の挙動はハンドラーを登録することで変更できます。  
例えば、下記のハンドラーを設定してみます。

```c
void test_handler(void)
{
	printf("Hello Handler.\n");
}
```

ハンドラーの登録は`lisp_set_abort_handler`関数にて行います。  
例えば次のようになります。

```c
lisp_set_abort_handler(test_handler);
lisp_abort();
```

実行結果を下記に示します。

```
$ ./a.out
Hello Handler.


**************
  LISP ABORT
**************
$
```

ハンドラーが起動されたあと、`LISP ABORT`が発生して
プロセスが強制終了したことが分かります。    
ハンドラーを登録したとしても、
そのまま終了した場合は`LISP ABORT`が実行されます。


# 5.3 `LISP ABORT`の捕捉

`LISP ABORT`は、`setjmp`を使うことでプロセスを終了させることなく
処理を継続させることができます。  
下記の命令を用いることで、捕捉と継続ができます。

- `lisp_set_abort_setjmp_handler`
- `Lisp_abort_Begin`
- `Lisp_abort_End`

`lisp_set_abort_setjmp_handler`は、補足用のハンドラーを設定します。  
`Lisp_abort_Begin`と`Lisp_abort_End`は、捕捉処理を囲むためのマクロです。

`LISP ABORT`を補足する例を下記に示します。

```c
int main(void)
{
    lisp_set_abort_setjmp_handler();
    Lisp_abort_Begin {
        printf("Start\n");
        lisp_abort();
        printf("End\n");
    }
    Lisp_abort_End;

    printf("Return\n");

    return 0;
}
```

実行結果は下記のとおりです。

```
$ ./a.out
Start
Return
$
```

実行結果では`Start`と`Return`が表示されており、
`End`が表示されていないのがわかります。  
`lisp_abort`関数によりabortがが発生して、
処理が`Lisp_abort_End`までジャンプしたためです。  
上記の方法だと、処理が普通に終わったものなのか、
あるいは`LISP ABORT`が発生したものなのか区別がつきません。  
そこで、次のように変更します。

```c
void main_call(void)
{
    printf("Start\n");
    lisp_abort();
    printf("End\n");
}

int main(void)
{
    int finish;

    lisp_set_abort_setjmp_handler();
    finish = 0;
    Lisp_abort_Begin {
        main_call();
        finish = 1;
    }
    Lisp_abort_End;

    if (finish == 0)
        printf("Lisp Abort\n");

    return 0;
}
```

変数`finish`を用意し、`Lisp_abort_Begin`の最後で
値が変更されていたら正常終了したとみなします。  
実行結果を下記に示します。

```
$ ./a.out
Start
Lisp Abort
$
```


# 5.4 C++での使用

`LISP ABORT`のハンドラーは`setjmp`が使われますが、
C++でコンパイルした場合は`try`/`catch`に変更されます。  
変更する理由は`setjmp`であればデストラクタが起動しないためです。  
例として下記の文をC++で実行してみます。

```cpp
class destruct
{
public:
    destruct() { printf("Constructor\n"); };
    ~destruct() { printf("Destructor\n"); };
};

void main_call(void)
{
    destruct x;

    printf("Start\n");
    lisp_abort();
    printf("End\n");
}

int main(void)
{
    int finish;

    lisp_set_abort_setjmp_handler();
    finish = 0;
    Lisp_abort_Begin {
        main_call();
        finish = 1;
    }
    Lisp_abort_End;

    if (finish == 0)
        printf("Lisp Abort\n");

    return 0;
}
```

実行例は下記のとおりです。

```
$ ./a.out
Constructor
Start
Destructor
Lisp Abort
$
```

この例では`setjmp`ではなく`try`/`catch`が使われているため、
デストラクタが起動しているのが確認できます。  
このような挙動を好ましく思わない場合は、
コンパイル時に`LISP_ABORT_SETJMP`をdefineすることで、
C++コンパイルでも`setjmp`を使用することができます。  
上記の例文を`setjmp`で実行した結果を下記に示します。

```
$ ./a.out
Constructor
Start
Lisp Abort
$
```

`lisp_abort`関数が実行されてると
そのまま`Lisp_abort_End`へと遷移しているため、
デストラクタが無視されているのがわかります。
