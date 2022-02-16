% 関数仕様 - 型関数

% 関数仕様 - 型関数

nptのドキュメントです。  
参照元：[ANSI Common Lisp npt](index.html)

# 関数仕様

`lisp.h`に記載されている下記の関数仕様を示します。

```c
■hold関数
int lisp_hold_p(addr x);
void lisp_hold_value(addr x, addr *ret);
void lisp_hold_set(addr x, addr value);
addr Lisp_holdv(addr x);
void lisp_hold(addr *ret, addr value);
addr Lisp_hold(void);

■nil, t
void lisp_nil(addr x);
void lisp_t(addr x);
addr Lisp_nil(void);
addr Lisp_t(void);

■type
int lisp_nil_p(addr x);
int lisp_t_p(addr x);
int lisp_null_p(addr x);
int lisp_character_p(addr x);
int lisp_cons_p(addr x);
int lisp_list_p(addr x);
int lisp_string_p(addr x);
int lisp_symbol_p(addr x);
int lisp_strvect_p(addr x);
int lisp_array_p(addr x);
int lisp_vector_p(addr x);

■数値型
int lisp_fixnum_p(addr x);
int lisp_bignum_p(addr x);
int lisp_integer_p(addr x);
int lisp_ratio_p(addr x);
int lisp_rational_p(addr x);
int lisp_single_float_p(addr x);
int lisp_double_float_p(addr x);
int lisp_long_float_p(addr x);
int lisp_float_p(addr x);
int lisp_real_p(addr x);
int lisp_complex_p(addr x);
int lisp_number_p(addr x);

■オブジェクト
int lisp_clos_p(addr x);
int lisp_hashtable_p(addr x);
int lisp_readtable_p(addr x);
int lisp_control_p(addr x);
int lisp_callname_p(addr x);
int lisp_function_p(addr x);
int lisp_package_p(addr x);
int lisp_random_state_p(addr x);
int lisp_pathname_p(addr x);
int lisp_stream_p(addr x);
int lisp_restart_p(addr x);
int lisp_environment_p(addr x);
int lisp_bitvector_p(addr x);
int lisp_print_dispatch_p(addr x);
```

# ■hold関数

hold変数の操作関数です。

```c
int lisp_hold_p(addr x);
void lisp_hold_value(addr x, addr *ret);
void lisp_hold_set(addr x, addr value);
addr Lisp_holdv(addr x);
void lisp_hold(addr *ret, addr value);
addr Lisp_hold(void);
```

## 関数 `lisp_hold_p`

```c
int lisp_hold_p(addr x);

入力: x オブジェクト
戻り値: bool値
```

`x`がhold変数の場合は0以外を返却します。  


## 関数 `lisp_hold_value`

```c
void lisp_hold_value(addr x, addr *ret);

入力: x オブジェクト
出力: ret オブジェクトの返却
```

もし`x`がhold変数の場合は、値を取り出し`ret`に返却します。  
もし`x`がhold変数ではない場合は、`x`をそのまま`ret`に返却します。


## 関数 `lisp_hold_set`

```c
void lisp_hold_set(addr x, addr value);

入力: x hold変数
入力: value オブジェクト
```

hold変数`x`にオブジェクトを格納します。  
もし`value`がhold変数の場合は、
`value`が保有しているオブジェクトを`x`に格納します。


## 関数`Lisp_holdv`

```c
addr Lisp_holdv(addr x);

入力: x オブジェクト
戻り値: オブジェクト
```

関数`lisp_hold_value`のinplace版です。  
`x`がhold変数の場合は、格納されているオブジェクトを返却します。  
`x`がhold変数ではない場合は、入力をそのまま返却します。


## 関数 `lisp_hold`

```c
void lisp_hold(addr *ret, addr value);

入力: value オブジェクト
出力: ret hold変数
```

hold変数を作成し、`value`を格納してから`ret`に返却します。  
もし`value`がhold変数の場合は、値を取り出してから格納します。


## 関数 `Lisp_hold`

```c
addr Lisp_hold(void);

戻り値: hold変数
```

hold変数を作成し返却します。  
hold変数が保有する値は`NIL`です。


