% 関数仕様 - オブジェクト

nptのドキュメントです。  
参照元：[ANSI Common Lisp npt](index.html)


# 関数仕様

`lisp.h`に記載されている下記の関数仕様を示します。

```c
■オブジェクト生成
int lisp_character_(addr x, unicode value);
void lisp_fixnum(addr x, fixnum value);
int lisp_float_(addr x, float value);
int lisp_double_(addr x, double value);
int lisp_long_double_(addr x, long double value);

■値取得
int lisp_zero_p(addr value);
int lisp_plus_p(addr value);
int lisp_minus_p(addr value);
void lisp_get_character(addr pos, unicode *ret);
void lisp_get_fixnum(addr pos, fixnum *ret);
int lisp_get_float_(addr pos, float *ret);
int lisp_get_double_(addr pos, double *ret);
int lisp_get_long_double_(addr pos, long double *ret);

■package
int lisp_package_(addr x, addr pos);
int lisp_package8_(addr x, const void *str);
int lisp_package16_(addr x, const void *str);
int lisp_package32_(addr x, const void *str);

■intern
int lisp_intern_(addr x, addr package, addr name);
int lisp_intern8_(addr x, const void *package, const void *name);
int lisp_intern16_(addr x, const void *package, const void *name);
int lisp_intern32_(addr x, const void *package, const void *name);

■reader
int lisp_reader_(addr x, addr str);
int lisp_reader8_(addr x, const void *str);
int lisp_reader16_(addr x, const void *str);
int lisp_reader32_(addr x, const void *str);

■pathname
int lisp_pathname_(addr x, addr name);
int lisp_pathname8_(addr x, const void *str);
int lisp_pathname16_(addr x, const void *str);
int lisp_pathname32_(addr x, const void *str);
int lisp_namestring_(addr x, addr path);
```


# ■オブジェクト生成

Lispオブジェクト生成の関数です。

```c
int lisp_character_(addr x, unicode value);
void lisp_fixnum(addr x, fixnum value);
int lisp_float_(addr x, float value);
int lisp_double_(addr x, double value);
int lisp_long_double_(addr x, long double value);
```

## 脱出関数`lisp_character_`

```c
int lisp_character_(addr x, unicode value);

入力: value unicode文字
出力: x hold変数
戻り値: 脱出時に0以外
```

`value`をUnicodeとして扱い、文字型のオブジェクトを生成します。  
`value`がサロゲートペアで予約されているコードであるか、
あるいはUnicodeの範囲を超えている場合はエラーです。


## 関数`lisp_fixnum`

```c
void lisp_fixnum(addr x, fixnum value);

入力: value 整数
出力: x hold変数
```

型`fixnum`で表される整数オブジェクトを生成します。


## 脱出関数`lisp_float_`

```c
int lisp_float_(addr x, float value);

入力: value 浮動小数
出力: x hold変数
戻り値: 脱出時に0以外
```

`single-float`型の浮動小数オブジェクトを生成します。  
`value`が`inf`か`nan`の場合はエラーです。


## 脱出関数`lisp_double_`

```c
int lisp_double_(addr x, double value);

入力: value 浮動小数
出力: x hold変数
戻り値: 脱出時に0以外
```

`double-float`型の浮動小数オブジェクトを生成します。  
`value`が`inf`か`nan`の場合はエラーです。


## 脱出関数`lisp_long_double_`

```c
int lisp_long_double_(addr x, long double value);

入力: value 浮動小数
出力: x hold変数
戻り値: 脱出時に0以外
```

`long-float`型の浮動小数オブジェクトを生成します。  
`value`が`inf`か`nan`の場合はエラーです。


# ■値取得

オブジェクトの値を取得する関数です。

```c
int lisp_zero_p(addr value);
int lisp_plus_p(addr value);
int lisp_minus_p(addr value);
void lisp_get_character(addr pos, unicode *ret);
void lisp_get_fixnum(addr pos, fixnum *ret);
int lisp_get_float_(addr pos, float *ret);
int lisp_get_double_(addr pos, double *ret);
int lisp_get_long_double_(addr pos, long double *ret);
```


## 関数`lisp_zero_p`

