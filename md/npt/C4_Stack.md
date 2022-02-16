% 関数仕様 - スタックフレーム

% 関数仕様 - スタックフレーム

nptのドキュメントです。  
参照元：[ANSI Common Lisp npt](index.html)


# 関数仕様

`lisp.h`に記載されている下記の関数仕様を示します。

```c
■スタックフレーム
void lisp_push_control(addr *ret);
int lisp_pop_control_(addr control);

■special変数
int lisp_push_special_(addr symbol, addr value);
int lisp_push_special8_(const void *name, addr value);
int lisp_push_special16_(const void *name, addr value);
int lisp_push_special32_(const void *name, addr value);
int lisp_get_special_(addr x, addr symbol);
int lisp_get_special8_(addr x, const void *name);
int lisp_get_special16_(addr x, const void *name);
int lisp_get_special32_(addr x, const void *name);
int lisp_set_special_(addr symbol, addr value);
int lisp_set_special8_(const void *name, addr value);
int lisp_set_special16_(const void *name, addr value);
int lisp_set_special32_(const void *name, addr value);

■defvar
int lisp_defvar_(addr symbol);
int lisp_defvar8_(const void *str);
int lisp_defvar16_(const void *str);
int lisp_defvar32_(const void *str);

■catch / throw
void lisp_catch(addr symbol);
int lisp_throw_(addr symbol);

■handler
int lisp_handler_bind_(addr name, addr call);
int lisp_handler_case_(addr name, addr call);
void lisp_handler_reverse(void);

■restart
void lisp_restart_make(addr x, addr name, addr call, int casep);
void lisp_restart_interactive(addr restart, addr call);
void lisp_restart_report(addr restart, addr call);
void lisp_restart_test(addr restart, addr call);
void lisp_restart_push(addr restart);
void lisp_restart_reverse(void);
```


# ■スタックフレーム

スタックフレームの領域確保と解放の関数です。

```c
void lisp_push_control(addr *ret);
int lisp_pop_control_(addr control);
```


## 関数`lisp_push_control`

```c
void lisp_push_control(addr *ret);

出力: ret 新しいスタックフレーム返却
```

新しいスタックフレームを確保します。  
スタックフレームは、主にhold変数に使われます。  


## 脱出関数`lisp_pop_control_`

```c
int lisp_pop_control_(addr control);

入力: control 解放するスタックフレーム
戻り値: 脱出時は0以外
```

スタックフレームを解放します。  
現在のスタックフレームは実行環境でも保有しており、
もし引数`control`と現在のスタックフレームが違う場合はエラーです。  

本関数は脱出時にも使用可能です。  
`control`がhold変数であった場合はエラーです。


# ■special変数

special変数の操作関数です。

```c
int lisp_push_special_(addr symbol, addr value);
int lisp_push_special8_(const void *name, addr value);
int lisp_push_special16_(const void *name, addr value);
int lisp_push_special32_(const void *name, addr value);
int lisp_get_special_(addr x, addr symbol);
int lisp_get_special8_(addr x, const void *name);
int lisp_get_special16_(addr x, const void *name);
int lisp_get_special32_(addr x, const void *name);
int lisp_set_special_(addr symbol, addr value);
int lisp_set_special8_(const void *name, addr value);
int lisp_set_special16_(const void *name, addr value);
int lisp_set_special32_(const void *name, addr value);
```

## 脱出関数`lisp_push_special_`

```c
int lisp_push_special_(addr symbol, addr value);

入力: symbol symbol
入力: value オブジェクト
戻り値: 脱出時は0以外
```

現在のスタックフレームに`symbol`のspecial変数を追加します。  
`value`はspecial変数の初期値であり、NULLの場合は`unbound`です。  
`symbol`と`value`がhold変数の場合は、内容が使用されます。


## 脱出関数`lisp_push_special8_`

```c
int lisp_push_special8_(const void *name, addr value);
int lisp_push_special16_(const void *name, addr value);
int lisp_push_special32_(const void *name, addr value);

入力: name Unicode文字列
入力: value オブジェクト
戻り値: 脱出時は0以外
```

現在のpackageから`name`というsymbolを探し、special変数を追加します。  
`value`はspecial変数の初期値であり、NULLの場合は`unbound`です。  
`value`がhold変数の場合は、内容が使用されます。  
Unicode文字列の詳細は`lisp_string8_`関数をご確認ください。


