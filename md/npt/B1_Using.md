% nptをC言語で使用する

% nptをC言語で使用する

nptのドキュメントです。  
参照元：[ANSI Common Lisp npt](index.html)  
次へ：[hold変数の使い方](B2_Hold.html)


# 1.1 はじめに

nptはC言語に組み込むことを目的として開発しています。  
本章の目的は、nptをモジュールという位置づけにして
どのように開発していくのかを示し、
簡単なサンプルを作成して実行することです。

★注意：nptのモジュール用関数はまだ開発中なので変更される可能性があります。


# 1.2 amalgamationを作成する

開発で必ず必要になるのがamalgamationのソースです
（npt amalgamationの詳細はこちら
[npt amalgamation](A4_Amalgamation.html)）。  
特にヘッダーファイルである`lisp.h`が必要となります。

まずはnptのソースからamalgamationを作成する手順を説明します。

```
$ cd github/npt
$ cd develop/amalgamation/
$ npt --script amalgamation-single.lisp
```

`amalgamation-single.lisp`はCommon Lispであればなんでも動作します。  
nptコマンドがない時は代わりに下記のどれかを実行してください。

```
$ sbcl --script amalgamation-single.lisp
$ ccl -l amalgamation-single.lisp
$ clisp amalgamation-single.lisp
```

作成されるファイルは下記のとおりです。

- `lisp.c`
- `lisp.h`
- `shell.c`

amalgamationのページでは`amalgamation-header.lisp`の使い方も説明していますが、
どちらを用いても構いません。  
`lisp.h`は同じものが生成されます。


# 1.3 nptのソースを組み込む方法を選ぶ

大きく3つ存在します。

1. amalgamationを利用する
2. nptのソースをそのまま利用する
3. `lisp.a`ファイルを作成する

どの方法でも、amalgamationが生成したヘッダーファイル`lisp.h`は必要となります。

1つ目のamalgamationを利用するというのは、
`amalgamation-single.lisp`が生成したファイル`lisp.c`を利用する方法です。  
この方法が楽なのですが、`lisp.c`ファイルが大きすぎるため
C言語のデバッガーが起動すると動作が非常に遅くなるという欠点があります。  
もしファイル容量が気になるのであれば、
`amalgamation-header.lisp`を用いることもできます。  
ファイル数は多少増えるものの個々のファイルの容量を
抑えることができるため、使いやすい方法になります。

2つ目のnptのソースをそのまま利用するというのは、
その名の通り、`src/*.c`ファイル一式をコピーするというものです。  
nptの`main.c`さえコンパイルしなければ実現できます。  
欠点は、nptがバージョンアップしたときに、
nptのソースを更新する必要があるということです。  
nptのファイルが増えるだけなら良いのですが、
減ることもあるため、管理が複雑になります。

3つ目の`lisp.a`ファイルというのは、
nptのオブジェクトファイルである`*.o`を開発用にまとめたものです。  
この方法は便利なので説明するときに利用します。

以上3つの方法について、簡単にコンパイルする手順を説明します。


# 1.4 コンパイルに用いる例文

今回実行する例文は下記の通りです。

```c
int main_lisp(void *ignore)
{
    lisp_format8_(NULL, "Hello~%", NULL);
    return 0;
}
```

この文は、Common Lispで表すと下記の文と同じです。

```lisp
(format t "Hello~%")
```

実際にコンパイルするにはこれだけではなく、
nptを初期化するコードも記載しなければなりません。  
下記に完全なコードを示しますので、
`main.c`という名前で保存してください。

```c
/* main.c */
#include <stdio.h>
#include "lisp.h"

int main_lisp(void *ignore)
{
    lisp_format8_(NULL, "Hello~%", NULL);
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


# 1.5 amalgamationを利用する

まずはamalgamation-singleだけを利用する方法を説明します。  
作成した`main.c`と同じディレクトリに
amalgamationが出力した下記のファイルを配置してください。

- `lisp.c`
- `lisp.h`

`shell.c`は不要です。

次にコンパイルを行います。  
コンパイルの方法は環境によって変わりますので、
[コンパイルの詳細](A2_Compilation.html)のページを参考にしてください。  
例文ではFreeBSDで実行する手順を示します。

```
$ cc lisp.c main.c -lm
$ ./a.out
Hello
$
```

amalgamation-headerを利用する方法を説明します。  
コンパイルの方法はsingleの場合とほぼ同じですが、
ソースファイルが1つだけではないので、
`lisp_file_*.c`のように一括指定します。

```
$ cc lisp_file_*.c main.c -lm
$ ./a.out
Hello
$
```


# 1.6 nptのソースをそのまま利用する

作業用のディレクトリを作成してください。

```
$ mkdir $HOME/libnpt1
```

`main.c`と`lisp.h`をコピーします。

```
$ cp -i main.c lisp.h $HOME/libnpt1/
```

次に、githubのnptのソースをコピーします。  
まずはnptのディレクトリに移動します。

```
$ cd github/npt
```

ソースをコピーします。

```
$ cp -i src/*.[ch] $HOME/libnpt1/
overwrite .../main.c? (y/n [n]) n  ★nを入力して上書きしない
not overwritten
$
```

コンパイルを行います。

```
$ cd $HOME/libnpt1
$ cc *.c -lm
$ ./a.out
Hello
$
```


# 1.7 `lisp.a`ファイルを作成する

作業用ディレクトリを作成してください。

```
$ mkdir $HOME/libnpt2
```

`main.c`と`lisp.h`をコピーします。

```
$ cp -i main.c lisp.h $HOME/libnpt2/
```

githubのnpt上で、`lisp.a`ファイルを作成します。  
まずは移動します。

```
$ cd github/npt
```

コンパイルをしてオブジェクトファイルを生成します。  
例えば`freebsd_debug.sh`などスクリプトを実行しても良いのですが、
その際はコンパイルオプションを覚えておくようにしてください。  
今回は手動でコンパイルします。

```
$ cc -c src/*.c
```

`lisp.a`ファイルを作成します。

```
$ ar -rc lisp.a *.o
$ ar -d lisp.a main.o
```

`lisp.a`が生成されましたのでコピーします。

```
$ cp -i lisp.a $HOME/libnpt2/
```

コンパイルします。

```
$ cd $HOME/libnpt2/
$ cc main.c lisp.a -lm
$ ./a.out
Hello
$
```


# 1.8 `main_lisp`の説明

今回の例文では`format`を実行するだけなので単純でしたが、
本来はCommon Lispと同等の文をC言語で表す必要があるため、
開発は非常に複雑でわかりづらいものとなります。

次章で詳しく見て行きます。

