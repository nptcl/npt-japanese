% npt amalgamation

nptのドキュメントです。  
参照元：[ANSI Common Lisp npt](index.html)  
前へ：[nptコマンドの引数](A3_Arguments.html)  
次へ：[npt特有の機能](A5_Features.html)


# 4.1 npt amalgamation

npt amalgamationとは、nptのソースを数個にまとめたものです。  
現在、nptのソースファイルは800個を超えていますが、
npt amalgamationをはそれらのソースを下記の3つにまとめてしまいます。

- `lisp.c`
- `lisp.h`
- `shell.c`

単純に結合しただけなので、
通常のnptとamalgamationでは機能の差はありません。

もともとは[sqlite](https://www.sqlite.org/)の
[amalgamation](https://www.sqlite.org/amalgamation.html)を
真似して作成しました。  
ソースファイルをまとめる目的は色々あると思いますが、
ファイルの数が少なくなるので扱いやすくなります。

上記の方法には欠点があり、`lisp.c`というファイルがあまりに大きいため、
例えばgdbなどC言語のデバッガーがソースを読み込むと
非常に時間がかかってしまいます。  
sqliteのページによると、ソースファイルが大きすぎる場合は
読み込めないソフトウェアもあるようです。

そこでソースを結合したあとに数個に分割するモードも用意しました。  
ソースの容量に依存しますが、現時点では12個のファイルにまとめることができます。

npt-amalgamationは専用のgithubで配布しています。

https://github.com/nptcl/npt-amalgamation  

ただし上記のページは
最新のソースが反映されているとは限りません。  
そこで下記の手順によりgithub/nptのソースから
amalgamationを作成する方法を説明します。


# 4.2 作成方法

まずはgithub/nptのディレクトリに移動します。

```
$ cd github/npt
```

amalgamationのディレクトリに移動します。

```
$ cd develop/amalgamation
```

ファイルを作成するプログラムを実行します。

```
$ npt --script amalgamation-single.lisp
Name: npt
Output: lisp.c
Output: lisp.h
Output: shell.c
```

この`lisp`ファイルはCommon Lisp処理系ならどれでも実行できると思います。  
nptコマンドが存在しない場合は、別の処理系でも実行可能です。  
例を示します。

```
$ sbcl --script amalgamation-single.lisp
$ ccl -l amalgamation-single.lisp
$ clisp amalgamation-single.lisp
```

生成された3つのファイルだけでnptを構築できます。  
コンパイルは通常の場合と同じです。  
例として、FreeBSD対応のコンパイルを行います。

```
$ cc -o npt -DLISP_FREEBSD lisp.c shell.c -lm
$ ./npt --version-script | grep amalgamation
amalgamation    true
$
```

続いて複数の分割する例を示します。  
以前の操作とは別になりますので、続けて作業しないよう注意してください。

```
$ npt --script amalgamation-header.lisp
Name: npt
Output: lisp_file.h
Output: lisp_file_01.c
Output: lisp_file_02.c
Output: lisp_file_03.c
Output: lisp_file_04.c
Output: lisp_file_05.c
Output: lisp_file_06.c
Output: lisp_file_07.c
Output: lisp_file_08.c
Output: lisp_file_09.c
Output: lisp.h
Output: shell.c
```

コンパイルは下記の通り。

```
$ cc -o npt -DLISP_FREEBSD lisp_file_*.c shell.c -lm
$ ./npt --version-script | grep amalgamation
amalgamation    true
$
```

`lisp_file.h`はnptのソースをコンパイルするときに使用するものです。  
一方、`lisp.h`はnptの開発を行う時に必要となるファイルであり、
nptのコンパイル時には不要です。
