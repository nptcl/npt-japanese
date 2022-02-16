% 関数仕様 - 実行

nptのドキュメントです。  
参照元：[ANSI Common Lisp npt](index.html)


# 関数仕様

`lisp.h`に記載されている下記の関数仕様を示します。

```c
■eval
int lisp_eval_(addr x, addr pos);
int lisp_eval8_(addr x, const void *str);
int lisp_eval16_(addr x, const void *str);
int lisp_eval32_(addr x, const void *str);

■funcall
int lisp_funcall_(addr x, addr call, ...);
int lisp_funcall8_(addr x, const void *str, ...);
int lisp_funcall16_(addr x, const void *str, ...);
int lisp_funcall32_(addr x, const void *str, ...);

■apply
int lisp_apply_(addr x, addr call, ...);
int lisp_apply8_(addr x, const void *str, ...);
int lisp_apply16_(addr x, const void *str, ...);
int lisp_apply32_(addr x, const void *str, ...);

■低レベル実行
int lisp_eval_control_(addr eval);
int lisp_eval_string_control_(addr eval);
int lisp_funcall_control_(addr call, ...);
int lisp_apply_control_(addr call, ...);

■返却値操作
void lisp_result_control(addr x);
void lisp_result2_control(addr x, addr y);
void lisp_values_control(addr x);
void lisp_nth_value_control(addr x, size_t index);
void lisp_set_result_control(addr value);
void lisp_set_values_control(addr first, ...);
void lisp_set_values_nil_control(void);
void lisp_set_values_list_control(addr list);

■脱出操作
int lisp_break_control(void);
int lisp_escape_control(void);
void lisp_reset_control(void);
enum lisp_escape lisp_escape_type_control(void);
void lisp_save_control(addr *ret);
void lisp_rollback_control(addr value);

■その他
int lisp_eval_loop_(void);
```


# ■eval

`eval`の関数です。

```c
int lisp_eval_(addr x, addr pos);
int lisp_eval8_(addr x, const void *str);
int lisp_eval16_(addr x, const void *str);
int lisp_eval32_(addr x, const void *str);
```


## 脱出関数`lisp_eval_`

```c
int lisp_eval_(addr x, addr pos);

入力: pos オブジェクト
出力: x hold変数かNULL
戻り値: 脱出時は0以外
```

`pos`をLisp式として`eval`を実行します。  
`pos`がhold変数の場合は、内容を使用します。  
`x`には`eval`実行結果の第1返却値が格納されます。  
もし`x`が`NULL`のときは、返却値は無視されます。

## 脱出関数`lisp_eval8_`

```c
int lisp_eval8_(addr x, const void *str);
int lisp_eval16_(addr x, const void *str);
int lisp_eval32_(addr x, const void *str);

入力: str Unicode文字列
出力: x hold変数かNULL
戻り値: 脱出時は0以外
```

`str`をreaderでオブジェクトに変換してから`eval`を実行します。  
`x`には`eval`実行結果の第1返却値が格納されます。  
もし`x`が`NULL`のときは、返却値は無視されます。  
Unicode文字列の詳細は`lisp_string8_`関数をご確認ください。


## 脱出関数`lisp_eval16_`

`lisp_eval8_`で解説


## 脱出関数`lisp_eval32_`

`lisp_eval8_`で解説


# ■funcall

`funcall`の関数です。

```c
int lisp_funcall_(addr x, addr call, ...);
int lisp_funcall8_(addr x, const void *str, ...);
int lisp_funcall16_(addr x, const void *str, ...);
int lisp_funcall32_(addr x, const void *str, ...);
```


## 脱出関数`lisp_funcall_`

```c
int lisp_funcall_(addr x, addr call, ...);

入力: call symbolかfunction
入力: 可変引数
出力: x hold変数
戻り値: 脱出時は0以外
```

`call`で指定した関数を実行します。  
Common Lispの`funcall`と同等です。  
可変引数は`NULL`で終端します。  
`x`には関数実行の第1返却値が格納されます。  
もし`x`が`NULL`のときは、返却値は無視されます。  
`call`と可変引数がhold変数の場合は、内容が使用されます。


## 脱出関数`lisp_funcall8_`

```c
int lisp_funcall8_(addr x, const void *str, ...);
int lisp_funcall16_(addr x, const void *str, ...);
int lisp_funcall32_(addr x, const void *str, ...);

入力: str Unicode文字列
入力: 可変引数
出力: x hold変数
戻り値: 脱出時は0以外
```

