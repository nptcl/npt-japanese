% nptコマンドの引数

nptのドキュメントです。  
参照元：[https://nptcl.hatenablog.com/entry/2020/08/21/214057:title]  
前へ：[https://nptcl.hatenablog.com/entry/2020/08/22/003812:title]  
次へ：[https://nptcl.hatenablog.com/entry/2020/08/23/184033:title]


nptコマンドの引数を説明します。  

# 3.1 引数
## --help

次のようなメッセージを表示します。

```
$ npt --help
npt -- ANSI Common Lisp Programming Language.

USAGE:
  npt [options] [inputs] [--] [arguments]

OPTIONS:
  --help             Print this message.
  --version          Print the version infomation.
  --core             Core mode.
  --standalone       Standalone mode.
  --heap <size>      Heap memory size.
  --local <size>     Local memory size.
  --corefile <file>  Core file instead of default file used.
  --initfile <file>  Init file instead of default file used.
  --nocore           Don't load a default core file.
  --noinit           Don't load a default init file.
  --debugger         Enable debugger.
  --nodebugger       Disable debugger.
  --quit             Exit after load and eval processing.

INPUTS:
  --load <file>      Load source file.
  --script <file>    Load script file.
  --eval <cmd>       Execute command.

If inputs aren't appeared, load from a standard-input.
```


## --version

nptのコンパイル情報を出力します。  
スクリプトなど機械的に読みやすいように整形された
引数`--version-script`も存在します。  
出力内容はほぼ変わりませんが、
スクリプト版の方が若干情報が増えます。


## --core

コアファイル読み込みモードです。  
`--standalone`と同時に指定できません。

コアファイルの位置は引数`--corefile`で指定できます。  
もし指定されなかった場合は、
標準のコアファイルを下記の順番で探します。

```
FreeBSD / Linux
	$NPT_HOME/npt.core
	$NPT_HOME/lib/npt.core
	$HOME/.npt/npt.core
	/usr/lib/npt/npt.core
	/usr/local/lib/npt/npt.core
	/opt/npt/npt.core
	/opt/lib/npt/not/npt.core

Windows
	%NPT_HOME%\npt.core
	%NPT_HOME%\lib\npt.core
	%USERPROFILE%\npt.core
	%ProgramData%\npt\npt.core
	%PROGRAMFILES%\npt\npt.core
	%ProgramFiles(x86)%\npt\npt.core
```

引数`--nocore`が指定された場合は、標準のコアファイルは読み込みません。
もしコアファイルが見つからなかった場合はエラーです。


## --standalone

Lispのイメージを作成するモードです。  
本引数が指定された場合は、
コアファイルを読み込まずにCommon Lispのイメージを最初から作成します。  
`--core`と同時に指定できません。

本モードは標準で指定されているため、引数`--standalone`は省略可能です。  
nptのコンパイルによっては、デフォルトが`--standalone`ではない場合が存在するため、
本引数はそのような特殊なコマンドのために用意されました。


## --heap `<size>`

heap領域のサイズを指定します。  
`<size>`は10進数の数値を指定します。

単位K, M, G, T, P, Eを付与することができます。  
例えば1GByteを指定したい場合は、

```
--heap 1G
```

となります。  
省略時は1Gです。


## --local `<size>`

local領域のサイズを指定します。  
`<size>`は`--heap`と同様、10進数の数値を指定し、単位を含めることができます。  
省略時は512Mです。


## --initfile `<file>`

起動時に初期化ファイルとして読み込まれるLispファイルを指定します。  
引数`--load`と同じような動作をしますが、
本引数は初期化を行うという目的でファイルを読み込みます。

もし`--initfile`が指定されていない場合は、
標準の初期化ファイルを下記の順番で探します。

```
FreeBSD / Linux
	$HOME/.npt/npt.lisp
	$NPT_HOME/npt.lisp
	$NPT_HOME/lib/npt.lisp
	/usr/lib/npt/npt.lisp
	/usr/local/lib/npt/npt.lisp
	/opt/npt/npt.lisp
	/opt/lib/npt/not/npt.lisp

Windows
	%USERPROFILE%\npt.lisp
	%NPT_HOME%\npt.lisp
	%NPT_HOME%\lib\npt.lisp
	%ProgramData%\npt\npt.lisp
	%PROGRAMFILES%\npt\npt.lisp
	%ProgramFiles(x86)%\npt\npt.lisp
```

引数`--noinit`が指定された場合は、標準の初期化ファイルは読み込みません。
もし初期化ファイルが見つからなかった場合は、
読み込みを行わずに次の処理へ移行します。


## --debugger / --nodebugger

デバッガーを有効/無効にします。  
有効の場合は、エラーが生じたときにデバッガーが起動されます。  
無効の場合は、エラーが生じたときにabortしてプログラムが異常終了します。

デバッガーの有効/無効は、`lisp-system::*enable-debugger*`に
`boolean`値として設定されます。


## --quit

本引数は、引数のINPUTSが処理されたあとに
終了するかあるいは`eval-loop`に移行するかを決定します。

もし`--quit`が指定された場合は終了します。  
指定されなかった場合は`eval-loop`に移行し入力待ちになります。


## INPUTS

INPUTSは次の3つの引数から成り立ちます。

- `--eval <cmd>`
- `--load <file>`
- `--script <file>`

これらの引数は何度も記載することができます。


## --eval `<cmd>`

引数`--eval`を用いることで、引数の文を実行できます。  
例を示します。

```
$ npt --eval '(format t "Hello~%")'
Hello
*
```

`--eval`の文が実行されたあとは入力待ち状態となります。  
もしeval実行後に即終了させたい場合は、引数`--quit`を指定します。

```
$ npt --quit --eval '(format t "Hello~%")'
Hello
$
```


## --load / --script

Lispファイルを読み込む場合は、
`--load`と`--script`の二つの方法があります。

`--load`はファイルを読み込んだあと、入力待ちに遷移します。  
`--script`はファイルを読み込んだあと、すぐに終了します。

`--script`は、`--quit`と`--load`を組み合わせたものに似ていますが、
それだけではなく、`--script`はLispのデバッガーを使用不可にするため、
もしエラーが生じても入力待ちにはならずに即終了する点が違っています。

`--script`は名前の通りスクリプトで実行することを前提としていますので、
エラーが生じたときに可能な限り停止しないようになります。  
`--script`は、`--nodebugger`と`--quit`を同時に指定したことになります。

実行例を示します。

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


# 3.2 引数`--`

引数`--`が指定された場合は、
それ以降の引数がnptのプログラムへ渡される引数と認識されます。

引数は`npt-system::*arguments*`に配列として格納されます。  
例を示します。

```
$ npt -- 10 20 30
* npt-system::*arguments*
#("npt" "10" "20" "30")
*
```


# 3.3 開発用の引数

引数`--build`は`--standalone`と同じです。

引数`--degrade`だけが指定された場合はテストケースを実行します。  
`--core`と`--standalone`とは同時に指定できません。

引数`--version-script`は、引数`--version`の内容を
スクリプトで読み込みやすいようにタブで整形したものを出力します。