# ■nil, t

`nil`と`t`オブジェクトの格納関数です。

```c
void lisp_nil(addr x);
void lisp_t(addr x);
addr Lisp_nil(void);
addr Lisp_t(void);
```

## 関数`lisp_nil`

```c
void lisp_nil(addr x);

出力: x hold変数
```

hold変素`x`に`nil`オブジェクトを格納します。

## 関数`lisp_t`

```c
void lisp_t(addr x);

出力: x hold変数
```

hold変素`x`に`t`オブジェクトを格納します。


## 関数`Lisp_nil`

```c
addr Lisp_nil(void);

戻り値: nil
```

`nil`オブジェクトを返却します。


## 関数`Lisp_t`

```c
addr Lisp_t(void);

戻り値: t
```

`t`オブジェクトを返却します。


# ■type

型チェックの関数です。

```c
■type
int lisp_nil_p(addr x);
int lisp_t_p(addr x);
int lisp_null_p(addr x);
int lisp_character_p(addr x);
int lisp_cons_p(addr x);
int lisp_list_p(addr x);
int lisp_string_p(addr x);
int lisp_symbol_p(addr x);
int lisp_strvect_p(addr x);
int lisp_array_p(addr x);
int lisp_vector_p(addr x);
```

## 関数`lisp_nil_p`

```c
int lisp_nil_p(addr x);

入力: x オブジェクト
戻り値: bool値
```

`x`がhold変数の場合は、内容が評価されます。  
`x`が`nil`であれば0以外を返却します。


## 関数`lisp_t_p`

```c
int lisp_t_p(addr x);

入力: x オブジェクト
戻り値: bool値
```

`x`がhold変数の場合は、内容が評価されます。  
`x`が`t`であれば0以外を返却します。


## 関数`lisp_null_p`

```c
int lisp_null_p(addr x);

入力: x オブジェクト
戻り値: bool値
```

`x`がhold変数の場合は、内容が評価されます。  
`x`がNULLポインターであれば0以外を返却します。  
NULLポインターはC言語の`(void *)0`のことであり、
Common Lispの`NIL`とは違います。


## 関数`lisp_character_p`

```c
int lisp_character_p(addr x);

入力: x オブジェクト
戻り値: bool値
```

`x`がhold変数の場合は、内容が評価されます。  
`x`が文字型であれば0以外を返却します。


## 関数`lisp_cons_p`

```c
int lisp_cons_p(addr x);

入力: x オブジェクト
戻り値: bool値
```

`x`がhold変数の場合は、内容が評価されます。  
`x`がconsであれば0以外を返却します。


## 関数`lisp_list_p`

```c
int lisp_list_p(addr x);

入力: x オブジェクト
戻り値: bool値
```

`x`がhold変数の場合は、内容が評価されます。  
`x`がlistであれば0以外を返却します。  
listとは、`NIL`かconsのことです。


## 関数`lisp_string_p`

```c
int lisp_string_p(addr x);

入力: x オブジェクト
戻り値: bool値
```

`x`がhold変数の場合は、内容が評価されます。  
`x`がstringであれば0以外を返却します。  
stringとは、`LISPTYPE_STRING`型のオブジェクトか、
あるいは`LISPTYPE_ARRAY`型でかつ
1次元のcharacter型specialized arrayのことです。

## 関数`lisp_strvect_p`

```c
int lisp_strvect_p(addr x);

入力: x オブジェクト
戻り値: bool値
```

`x`がhold変数の場合は、内容が評価されます。  
`x`が`LISPTYPE_STRING`型であれば0以外を返却します。  
Common Lispの`stringp`とは違います。


## 関数`lisp_symbol_p`

```c
int lisp_symbol_p(addr x);

入力: x オブジェクト
戻り値: bool値
```

`x`がhold変数の場合は、内容が評価されます。  
`x`がsymbolであれば0以外を返却します。


## 関数`lisp_array_p`

```c
int lisp_array_p(addr x);

入力: x オブジェクト
戻り値: bool値
```

`x`がhold変数の場合は、内容が評価されます。  
`x`が`LISPTYPE_ARRAY`型であれば0以外を返却します。  
Common Lispの`arrayp`とは違います。