## 脱出関数`lisp_push_special16_`

`lisp_push_special8_`で解説


## 脱出関数`lisp_push_special32_`

`lisp_push_special8_`で解説


## 脱出関数`lisp_get_special_`

```c
int lisp_get_special_(addr x, addr symbol);

入力: symbol symbol
出力: x hold変数
戻り値: 脱出時は0以外
```

special変数の値を取得します。  
取得した値が`unbound`の場合はNULLが格納されます。  
hold変数に格納されたNULL値は`lisp_null_p`関数で確認できます。  
`symbol`がhold変数の場合は、内容が使用されます。


## 脱出関数`lisp_get_special8_`

```c
int lisp_get_special8_(addr x, const void *name);
int lisp_get_special16_(addr x, const void *name);
int lisp_get_special32_(addr x, const void *name);

入力: name Unicode文字列
出力: x hold変数
```

現在のpackageから`name`というsymbolを探し、special変数の値を取得します。  
取得した値が`unbound`の場合はNULLが格納されます。  
hold変数に格納されたNULL値は`lisp_null_p`関数で確認できます。  
Unicode文字列の詳細は`lisp_string8_`関数をご確認ください。


## 脱出関数`lisp_get_special16_`

`lisp_get_special8_`で解説


## 脱出関数`lisp_get_special32_`

`lisp_get_special8_`で解説


## 脱出関数`lisp_set_special_`

```c
int lisp_set_special_(addr symbol, addr value);

入力: symbol symbol
入力: value オブジェクト
戻り値: 脱出時に0以外
```

special変数に値を設定します。  
valueがNULLの場合は`unbound`が設定されます。  
`symbol`, `value`がhold変数の場合は、内容が使用されます。


## 脱出関数`lisp_set_special8_`

```c
int lisp_set_special8_(const void *name, addr value);
int lisp_set_special16_(const void *name, addr value);
int lisp_set_special32_(const void *name, addr value);

入力: name Unicode文字列
入力: value オブジェクト
戻り値: 脱出時に0以外
```

現在のpackageから`name`というsymbolを探し、special変数に値を設定します。  
valueがNULLの場合は`unbound`が設定されます。  
Unicode文字列の詳細は`lisp_string8_`関数をご確認ください。


## 脱出関数`lisp_set_special16_`

`lisp_set_special8_`で解説


## 脱出関数`lisp_set_special32_`

`lisp_set_special8_`で解説


# ■defvar

`defvar`の関数です。

```c
int lisp_defvar_(addr symbol);
int lisp_defvar8_(const void *str);
int lisp_defvar16_(const void *str);
int lisp_defvar32_(const void *str);
```


## 脱出関数`lisp_defvar_`

```c
int lisp_defvar_(addr symbol);

入力: symbol
戻り値: 脱出時は0以外
```

`symbol`をspecial変数にします。  
`symbol`がhold変数の場合は、内容を使用します。


## 脱出関数`lisp_defvar8_`

```c
int lisp_defvar8_(const void *str);
int lisp_defvar16_(const void *str);
int lisp_defvar32_(const void *str);

入力: str Unicode文字列
戻り値: 脱出時は0以外
```

`str`で表されるsymbolをspecial変数にします。  
Unicode文字列の詳細は`lisp_string8_`関数をご確認ください。


## 脱出関数`lisp_defvar16_`

`lisp_defvar8_`で解説


## 脱出関数`lisp_defvar32_`

`lisp_defvar8_`で解説


# ■catch / throw

`catch` / `throw`の関数です。

```c
void lisp_catch(addr symbol);
int lisp_throw_(addr symbol);
```

## 関数`lisp_catch`

```c
void lisp_catch(addr symbol);

入力: symbol symbolオブジェクト
```

現在のスタックフレームに、`catch`用のsymbolを登録します。  
`symbol`がhold変数の場合は、内容を使用します。


## 脱出関数`lisp_throw_`

```c
int lisp_throw_(addr symbol);

入力: symbol symbolオブジェクト
戻り値: 0以外
```

引数`symbol`を用いて`throw`を実行します。  
スタックフレームを遡って探索し、
`catch`用の`symbol`が見つかったら脱出を開始します。  
`symbol`が見つからなかったら`error`が発生します。  
`symbol`がhold変数の場合は、内容を使用します。


# ■handler

`handler-bind`と`handler-case`の関数です。

