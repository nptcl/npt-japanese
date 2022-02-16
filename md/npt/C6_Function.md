% 関数仕様 - 関数

nptのドキュメントです。  
参照元：[ANSI Common Lisp npt](index.html)


# 関数仕様

`lisp.h`に記載されている下記の関数仕様を示します。

```c
■function
void lisp_get_function(addr x, addr symbol);
void lisp_get_setf(addr x, addr symbol);
int lisp_get_function_(addr x, addr value);
int lisp_get_function8_(addr x, const void *str);
int lisp_get_function16_(addr x, const void *str);
int lisp_get_function32_(addr x, const void *str);
int lisp_get_setf_(addr x, addr value);
int lisp_get_setf8_(addr x, const void *str);
int lisp_get_setf16_(addr x, const void *str);
int lisp_get_setf32_(addr x, const void *str);

■compiled-function
void lisp_compiled_dynamic(int index, lisp_calltype_dynamic call);
void lisp_compiled_rest(int index, lisp_calltype_rest call);
void lisp_compiled_empty(int index, lisp_calltype_empty call);
void lisp_compiled_var1(int index, lisp_calltype_var1 call);
void lisp_compiled_var2(int index, lisp_calltype_var2 call);
void lisp_compiled_var3(int index, lisp_calltype_var3 call);

int lisp_compiled_function_(addr x, int index, addr symbol);
int lisp_compiled_function8_(addr x, int index, const void *str);
int lisp_compiled_function16_(addr x, int index, const void *str);
int lisp_compiled_function32_(addr x, int index, const void *str);
int lisp_compiled_defun_(int index, addr symbol);
int lisp_compiled_defun8_(int index, const void *str);
int lisp_compiled_defun16_(int index, const void *str);
int lisp_compiled_defun32_(int index, const void *str);
int lisp_compiled_defun_setf_(int index, addr symbol);
int lisp_compiled_defun_setf8_(int index, const void *str);
int lisp_compiled_defun_setf16_(int index, const void *str);
int lisp_compiled_defun_setf32_(int index, const void *str);

void lisp_compiled_setvalue(addr pos, addr value);
void lisp_compiled_getvalue(addr *ret);
```


# ■function

symbolから関数オブジェクトを取得する関数です。

```c
void lisp_get_function(addr x, addr symbol);
void lisp_get_setf(addr x, addr symbol);
int lisp_get_function_(addr x, addr value);
int lisp_get_function8_(addr x, const void *str);
int lisp_get_function16_(addr x, const void *str);
int lisp_get_function32_(addr x, const void *str);
int lisp_get_setf_(addr x, addr value);
int lisp_get_setf8_(addr x, const void *str);
int lisp_get_setf16_(addr x, const void *str);
int lisp_get_setf32_(addr x, const void *str);
```

## 関数`lisp_get_function`

```c
void lisp_get_function(addr x, addr symbol);

入力: symbol symbol型オブジェクト
出力: x hold変数
```

symbolから関数オブジェクトを取得します。  
Common Lispの`symbol-function`と同じです。  
`value`がhold変数の場合は、内容を使用します。  
関数が`unbound`の場合は`NULL`が返却されます。  
引数がsymbol型ではない場合は`LISP ABORT`します。


## 関数`lisp_get_setf`

```c
void lisp_get_setf(addr x, addr symbol);

入力: symbol symbol型オブジェクト
出力: x hold変数
```

symbolから`setf`の関数オブジェクトを取得します。  
Common Lispの`(fdefinition (list 'setf symbol))`と同じです。  
`value`がhold変数の場合は、内容を使用します。  
関数が`unbound`の場合は`NULL`が返却されます。  
引数がsymbol型ではない場合は`LISP ABORT`します。


## 脱出関数`lisp_get_function_`

```c
int lisp_get_function_(addr x, addr value);

入力: value オブジェクト
出力: x hold変数
戻り値: 脱出時は0以外
```

