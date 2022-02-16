% 関数仕様 - シーケンス

nptのドキュメントです。  
参照元：[ANSI Common Lisp npt](index.html)


# 関数仕様

`lisp.h`に記載されている下記の関数仕様を示します。

```c
■シーケンス生成
void lisp_cons(addr x, addr car, addr cdr);
void lisp_vector(addr x, size_t size);
void lisp_list(addr x, ...);
void lisp_lista(addr x, ...);

■シーケンス操作
int lisp_getelt_(addr x, addr pos, size_t index);
int lisp_setelt_(addr pos, size_t index, addr value);
int lisp_length_(addr pos, size_t *ret);

int lisp_reverse_(addr x, addr pos);
int lisp_nreverse_(addr x, addr pos);

■cons
void lisp_car(addr x, addr list);
void lisp_cdr(addr x, addr list);
void lisp_carcdr(addr x, addr y, addr list);

void lisp_setf_car(addr cons, addr value);
void lisp_setf_cdr(addr cons, addr value);
void lisp_setf_carcdr(addr cons, addr car, addr cdr);

■string
int lisp_string8_(addr x, const void *str);
int lisp_string16_(addr x, const void *str);
int lisp_string32_(addr x, const void *str);
int lisp_string_getc_(addr pos, size_t i, unicode *c);

■strvect
int lisp_strvect_getc(addr pos, size_t i, unicode *c);
int lisp_strvect_length(addr pos, size_t *ret);
```


# ■シーケンス生成

シーケンスオブジェクトの生成関数です。

```c
void lisp_cons(addr x, addr car, addr cdr);
void lisp_vector(addr x, size_t size);
void lisp_list(addr x, ...);
void lisp_lista(addr x, ...);
```


## 関数`lisp_cons`

```c
void lisp_cons(addr x, addr car, addr cdr);

入力: car, cdr オブジェクト
出力: x hold変数
```

consオブジェクトを生成します。  
`car`が`NULL`の場合は`NIL`が指定されます。  
`cdr`が`NULL`の場合は`NIL`が指定されます。  
`car`がhold変数の場合は、内容が指定されます。  
`cdr`がhold変数の場合は、内容が指定されます。


## 関数`lisp_vector`

```c
void lisp_vector(addr x, size_t size);

入力: size 配列の長さ
出力: x hold変数
```

一次元の配列オブジェクトを生成します。  
`simple-vector`型の専用オブジェクトです。


## 関数`lisp_list`

```c
void lisp_list(addr x, ...);

入力: 可変引数
出力: x hold変数
```

可変引数を要素にしたlistオブジェクトを生成します。  
可変引数はaddrを受け取り、NULLで終端します。  
引数がhold変数の場合は、内容を使用します。

例をあげます。

```c
lisp_fixnum(x, 10);
lisp_fixnum(y, 20);
lisp_fixnum(z, 30);
lisp_list(x, x, y, z, NULL);

x -> (10 20 30)
```


## 関数`lisp_lista`

```c
void lisp_lista(addr x, ...);

入力: 可変引数
出力: x hold変数
```

可変引数を要素にしたlistオブジェクトを生成します。  
Common Lispの`list*`とほぼ同等であり、最終要素がリストのcdrになります。  
可変引数はaddrを受け取り、NULLで終端します。  
`list*`とは違い、要素が一つもない場合は`NIL`を返却します。  
引数がhold変数の場合は、内容を使用します。

例をあげます。

```c
lisp_fixnum(x, 10);
lisp_fixnum(y, 20);
lisp_fixnum(z, 30);
lisp_lista(x, x, y, z, NULL);

x -> (10 20 . 30)
```

# ■シーケンス操作

シーケンスの操作関数です。

```c
int lisp_getelt_(addr x, addr pos, size_t index);
int lisp_setelt_(addr pos, size_t index, addr value);
int lisp_length_(addr pos, size_t *ret);

int lisp_reverse_(addr x, addr pos);
int lisp_nreverse_(addr x, addr pos);
```


## 脱出関数`lisp_getelt_`

```c
int lisp_getelt_(addr x, addr pos, size_t index);

入力: pos シーケンス
入力: index インデックス
出力: x hold変数
戻り値: 脱出時は0以外
```

シーケンス`pos`の`index`番目の要素を返却します。  
`pos`がhold変数の場合は、内容が使用されます。  


## 脱出関数`lisp_setelt_`

```c
int lisp_setelt_(addr pos, size_t index, addr value);


入力: pos シーケンス
入力: index インデックス
出力: x hold変数
戻り値: 脱出時は0以外
```

シーケンス`pos`の`index`番目の要素を`value`に設定します。  
`pos`, `value`がhold変数の場合は、内容が使用されます。  


## 脱出関数`lisp_length_`

```c
int lisp_length_(addr pos, size_t *ret);

入力: pos シーケンス
出力: ret 要素数
戻り値: 脱出時は0以外
```

シーケンス`pos`の要素数を返却します。  
`pos`がhold変数の場合は、内容が使用されます。  


## 脱出関数`lisp_reverse_`

```c
int lisp_reverse_(addr x, addr pos);

入力: pos シーケンス
出力: x hold変数
戻り値: 脱出時に0以外
```

