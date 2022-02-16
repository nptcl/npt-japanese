% スタートアップ

% スタートアップ

nptのドキュメントです。  
参照元：[ANSI Common Lisp npt](index.html)  
前へ：[脱出の操作](B6_Operations.html)  
次へ：[Paperオブジェクト](B8_Paper.html)


# 7.1 スタートアップ

本章ではC言語にて、nptをどのようにして開始するかを説明します。

C言語では`main`関数から実行されますが、Windowsの場合は`WinMain`関数ですので、
両者でどのようにnptを初期化するのかを説明します。


# 7.2 開始と終了

nptを開始するには、まずは次の関数を実行します。

```c
void lisp_init(void);
```

この関数は、npt内のC言語で使用される静的変数を初期化し、
使用準備ができたことを宣言します。  
対応する解放処理は下記の関数になります。

```c
void lisp_free(void);
```

初期化処理を実行したあとは、関数ポインタの登録を実行することができます。  
関数ポインタの登録とは、例えば下記の関数を用いた処理のことです。

```c
void lisp_compiled_rest(int index, lisp_calltype_rest call);
```

関数ポインタの値は一度実行してしまえば`lisp_free`で解放するまで持続します。


# 7.3 コマンド引数の読み込み

コマンド引数とは、`main`関数の`argc`, `argv`, `env`のことです。  
読み込みに使用する関数は下記のとおりです。

```c
struct lispargv *lispargv_main(int argc, char *argv[], char *env[]);
```

エラー時にはNULLが返却されます。  
動的にメモリが確保されますので、終了時には下記の解放処理が必要です。

```c
void lispargv_free(struct lispargv *ptr);
```

実行例を下記に示します。

```c
int main(int argc, char *argv[], char *env[])
{
    struct lispargv *args;

    lisp_init();
    args = lispargv_main(argc, argv, env);
    if (args == NULL) {
        fprintf(stderr, "argv error\n");
        return 1;
    }

    /* ここにnptの処理を記載する */

    /* free */
    lispargv_free(args);
    lisp_free();

    return 0;
}
```

`lispargv_main`関数は、Windows環境で実行すると`argc`, `argv`, `env`は全て無視され、
代わりに下記の関数を強制的に実行します。

```c
struct lispargv *lispargv_windows(void);
```

この関数は`lispargv_main`と同等ですが、
引数と環境変数の情報をWIN32APIから取得します。  
もし`WinMain`関数から起動する場合は、
`argc`のような引数は存在しないため、上記の関数を使用するしかないはずです。  
しかしWindows環境でも`main`関数を使用することはできます。  
そのような場合でも、文字コードを正しく処理するために、
強制的に`lispargv_windows`が使用されます。  
もし`lispargv_windows`ではなく、
`main`関数の引数から実行したい場合は
下記の関数を使用してください。

```c
struct lispargv *lispargv_main_force(int argc, char *argv[], char *env[]);
```

この関数は、Windows環境であっても強制的に引数を読み込みます。

もし、`argc`, `argv`, `env`が存在しないか、
あるいは指定したくない場合は下記のように実行をして下さい。

```c
args = lispargv_main_force(0, NULL, NULL);
```


# 7.4 nptの設定

nptをC言語に組み込んで使用する場合には、
引数で変更されては困るものも存在します。  
今回は次のように実行して、
`standalone`モードでの実行を強制することにします。

```c
args->mode_core = 0;
args->mode_degrade = 0;
args->mode_standalone = 1;
args->nocore = 1;
args->noinit = 1;
args->debugger = 1;
args->debuggerp = 0;
args->quit = 1;
```

もしメモリの大きさを変更したい場合は次のようにします。

```c
args->heap = 1024UL * 1024UL*1024UL;  /* 1G */
args->local = 256UL * 1024UL*1024UL;  /* 256M */
```

`heap`は、heap領域の大きさです。  
`local`は、stack領域の大きさです。  
どちらもnptが実行される初期段階で`malloc`により確保されます。

以上のことをまとめると、代表的な`main`関数は下記のようになります。

