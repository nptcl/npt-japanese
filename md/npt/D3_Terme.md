% Lisp関数仕様 - terme

nptのドキュメントです。  
参照元：[ANSI Common Lisp npt](index.html)


# Lisp関数仕様

`npt-system`パッケージの下記の関数を説明します。

- [terme](#terme-1)

```lisp
defun terme
```

- [`terme-enable`](#terme-2)
- [`terme-begin`](#terme-3)
- [`terme-end`](#terme-4)
- [`terme-input`](#terme-5)
- [`terme-output`](#terme-6)
- [`terme-move`](#terme-7)
- [`terme-clear`](#terme-8)
- [`terme-delete`](#terme-9)
- [`terme-size`](#terme-10)
- [`terme-scroll`](#terme-11)
- [`terme-font`](#terme-12)


# <a id="terme-1">関数`terme`</a>

本関数は、端末の入出力を操作します。

termeを利用するには、コンパイルオプションを指定する必要があります。  
利用可能かどうかはコマンドライン引数の`--version`で確認できます。

```
$ npt --version | grep Prompt
Prompt mode          terme
```

関数仕様を下記に示します。

```lisp
(defun terme (symbol &rest args) ...) -> *

入力: symbol
入力: args, 引数
出力: *, 状態
```

`symbol`は次の内容を指定できます。

- `terme-enable`
- `terme-begin`
- `terme-end`
- `terme-input`
- `terme-output`
- `terme-move`
- `terme-clear`
- `terme-delete`
- `terme-size`
- `terme-scroll`
- `terme-font`

例えば、`terme-enable`を実行する際は次のようにします。

```lisp
(terme 'terme-enable)
```

`sysctl`とは違い、引数は`symbol`を`eq`判定で行います。  
もし`npt-system`パッケージを継承していない場合は、次のように実行してください。

```lisp
(npt-system:terme 'npt-system:terme-enable)
```

以降は、継承していることを前提に説明します。


# <a id="terme-2">関数`terme`: `terme-enable`</a>

termeモジュールが利用可能かどうかを返却します。

```lisp
(defun terme (terme-enable) ...) -> boolean
```

返却が`t`の場合は、`terme`機能を利用できます。  
返却が`nil`の場合は、`terme`機能は利用できません。

実行例を示します。

```lisp
(terme 'terme-enable)
```


# <a id="terme-3">関数`terme`: `terme-begin`</a>

termeの操作を開始します。

```lisp
(defun terme (terme-begin &optional mode) ...) -> paper
```

内部の動作は、端末をraw modeに設定しています。  
raw modeは、下記の点において通常のモードと違っています。

- Ctrl+Cなどが入力として扱われる
- 入出力は行単位ではなく文字単位で行われる
- 改行の扱いが通常とは異なる

返却値`paper`は、変更前の端末情報を保有したPaperオブジェクトです。  
`terme-end`の引数に渡すことで、端末の状態をもとに戻すことができます。  
終了する前は、必ず`terme-end`を実行してください。

引数`mode`は、`nil`か`:default`を指定できます。  
省略時は`nil`であり、端末をraw modeに設定します。  
`mode`が`:default`の場合は、端末を起動時の設定に変更します。  
その際の返却値は、raw modeと同様に、変更される前の端末情報です。

実行例は`terme-end`をご確認ください。


# <a id="terme-4">関数`terme`: `terme-end`</a>

termeの操作を終了します。

```lisp
(defun terme (terme-end paper) ...) -> null
```

内部の動作は、引数の情報をもとに端末を通常の状態に戻します。

引数に、`terme-begin`で返却されたPaperオブジェクトを受け取ります。  
端末の操作を終了する場合は、必ず`terme-end`を実行して下さい。  

`terme-end`は、`unwind-protect`のcleanupにて実行することをお勧めします。  
例えば、次のようになります。

```lisp
(let ((x (terme 'terme-begin)))
  (unwind-protect
    (progn ...)
    (terme 'terme-end x)))
```


# <a id="terme-5">関数`terme`: `terme-input`</a>

入力を受け取ります。

```lisp
(defun terme (terme-input &optional (block t)) ...) -> (values symbol value)
  block   (or null (eql t) integer float)  ;; default T
  symbol  symbol
  value   (or null integer)
```

本機能は入力が到達するまで実行を停止します。  
入力とは下記のいずれかになります。

- キーボードからの入力
- 端末のサイズ変更通知

入力と返却値の対応を下記に示します。

|入力|返却`symbol`|返却`value`|
|----|----|----|
|文字|`terme-code`|文字コード|
|↑ キー|`terme-up`|`nil`|
|↓ キー|`terme-down`|`nil`|
|← キー|`terme-left`|`nil`|
|→ キー|`terme-right`|`nil`|
|Function キー|`terme-function`| 1, 2, ～|
|Home キー|`terme-home`|`nil`|
|End キー|`terme-end`|`nil`|
|Page Up キー|`terme-page-up`|`nil`|
|Page Down キー|`terme-page-down`|`nil`|
|Insert キー|`terme-insert`|`nil`|
|Esc キー|`terme-escape`|`nil`|

イベントと返却値の対応を下記に示します。

|イベント|返却`symbol`|返却`value`|
|----|----|----|
|入力異常|`nil`|`nil`|
|サイズ変更|`terme-signal`|`nil`|
|タイムアウト|`terme-hang`|`nil`|

入力異常とは、認識できない入力か、非対応のエスケープシーケンスを受け取った時です。  
頻繁に発生することが考えられますので、無視することをお勧めします。

サイズ変更は、プロセスがシグナルを受け取った時です。  
端末のサイズが変更されたときもシグナルを受け取りますので、
画面の再描画を行う契機になります。

タイムアウトについて説明します。

`terme-input`は、省略可能な引数`block`を受け取ります。  
省略時は`t`です。  
`block`が`t`の場合は無限に待ち続けます。  
`block`が`nil`か`0`の場合は、待たずにすぐに返却します。  
`block`が整数か浮動小数の場合は、タイムアウトまでの秒数を表します。  
もしタイムアウトが発生した場合は、`terme-hang`が返却されます。

実行例を示します。

```lisp
(terme 'terme-input)
-> TERME-CODE, 3       ;; Ctrl+Cを受け取った

(terme 'terme-input 0.01)
-> TERME-HANG, NIL     ;; タイムアウト
```


# <a id="terme-6">関数`terme`: `terme-output`</a>

端末にデータを出力します。

```lisp
(defun terme (terme-output &optional value) ...) -> null
  value  (or null charcter string integer array)  ;; default nil
```

引数`value`は省略可能であり、デフォルトは`nil`です。  
引数`value`が文字の場合は、UTF-8エンコードで出力します。  
引数`value`が文字列の場合は、UTF-8エンコードで出力します。  
引数`value`が整数の場合は、Unicodeコードとみなして、UTF-8エンコードで出力します。  
引数`value`が配列の場合は、内容に応じて出力を行います。  
引数`value`が`nil`の場合は、キャッシュのデータをflushします。

引数が配列であった場合は、必ず一次元である必要があります。  
配列は、最初の要素から、`fill-pointer`の値まで出力します。  
あらかじめバッファを広めに用意しておき、`fill-pointer`でサイズを操作することで、
メモリ空間の節約と速度向上を期待することができます。

本機能で出力を行うと、内部のバッファに出力データが保留されます。  
画面に反映したい場合は、必ず`(terme 'terme-output)`で内容をflushして下さい。  
`terme-output`ではない、他の操作関数(例えば`terme-move`など)は、
エスケープシーケンスを`terme-output`で出力して実現しています。  
このような操作関数を即座に画面に反映したい場合は、
文字出力と同様に`(terme 'terme-output)`を実行してバッファをflushして下さい。

実行例を示します。

```lisp
;;  13, 10, flushで改行出力
(terme 'terme-output 13)
(terme 'terme-output 10)
(terme 'terme-output)

;;  カーソルの移動
(terme 'terme-move 10 20 :absolute)
(terme 'terme-output)
```


# <a id="terme-7">関数`terme`: `terme-move`</a>

カーソルを移動します。

```lisp
(defun terme (terme-move x y mode) ...) -> null
  x     integer
  y     (or null integer)
  mode  (member :absolute :relative)
```

`mode`が`:relative`のときは、現在のカーソルの位置からの移動距離を指定します。  
`mode`が`:absolute`のときは、左上からの絶対座標を指定します。  
`(0, 0)`が原点です。  
`:absolute`のときのみ、`y`を`nil`に設定することができます。

実行例を示します。

```lisp
(terme 'terme-move 0 0 :absolute)
(terme 'terme-output)
```


# <a id="terme-8">関数`terme`: `terme-clear`</a>

端末全体の文字を消去します。

```lisp
(defun terme (terme-clear &optional value) ...) -> null
  value  (member nil :before :after)  ;; default nil
```

引数`value`は省略可能であり、デフォルトは`nil`です。  
引数`value`が`nil`の場合は、画面全体を消去します。  
引数`value`が`:before`の場合は、カーソルの位置を含む行頭までと、上部全てを削除します。  
引数`value`が`:after`の場合は、カーソルの位置を含む行末までと、下部全てを削除します。  

`:before`の実行例を示します。

```lisp
(terme 'terme-clear)
(terme 'terme-move 0 0 :absolute)
(terme 'terme-output "ABCDEF")
(terme 'terme-move 0 1 :absolute)
(terme 'terme-output "GHIJKL")
(terme 'terme-move 0 2 :absolute)
(terme 'terme-output "MNOPQR")

(terme 'terme-move 3 1 :absolute)
(terme 'terme-clear :before)
(terme 'terme-move 0 3 :absolute)
(terme 'terme-output)
```

実行結果

```

    KL
MNOPQR
```

`:after`の実行例を示します。

```lisp
(terme 'terme-clear)
(terme 'terme-move 0 0 :absolute)
(terme 'terme-output "ABCDEF")
(terme 'terme-move 0 1 :absolute)
(terme 'terme-output "GHIJKL")
(terme 'terme-move 0 2 :absolute)
(terme 'terme-output "MNOPQR")

(terme 'terme-move 3 1 :absolute)
(terme 'terme-clear :after)
(terme 'terme-move 0 3 :absolute)
(terme 'terme-output)
```

実行結果

```
ABCDEF
GHI

```


# <a id="terme-9">関数`terme`: `terme-delete`</a>

行の文字を消去します。

```lisp
(defun terme (terme-delete &optional value) ...) -> null
  value  (member nil :before :after)  ;; default nil
```

引数`value`は省略可能であり、デフォルトは`nil`です。  
引数`value`が`nil`の場合は、行全体を消去します。  
引数`value`が`:before`の場合は、カーソルの位置を含む行頭までを削除します。  
引数`value`が`:after`の場合は、カーソルの位置を含む行末までを削除します。  

実行例を示します。

```lisp
(terme 'terme-clear)
(terme 'terme-move 0 0 :absolute)
(terme 'terme-output "ABCDEF")
(terme 'terme-move 0 1 :absolute)
(terme 'terme-output "GHIJKL")
(terme 'terme-move 0 2 :absolute)
(terme 'terme-output "MNOPQR")

(terme 'terme-move 3 1 :absolute)
(terme 'terme-delete :before)
(terme 'terme-move 0 3 :absolute)
(terme 'terme-output)
```

実行結果

```
ABCDEF
    KL
MNOPQR
```


# <a id="terme-10">関数`terme`: `terme-size`</a>

端末の幅と高さを取得します。  
単位は文字数です。

```lisp
(defun terme (terme-size) ...) -> x, y
  x  横の文字数、幅
  y  縦の文字数、高さ
```

実行例

```lisp
* (terme 'terme-size)
80
25
```


# <a id="terme-11">関数`terme`: `terme-scroll`</a>

画面を上下にスクロールします。

```lisp
(defun terme (terme-scroll value) ...) -> null
  value  integer
```

`value`が正の時は、上方向にスクロールします。  
`value`が負の時は、下方向にスクロールします。  

`value`が`1`の時は、画面の最下段でEnterを押したときの動作と同じです。


# <a id="terme-12">関数`terme`: `terme-font`</a>

文字種、文字色、背景色を変更します。

```lisp
(defun terme (terme-font &rest args) ...) -> null
  value  (member nil :before :after)  ;; default nil
```

本機能は、表示する端末の性能によっては正しく表示されません。  

文字種とは、例えばボールド、イタリックなどの属性を示します。  
文字色、背景色は、デフォルトの8色、256パレット、RGB指定で設定可能です。  

下記の順番で、本機能の使い方を説明します。

- 設定のリセット
- 文字種の設定
- 文字色の設定
- 背景色の設定
- 複合設定


## 設定のリセット

次のいずれかを実行することで、設定をリセットできます。

```lisp
(terme 'terme-font)
(terme 'terme-font nil)
(terme 'terme-font 'code 'reset)
(terme 'terme-font 'code 0)
```

文字種、文字色、背景色がデフォルトの設定に戻ります。


## 文字種の設定

文字種は`'code`で設定できます。

```lisp
(terme 'terme-font 'code x)
```

`x`は、整数かsymbolを指定します。  
整数のときはエスケープシーケンスの操作番号です。  
symbolのときは、下記の内容を指定できます。

|symbol|内容|コード|
|---|---|---|
|`reset`       |リセット   |0 |
|`bold`        |ボールド   |1 |
|`faint`       |薄く表示   |2 |
|`italic`      |イタリック |3 |
|`underline`   |下線       |4 |
|`slow-blink`  |遅く点滅   |5 |
|`rapid-blink` |速く点滅   |6 |
|`reverse`     |色逆転     |7 |
|`hide`        |文字を隠す |8 |
|`strike`      |打消し線   |9 |

実行例を示します。

```lisp
(terme 'terme-font 'code 'italic)
(terme 'terme-output)
```


## 文字色の設定

文字色は次の3通りの方法で指定できます。

- 標準8色指定
- 256パレット指定
- RGBフルカラー指定

標準8色指定は、`fore`という識別子で設定できます。  
次の値を引数の取ります。

|色| 設定値 | 設定値(暗い) | 設定値(明るい) |
|---|---|---|---|
|黒  | `black`   | `dark-black`   | `bright-black`   |
|赤  | `red`     | `dark-red`     | `bright-red`     |
|緑  | `green`   | `dark-green`   | `bright-green`   |
|黄色| `yellow`  | `dark-yellow`  | `bright-yellow`  |
|青  | `blue`    | `dark-blue`    | `bright-blue`    |
|赤紫| `magenta` | `dark-magenta` | `bright-magenta` |
|水色| `cyan`    | `dark-cyan`    | `bright-cyan`    |
|白  | `white`   | `dark-white`   | `bright-white`   |
|標準| `default` | -              | -                |

`dark-`も`bright-`も付いていない識別は、
`*prompt-bright*`の値により明暗が選択されます。  
例えば、`*prompt-bright*`が`t`のとき、
`yellow`は`bright-yellow`と同じです。

実行例を示します。

```lisp
(terme 'terme-font 'fore 'dark-magenta)
(terme 'terme-output)
```

256パレット指定は、`palfore`という識別子で設定できます。  
引数に、`#x00`～`#xFF`までの整数を取ります。

実行例を示します。

```lisp
(terme 'terme-font 'palfore #xAA)
(terme 'terme-output)
```

RGBフルカラー指定は、`rgbfore`という識別子で設定できます。  
引数に、`#x00`～`#xFF`までの整数を連続で3つ取ります。

実行例を示します。

```lisp
(terme 'terme-font 'rgbfore #xFF #xFF #x80)
(terme 'terme-output)
```


## 背景色の設定

設定方法は文字色と同じです。  
識別子が違いますので、下記に示します。

- 標準8色指定、`back`
- 256パレット指定、`palback`
- RGBフルカラー指定、`rgbback`

実行例を示します。

```lisp
(terme 'terme-font 'back 'dark-magenta)
(terme 'terme-font 'palback #xAA)
(terme 'terme-font 'rgbback #xFF #xFF #x80)
```


## 複合設定

文字種、文字色、背景色は、複合して設定できます。  
同時に設定したい場合は、連続して記載してください。

実行例を下記に示します。

```lisp
(terme 'terme-font 'code 'underline 'fore 'magenta 'rgbback #xFF #xFF #x80)
(terme 'terme-output)
```