`str`という名前の関数を実行します。  
Common Lispの`funcall`と同等です。  
可変引数は`NULL`で終端します。  
`x`には関数実行の第1返却値が格納されます。  
もし`x`が`NULL`のときは、返却値は無視されます。  
可変引数がhold変数の場合は、内容が使用されます。  
Unicode文字列の詳細は`lisp_string8_`関数をご確認ください。

実行例を下記に示します。

```c
lisp_fixnum(x, 10);
lisp_fixnum(y, 20);
lisp_fixnum(z, 30);
lisp_funcall8_(x, "+", x, y, z, NULL);

x -> 60
```


## 脱出関数`lisp_funcall16_`

`lisp_funcall8_`で解説


## 脱出関数`lisp_funcall32_`

`lisp_funcall8_`で解説


# ■apply

`apply`の関数です。

```c
int lisp_apply_(addr x, addr call, ...);
int lisp_apply8_(addr x, const void *str, ...);
int lisp_apply16_(addr x, const void *str, ...);
int lisp_apply32_(addr x, const void *str, ...);
```


## 脱出関数`lisp_apply_`

```c
int lisp_apply_(addr x, addr call, ...);

入力: call symbolかfunction
入力: 可変引数
出力: x hold変数
戻り値: 脱出時は0以外
```

`call`で指定した関数を実行します。  
Common Lispの`apply`と同等です。  
可変引数は`NULL`で終端し最後の要素が`cdr`部になります。  
`x`には関数実行の第1返却値が格納されます。  
もし`x`が`NULL`のときは、返却値は無視されます。  
`call`と可変引数がhold変数の場合は、内容が使用されます。


## 脱出関数`lisp_apply8_`

```c
int lisp_apply8_(addr x, const void *str, ...);
int lisp_apply16_(addr x, const void *str, ...);
int lisp_apply32_(addr x, const void *str, ...);

入力: str Unicode文字列
入力: 可変引数
出力: x hold変数
戻り値: 脱出時は0以外
```

`str`という名前の関数を実行します。  
Common Lispの`apply`と同等です。  
可変引数は`NULL`で終端し最後の要素が`cdr`部になります。  
`x`には関数実行の第1返却値が格納されます。  
もし`x`が`NULL`のときは、返却値は無視されます。  
可変引数がhold変数の場合は、内容が使用されます。  
Unicode文字列の詳細は`lisp_string8_`関数をご確認ください。

実行例を下記に示します。

```c
lisp_fixnum(x, 10);
lisp_fixnum(y, 20);
lisp_fixnum(z, 30);
lisp_list_(x, x, y, z, NULL);
lisp_apply8_(x, "+", x, NULL);

x -> 60
```


## 脱出関数`lisp_apply16_`

`lisp_apply8_`で解説


## 脱出関数`lisp_apply32_`

`lisp_apply8_`で解説


# ■低レベル実行

実行の低レベル操作版です。

```c
int lisp_eval_control_(addr eval);
int lisp_eval_string_control_(addr eval);
int lisp_funcall_control_(addr call, ...);
int lisp_apply_control_(addr call, ...);
```


## 脱出関数`lisp_eval_control_`

```c
int lisp_eval_control_(addr eval);

入力: eval オブジェクト
戻り値: 脱出時は0以外
```

引数`eval`をevalで実行します。  
返却値を取得するには、返却値のアクセス関数を使用します。


## 脱出関数`lisp_eval_string_control_`

```c
int lisp_eval_string_control_(addr eval);

入力: eval 文字列
戻り値: 脱出時は0以外
```

引数`eval`を`reader`でオブジェクトに変換してからevalで実行します。  
返却値を取得するには、返却値のアクセス関数を使用します。


## 脱出関数`lisp_funcall_control_`

```c
int lisp_funcall_control_(addr call, ...);

入力: call symbolかfunction
入力: 可変引数
戻り値: 脱出時は0以外
```

`call`で指定した関数を実行します。  
Common Lispの`funcall`と同等です。  
可変引数は`NULL`で終端します。  
`call`と可変引数がhold変数の場合は、内容が使用されます。
返却値を取得するには、返却値のアクセス関数を使用します。


## 脱出関数`lisp_apply_control_`

