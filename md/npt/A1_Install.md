% インストール方法

% インストール方法

nptのドキュメントです。  
参照元：[ANSI Common Lisp npt](index.html)  
次へ：[コンパイルの詳細](A2_Compilation.html)


# 1.1 インストール方法

インストールは、ソースをCコンパイラでコンパイルして行います。  
コンパイル方法は、スクリプトによるものと`autoconf`を用いるもの、
それらを使わずに手動で行うものがあります。

手動でコンパイルする方法については別途ページを用意しますので、
もし本ページの方法がうまく行かない場合はそちらをご覧ください
（[コンパイルの詳細](A2_Compilation.html)）。

まずはgithubからソースをダウンロードします。

```
$ git clone https://github.com/nptcl/npt.git
$ cd npt
```

# 1.2 スクリプトによるコンパイル

FreeBSDとLinuxのコンパイルスクリプトを用意しました。

FreeBSDでコンパイルするには次のように実行します。

```
$ ./freebsd_release.sh
```

Linuxでコンパイルするには、
`gcc`と`gmake`をあらかじめインストールしておいてください。  
コンパイルは次のように実行します。

```
$ ./linux_release.sh
```

どちらの場合も、成功すれば`npt`という実行ファイルが作成されます。


# 1.3 バッチファイルによるコンパイル

Windowsでコンパイルするためのバッチファイルを用意しています。

Visual Studio 2017で動作確認しています。  
下記のコマンドが使用できる環境でコンパイルできます。

- CL.EXE
- LINK.EXE
- NMAKE.EXE

コンパイルは下記のコマンドを実行してください。

- `windows_release.bat`

成功した場合は、`npt.exe`という実行ファイルが生成されます。

環境によってはうまく動作しないかもしれません。  
失敗する場合は、[コンパイルの詳細](A2_Compilation.html)を確認し、
手動でコンパイルを行ってください。


# 1.4 `autoconf`によるコンパイル

`autoconf`によるコンパイルを行うには、
`bootstrap.sh`を実行して`configure`を生成します。

```
$ ./bootstrap.sh
```

正常に終了したら`configure`を実行します。

```
$ ./configure
```

もしインストール先を指定したい場合は`prefix`を指定します。

```
$ ./configure --prefix=/usr/local
```

コンパイルを行います。

```
$ make
$ make install
```

`make`が成功した段階で、`npt`という実行ファイルが生成されます。  
`make install`により、`prefix`へ`npt`という実行ファイルがコピーされます。


# 1.5 実行ファイルのインストール

スクリプトによるコンパイルを行った場合は、
`npt`という実行ファイルを好きな場所にコピーしてインストール完了です。  
例えば次の通り。

```
$ ./freebsd_release.sh
...
$ cp -i npt /usr/local/bin/.
```

`configure`では、`make install`を行うことで、
`prefix`で指定した場所に`npt`がコピーされます。

インストールによりコピーされるファイルは、
実行ファイルの`npt`一つだけです。  
よってアンインストールをしたい場合は、
`npt`を削除するだけになります。


# 1.6 実行例

起動すると、プロンプトが`*`に変わります。

```
$ npt
*
```

Lispの式を入力すると返答が出力されます。

```
* (+ 10 20 30)
60
*
```

終了する場合は、Ctrl+Dか、あるいは`(exit)`を実行します。

```
* (exit)
$
```

ファイルを読み込む場合は、引数に`--load`か`--script`を使います。

```
$ cat > aaa.lisp
(format t "Hello~%")
^D
$ npt --script aaa.lisp
Hello
$ npt --load aaa.lisp
Hello
* (quit)
$
```

詳細は`--help`を確認ください。

```
$ npt --help
```
