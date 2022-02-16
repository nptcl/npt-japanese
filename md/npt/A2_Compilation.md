% コンパイルの詳細

nptのドキュメントです。  
参照元：[ANSI Common Lisp npt](index.html)  
前へ：[インストール方法](A1_Install.html)  
次へ：[nptコマンドの引数](A3_Arguments.html)


# 2.1 手動でコンパイル

コンパイルをするには、`src`ディレクトリにある
全ての`c`ファイルをコンパイルすることで実現できます。  
簡単な例をあげます。

```
$ cc src/*.c -lm
$ ./a.out --version
npt Version 1.0.2
...
Lisp mode            ANSI-C
...
```

ただし、この方法でコンパイルすると、`ANSI-C`モードという
機能を削減したモードでコンパイルされてしまいます。  
機能が削減されていますので、Common Lispの機能を全て使うことができません。

全ての機能を使用したい場合は、
コンパイルするときに環境の種類を指定しなければなりません。  
利用できる環境は下記のとおりです。

| 環境 | #define | ANSI Common Lispの機能 |
| --- | --- | --- |
| FreeBSD | LISP_FREEBSD | 全て使用可能 |
| Linux | LISP_LINUX | 全て使用可能 |
| Windows | LISP_WINDOWS | 全て使用可能 |
| ANSI-C | LISP_ANSIC (あるいは省略) | 制限あり |

例えば、FreeBSDを指定してコンパイルするときは次のように実行します。

```
$ cc -DLISP_FREEBSD src/*.c -lm
$ ./a.out --version
npt Version 1.0.2
...
Lisp mode            FreeBSD
...
```


# 2.2 デバッグ・リリース

通常のコンパイルでは、nptはリリースモードで行われます。  
もし`LISP_DEBUG`を指定した場合、デバッグモードとしてコンパイルを行います。

例をあげます。

```
$ cc -DLISP_DEBUG -DLISP_FREEBSD src/*.c -lm
$ ./a.out --version
npt Version 1.0.2
...
Release mode         debug
...
```

デバッグモードとリリースモードの違いはチェックの数です。  
デバッグモードではあらゆる場所にチェックのコードを配置しており、
もしチェックに違反していた場合は、プログラムが強制停止するようになっています。

一方、リリースモードではそのチェック自体が存在しないため、
デバッグモードに比べると実行が速くなります。

Lispとして使う分にはデバッグモードは必要ありませんが、
もしnptをC言語に組み込んで使用するのであれば、
少なくとも開発段階では`LISP_DEBUG`を指定した方が良いかと思います。


# 2.3 プロンプト

プロンプトとは、入力を受け取るときに使用するモジュールです。  
下記のモジュールを選択できます。

| モジュール | #define | リンク |
| --- | --- | --- |
| terme | LISP_TERME |  |
| editline | LISP_EDITLINE | -ledit |
| readline | LISP_READLINE | -lreadline |
| stdin | LISP_STDIN |  |

termeは、nptのプロンプトの機能です。  
FreeBSDとLinuxでは標準で使用されます。

editlineとreadlineは外部モジュールであり、
使用するには別途インストール作業が必要です。

stdinは、単純に標準入力から読み込みを行います。  
履歴やカーソルの移動が使えません。

コンパイルの例を示します。

```
$ cc -DLISP_FREEBSD -DLISP_EDITLINE src/*.c -lm -ledit
$ ./a.out --version
npt Version 1.0.2
...
Prompt mode          editline
...
```


# 2.4 localメモリの方式変更

localメモリとは、heap領域とは別のメモリ領域であるstackのことです。  
nptは起動時にheap領域のメモリを`malloc`にて一括で確保しますが、
localメモリをどのように確保するかを指定することができます。

通常はheapと同様、localメモリも`malloc`にて一括確保を行います。  
もしコンパイル時に`LISP_MEMORY_MALLOC`を指定した場合は、
localメモリの確保を要求するたびに`malloc`にて確保します。

一括確保の方が速度が速く、`LISP_MEMORY_MALLOC`は若干遅いようです。  
defineが指定された場合は
`npt`コマンドの`--version`に`Debug Memory true`が出現します。


# 2.5 ガベージコレクタ強制実行モード

ガベージコレクタとは、heap領域のメモリを掃除するための機能です。

nptでは、heap領域の使用量を監視しており、
もしメモリが圧迫されていると判断した場合は、
何らかのタイミングでガベージコレクタが実行されます。

もしコンパイル時に`LISP_DEBUG_FORCE_GC`が与えられた場合は、
ガベージコレクタ強制実行モードとなり、
実行できるタイミング全てでガベージコレクタが実行されるようになります。

本モードは動作が非常に遅くなります。  
このモードの存在意義は、C言語にて開発しているときに
メモリ破壊が生じないかを確認するためのものとなります。


# 2.6 Windows ANSI-Cモード

Windows環境でANSI-Cモードを使用すると、
ANSI C言語の機能だけではUnicodeのファイル名を扱えないという問題が生じます。

そこで、`LISP_ANSIC`の代わりになる、`LISP_ANSIC_WINDOWS`モードを用意しました。  
このモードは、ファイルのオープンに`fopen`ではなく`_wfopen`を使用するので、
Unicodeのファイル名を問題なく扱うことができるようになります。


# 2.7 Windowsのメイン関数

Windows環境でC言語を扱うときには、
スタートアップ関数をC言語標準の`main`にするのか、
あるいはWindows標準の`WinMain`にするのか選択できます。

nptでは、通常は`main`関数を使いますが、
defineによって変更することができます。

| 関数 | #define |
| --- | --- |
| `main` | LISP_CONSOLE (または省略) |
| `WinMain` | LISP_WINMAIN |

ただスタートアップ関数を切り替えるだけであり、機能としての違いありません。


# 2.8 C++でコンパイル

nptはC++でコンパイルできることを確認しています。  
コンパイルは次のようにして行います。

```
$ c++ -Wno-deprecated src/*.c
```

引数の`-Wno-deprecated`は、
C++コンパイラで`*.c`ファイルをコンパイルする際に出る
警告を抑止するためのものです。

確認は`*features*`で行うことができます。

```
$ ./a.out
*features*
(:LONG-FLOAT-80 :CPLUSPLUS :MATH-INACCURACY :NPT-64-BIT :NPT :64-BIT
 :ARCH-64-BIT :NPT-ANSI-C :ANSI-C :COMMON-LISP :ANSI-CL)
```

`*features*`の中に、`:CPLUSPLUS`が含まれているのがわかります。

CコンパイラとC++コンパイラで出力されるコードにほぼ違いはありませんが、
`setjmp`を使用しているコードが`try / catch`に変更される部分があります。


# 2.9 デグレードモード

デグレードモードとは、C言語でテストを行うモードです。
コンパイル時に`LISP_DEGRADE`を付与することで実施できますが、
ソースファイルが`src`だけではなく`test`にも含まれるようになるため、
単純にコンパイルすることができません。

通常このモードが必要になることはほぼないと思いますが、
実施したいのであれば`freebsd_debug.sh`など`debug`指定のものを
使用することを考えてください。


# 2.10 関数番号の最大値

関数番号とは、C言語の関数ポインタを登録するときの番号です。  
登録できる関数ポインタの数はデフォルトで32個ですが、
`LISP_POINTER_EXTEND`を指定することで変更することができます。

関数番号の個数を128個に変更する例を示します。

```
$ cc -DLISP_POINTER_EXTEND=128 src/*.c -lm
```

この例の場合、関数番号の範囲は0～127になります。

関数番号の使い方については
[関数の登録](B4_Registering.html)をご確認ください。
