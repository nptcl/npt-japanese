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
(text 2.4.5 "ダブルクォート" "Double-Quote")
(text 2.4.8 "シャープサイン" "Sharpsign")
(text 2.4.8.1 "シャープサイン バックスラッシュ" "Sharpsign Backslash")

;; Chapter 3
(text 3.1 "評価" "Evaluation")
(index 3.2 "コンパイル" "Compilation")
(text 3.2.1 "コンパイラーの用語" "Compiler Terminology")
(text 3.2.4 "ファイルコンパイル時の{literal-object}"
      "Literal Objects in Compiled Files")
(text 3.2.4.4 "外部オブジェクトの制約の追記"
      "Additional Constraints on Externalizable Objects")
(index 3.5 "関数呼び出しのエラーチェック" "Error Checking in Function Calls")
(index 3.8 "評価とコンパイルの辞書" "Evaluation and Compilation Dictionary")
(dictionary 3.8.eval)
(dictionary 3.8.defmacro)
(dictionary 3.8.symbol-macrolet)

;; Chapter 4
(text 4.3 "クラス" "Classes")
(text 4.3.6 "クラスの再定義" "Redefining Classes")
(index 4.4 "型とクラスの辞書" "Types and Classes Dictionary")
(dictionary 4.4.generic-function)
(dictionary 4.4.standard-generic-function)
(dictionary 4.4.class)
(dictionary 4.4.built-in-class)
(dictionary 4.4.structure-class)
(dictionary 4.4.standard-class)
(dictionary 4.4.method)
(dictionary 4.4.standard-method)
(dictionary 4.4.structure-object)
(dictionary 4.4.standard-object)
(dictionary 4.4.method-combination)
(dictionary 4.4.t!system-class)
(dictionary 4.4.coerce)
(dictionary 4.4.typep)
(dictionary 4.4.type-error)

;; Chapter 5
(index 5.3 "データと制御フローの辞書" "Data and Control Flow Dictionary")
(dictionary 5.3.apply)
(dictionary 5.3.funcall)
(dictionary 5.3.setq)
(dictionary 5.3.nil!variable)
(dictionary 5.3.t!variable)
(dictionary 5.3.eq)
(dictionary 5.3.eql)
(dictionary 5.3.equal)
(dictionary 5.3.equalp)
(dictionary 5.3.setf)
(dictionary 5.3.program-error)

;; Chapter 7
(text 7.1 "オブジェクトの作成と初期化" "Object Creation and Initialization")
(text 7.1.1 "{initialization-arguments}" "Initialization Arguments")
(text 7.1.2 "{initialization-arguments}の有効性の宣言"
      "Declaring the Validity of Initialization Arguments")
(text 7.1.3 "{initialization-arguments}のデフォルト値"
      "Defaulting of Initialization Arguments")
(text 7.1.4 "{initialization-arguments}の規則" "Rules for Initialization Arguments")
(text 7.1.5 "Shared-Initialize" "Shared-Initialize")
(text 7.1.6 "Initialize-Instance" "Initialize-Instance")
(text 7.1.7 "Make-InstanceとInitialize-Instanceの宣言"
      "Definitions of Make-Instance and Initialize-Instance")
(text 7.2 "インスタンスのクラスの変更" "Changing the Class of an Instance")
(text 7.2.1 "インスタンスの構造の修正" "Modifying the Structure of the Instance")
(text 7.2.2 "新しく追加された局所スロットの初期化"
      "Initializing Newly Added Local Slots")
(text 7.2.3 "インスタンスのクラスの更新のカスタマイズ"
      "Customizing the Change of Class of an Instance")
(text 7.3 "インスタンスの再初期化" "Reinitializing an Instance")
(text 7.3.1 "再初期化のカスタマイズ" "Customizing Reinitialization")
(text 7.4 "メタオブジェクト" "Meta-Objects")
(text 7.4.1 "標準メタオブジェクト" "Standard Meta-objects")
(index 7.5 "スロット" "Slots")
(text 7.5.1 "スロットの紹介" "Introduction to Slots")
(text 7.5.2 "スロットへのアクセス" "Accessing Slots")
(text 7.5.3 "スロットの継承とスロットオプション"
      "Inheritance of Slots and Slot Options")
(index 7.6 "ジェネリック関数とメソッド" "Generic Functions and Methods")
(text 7.6.1 "ジェネリック関数の紹介" "Introduction to Generic Functions")
(text 7.6.2 "メソッドの紹介" "Introduction to Methods")
(text 7.6.3 "特定パラメーターと{qualifiers}の合致"
      "Agreement on Parameter Specializers and Qualifiers")
(text 7.6.4 "ジェネリック関数の全てのメソッドのラムダリストの合意"
      "Congruent Lambda-lists for all Methods of a Generic Function")
(text 7.6.5 "ジェネリック関数とメソッドのキーワード引数"
      "Keyword Arguments in Generic Functions and Methods")
(text 7.6.5.1 "ジェネリック関数とメソッドのキーワード引数の例"
      "Examples of Keyword Arguments in Generic Functions and Methods")
(text 7.6.6 "メソッドの選択とコンビネーション" "Method Selection and Combination")
(text 7.6.6.1 "有効なメソッドの決定" "Determining the Effective Method")
(text 7.6.6.1.1 "適用可能なメソッドの選択" "Selecting the Applicable Methods")
(text 7.6.6.1.2 "優先順位による適用可能なメソッドのソート"
      "Sorting the Applicable Methods by Precedence Order")