```c
int lisp_handler_bind_(addr name, addr call);
int lisp_handler_case_(addr name, addr call);
void lisp_handler_reverse(void);
```


## 脱出関数`lisp_handler_bind_`

```c
int lisp_handler_bind_(addr name, addr call);

入力: name symbolかcondition
入力: call 関数オブジェクト
戻り値: 脱出時は0以外
```

`handler-bind`用のコードを現在のスタックフレームに登録します。  
`name`が`symbol`の場合は、`find-class`を呼び出します。  
`call`は引数1つを受け取る関数オブジェクトを指定します。  
`name`と`call`がhold変数の場合は、内容を使用します。


## 脱出関数`lisp_handler_case_`

```c
int lisp_handler_case_(addr name, addr call);

入力: name symbolかcondition
入力: call 関数オブジェクト
戻り値: 脱出時は0以外
```

`handler-case`用のコードを現在のスタックフレームに登録します。  
`name`が`symbol`の場合は、`find-class`を呼び出します。  
`call`は引数1つを受け取る関数オブジェクトを指定します。  
`name`と`call`がhold変数の場合は、内容を使用します。


## 関数`lisp_handler_reverse`

```c
void lisp_handler_reverse(void);
```

handlerリストを逆順にします。  
`lisp_handler_bind_`と`lisp_handler_case_`は複数登録することができますが、
現在のスタックフレームに対して`push`で追加していくため、
評価順が登録順ではなく逆順になってしまいます。  
そこで本関数を実行することでhandlerリストを逆順にできます。


# ■restart

`restart`の関数です。

```c
void lisp_restart_make(addr x, addr name, addr call, int casep);
void lisp_restart_interactive(addr restart, addr call);
void lisp_restart_report(addr restart, addr call);
void lisp_restart_test(addr restart, addr call);
void lisp_restart_push(addr restart);
void lisp_restart_reverse(void);
```


## 関数`lisp_restart_make`

```c
void lisp_restart_make(addr x, addr name, addr call, int casep);

入力: name symbolオブジェクトかNULL
入力: call 関数オブジェクト
入力: casep `restart-bind`は0、`restart-case`は0以外
出力: x hold変数
```

`restart`オブジェクトを生成します。  
`name`は名前であり、`NULL`の場合は`NIL`です。  
`call`は関数オブジェクトを指定します。  
`casep`は`restart-bind`と`restart-case`を区別するための引数であり、
`restart-case`を指定したい場合は0以外を指定します。  
本関数は`restart`オブジェクトを生成するだけであり、
スタックフレームに登録するわけではありません。  
`name`, `call`がhold変数の場合は、内容を使用します。


## 関数`lisp_restart_interactive`

```c
void lisp_restart_interactive(addr restart, addr call);

入力: restart restartオブジェクト
入力: call 関数オブジェクト
```

`restart`オブジェクトにinteractiveコードを設定します。  
`call`は引数無しで呼び出す関数を指定します。  
`call`が`NULL`の場合は指定無しです。  
`restart`と`call`がhold変数の場合は、内容を使用します。


## 関数`lisp_restart_report`

```c
void lisp_restart_report(addr restart, addr call);

入力: restart restartオブジェクト
入力: call 関数オブジェクト
```

`restart`オブジェクトにreportコードを設定します。  
`call`は引数1つで呼び出す関数を指定します。  
`call`が`NULL`の場合は指定無しです。  
`restart`と`call`がhold変数の場合は、内容を使用します。


## 関数`lisp_restart_test`

```c
void lisp_restart_test(addr restart, addr call);

入力: restart restartオブジェクト
入力: call 関数オブジェクト
```

`restart`オブジェクトにtestコードを設定します。  
`call`は引数1つで呼び出す関数を指定します。  
`call`が`NULL`の場合は指定無しです。  
`restart`と`call`がhold変数の場合は、内容を使用します。


## 関数`lisp_restart_push`

```c
void lisp_restart_push(addr restart);

入力: restart restartオブジェクト
```

`restart`を現在のスタックフレームに登録します。  
`restart`がhold変数の場合は、内容を使用します。


## 関数`lisp_restart_reverse`

```c
void lisp_restart_reverse(void);
```

restartリストを逆順にします。  
`lisp_restart_push`は複数登録することができますが、
現在のスタックフレームに対して`push`で追加していくため、
評価順が登録順ではなく逆順になってしまいます。  
そこで本関数を実行することでrestartリストを逆順にできます。