`value`がsymbolの場合は関数を取得します。  
`value`がfunction型の場合は値をそのまま返却します。  
`value`がhold変数の場合は、内容を使用します。  
関数が`unbound`の場合は`NULL`が返却されます。  


## 脱出関数`lisp_get_function8_`

```c
int lisp_get_function8_(addr x, const void *str);
int lisp_get_function16_(addr x, const void *str);
int lisp_get_function32_(addr x, const void *str);

入力: str Unicode文字列
出力: x hold変数
戻り値: 脱出時は0以外
```

`str`をsymbol名として関数を取得します。  
関数が`unbound`の場合は`NULL`が返却されます。  
Unicode文字列の詳細は`lisp_string8_`関数をご確認ください。


## 脱出関数`lisp_get_function16_`

`lisp_get_function8_`で解説


## 脱出関数`lisp_get_function32_`

`lisp_get_function8_`で解説


## 脱出関数`lisp_get_setf_`

```c
int lisp_get_setf_(addr x, addr value);

入力: value オブジェクト
出力: x hold変数
戻り値: 脱出時は0以外
```

`value`がsymbolの場合は`setf`関数を取得します。  
`value`がfunction型の場合は値をそのまま返却します。  
`value`がhold変数の場合は、内容を使用します。  
関数が`unbound`の場合は`NULL`が返却されます。  


## 脱出関数`lisp_get_setf8_`

```c
int lisp_get_setf8_(addr x, const void *str);
int lisp_get_setf16_(addr x, const void *str);
int lisp_get_setf32_(addr x, const void *str);

入力: str Unicode文字列
出力: x hold変数
戻り値: 脱出時は0以外
```

`str`をsymbol名として`setf`関数を取得します。  
関数が`unbound`の場合は`NULL`が返却されます。  
Unicode文字列の詳細は`lisp_string8_`関数をご確認ください。


## 脱出関数`lisp_get_setf16_`

`lisp_get_setf8_`で解説


## 脱出関数`lisp_get_setf32_`

`lisp_get_setf8_`で解説


# ■compiled-function

関数作成のための関数です。

```c
void lisp_compiled_dynamic(int index, lisp_calltype_dynamic call);
void lisp_compiled_rest(int index, lisp_calltype_rest call);
void lisp_compiled_empty(int index, lisp_calltype_empty call);
void lisp_compiled_var1(int index, lisp_calltype_var1 call);
void lisp_compiled_var2(int index, lisp_calltype_var2 call);
void lisp_compiled_var3(int index, lisp_calltype_var3 call);

int lisp_compiled_function_(addr x, int index, addr symbol);
int lisp_compiled_function8_(addr x, int index, const void *str);
int lisp_compiled_function16_(addr x, int index, const void *str);
int lisp_compiled_function32_(addr x, int index, const void *str);
int lisp_compiled_defun_(int index, addr symbol);
int lisp_compiled_defun8_(int index, const void *str);
int lisp_compiled_defun16_(int index, const void *str);
int lisp_compiled_defun32_(int index, const void *str);
int lisp_compiled_defun_setf_(int index, addr symbol);
int lisp_compiled_defun_setf8_(int index, const void *str);
int lisp_compiled_defun_setf16_(int index, const void *str);
int lisp_compiled_defun_setf32_(int index, const void *str);

void lisp_compiled_setvalue(addr pos, addr value);
void lisp_compiled_getvalue(addr *ret);
```


## 関数`lisp_compiled_dynamic`

```c
void lisp_compiled_dynamic(int index, lisp_calltype_dynamic call);

入力: index 関数番号
入力: call 関数ポインタ int (*call)(addr)
```

関数ポインタ`call`を`index`番目に登録します。  
`index`は0～31までの値であり、
上限値31はdefine値`LISP_POINTER_EXTEND`で設定できます。