`pos`を逆順にしたものを返却します。  
`pos`がhold変数の場合は、内容が使用されます。  
シーケンスは新たに作成されるので、元のシーケンスは破壊しません。

## 脱出関数`lisp_nreverse_`

```c
int lisp_nreverse_(addr x, addr pos);

入力: pos シーケンス
出力: x hold変数
戻り値: 脱出時に0以外
```

`pos`を逆順にしたものを返却します。  
`pos`がhold変数の場合は、内容が使用されます。  
シーケンスを新たに作成せず、シーケンスを破壊します。


# ■cons

consのアクセス関数です。

```c
void lisp_car(addr x, addr list);
void lisp_cdr(addr x, addr list);
void lisp_carcdr(addr x, addr y, addr list);

void lisp_setf_car(addr cons, addr value);
void lisp_setf_cdr(addr cons, addr value);
void lisp_setf_carcdr(addr cons, addr car, addr cdr);
```

## 関数`lisp_car`

```c
void lisp_car(addr x, addr list);

入力: list リスト
出力: x hold変数
```

`list`のcarを取得します。  
`list`はconsかNILを指定できます。


## 関数`lisp_cdr`

```c
void lisp_cdr(addr x, addr list);

入力: list リスト
出力: x hold変数
```

`list`のcdrを取得します。  
`list`はconsかNILを指定できます。


## 関数`lisp_carcdr`

```c
void lisp_carcdr(addr x, addr y, addr list);

入力: `list` リスト
出力: x, y hold変数
```

`list`のcarを`x`に、cdrを`y`に返却します。
`list`はconsかNILを指定できます。


## 関数`lisp_setf_car`

```c
void lisp_setf_car(addr cons, addr value);

入力: cons cons型
入力: value オブジェクト
```

`value`がhold変数の場合は、内容が使用されます。  
`cons`のcar部に`value`を設定します。


## 関数`lisp_setf_cdr`

```c
void lisp_setf_cdr(addr cons, addr value);

入力: cons cons型
入力: value オブジェクト
```

`value`がhold変数の場合は、内容が使用されます。  
`cons`のcdr部に`value`を設定します。


## 関数`lisp_setf_carcdr`

```c
void lisp_setf_carcdr(addr cons, addr car, addr cdr);

入力: cons cons型
入力: car, cdr オブジェクト
```

`car`, `cdr`がhold変数の場合は、内容が使用されます。  
`cons`のcar部に`car`を設定します。  
`cons`のcdr部に`cdr`を設定します。


# ■string

stringのアクセス関数です。

```c
int lisp_string8_(addr x, const void *str);
int lisp_string16_(addr x, const void *str);
int lisp_string32_(addr x, const void *str);
int lisp_string_getc_(addr pos, size_t i, unicode *c);
```

# 脱出関数`lisp_string8_`

```c
int lisp_string8_(addr x, const void *str);
int lisp_string16_(addr x, const void *str);
int lisp_string32_(addr x, const void *str);

入力: str 文字列
出力: x hold変数
戻り値: 脱出時は0以外
```

stringオブジェクトを返却します。  
`simple-string`型の専用オブジェクトです。  
`str`はオブジェクトに格納する文字列を指定します。  
`str`のメモリ形式は下記の通りです。

- 8bit, 16bit, 32bitの配列
- UTF-8, UTF-16, UTF-32エンコード
- 0で終端する

# 脱出関数`lisp_string16_`

`lisp_string8_`で解説


# 脱出関数`lisp_string32_`

`lisp_string8_`で解説


## 脱出関数`lisp_string_getc_`

```c
int lisp_string_getc_(addr pos, size_t i, unicode *c);

入力: pos 文字列
入力: i インデックス
出力: c 文字
戻り値: 脱出時は0以外
```

`strvect`オブジェクトから文字の値を取得します。  
`pos`がhold変数の場合は、内容を使用します。


# ■strvect

`simple-string`専用のオブジェクトである、`strvect`の操作関数です。

```c
int lisp_strvect_getc(addr pos, size_t i, unicode *c);
int lisp_strvect_length(addr pos, size_t *ret);
```


## 関数`lisp_strvect_getc`

```c
int lisp_strvect_getc(addr pos, size_t i, unicode *c);

入力: pos オブジェクト
入力: i インデックス
出力: c 文字
戻り値: 正常終了は0、エラーは0以外
```

`strvect`オブジェクトから文字の値を取得します。  
本関数は脱出なしで文字列から文字を取得するための関数です。

`lisp_string_getc_`と違い`array`オブジェクトには対応していません。  
もし`strvect`型オブジェクトではない場合は戻り値`-1`で終了します。  
もし`i`が文字数を超えていた場合は、戻り値`1`で終了します。  
文字を`c`に返却したら、戻り値`0`で終了します。


## 関数`lisp_strvect_length`

```c
int lisp_strvect_length(addr pos, size_t *ret);

入力: pos オブジェクト
出力: ret 文字列の長さ
戻り値: 正常終了は0、エラーは0以外
```

`strvect`オブジェクトから文字列の長さを取得します。  
本関数は脱出なしで文字列から長さを取得するための関数です。

`lisp_length_`と違い`strvect`オブジェクトのみに対応しています。  
もし`strvect`型オブジェクトではない場合は戻り値`-1`で終了します。  
文字列の長さを`ret`に返却したら、戻り値`0`で終了します。