## 関数`lisp_vector_p‘

```c
int lisp_vector_p(addr x);

入力: x オブジェクト
戻り値: bool値
```

`x`がhold変数の場合は、内容が評価されます。  
`x`が`LISPTYPE_VECTOR`型であれば0以外を返却します。  
Common Lispの`vectorp`とは違います。


# ■数値型

数値型の型関数です。

```c
int lisp_fixnum_p(addr x);
int lisp_bignum_p(addr x);
int lisp_integer_p(addr x);
int lisp_ratio_p(addr x);
int lisp_rational_p(addr x);
int lisp_single_float_p(addr x);
int lisp_double_float_p(addr x);
int lisp_long_float_p(addr x);
int lisp_float_p(addr x);
int lisp_real_p(addr x);
int lisp_complex_p(addr x);
int lisp_number_p(addr x);
```

## 関数`lisp_fixnum_p`

```c
int lisp_fixnum_p(addr x);

入力: x オブジェクト
戻り値: bool値
```

`x`がhold変数の場合は、内容が評価されます。  
`x`が`LISPTYPE_FIXNUM`型であれば0以外を返却します。  
Common Lispの`(typep x 'fixnum)`とは厳密には違いますが、
通常の使用で差異が生じることはありません。


## 関数`lisp_bignum_p`

```c
int lisp_bignum_p(addr x);

入力: x オブジェクト
戻り値: bool値
```

`x`がhold変数の場合は、内容が評価されます。  
`x`が`LISPTYPE_BIGNUM`型であれば0以外を返却します。  


## 関数`lisp_integer_p`

```c
int lisp_integer_p(addr x);

入力: x オブジェクト
戻り値: bool値
```

`x`がhold変数の場合は、内容が評価されます。  
`x`が`integer`型であれば0以外を返却します。  


## 関数`lisp_ratio_p`

```c
int lisp_ratio_p(addr x);

入力: x オブジェクト
戻り値: bool値
```

`x`がhold変数の場合は、内容が評価されます。  
`x`が`ratio`型であれば0以外を返却します。  


## 関数`lisp_rational_p`

```c
int lisp_rational_p(addr x);

入力: x オブジェクト
戻り値: bool値
```

`x`がhold変数の場合は、内容が評価されます。  
`x`が`rational`型であれば0以外を返却します。  


## 関数`lisp_single_float_p`

```c
int lisp_single_float_p(addr x);

入力: x オブジェクト
戻り値: bool値
```

`x`がhold変数の場合は、内容が評価されます。  
`x`が`single-float`型であれば0以外を返却します。  


## 関数`lisp_double_float_p`

```c
int lisp_double_float_p(addr x);

入力: x オブジェクト
戻り値: bool値
```

`x`がhold変数の場合は、内容が評価されます。  
`x`が`double-float`型であれば0以外を返却します。  


## 関数`lisp_long_float_p`

```c
int lisp_long_float_p(addr x);

入力: x オブジェクト
戻り値: bool値
```

`x`がhold変数の場合は、内容が評価されます。  
`x`が`long-float`型であれば0以外を返却します。  


## 関数`lisp_float_p`

```c
int lisp_float_p(addr x);

入力: x オブジェクト
戻り値: bool値
```

`x`がhold変数の場合は、内容が評価されます。  
`x`が`float`型であれば0以外を返却します。  


## 関数`lisp_real_p`

```c
int lisp_real_p(addr x);

入力: x オブジェクト
戻り値: bool値
```

`x`がhold変数の場合は、内容が評価されます。  
`x`が`real`型であれば0以外を返却します。  


## 関数`lisp_complex_p`

```c
int lisp_complex_p(addr x);

入力: x オブジェクト
戻り値: bool値
```

`x`がhold変数の場合は、内容が評価されます。  
`x`が`complex`型であれば0以外を返却します。  


## 関数`lisp_number_p`

```c
int lisp_number_p(addr x);

入力: x オブジェクト
戻り値: bool値
```

`x`がhold変数の場合は、内容が評価されます。  
`x`が`number`型であれば0以外を返却します。  