Lispから呼び出されると、引数を`&rest`指定のようにリストとして第1引数に渡してます。  
`rest`と違い、リストは`dynamic-extent`で確保されるため、
関数の返却値には設定できません。

下記の宣言のような関数が作成されます。

```lisp
(defun name (&rest args)
  (declare (dynamic-extent args)
  ...)
```


## 関数`lisp_compiled_rest`

```c
void lisp_compiled_rest(int index, lisp_calltype_rest call);

入力: index 関数番号
入力: call 関数ポインタ int (*call)(addr)
```

関数ポインタ`call`を`index`番目に登録します。  
`index`は0～31までの値であり、
上限値31はdefine値`LISP_POINTER_EXTEND`で設定できます。

Lispから呼び出されると、引数を`&rest`指定のようにリストとして第1引数に渡してます。  
`dynamic`と違い、リストはheap領域に確保されるため、関数の返却値に設定できます。

下記の宣言のような関数が作成されます。

```lisp
(defun name (&rest args)
  ...)
```


## 関数`lisp_compiled_empty`

```c
void lisp_compiled_empty(int index, lisp_calltype_empty call);

入力: index 関数番号
入力: call 関数ポインタ int (*call)(void)
```

関数ポインタ`call`を`index`番目に登録します。  
`index`は0～31までの値であり、
上限値31はdefine値`LISP_POINTER_EXTEND`で設定できます。

Lispからは引数無しで呼び出されます。  
引数がある場合はエラーです。  

下記の宣言のような関数が作成されます。

```lisp
(defun name ()
  ...)
```


## 関数`lisp_compiled_var1`

```c
void lisp_compiled_var1(int index, lisp_calltype_var1 call);

入力: index 関数番号
入力: call 関数ポインタ int (*call)(addr)
```

関数ポインタ`call`を`index`番目に登録します。  
`index`は0～31までの値であり、
上限値31はdefine値`LISP_POINTER_EXTEND`で設定できます。

Lispからは引数1つで呼び出されます。  
引数が1つではない場合はエラーです。  

下記の宣言のような関数が作成されます。

```lisp
(defun name (x)
  ...)
```


## 関数`lisp_compiled_var2`

```c
void lisp_compiled_var2(int index, lisp_calltype_var2 call);

入力: index 関数番号
入力: call 関数ポインタ int (*call)(addr, addr)
```

関数ポインタ`call`を`index`番目に登録します。  
`index`は0～31までの値であり、
上限値31はdefine値`LISP_POINTER_EXTEND`で設定できます。

Lispからは引数2つで呼び出されます。  
引数が2つではない場合はエラーです。  

下記の宣言のような関数が作成されます。

```lisp
(defun name (x y)
  ...)
```


## 関数`lisp_compiled_var3`

```c
void lisp_compiled_var3(int index, lisp_calltype_var3 call);

入力: index 関数番号
入力: call 関数ポインタ int (*call)(addr, addr, addr)
```

関数ポインタ`call`を`index`番目に登録します。  
`index`は0～31までの値であり、
上限値31はdefine値`LISP_POINTER_EXTEND`で設定できます。

Lispからは引数3つで呼び出されます。  
引数が3つではない場合はエラーです。  

下記の宣言のような関数が作成されます。

```lisp
(defun name (x y z)
  ...)
```


## 脱出関数`lisp_compiled_function_`

```c
int lisp_compiled_function_(addr x, int index, addr symbol);

入力: index 関数番号
入力: symbol symbolオブジェクトかNULL
戻り値: 脱出時は0以外
```

関数オブジェクトを生成します。  
関数内部で保有する名前は`symbol`に指定します。  
`symbol`がNULLの場合は`NIL`がを使用します。  
`symbol`がhold変数の場合は、内容を使用します。  
オブジェクトが呼び出されると、関数番号に登録した関数ポインタが実行されます。


## 脱出関数`lisp_compiled_function8_`