```c
int lisp_zero_p(addr value);

入力: value オブジェクト
戻り値: bool値
```

`value`がhold変数の場合は、内容が評価されます。  
`value`が実数でありかつ`0`である場合に0以外が返却されます。


## 関数`lisp_plus_p`

```c
int lisp_plus_p(addr value);

入力: value オブジェクト
戻り値: bool値
```

`value`がhold変数の場合は、内容が評価されます。  
`value`が実数でありかつ`0`を超えている場合に0以外が返却されます。  
`0`は含まれません。


## 関数`lisp_minus_p`

```c
int lisp_minus_p(addr value);

入力: value オブジェクト
戻り値: bool値
```

`value`がhold変数の場合は、内容が評価されます。  
`value`が実数でありかつ`0`をより小さい場合に0以外が返却されます。  
`0`は含まれません。


## 関数`lisp_get_character`

```c
void lisp_get_character(addr pos, unicode *ret);

入力: pos 文字型オブジェクト
出力: ret unicode文字
```

`pos`がhold変数の場合は、内容が評価されます。  
文字型のコードを`ret`に返却します。


## 関数`lisp_get_fixnum`

```c
void lisp_get_fixnum(addr pos, fixnum *ret);

入力: pos fixnum型オブジェクト
出力: ret fixnum型整数
```

`pos`がhold変数の場合は、内容が評価されます。  
`LISPTYPE_FIXNUM`型オブジェクトから値を`ret`に返却します。


## 脱出関数`lisp_get_float_`

```c
int lisp_get_float_(addr pos, float *ret);

入力: pos 実数型オブジェクト
出力: ret 浮動小数
戻り値: 脱出時に0以外
```

`pos`がhold変数の場合は、内容が評価されます。  
`pos`が`single-float`型の場合は値を`ret`に返却します。  
それ以外の実数型の場合は`single-float`にcastして返却します。


## 脱出関数`lisp_get_double_`

```c
int lisp_get_double_(addr pos, double *ret);

入力: pos 実数型オブジェクト
出力: ret 浮動小数
戻り値: 脱出時に0以外
```

`pos`がhold変数の場合は、内容が評価されます。  
`pos`が`double-float`型の場合は値を`ret`に返却します。  
それ以外の実数型の場合は`double-float`にcastして返却します。


## 脱出関数`lisp_get_long_double_`

```c
int lisp_get_long_double_(addr pos, long double *ret);

入力: pos 実数型オブジェクト
出力: ret 浮動小数
戻り値: 脱出時に0以外
```

`pos`がhold変数の場合は、内容が評価されます。  
`pos`が`long-float`型の場合は値を`ret`に返却します。  
それ以外の実数型の場合は`long-float`にcastして返却します。


# ■package

packageの関数です。

```c
int lisp_package_(addr x, addr pos);
int lisp_package8_(addr x, const void *str);
int lisp_package16_(addr x, const void *str);
int lisp_package32_(addr x, const void *str);
```

## 脱出関数`lisp_package_`

```c
int lisp_package_(addr x, addr pos);

入力: pos package-designer
出力: x hold変数
戻り値: 脱出時は0以外
```

`pos`が表す名前のpackageを返却します。  
`pos`がhold変数の場合は、内容が使用されます。


## 脱出関数`lisp_package8_`

```c
int lisp_package8_(addr x, const void *str);
int lisp_package16_(addr x, const void *str);
int lisp_package32_(addr x, const void *str);

入力: str Unicode文字列
出力: x hold変数
戻り値: 脱出時は0以外
```

`str`が表す名前のpackageを返却します。  
Unicode文字列の詳細は`lisp_string8_`関数をご確認ください。


## 脱出関数`lisp_package16_`

`lisp_package8_`で解説


## 脱出関数`lisp_package32_`

`lisp_package8_`で解説


# ■intern

internの関数です。

```c
int lisp_intern_(addr x, addr package, addr name);
int lisp_intern8_(addr x, const void *package, const void *name);
int lisp_intern16_(addr x, const void *package, const void *name);
int lisp_intern32_(addr x, const void *package, const void *name);
```


## 脱出関数`lisp_intern_`

