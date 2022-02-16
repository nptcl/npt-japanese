% 関数仕様 - 書式

nptのドキュメントです。  
参照元：[ANSI Common Lisp npt](index.html)


# 関数仕様

`lisp.h`に記載されている下記の関数仕様を示します。

```c
■format
int lisp_format8_(addr stream, const void *str, ...);
int lisp_format16_(addr stream, const void *str, ...);
int lisp_format32_(addr stream, const void *str, ...);

■標準出力
int lisp_stdout8_(const void *str, ...);
int lisp_stdout16_(const void *str, ...);
int lisp_stdout32_(const void *str, ...);

■stringf
int lisp_stringf8_(addr x, const void *str, ...);
int lisp_stringf16_(addr x, const void *str, ...);
int lisp_stringf32_(addr x, const void *str, ...);
```


# ■format

`format`の関数です。

```c
int lisp_format8_(addr stream, const void *str, ...);
int lisp_format16_(addr stream, const void *str, ...);
int lisp_format32_(addr stream, const void *str, ...);
```


## 脱出関数`lisp_format8_`

```c
int lisp_format8_(addr stream, const void *str, ...);
int lisp_format16_(addr stream, const void *str, ...);
int lisp_format32_(addr stream, const void *str, ...);

入力: stream streamかTかNULL
入力: str Unicode文字列
戻り値: 脱出時は0以外
```

`format`関数を呼び出します。  
`stream`が`NULL`の場合は`T`と同じです。  
`stream`が`T`の場合は`*standard-output*`に出力されます。  
`stream`が`NIL`の場合は文字列作成ですが内容は破棄されます。  
`stream`がhold変数の場合は、内容を使用します。  
Unicode文字列の詳細は`lisp_string8_`関数をご確認ください。


## 脱出関数`lisp_format16_`

`lisp_format8_`で解説


## 脱出関数`lisp_format32_`

`lisp_format8_`で解説


# ■標準出力

`*standard-output*`に出力する関数です。

```c
int lisp_stdout8_(const void *str, ...);
int lisp_stdout16_(const void *str, ...);
int lisp_stdout32_(const void *str, ...);
```


## 脱出関数`lisp_stdout8_`

```c
int lisp_stdout8_(const void *str, ...);
int lisp_stdout16_(const void *str, ...);
int lisp_stdout32_(const void *str, ...);

入力: str Unicode文字列
戻り値: 脱出時は0以外
```

`format`関数を`*standard-output*`宛てに呼び出します。  
`lisp_format8_(NULL, str, ...)`と同等です。  
Unicode文字列の詳細は`lisp_string8_`関数をご確認ください。

## 脱出関数`lisp_stdout16_`

`lisp_stdout8_`で解説


## 脱出関数`lisp_stdout32_`

`lisp_stdout8_`で解説


# ■stringf

`format`の結果を文字列で返却する関数です。

```c
int lisp_stringf8_(addr x, const void *str, ...);
int lisp_stringf16_(addr x, const void *str, ...);
int lisp_stringf32_(addr x, const void *str, ...);
```


## 脱出関数`lisp_stringf8_`

```c
int lisp_stringf8_(addr x, const void *str, ...);
int lisp_stringf16_(addr x, const void *str, ...);
int lisp_stringf32_(addr x, const void *str, ...);

入力: str Unicode文字列
出力: x hold変数
戻り値: 脱出時は0以外
```

`format`関数を呼び出し文字列を返却します。  
Common Lispの`(format nil str ...)`と同等です。  
Unicode文字列の詳細は`lisp_string8_`関数をご確認ください。


## 脱出関数`lisp_stringf16_`

`lisp_stringf8_`で解説


## 脱出関数`lisp_stringf32_`

`lisp_stringf8_`で解説
