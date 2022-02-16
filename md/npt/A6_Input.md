% 入力モジュール

% 入力モジュール

nptのドキュメントです。  
参照元：[ANSI Common Lisp npt](index.html)  
前へ：[npt特有の機能](A5_Features.html)


# 6.1 入力モジュールTERME

`TERME`とは、`readline`, `editline`のように、
入力を補助するためのモジュールです。

現在nptでは、外部モジュールの`readline`と`editline`を利用することができます。  
これらのモジュールはnpt内部の機能ではありませんので、
使用するには別途モジュールをインストールする必要がありました。  
それに対して`TERME`は、nptのソースに含まれているため
新たに何かを用意する必要はありません。

nptの開発方針には、何のモジュールにも依存せず
単体でCommon Lispを構築するという考えがあります。  
それにもかかわらず、`readline`, `editline`を
利用できるのは単純に便利だったからです。  
`TERME`の開発の目的は、これらのモジュールのに替わることです。

現在、`TERME`はFreeBSDとLinuxで使用することができます。


# 6.2 TERMEの使用

FreeBSDとLinuxではデフォルトで`TERME`を利用できます。  
下記にFreeBSDでコンパイルした例を示します。

```
$ cc -o npt -DLISP_FREEBSD *.c -lm
$ ./npt --version-script | grep prompt-mode
prompt-mode     terme
```

`prompt-mode`が`terme`になっていることが分かります。  

`readline`や`editline`のように、明示的に指定することもできます。  
`LISP_TERME`をdefineしてコンパイルしてください。

```
$ cc -o npt -DLISP_FREEBSD -DLISP_TERME *.c -lm
```

`TERME`のオプションは、下記の2つ用意されています。

- カラーモード
- 明暗モード

カラーモードは、名の通りプロンプトに色を付けるかどうかを選択します。  
明暗モードは、色を明るくするか暗くするかを選択します。  
使用しているターミナルの背景が白地の場合は、
デフォルトの明るいモードだと見づらいかもしれません。  
そのようなときは、暗いモードの使用を検討してみてください。  

デフォルトはカラー使用、明るいモードです。  
コンパイルした後でも、これらのモードは変更可能です。


## カラーモード

カラーモードは、次のdefine値で変更できます。

- `LISP_TERME_COLOR`  (デフォルト)
- `LISP_TERME_MONOCHROME`

もし色を使用したくない場合は、
`LISP_TERME_MONOCHROME`を指定してコンパイルしてください。  
例えば次の通り。

```
$ cc -o npt -DLISP_FREEBSD -DLISP_TERME_MONOCHROME *.c -lm
```

モードの指定は下記のコマンドで確認できます。

```
$ ./npt --version-script | grep prompt-color
prompt-color     off
```

モードはコマンドのオプションで変更できます。  
カラーモードで起動する場合は次のようにします。

```
$ npt --color
```

色を使用しないモノクロモードで起動する場合は次のようにします。

```
$ npt --monochrome
```

実行中は`npt-system:*prompt-color*`の値を操作することで、
モードの確認と切り替えをすることができます。

```lisp
* npt-system:*prompt-color*
NIL
* (setq npt-system:*prompt-color* t)
T
```


## 明暗モード

カラーモードが指定されているときに限り、
明暗モードを指定できます。  
明暗モードは、次のdefine値で変更できます。

- `LISP_TERME_BRIGHT`  (デフォルト)
- `LISP_TERME_DARK`

もし暗い色を使用したい場合は、
`LISP_TERME_DARK`を指定してコンパイルしてください。  
例えば次の通り。

```
$ cc -o npt -DLISP_FREEBSD -DLISP_TERME_DARK *.c -lm
```

モードの指定は下記のコマンドで確認できます。

```
$ ./npt --version-script | grep prompt-bright
prompt-bright   dark
```

モードはコマンドのオプションで変更できます。  
明るいモードで起動する場合は次のようにします。

```
$ npt --bright
```

暗いモードで起動する場合は次のようにします。

```
$ npt --dark
```

実行中は`npt-system:*prompt-bright*`の値を操作することで、
モードの確認と切り替えをすることができます。

```lisp
* npt-system:*prompt-bright*
NIL
* (setq npt-system:*prompt-bright* t)
T
```


# 6.3 操作方法

操作方法を示します。

- 移動
  - カーソルを左に移動　`Ctrl+B`, 左カーソルキー
  - カーソルを右に移動　`Ctrl+F`, 右カーソルキー
  - カーソルを文頭に移動　`Ctrl+A`
  - カーソルを文末に移動　`Ctrl+E`

- 決定と履歴
  - 入力の決定　`Ctrl+J`, `Ctrl+M`, Enterキー, Returnキー
  - ひとつ前の履歴　`Ctrl+P`, 上カーソルキー
  - ひとつ後の履歴　`Ctrl+N`, 下カーソルキー

- 削除
  - 一文字削除　`Ctrl+D`
  - バックスペース　`Ctrl+H`, BSキー
  - 文頭まで削除　`Ctrl+U`
  - 文末まで削除　`Ctrl+K`

- その他
  - 画面の再描画　`Ctrl+L`
  - 中断　`Ctrl+C`
  - プロセスの停止　`Ctrl+Z`
  - `EOF`　何も入力がない状態で`Ctrl+D`

その他の文字は入力になります。  
入力文字はUTF-8のみ受け付けます。  
不正なUTF-8文字は全て無視されます。


# 6.4 その他の情報

`Ctrl+D`には2つの機能があります。  
もし何かの文字が入力されている場合は、カーソルにある一文字を削除します。  
しかし、入力がない時に`Ctrl+D`を押すと、
`EOF`を返却したことになり、プロンプトは強制終了されます。

もしdebugger起動中の`restart`選択画面のときに
`Ctrl+D`で`EOF`を入力した場合は、
`abort` restartを選択したことと同じになります。  
`:exit`を入力した場合も同じように`abort`となります。

もし`eval-loop`で`Ctrl+D`を入力した場合は、
`eval-loop`から脱出するので、おそらくはプロセスが終了します。  
もし`eval-loop`を終了したくない場合は、
`npt-system:*eval-loop-exit*`変数に`t`を代入してください。  
終了を確認する`Exit?`というプロンプトが表示されます。

実行例を下記に示します。

```
$ npt
* (setq npt-system:*eval-loop-exit* t)
T
* ^D
Exit? ^D
* ^D
Exit? zzz
* ^D
Exit? y
$
```

起動時に設定したい場合は、`initfile`を利用するのが便利です。  
次の操作によりファイルを作成してください。

```
$ vi $HOME/.npt.lisp
```

作成するファイルは、npt起動時に自動的に`load`されます。  
下記に例を示します。

```lisp
;; 終了時に確認のプロンプトを出す
(setq npt-system:*eval-loop-exit* t)
;; プロンプトの色を暗くする
(setq npt-system:*prompt-bright* nil)
```