```c
int lisp_compiled_function8_(addr x, int index, const void *str);
int lisp_compiled_function16_(addr x, int index, const void *str);
int lisp_compiled_function32_(addr x, int index, const void *str);

入力: index 関数番号
入力: str Unicode文字列
戻り値: 脱出時は0以外
```

関数オブジェクトを生成します。  
関数内部で保有する名前は`str`に指定します。  
オブジェクトが呼び出されると、関数番号に登録した関数ポインタが実行されます。  
Unicode文字列の詳細は`lisp_string8_`関数をご確認ください。


## 脱出関数`lisp_compiled_function16_`

`lisp_compiled_function8_`で解説


## 脱出関数`lisp_compiled_function32_`

`lisp_compiled_function8_`で解説


## 脱出関数`lisp_compiled_defun_`

```c
int lisp_compiled_defun_(int index, addr symbol);

入力: index 関数番号
入力: symbol symbolオブジェクト
戻り値: 脱出時は0以外
```

関数を登録します。  
オブジェクトを生成して`symbol-function`に登録します。  
`symbol`がhold変数の場合は、内容を使用します。  
生成された関数が呼び出されると、関数番号に登録した関数ポインタが実行されます。


## 脱出関数`lisp_compiled_defun8_`

```c
int lisp_compiled_defun8_(int index, const void *str);
int lisp_compiled_defun16_(int index, const void *str);
int lisp_compiled_defun32_(int index, const void *str);

入力: index 関数番号
入力: str Unicode文字列
戻り値: 脱出時は0以外
```

関数を登録します。  
オブジェクトを生成して`symbol-function`に登録します。  
生成された関数が呼び出されると、関数番号に登録した関数ポインタが実行されます。  
Unicode文字列の詳細は`lisp_string8_`関数をご確認ください。


## 脱出関数`lisp_compiled_defun16_`

`lisp_compiled_defun8_`で解説


## 脱出関数`lisp_compiled_defun32_`

`lisp_compiled_defun8_`で解説


## 脱出関数`lisp_compiled_defun_setf_`


```c
int lisp_compiled_defun_setf_(int index, addr symbol);

入力: index 関数番号
入力: symbol symbolオブジェクト
戻り値: 脱出時は0以外
```

`symbol`の`setf`関数を登録します。  
`symbol`がhold変数の場合は、内容を使用します。  
生成された関数が呼び出されると、関数番号に登録した関数ポインタが実行されます。


## 脱出関数`lisp_compiled_defun_setf8_`

```c
int lisp_compiled_defun_setf8_(int index, const void *str);
int lisp_compiled_defun_setf16_(int index, const void *str);
int lisp_compiled_defun_setf32_(int index, const void *str);

入力: index 関数番号
入力: str Unicode文字列
戻り値: 脱出時は0以外
```

`symbol`の`setf`関数を登録します。  
生成された関数が呼び出されると、関数番号に登録した関数ポインタが実行されます。  
Unicode文字列の詳細は`lisp_string8_`関数をご確認ください。


## 脱出関数`lisp_compiled_defun_setf16_`

`lisp_compiled_defun_setf8_`で解説


## 脱出関数`lisp_compiled_defun_setf32_`

`lisp_compiled_defun_setf8_`で解説


## 関数`lisp_compiled_getvalue`

```c
void lisp_compiled_getvalue(addr *ret);

出力: ret オブジェクト返却
```

クロージャーから値を取得します。  
値はスタックフレームから取得しますので、
取得前に`lisp_push_control`を使用しないでください。


## 関数`lisp_compiled_setvalue`

```c
void lisp_compiled_setvalue(addr pos, addr value);

入力: pos 関数オブジェクト
入力: value オブジェクトかNULL
```

関数オブジェクトのクロージャーに値を設定します。  
`value`がNULLの場合は`NIL`が使用されます。  
`value`がhold変数の場合は、内容が使用されます。