```c
int lisp_apply_control_(addr call, ...);

入力: call symbolかfunction
入力: 可変引数
戻り値: 脱出時は0以外
```

`call`で指定した関数を実行します。  
Common Lispの`apply`と同等です。  
可変引数は`NULL`で終端し最後の要素が`cdr`部になります。  
`call`と可変引数がhold変数の場合は、内容が使用されます。
返却値を取得するには、返却値のアクセス関数を使用します。


# ■返却値操作

返却値を操作する関数です。

```c
void lisp_result_control(addr x);
void lisp_result2_control(addr x, addr y);
void lisp_values_control(addr x);
void lisp_nth_value_control(addr x, size_t index);
void lisp_set_result_control(addr value);
void lisp_set_values_control(addr first, ...);
void lisp_set_values_nil_control(void);
void lisp_set_values_list_control(addr list);
```


## 関数`lisp_result_control`

```c
void lisp_result_control(addr x);

出力: x hold変数
```

第1返却値を取得します。  
もし返却値が0個の場合は`NIL`です。


## 関数`lisp_result2_control`

```c
void lisp_result2_control(addr x, addr y);

出力: x, y hold変数
```

第1返却値を`x`に、第2返却値を`y`に取得します。  
もし対応する返却値が存在しない場合は`NIL`が返却されます。


## 関数`lisp_values_control`

```c
void lisp_values_control(addr x);

出力: x hold変数
```

返却値をリストとして取得します。  
Common Lispの`multiple-value-list`と同じです。


## 関数`lisp_nth_value_control`

```c
void lisp_nth_value_control(addr x, size_t index);

入力: index 取得インデックス
出力: x hold変数
```

`index`番目の返却値を取得します。  
Common Lispの`nth-value`とほぼ同じです。  
対応する値が存在しない場合は`NIL`が返却されます。


# ■脱出操作

脱出の操作関数です。

```c
int lisp_break_control(void);
int lisp_escape_control(void);
void lisp_reset_control(void);
enum lisp_escape lisp_escape_type_control(void);
void lisp_save_control(addr *ret);
void lisp_rollback_control(addr value);
```


## 関数`lisp_break_control`

```c
int lisp_break_control(void);

戻り値: bool値
```

脱出から非脱出に切り替わるタイミングを調査します。  
現在脱出モードであり、あつ現在のスタックフレームが
脱出先のスタックフレームである場合は真を返却します。  
非脱出時にも実行できますが、必ず0を返却します。  


## 関数`lisp_escape_control`

```c
int lisp_escape_control(void);

戻り値: 脱出時は0以外
```

現在脱出中かどうかを調査します。  
通常時であれば0、脱出時であれば0以外が返却されます。  

## 関数`lisp_reset_control`

```c
void lisp_reset_control(void);
```

脱出を中断して通常時（非脱出）に切り替えます。  
脱出の理由は破棄されます。


## 関数`lisp_escape_type_control`

```c
enum lisp_escape lisp_escape_type_control(void);

戻り値: 脱出モード
```

脱出のモードを調査します。  
戻り値は下記のとおりです。

| 戻り値 | モード |
| --- | --- |
| lisp_escape_normal | 非脱出時 |
| lisp_escape_tagbody | `tagbody`/`go`による脱出中 |
| lisp_escape_block | `block`/`return-from`による脱出中 |
| lisp_escape_catch | `catch`/`throw`による脱出中 |
| lisp_escape_handler_case | `handler-case`による脱出中 |
| lisp_escape_restart_case | `restart-case`による脱出中 |


## 関数`lisp_save_control`

```c
void lisp_save_control(addr *ret);

出力: ret 退避用オブジェクト
```

脱出情報と戻り値を退避させます。  
退避用に専用のオブジェクトを生成し、
現在のスタックフレーム上に配置します。  

`unwind-protect`の`cleanup`フォームを実行するときに使います。


## 関数`lisp_rollback_control`

```c
void lisp_rollback_control(addr value);

入力: value 退避用オブジェクト
```

`lisp_save_control`で作成した退避用オブジェクトを用いて、
脱出情報と戻り値を更新します。  
`value`がhold変数の場合はエラーです。


# ■その他

その他の操作関数です。

```c
int lisp_eval_loop_(void);
```


## 脱出関数`lisp_eval_loop_`

```c
int lisp_eval_loop_(void);

戻り値: 脱出時は0以外
```

`eval-loop`に移行します。