```c
int lisp_intern_(addr x, addr package, addr name);

入力: package package-designerかnil
入力: name 文字列
出力: x hold変数
戻り値: 脱出時は0以外
```

`package`に`name`で表す名前のsymbolをinternします。  
`package`が`nil`か`NULL`の場合は`*package*`の値が使用されます。  
`package`と`name`がhold変数の場合は、内容が使用されます。


## 脱出関数`lisp_intern8_`

```c
int lisp_intern8_(addr x, const void *package, const void *name);
int lisp_intern16_(addr x, const void *package, const void *name);
int lisp_intern32_(addr x, const void *package, const void *name);

入力: package Unicode文字列かNULL
入力: name Unicode文字列
出力: x hold変数
戻り値: 脱出時は0以外
```

`package`に`name`で表す名前のsymbolをinternします。  
`package`が`NULL`の場合は`*package*`の値が使用されます。  
Unicode文字列の詳細は`lisp_string8_`関数をご確認ください。


## 脱出関数`lisp_intern16_`

`lisp_intern8_`で解説


## 脱出関数`lisp_intern32_`

`lisp_intern8_`で解説


# ■reader

readerによる読み込みの関数です。

```c
int lisp_reader_(addr x, addr str);
int lisp_reader8_(addr x, const void *str);
int lisp_reader16_(addr x, const void *str);
int lisp_reader32_(addr x, const void *str);
```


## 脱出関数`lisp_reader_`

```c
int lisp_reader_(addr x, addr str);

入力: str 文字列
出力: x hold変数
戻り値: 脱出時に0以外
```

文字列の`str`をreaderで読み込みます。  
`read-from-string`関数と同等です。  
何も読み込めなかったときはNULLが返却されます。  
NULLかどうかは`lisp_null_p`関数で確認できます。  
`str`がhold変数の場合は、内容が使用されます。


## 脱出関数`lisp_reader8_`

```c
int lisp_reader8_(addr x, const void *str);
int lisp_reader16_(addr x, const void *str);
int lisp_reader32_(addr x, const void *str);

入力: str Unicode文字列
出力: x hold変数
戻り値: 脱出時は0以外
```

文字列の`str`をreaderで読み込みます。  
`read-from-string`関数と同等です。  
何も読み込めなかったときはNULLが返却されます。  
NULLかどうかは`lisp_null_p`関数で確認できます。  
Unicode文字列の詳細は`lisp_string8_`関数をご確認ください。


## 脱出関数`lisp_reader16_`

`lisp_reader8_`で解説


## 脱出関数`lisp_reader32_`

`lisp_reader8_`で解説


# ■pathname

pathnameの関数です。

```c
int lisp_pathname_(addr x, addr name);
int lisp_pathname8_(addr x, const void *str);
int lisp_pathname16_(addr x, const void *str);
int lisp_pathname32_(addr x, const void *str);
int lisp_namestring_(addr x, addr path);
```


## 脱出関数`lisp_pathname_`

```c
int lisp_pathname_(addr x, addr name);

入力: name pathname-designer
出力: x hold変数
戻り値: 脱出時は0以外
```

文字列`name`をpathnameに変換します。  
`parse-namestring`関数と同等です。  
`name`がhold変数の時は、内容が使用されます。


## 脱出関数`lisp_pathname8_`

```c
int lisp_pathname8_(addr x, const void *str);
int lisp_pathname16_(addr x, const void *str);
int lisp_pathname32_(addr x, const void *str);

入力: str Unicode文字列
出力: x hold変数
戻り値: 脱出時は0以外
```

文字列`str`をpathnameに変換します。  
`parse-namestring`関数と同等です。  
Unicode文字列の詳細は`lisp_string8_`関数をご確認ください。


## 脱出関数`lisp_pathname16_`

`lisp_pathname8_`で解説


## 脱出関数`lisp_pathname32_`

`lisp_pathname8_`で解説


## 脱出関数`lisp_namestring_`

```c
int lisp_namestring_(addr x, addr path);

入力: path pathname-designer
出力: x hold変数
戻り値: 脱出時に0以外
```

pathnameオブジェクトで`path`を文字列に変換します。  
`namestring`関数と同等です。  
`path`がhold変数の時は、内容が使用されます。
