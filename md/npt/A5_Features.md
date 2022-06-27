% npt特有の機能

nptのドキュメントです。  
参照元：[ANSI Common Lisp npt](index.html)  
前へ：[npt amalgamation](A4_Amalgamation.html)  
次へ：[入力モジュール](A6_Input.html)

# 5.1 nptの機能

本章はnpt特有の機能について、代表的なものを紹介します。  
nptで使用するコマンドと変数は、`npt-system`パッケージに存在します。

下記の内容について説明します。

- [5.2 コマンド引数](#specific-2)
- [5.3 環境変数](#specific-3)
- [5.4 ガベージコレクタの実行](#specific-4)
- [5.5 コアファイルの保存](#specific-5)
- [5.6 プロセスの終了](#specific-6)
- [5.7 `ed`関数によるエディタ起動](#specific-7)
- [5.8 `require`関数の動作](#specific-8)
- [5.9 EastAsianWidthの操作](#specific-9)
- [5.10 `load-logical-pathname-translations`の読み込み](#specific-10)
- [5.11 `pathname`の使用](#specific-11)
- [5.12 `random-state`の初期値](#specific-12)
- [5.13 `load`関数の引数](#specific-13)

## <a id="specific-2">5.2 コマンド引数</a>

nptコマンドの引数は下記の変数に格納します。

```lisp
npt-system::*arguments*
```

値は配列であり、第一要素が`npt`のコマンド、
第二引数以降がコマンドの引数です。

例として下記のコマンドを実行したことを考えます。

```
$ npt -- 10 20 30
*
```

引数の`--`は、これ以降の引数がnptコマンドの引数になるという指定です。  
値は次のようになります。

```
* npt-system::*arguments*
#("npt" "10" "20" "30")
```


## <a id="specific-3">5.3 環境変数</a>

環境変数は下記の変数に格納しています。

```lisp
npt-system::*environment*
```

値はハッシュテーブルです。  
例えば、ホームディレクトリを表す`$HOME`を取得するには
次のように実行します。

```
$ npt
* (gethash "HOME" npt-system::*environment*)
"/home/username"
T
*
```


## <a id="specific-4">5.4 ガベージコレクタの実行</a>

下記のコマンドでガベージコレクタを起動します。

```lisp
(npt-system:gc)
```

ガベージコレクタはheap領域が圧迫されていれば自動的に実行されますが、
タイミングによっては判定が間に合わずにメモリ不足に陥る可能性があります。  
上記のコマンドを定期的に実行することで回避できるかもしれません。

もしメモリ不足が生じた場合は`LISP ABORT`します。

関数仕様を作成しました。  
[Lisp関数仕様 - システム関数](D1_System.html)


## <a id="specific-5">5.5 コアファイルの保存</a>

下記のコマンドでコアファイルを作成できます。

```lisp
(npt-system:savecore file)
```

本命令は`serious-condition`の`savecore`conditionを実行してnptを終了させます。  
正しく`savecore`conditionで終了したら、コアファイルの保存が始まります。

作成したコアファイルを読み込むためには、nptコマンドの`--core`引数を使用します。

関数仕様を作成しました。  
[Lisp関数仕様 - システム関数](D1_System.html)


## <a id="specific-6">5.6 プロセスの終了</a>

下記のコマンドでnptを終了します。

```lisp
(npt-system:exit code)
(npt-system:quit code)
```

上記2つは全く同じものです。  
nptのプロンプトで`(exit)`と`(quit)`を実行できるように、
標準で`common-lisp-user`パッケージに`import`されています。   

本命令は`serious-condition`の`exit`conditionを実行してnptを終了させます。  
正しく`exit`conditionで終了したら、引数の値を終了コードにしてプロセスを終了させます。

関数仕様を作成しました。  
[Lisp関数仕様 - システム関数](D1_System.html)


## <a id="specific-7">5.7 `ed`関数によるエディタ起動</a>

Common Lispの関数`ed`はエディタを起動します。  
この機能に対応しているのはFreeBSD, Linux, Windowsです。

起動するエディタは設定可能であり、
下記の順番でエディタのコマンド名を取得します。

1. `npt-system::*ed-program*`から文字列を取得
2. 環境変数`EDITOR`から文字列を取得
3. npt標準のエディタを起動

npt標準のエディタとは、
FreeBSD/Linuxなら`vi`、
Windowsなら`notepad.exe`、
それ以外なら`ed`です。


## <a id="specific-8">5.8 `require`関数の動作</a>

Common Lispの関数`require`は引数の名前からモジュールを読み込む機能です。  
nptでの実装はsbclのものとほぼ同じにしてあります。

`require`は実行されると、変数`npt-system::*module-provider-functions*`を
関数のリストとして読み込み、
最初の関数から順に`require`の引数を指定して実行していきます。  
もしどれかの関数が`NIL`以外の値を返却したら、
ロードが成功したとみなして処理を終了します。

例を示します。

```lisp
(defun require-tmp (var)
  (load (merge-pathnames
          (format nil "~(~A~).lisp" var)
          #p"/tmp/")))

(push #'require-tmp npt-system::*module-provider-functions*)

(require 'aaa)
```

実行した結果を示します。(ただし失敗例）

```
ERROR: NPT-SYSTEM::SIMPLE-FILE-ERROR
Cannot open file #P"/tmp/aaa.lisp".

 0. ABORT            Return to eval-loop.
[1]* 0
```

ファイル`/tmp/aaa.lisp`を読み込もうとしているのがわかります。


## <a id="specific-9">5.9 EastAsianWidthの操作</a>

EastAsianWidthとは、Unicodeの全角・半角を表すものです。  
nptでは全角が2文字、半角が1文字として、
`format`やPretty Printingの出力を整形しています。

EastAsianWidthに関する関数は下記の3つです。

```lisp
(defun eastasian-width (var) ...)
(defun eastasian-get (var) ...)
(defun eastasian-set (var size &optional errorp) ...)
```

関数仕様を作成しました。  
[Lisp関数仕様 - システム関数](D1_System.html)


### 関数`eastasian-width`

オブジェクトからEastAsianWidthのサイズを返却します。

引数`var`が整数の場合は、Unicodeの文字としてサイズを返却します。  
引数`var`が文字の場合は、その文字のサイズを返却します。  
引数`var`が文字列の場合は、全ての文字のサイズの合計を返却します。

第1返却値はEastAsianWidthのサイズです。  
第2返却値はサイズが正しく求められたかどうかのboolean値です。


### 関数`eastasian-get`

EastAsianWidthは全角と半角の判定と書きましたが、
正確には文字に対して、`N`, `A`, `H`, `W`, `F`, `NA`の
6つのカテゴリに分類されます。  
本関数はそれぞれのカテゴリが、何文字分に相当するかを取得します。

引数`var`は`string-designator`であり、カテゴリの名前を表します。

第1返却値はEastAsianWidthのサイズです。  
第2返却値はカテゴリを表すsymbolであり、エラーは‘NIL`です。

例を示します。

```lisp
* (npt-system:eastasian-get :na)
1
NPT-SYSTEM::NA

* (npt-system:eastasian-get :hello)
0
NIL
*
```


### 関数`eastasian-set`

EastAsianWidthのカテゴリのサイズを設定します。

引数`var`はカテゴリをあらわすsymbolです。  
引数`size`はカテゴリに対するサイズです。  
引数`&optional errorp`が`error` condition発生の有無です。


## <a id="specific-10">5.10 `load-logical-pathname-translations`の読み込み</a>

`load-logical-pathname-translations`とは、
論理パス名の設定をファイルから読み込む機能です。  
ファイルの読み込む場所は処理系依存です。  
nptでは下記のspecial変数をもとにファイルを探索します。

```lisp
npt-system::*load-logical-pathname-translations*
```

`load-logical-pathname-translations`関数は
文字列を引数として受け取り、対応する設定ファイルを読み込みます。  
例えば次のように実行されたことを考えます。

```lisp
(load-logical-pathname-translations "hello")
```

設定ファイルが次の場所に存在するとします。

```
/tmp/host/hello.txt
```

この場合は、special変数の値を次のように設定します。

```lisp
(setq npt-system::*load-logical-pathname-translations* #p"/tmp/host/*.txt")
```

動作確認をしてみます。  
まずは適当な設定ファイルを配置します。  
ファイルの内容を下記に示します。

```lisp
("*.*" "/home/lisp/")
("path;to;*.*" "/home/path/")
```

設定ファイルを配置します。

```
$ cd /tmp
$ mkdir host
$ cd host
$ vi hello.txt
上記の内容を入力
$
```

nptにより次の命令を実行します。

```lisp
(load-logical-pathname-translations "hello")
-> t

(translate-logical-pathname "hello:name.txt")
-> #P"/home/lisp/name.txt"


(translate-logical-pathname "hello:path;to;name.txt")
-> #P"/home/path/name.txt"
```

正しく変換されているのがわかります。


## <a id="specific-11">5.11 `pathname`の仕様</a>

`pathname`とはファイル名を表すオブジェクトです。

`pathname-host`は、ファイル名がどの環境に属しているかを表します。  
nptでは次の値を使用します。

| `pathname-host` | 環境 |
| --- | --- |
| `npt-system::unix` | Unix環境 |
| `npt-system::windows` | Windows環境 |
| 文字列 | 論理パス |

初期値は`*default-pathname-defaults*`の`pathname`オブジェクトに
設定されている`host`の値です。

`parse-namestring`関数では、`host`の値によって文字列を分析する方法が決まります。  
もし実行している環境がUnix上であっても、`host`の値を変更することで
Windows用のファイル名を認識することができます。  
例えば下記の通り。

```lisp
* (parse-namestring "C:\\Windows\\" 'npt-system::windows)
#P"C:\\Windows\\"
11
* (pathname-directory *)
(:ABSOLUTE "Windows")
```

`equal`関数は`pathname`が同一かどうかを調べることができます。  
もし`namestring`が同じでも`host`が違う場合は同一ではありません。

```lisp
* (parse-namestring "notepad.exe" 'npt-system::windows)
#P"notepad.exe"
11
* (parse-namestring "notepad.exe" 'npt-system::unix)
#P"notepad.exe"
11
* (equal ** *)
NIL
```

`equal`関数は、`host`の値を見て文字列の大文字小文字の判定を行います。  
Unix環境では大文字小文字を別とみなし、
Windows環境では同一とみなします。

```lisp
* (equal
    (parse-namestring "Hello.TXT" 'npt-system::unix)
    (parse-namestring "hello.txt" 'npt-system::unix))
NIL
* (equal
    (parse-namestring "Hello.TXT" 'npt-system::windows)
    (parse-namestring "hello.txt" 'npt-system::windows))
T
```

`pathname-device`は、Unixと論理パスでは無視されます。  
Windowsでは、ファイルの種別か、あるいはドライブレターが設定されます。

```lisp
* (pathname-device (parse-namestring "C:\\Windows\\" 'npt-system::windows))
"C"
* (pathname-device (parse-namestring "notepad.exe" 'npt-system::windows))
NIL
* (pathname-device (parse-namestring "\\\\.\\COM1" 'npt-system::windows))
NPT-SYSTEM::DEVICE
```

`pathname-version`は、UnixとWindowsでは無視されます。  
論理パスでは規則に従って使用されます。

```lisp
* (pathname-version (logical-pathname "test:hello.txt"))
:NEWEST
* (pathname-version (logical-pathname "test:hello.txt.999"))
999
```


## <a id="specific-12">5.12 `random-state`の初期値</a>

`random-state`とは乱数を生成するときに使用するオブジェクトです。  
nptではxorshiftという乱数の生成器を使用しており、
`random-state`には128bitの内部状態を保有しています。

初期値は関数`make-random-state`に引数`t`を渡すことで、
可能な限りデタラメな値を設定できます。  
例えば下記の通り。

```lisp
* (make-random-state t)
#<RANDOM-STATE #x85A5B416389D9716A81B4F43F76E922A>
* (make-random-state t)
#<RANDOM-STATE #xE51C94EB01856FEAC5B1EC8C90E3107E>
```

乱数の初期値を決めることは簡単ではないので、
基本的にはOSに初期値を設定してもらいます。  
本章では、乱数の初期値をどのように取得しているか説明します。


### FreeBSD / Linux
コンパイルモードがFreeBSDかLinuxの場合は、
ファイル`/dev/urandom`から乱数の初期値を取得します。

読み込むデバイスは`/dev/random`ではないことに注意してください。  
FreeBSDでは両者に違いはありませんが、Linuxでは`/dev/random`の方が安全です。  
nptでは安全性より利便性を優先し、`/dev/urandom`を使用することにしました。

`/dev/urandom`から、256byteのデータを受け取り、
それをMD5でハッシュに送り、
MD5の内部状態をそのままxorshiftの内部状態に設定します。  
もし`/dev/urandom`の読み込みが失敗した場合はエラーです。


### Windows
コンパイルモードがWindowsの場合は、
`Advapi32.dll`の関数`SystemFunction036`、
通称`RtlGenRandom`関数から初期値を取得します。

`RtlGenRandom`から、256byteのデータを受け取り、
それをMD5でハッシュに送り、
MD5の内部状態をそのままxorshiftの内部状態に設定します。  
もし`RtlGenRandom`の読み込みが失敗した場合はエラーです。


### ANSI-C
ファイル`/dev/urandom`を読み込もうとします。  
もし値が取得できた場合は初期値に使用しますが、
値が取得できなかった場合はあきらめて、
時刻などを乱数の初期値にします。

FreeBSD, Linux, Windowsとは違い、
初期値用のデバイスが読み込めなかった場合でも
エラーが生じることはなく続行します。


## <a id="specific-13">5.13 `load`関数の引数</a>

`load`関数は、Lisp式が記述されたテキストファイルか、
`compile-file`関数により生成されたバイナリファイル（通称faslファイル）を
読み込むことができます。

どちらを読み込むかは`pathname-type`が`"FASL"`であるかどうかで判定されますが、
`load`関数の引数`:type`により種別を指定することもできます。

テキストファイルを読み込む場合

```lisp
(load file :type :lisp)
```

`fasl`ファイルを読み込む場合

```lisp
(load file :type :fasl)
```

`load`関数の第一引数は`pathname`だけではなく、`memory-stream`を指定することができます。  
ただし`memory-stream`は`pathname`を持たないため、
`:type`引数を指定する必要があります。

実行例を示します。

```lisp
(let ((input (npt-system:make-memory-io-stream))
      (output (npt-system:make-memory-io-stream)))
  (with-open-file (stream input :direction :output)
    (format stream "(format t \"Hello~~%\")"))
  (with-open-file (stream input :direction :input)
    (compile-file stream :output-file output))
  (file-position output :start)
  (load output :type :fasl))
```

実行結果

```
Hello
T
```

この例では、変数`input`にテキストファイルを書き込み、
`compile-file`関数によって変数`output`にfaslファイルを出力します。  
出力された`output`のファイルポインタを先頭に戻してから、
`load`関数により生成されたfaslファイルを実行します。