```c
int main(int argc, char *argv[], char *env[])
{
    int result;
    struct lispargv *args;

    /* initialize */
    lisp_init();
    args = lispargv_main(argc, argv, env);
    if (args == NULL) {
        fprintf(stderr, "argv error\n");
        return 1;
    }

    /* main_argv */
    args->mode_core = 0;
    args->mode_degrade = 0;
    args->mode_standalone = 1;
    args->nocore = 1;
    args->noinit = 1;
    args->debugger = 1;
    args->debuggerp = 0;
    args->quit = 1;
    result = main_argv(args);

    /* free */
    lispargv_free(args);
    lisp_free();

    return result;
}
```

以降は`main_argv`関数を作成していきます。


# 7.5 ヘルプの表示

もし引数に`--help`などが指定されていた場合は、
この段階で情報の表示を行い、実行を終了させます。

```c
static int main_argv(struct lispargv *args)
{
    if (args->mode_help)
        return lisp_main_help(stdout);
    if (args->mode_version)
        return lisp_main_version(args, stdout);
    if (args->mode_degrade)
        return lisp_main_degrade(args);
 
   /* 途中 */

    return 0
}
```

これで下記の引数に対応できました。

- `--help`
- `--version`
- `--version-script`
- `--degrade`


# 7.6 `main_lisp`の実行

次に行うことは、npt環境の整備です。  
下記の命令にて実行します。

```c
int lisp_argv_init(struct lispargv *ptr);
int lisp_argv_run(struct lispargv *ptr);
```

`lisp_argv_init`関数で準備し、`lisp_argv_run`でLispを実行します。  
これまでの例文のように、`main_lisp`関数を実行するには、
`args->call`を変更することで実現できます。

実行例を下記に示します。

```c
 int main_lisp(void *call_ptr)
{
    return 0;
}

static int main_argv(struct lispargv *args)
{
    /* mode */
    if (args->mode_help)
        return lisp_main_help(stdout);
    if (args->mode_version)
        return lisp_main_version(args, stdout);
    if (args->mode_degrade)
        return lisp_main_degrade(args);

    /* execute */
    args->call = main_lisp;
    args->call_ptr = NULL;
    lisp_argv_init(args);
    lisp_argv_run(args);

    return lisp_code? 1: lisp_result;
}
```

本来であれば`lisp_argv_init`と`lisp_argv_run`の
戻り値をチェックする必要があるのですが、
もしエラーが生じていた場合は`lisp_code`の値が`1`になり、
さらに`lisp_argv_run`関数が必ず失敗するのでチェックは無視します。

`args->call`に登録した`main_lisp`関数は、
`args->call_ptr`を引数として呼び出されます。  
なぜ関数ポインタで登録する必要があるかというと、
Common Lispとして正しく動作するさせるためには
様々な設定をしてから実行する必要があるためです。  
一例をあげるなら、`warn`関数で使用する`handler-bind`の処理です。

`main_lisp`関数は脱出関数ですが、
普通の脱出関数とは少々違っており、
もし非脱出時に0以外の値が返却された場合は
異常終了とみなして後の処理を全て無視して、
終了コード`1`で終了します。


# 7.7 まとめ

以上の内容をまとめますと、
最初に[nptをC言語で使用する](B1_Using.html)で説明した
例文そのものになります。

下記に例文を示します。

```c
int main_lisp(void *call_ptr)
{
    return lisp_format8_(NULL, "Hello~%", NULL);
}

static int main_argv(struct lispargv *args)
{
    /* mode */
    if (args->mode_help)
        return lisp_main_help(stdout);
    if (args->mode_version)
        return lisp_main_version(args, stdout);
    if (args->mode_degrade)
        return lisp_main_degrade(args);

    /* execute */
    args->call = main_lisp;
    args->call_ptr = NULL;
    lisp_argv_init(args);
    lisp_argv_run(args);

    return lisp_code? 1: lisp_result;
}

int main(int argc, char *argv[], char *env[])
{
    int result;
    struct lispargv *args;

    /* initialize */
    lisp_init();
    args = lispargv_main(argc, argv, env);
    if (args == NULL) {
        fprintf(stderr, "argv error\n");
        return 1;
    }

    /* main_argv */
    args->mode_core = 0;
    args->mode_degrade = 0;
    args->mode_standalone = 1;
    args->nocore = 1;
    args->noinit = 1;
    args->debugger = 1;
    args->debuggerp = 0;
    args->quit = 1;
    result = main_argv(args);

    /* free */
    lispargv_free(args);
    lisp_free();

    return result;
}
```

実行結果は下記のとおりです。

```
Hello
```