(text 7.6.6.1.3 "ソートされた適用可能なメソッドのMethod-Combination実行"
      "Applying method combination to the sorted list of applicable methods")
(text 7.6.6.2 "Standard Method-Combination" "Standard Method Combination")
(text 7.6.6.3 "Method-Combinationの宣言" "Declarative Method Combination")
(text 7.6.6.4 "組み込みのMethod-Combination" "Built-in Method Combination Types")
(text 7.6.7 "メソッドの継承" "Inheritance of Methods")
(index 7.7 "オブジェクトの辞書" "Objects Dictionary")
(dictionary 7.7.function-keywords)
(dictionary 7.7.ensure-generic-function)
(dictionary 7.7.allocate-instance)
(dictionary 7.7.reinitialize-instance)
(dictionary 7.7.shared-initialize)
(dictionary 7.7.update-instance-for-different-class)
(dictionary 7.7.update-instance-for-redefined-class)
(dictionary 7.7.change-class)
(dictionary 7.7.slot-boundp)
(dictionary 7.7.slot-exists-p)
(dictionary 7.7.slot-makunbound)
(dictionary 7.7.slot-missing)
(dictionary 7.7.slot-unbound)
(dictionary 7.7.slot-value)
(dictionary 7.7.method-qualifiers)
(dictionary 7.7.no-applicable-method)
(dictionary 7.7.no-next-method)
(dictionary 7.7.remove-method)
(dictionary 7.7.make-instance)
(dictionary 7.7.make-instances-obsolete)
(dictionary 7.7.make-load-form)
(dictionary 7.7.make-load-form-saving-slots)
(dictionary 7.7.with-accessors)
(dictionary 7.7.with-slots)
(dictionary 7.7.defclass)
(dictionary 7.7.defgeneric)
(dictionary 7.7.defmethod)
(dictionary 7.7.find-class)
(dictionary 7.7.next-method-p)
(dictionary 7.7.call-method)
(dictionary 7.7.make-method)  ;; delete
(dictionary 7.7.call-next-method)
(dictionary 7.7.compute-applicable-methods)
(dictionary 7.7.define-method-combination)
(dictionary 7.7.find-method)
(dictionary 7.7.add-method)
(dictionary 7.7.initialize-instance)
(dictionary 7.7.class-name)
;(dictionary 7.7.(setf class-name))
(dictionary 7.7.class-of)
(dictionary 7.7.unbound-slot)
(dictionary 7.7.unbound-slot-instance)

;; Chapter 8
(index 8.2 "構造体の辞書" "Structures Dictionary")
(dictionary 8.2.defstruct)
(dictionary 8.2.copy-structure)

;; Chapter 9
(index 9.2 "コンディションの辞書" "Conditions Dictionary")
(dictionary 9.2.condition)
(dictionary 9.2.serious-condition)
(dictionary 9.2.error!condition)
(dictionary 9.2.define-condition)

;; Chapter 10
(index 10.2 "シンボルの辞書" "Symbols Dictionary")
(dictionary 10.2.symbol)

;; Chapter 13
(index 13.1 "文字の説明" "Character Concepts")
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

;; Chapter 15
(index 15.2 "配列の辞書" "Arrays Dictionary")
(dictionary 15.2.array)
(dictionary 15.2.simple-array)
(dictionary 15.2.vector!system-class)
(dictionary 15.2.aref)

;; Chapter 16
(index 16.1 "文字の説明" "String Concepts")
(index 16.2 "文字列の辞書" "Strings Dictionary")
(dictionary 16.2.string!system-class)
(dictionary 16.2.base-string)
(dictionary 16.2.simple-string)
(dictionary 16.2.simple-base-string)
(dictionary 16.2.simple-string-p)
(dictionary 16.2.char-accessor)
(dictionary 16.2.string!function)
(dictionary 16.2.string-case)
(dictionary 16.2.string-trim)
(dictionary 16.2.string-equal)
(dictionary 16.2.stringp)
(dictionary 16.2.make-string)

;; Chapter 17
(index 17.3 "シーケンスの辞書" "Sequences Dictionary")
(dictionary 17.3.sequence)
(dictionary 17.3.elt)

;; Chapter 18
(index 18.2 "ハッシュテーブルの辞書" "Hash Tables Dictionary")
(dictionary 18.2.sxhash)

;; Chapter 21
(index 21.2 "ストリームの辞書" "Streams Dictionary")
(dictionary 21.2.stream)

;; Chapter 22
(index 22.1 "Lispプリンター" "The Lisp Printer")
(text 22.1.3 "標準のPrint-Objectメソッド" "Default Print-Object Methods")
(text 22.1.3.2 "文字の印字" "Printing Characters")
(text 22.1.3.4 "文字列の印字" "Printing Strings")
(index 22.4 "プリンターの辞書" "Printer Dictionary")
(dictionary 22.4.write-to-string)
(dictionary 22.4.prin1-to-string) ;; delete
(dictionary 22.4.princ-to-string) ;; delete
(dictionary 22.4.format)

;; Chapter 23
(index 23.2 "リーダーの辞書" "Reader Dictionary")
(dictionary 23.2.read)

;; Chapter 24
(index 24.2 "システム構築の辞書" "System Construction Dictionary")
(dictionary 24.2.compile-file)
(dictionary 24.2.load)

