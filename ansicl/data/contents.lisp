;; draft proposed American National Standard for Information Systems
;; Programming Language Common Lisp
;; Version 15.17R, X3J13/94-101R.
;; Fri 12-Aug-1994 6:35pm EDT
;; http://www.cs.cmu.edu/afs/cs/Web/Groups/AI/lang/lisp/doc/standard/ansi/dpans/

;; ドラフト版提案書　ANSIプログラミング言語Common Lisp
;; Version 15.17R, X3J13/94-101R.
;; 1994年8月12日金曜日　午後6時35分（米国東部標準時・夏時間）

(index 1 "紹介" "Introduction")
(index 2 "構文" "Syntax")
(index 3 "評価とコンパイル" "Evaluation and Compilation")
(index 4 "型とクラス" "Types and Classes")
(index 5 "データと制御フロー" "Data and Control Flow")
(index 6 "繰り返し" "Iteration")
(index 7 "オブジェクト" "Objects")
(index 8 "構造体" "Structures")
(index 9 "コンディション" "Conditions")
(index 10 "シンボル" "Symbols")
(index 11 "パッケージ" "Packages")
(index 12 "数" "Numbers")
(index 13 "文字" "Characters")
(index 14 "コンス" "Conses")
(index 15 "配列" "Arrays")
(index 16 "文字列" "Strings")
(index 17 "シーケンス" "Sequences")
(index 18 "ハッシュテーブル" "Hash Tables")
(index 19 "ファイル名" "Filenames")
(index 20 "ファイル操作" "Files")
(index 21 "ストリーム" "Streams")
(index 22 "プリンター" "Printer")
(index 23 "リーダー" "Reader")
(index 24 "システム構築" "System Construction")
(index 25 "環境" "Environment")
(index 26 "用語集" "Glossary")
(index A "付録" "Appendix")

;; Chapter 2
(text 2.1 "文字の構文" "Character Syntax")
(text 2.1.3 "標準文字" "Standard Characters")
(text 2.4 "標準マクロ文字" "Standard Macro Characters")
(text 2.4.8 "シャープサイン" "Sharpsign")
(text 2.4.8.1 "シャープサイン バックスラッシュ" "Sharpsign Backslash")

;; Chapter 4
(index 4.4 "型とクラスの辞書" "Types and Classes Dictionary")
(dictionary 4.4.t)
(dictionary 4.4.coerce)
(dictionary 4.4.typep)
(dictionary 4.4.type-error)

;; Chapter 5
(index 5.3 "データと制御フローの辞書" "Data and Control Flow Dictionary")
(dictionary 5.3.program-error)
(dictionary 5.3.nil!variable)
(dictionary 5.3.eq)
(dictionary 5.3.eql)
(dictionary 5.3.equal)
(dictionary 5.3.equalp)

;; Chapter 13
(index 13.1 "文字の概念" "Character Concepts")
(text 13.1.3 "文字の属性" "Character Attributes")
(text 13.1.4 "文字のカテゴリ" "Character Categories")
(text 13.1.4.3 "文字のケース" "Characters With Case")
(text 13.1.10 "処理系実装のスクリプトの説明"
      "Documentation of Implementation-Defined Scripts")
(index 13.2 "文字の辞書" "Characters Dictionary")
(dictionary 13.2.character!system-class)
(dictionary 13.2.base-char)
(dictionary 13.2.standard-char)
(dictionary 13.2.extended-char)
(dictionary 13.2.char-equal)
(dictionary 13.2.character!function)
(dictionary 13.2.characterp)
(dictionary 13.2.alpha-char-p)
(dictionary 13.2.alphanumericp)
(dictionary 13.2.digit-char)
(dictionary 13.2.digit-char-p)
(dictionary 13.2.graphic-char-p)
(dictionary 13.2.standard-char-p)
(dictionary 13.2.char-case)
(dictionary 13.2.case-p)
(dictionary 13.2.char-code)
(dictionary 13.2.char-int)
(dictionary 13.2.code-char)
(dictionary 13.2.char-code-limit)
(dictionary 13.2.char-name)
(dictionary 13.2.name-char)

;; Chapter 16
(index 16.2 "文字列の辞書" "Strings Dictionary")
(dictionary 16.2.string-equal)

;; Chapter 18
(index 18.2 "ハッシュテーブルの辞書" "Hash Tables Dictionary")
(dictionary 18.2.sxhash)

;; Chapter 22
(index 22.1 "Lispプリンター" "The Lisp Printer")
(text 22.1.3 "標準のPrint-Object`メソッド" "Default Print-Object Methods")
(text 22.1.3.2 "文字の印字" "Printing Characters")

;; Chapter 23
(index 23.2 "リーダーの辞書" "Reader Dictionary")
(dictionary 23.2.read)

