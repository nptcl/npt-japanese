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
(index 2.3 "トークンの解釈" "Interpretation of Tokens")
(text 2.3.1 "トークンとしての数" "Numbers as Tokens")
(text 2.3.1.1 "トークンとしての潜在的数" "Potential Numbers as Tokens")
(text 2.3.4 "トークンとしてのシンボル" "Symbols as Tokens")
(text 2.4 "標準マクロ文字" "Standard Macro Characters")
(text 2.4.1 "左括弧" "Left-Parenthesis")
(text 2.4.3 "シングルクォート" "Single-Quote")
(text 2.4.5 "ダブルクォート" "Double-Quote")
(text 2.4.6 "バッククォート" "Backquote")
(text 2.4.8 "シャープサイン" "Sharpsign")
(text 2.4.8.1 "シャープサイン バックスラッシュ" "Sharpsign Backslash")
(text 2.4.8.2 "シャープサイン シングルクォート" "Sharpsign Single-Quote")

;; Chapter 3
(text 3.1 "評価" "Evaluation")
(text 3.1.2 "評価の規範" "The Evaluation Model")
(text 3.1.2.1 "フォームの評価" "Form Evaluation")
(text 3.1.2.1.1 "フォームとしてのシンボル" "Symbols as Forms")
(text 3.1.2.1.1.3 "定数の変数" "Constant Variables")
(text 3.1.2.1.2 "フォームとしてのコンス" "Conses as Forms")
(text 3.1.2.1.2.4 "ラムダフォーム" "Lambda Forms")
(text 3.1.3 "ラムダ式" "Lambda Expressions")
(index 3.2 "コンパイル" "Compilation")
(text 3.2.1 "コンパイラーの用語" "Compiler Terminology")
(text 3.2.2 "コンパイルの意味" "Compilation Semantics")
(text 3.2.2.1 "コンパイラーマクロ" "Compiler Macros")
(text 3.2.2.2 "小さなコンパイル" "Minimal Compilation")
(text 3.2.3 "ファイルのコンパイル" "File Compilation")
(text 3.2.4 "ファイルコンパイル時の{literal-object}"
      "Literal Objects in Compiled Files")
(text 3.2.4.4 "外部オブジェクトの制約の追記"
      "Additional Constraints on Externalizable Objects")
(text 3.2.5 "コンパイラーの例外状況" "Exceptional Situations in the Compiler")
(text 3.4 "ラムダリスト" "Lambda Lists")
(text 3.4.1 "{ordinary-lambda-list}" "Ordinary Lambda Lists")
(text 3.4.4 "マクロのラムダリスト" "Macro Lambda Lists")
(text 3.4.5 "{destructuring-lambda-list}" "Destructuring Lambda Lists")
(text 3.4.11 "ドキュメント文字と宣言の文脈的な作用"
      "Syntactic Interaction of Documentation Strings and Declarations")
(index 3.5 "関数呼び出しのエラーチェック" "Error Checking in Function Calls")
(index 3.6 "横断の規則と副作用" "Traversal Rules and Side Effects")
(index 3.7 "破壊的操作" "Destructive Operations")
(index 3.8 "評価とコンパイルの辞書" "Evaluation and Compilation Dictionary")
(dictionary 3.8.lambda!symbol)
(dictionary 3.8.lambda!macro)
(dictionary 3.8.compile)
(dictionary 3.8.eval)
(dictionary 3.8.eval-when)
(dictionary 3.8.load-time-value)
(dictionary 3.8.quote)
(dictionary 3.8.compiler-macro-function)
(dictionary 3.8.define-compiler-macro)
(dictionary 3.8.defmacro)
(dictionary 3.8.macro-function)
(dictionary 3.8.macroexpand)
(dictionary 3.8.define-symbol-macro)
(dictionary 3.8.symbol-macrolet)
(dictionary 3.8.macroexpand-hook)
(dictionary 3.8.proclaim)
(dictionary 3.8.declaim)
(dictionary 3.8.declare)
(dictionary 3.8.ignore)
(dictionary 3.8.ignorable)  ;; delete
(dictionary 3.8.dynamic-extent)
(dictionary 3.8.type)
(dictionary 3.8.inline)
(dictionary 3.8.notinline)  ;; delete
(dictionary 3.8.ftype)
(dictionary 3.8.declaration)
(dictionary 3.8.optimize)
(dictionary 3.8.special)
(dictionary 3.8.locally)
(dictionary 3.8.the)
(dictionary 3.8.special-operator-p)
(dictionary 3.8.constantp)

;; Chapter 4
(text 4.2 "型" "Types")
(text 4.2.3 "型指定子" "Type Specifiers")
(text 4.3 "クラス" "Classes")
(text 4.3.4 "継承" "Inheritance")
(text 4.3.5 "{class-precedence-list}の決定" "Determining the Class Precedence List")
(text 4.3.6 "クラスの再定義" "Redefining Classes")
(text 4.3.7 "型とクラスの統合" "Integrating Types and Classes")
(index 4.4 "型とクラスの辞書" "Types and Classes Dictionary")
(dictionary 4.4.nil!type)
(dictionary 4.4.boolean)
(dictionary 4.4.function!system-class)
(dictionary 4.4.compiled-function)
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
(dictionary 4.4.satisfies)
(dictionary 4.4.member!type)
(dictionary 4.4.not!type)
(dictionary 4.4.and!type)
(dictionary 4.4.or!type)
(dictionary 4.4.values!type)
(dictionary 4.4.eql!type)
(dictionary 4.4.coerce)
(dictionary 4.4.deftype)
(dictionary 4.4.subtypep)
(dictionary 4.4.type-of)
(dictionary 4.4.typep)
(dictionary 4.4.type-error)
(dictionary 4.4.type-error-datum)
(dictionary 4.4.simple-type-error)

;; Chapter 5
(text 5.1 "一般化された参照" "Generalized Reference")
(text 5.1.1 "{place}と一般化された参照の概要"
      "Overview of Places and Generalized Reference")
(text 5.1.1.1 "{place}のサブフォームの評価" "Evaluation of Subforms to Places")
(text 5.1.1.2 "Setfの展開" "Setf Expansions")
(text 5.1.2 "{place}の種類" "Kinds of Places")
(text 5.1.2.2 "{place}としての関数呼び出しフォーム" "Function Call Forms as Places")
(text 5.1.2.3 "{place}としてのVALUESフォーム" "VALUES Forms as Places")
(text 5.1.2.5 "APPLYの{place}フォーム" "APPLY Forms as Places")
(text 5.2 "終了地点への制御の遷移" "Transfer of Control to an Exit Point")
(index 5.3 "データと制御フローの辞書" "Data and Control Flow Dictionary")
(dictionary 5.3.apply)
(dictionary 5.3.defun)
(dictionary 5.3.fdefinition)
(dictionary 5.3.fboundp)
(dictionary 5.3.fmakunbound)
(dictionary 5.3.flet)
(dictionary 5.3.funcall)
(dictionary 5.3.function!special)
(dictionary 5.3.function-lambda-expression)
(dictionary 5.3.functionp)
(dictionary 5.3.compiled-function-p)
(dictionary 5.3.call-arguments-limit)
(dictionary 5.3.lambda-list-keywords)
(dictionary 5.3.lambda-parameters-limit)
(dictionary 5.3.defconstant)
(dictionary 5.3.defparameter)
(dictionary 5.3.destructuring-bind)
(dictionary 5.3.let)
(dictionary 5.3.progv)
(dictionary 5.3.setq)
(dictionary 5.3.psetq)
(dictionary 5.3.block)
(dictionary 5.3.catch)
(dictionary 5.3.go)
(dictionary 5.3.return-from)
(dictionary 5.3.return)
(dictionary 5.3.tagbody)
(dictionary 5.3.throw)
(dictionary 5.3.unwind-protect)
(dictionary 5.3.nil!variable)
(dictionary 5.3.not!function)
(dictionary 5.3.t!variable)
(dictionary 5.3.eq)
(dictionary 5.3.eql!function)
(dictionary 5.3.equal)
(dictionary 5.3.equalp)
(dictionary 5.3.identity)
(dictionary 5.3.complement)
(dictionary 5.3.constantly)
(dictionary 5.3.every)
(dictionary 5.3.and!macro)
(dictionary 5.3.cond)
(dictionary 5.3.if)
(dictionary 5.3.or!macro)
(dictionary 5.3.when)
(dictionary 5.3.case)
(dictionary 5.3.typecase)
(dictionary 5.3.multiple-value-bind)
(dictionary 5.3.multiple-value-call)
(dictionary 5.3.multiple-value-list)
(dictionary 5.3.multiple-value-prog1)
(dictionary 5.3.multiple-value-setq)
(dictionary 5.3.values!accessor)
(dictionary 5.3.values-list)
(dictionary 5.3.multiple-values-limit)
(dictionary 5.3.nth-value)
(dictionary 5.3.prog)
(dictionary 5.3.prog1)
(dictionary 5.3.progn)
(dictionary 5.3.define-modify-macro)
(dictionary 5.3.defsetf)
(dictionary 5.3.define-setf-expander)
(dictionary 5.3.get-setf-expansion)
(dictionary 5.3.setf)
(dictionary 5.3.shiftf)
(dictionary 5.3.rotatef)
(dictionary 5.3.control-error)
(dictionary 5.3.program-error)
(dictionary 5.3.undefined-function)

;; Chapter 6
(index 6.2 "繰り返しの辞書" "Iteration Dictionary")
(dictionary 6.2.do)
(dictionary 6.2.do*)  ;; delete
(dictionary 6.2.dotimes)
(dictionary 6.2.dolist)
(dictionary 6.2.loop)
(dictionary 6.2.loop-finish)

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
(dictionary 7.7.call-method-local)
(dictionary 7.7.call-next-method)
(dictionary 7.7.compute-applicable-methods)
(dictionary 7.7.define-method-combination)
(dictionary 7.7.find-method)
(dictionary 7.7.add-method)
(dictionary 7.7.initialize-instance)
(dictionary 7.7.class-name)
(dictionary 7.7.setf-class-name)
(dictionary 7.7.class-of)
(dictionary 7.7.unbound-slot)
(dictionary 7.7.unbound-slot-instance)

;; Chapter 8
(index 8.2 "構造体の辞書" "Structures Dictionary")
(dictionary 8.2.defstruct)
(dictionary 8.2.copy-structure)

;; Chapter 9
(text 9.1 "コンディションシステムの説明" "Condition System Concepts")
(index 9.2 "コンディションの辞書" "Conditions Dictionary")
(dictionary 9.2.condition)
(dictionary 9.2.warning)
(dictionary 9.2.style-warning)
(dictionary 9.2.serious-condition)
(dictionary 9.2.error!condition)
(dictionary 9.2.cell-error)
(dictionary 9.2.cell-error-name)
(dictionary 9.2.method-combination-error)
(dictionary 9.2.invalid-method-error)
(dictionary 9.2.handler-bind)
(dictionary 9.2.handler-case)
(dictionary 9.2.ignore-errors)
(dictionary 9.2.define-condition)
(dictionary 9.2.make-condition)
(dictionary 9.2.restart-bind)
(dictionary 9.2.restart-case)
(dictionary 9.2.restart-name)
(dictionary 9.2.with-condition-restarts)
(dictionary 9.2.with-simple-restart)
(dictionary 9.2.abort!restart)
(dictionary 9.2.continue!restart)
(dictionary 9.2.muffle-warning!restart)
(dictionary 9.2.store-value!restart)
(dictionary 9.2.use-value!restart)

;; Chapter 10
(index 10.2 "シンボルの辞書" "Symbols Dictionary")
(dictionary 10.2.symbol)
(dictionary 10.2.keyword)
(dictionary 10.2.symbolp)
(dictionary 10.2.keywordp)
(dictionary 10.2.make-symbol)
(dictionary 10.2.copy-symbol)
(dictionary 10.2.gensym)
(dictionary 10.2.gensym-counter)
(dictionary 10.2.gentemp)
(dictionary 10.2.symbol-function)
(dictionary 10.2.symbol-name)
(dictionary 10.2.symbol-package)
(dictionary 10.2.symbol-plist)
(dictionary 10.2.symbol-value)
(dictionary 10.2.get)
(dictionary 10.2.remprop)
(dictionary 10.2.boundp)
(dictionary 10.2.makunbound)
(dictionary 10.2.set)
(dictionary 10.2.unbound-variable)

;; Chapter 11
(index 11.2 "パッケージの辞書" "Packages Dictionary")
(dictionary 11.2.package!system-class)
(dictionary 11.2.export)
(dictionary 11.2.find-symbol)
(dictionary 11.2.find-package)
(dictionary 11.2.find-all-symbols)
(dictionary 11.2.import)
(dictionary 11.2.list-all-packages)
(dictionary 11.2.rename-package)
(dictionary 11.2.shadow)
(dictionary 11.2.shadowing-import)
(dictionary 11.2.delete-package)
(dictionary 11.2.make-package)
(dictionary 11.2.with-package-iterator)
(dictionary 11.2.unexport)
(dictionary 11.2.unintern)
(dictionary 11.2.in-package)
(dictionary 11.2.unuse-package)
(dictionary 11.2.use-package)
(dictionary 11.2.defpackage)
(dictionary 11.2.do-symbols)
(dictionary 11.2.intern)
(dictionary 11.2.package-name)
(dictionary 11.2.package-nicknames)
(dictionary 11.2.package-shadowing-symbols)
(dictionary 11.2.package-use-list)
(dictionary 11.2.package-used-by-list)
(dictionary 11.2.packagep)
(dictionary 11.2.package-error)
(dictionary 11.2.package-error-package)

;; Chapger 12
(index 12.2 "数の辞書" "Numbers Dictionary")
(dictionary 12.=)
(dictionary 12.2.max)
(dictionary 12.2.floor)
(dictionary 12.2.+)
(dictionary 12.2.incf)
(dictionary 12.2.decf)  ;; delete

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

;; Chapter 14
(index 14.2 "コンスの辞書" "Conses Dictionary")
(dictionary 14.2.list!system-class)
(dictionary 14.2.null!system-class)
(dictionary 14.2.cons!system-class)
(dictionary 14.2.atom!type)
(dictionary 14.2.cons!function)
(dictionary 14.2.consp)
(dictionary 14.2.atom!function)
(dictionary 14.2.rplaca)
(dictionary 14.2.car)
(dictionary 14.2.copy-tree)
(dictionary 14.2.sublis)
(dictionary 14.2.subst)
(dictionary 14.2.tree-equal)
(dictionary 14.2.copy-list)
(dictionary 14.2.list!function)
(dictionary 14.2.list-length)
(dictionary 14.2.listp)
(dictionary 14.2.make-list)
(dictionary 14.2.push)
(dictionary 14.2.pop)
(dictionary 14.2.first)
(dictionary 14.2.nth)
(dictionary 14.2.endp)
(dictionary 14.2.null!function)
(dictionary 14.2.nconc)
(dictionary 14.2.append)
(dictionary 14.2.revappend)
(dictionary 14.2.butlast)
(dictionary 14.2.last)
(dictionary 14.2.ldiff)
(dictionary 14.2.nthcdr)
(dictionary 14.2.rest)
(dictionary 14.2.member!function)
(dictionary 14.2.mapc)
(dictionary 14.2.acons)
(dictionary 14.2.assoc)
(dictionary 14.2.copy-alist)
(dictionary 14.2.pairlis)
(dictionary 14.2.rassoc)
(dictionary 14.2.get-properties)
(dictionary 14.2.getf)
(dictionary 14.2.remf)
(dictionary 14.2.intersection)
(dictionary 14.2.adjoin)
(dictionary 14.2.pushnew)
(dictionary 14.2.set-difference)
(dictionary 14.2.set-exclusive-or)
(dictionary 14.2.subsetp)
(dictionary 14.2.union)

;; Chapter 15
(index 15.2 "配列の辞書" "Arrays Dictionary")
(dictionary 15.2.array)
(dictionary 15.2.simple-array)
(dictionary 15.2.vector!system-class)
(dictionary 15.2.make-array)
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
(index 17.2 "テスト関数のルール" "Rules about Test Functions")
(text 17.2.1 "2つの引数のテスト" "Satisfying a Two-Argument Test")
(dictionary 17.3.sequence)
(dictionary 17.3.copy-seq)
(dictionary 17.3.elt)
(dictionary 17.3.fill)
(dictionary 17.3.make-sequence)
(dictionary 17.3.subseq)
(dictionary 17.3.map)
(dictionary 17.3.map-into)
(dictionary 17.3.reduce)
(dictionary 17.3.count)
(dictionary 17.3.length)
(dictionary 17.3.reverse)
(dictionary 17.3.sort)
(dictionary 17.3.find)
(dictionary 17.3.position)
(dictionary 17.3.search)
(dictionary 17.3.mismatch)
(dictionary 17.3.replace)
(dictionary 17.3.substitute)
(dictionary 17.3.concatenate)
(dictionary 17.3.merge)
(dictionary 17.3.remove)
(dictionary 17.3.remove-duplicates)

;; Chapter 18
(index 18.2 "ハッシュテーブルの辞書" "Hash Tables Dictionary")
(dictionary 18.2.hash-table)
(dictionary 18.2.make-hash-table)
(dictionary 18.2.hash-table-p)
(dictionary 18.2.hash-table-count)
(dictionary 18.2.hash-table-rehash-size)
(dictionary 18.2.hash-table-rehash-threshold)
(dictionary 18.2.hash-table-size)
(dictionary 18.2.hash-table-test)
(dictionary 18.2.gethash)
(dictionary 18.2.remhash)
(dictionary 18.2.maphash)
(dictionary 18.2.with-hash-table-iterator)
(dictionary 18.2.clrhash)
(dictionary 18.2.sxhash)

;; Chapter 21
(index 21.2 "ストリームの辞書" "Streams Dictionary")
(dictionary 21.2.stream)
(dictionary 21.2.broadcast-stream)
(dictionary 21.2.concatenated-streamstream)
(dictionary 21.2.echo-stream)
(dictionary 21.2.file-stream)
(dictionary 21.2.stringstream)
(dictionary 21.2.synonym-stream)
(dictionary 21.2.two-way-stream)
(dictionary 21.2.input-stream-p)
(dictionary 21.2.interactive-stream-p)
(dictionary 21.2.open-stream-p)
(dictionary 21.2.stream-element-type)
(dictionary 21.2.streamp)
(dictionary 21.2.read-byte)
(dictionary 21.2.write-byte)
(dictionary 21.2.peek-char)
(dictionary 21.2.read-char)
(dictionary 21.2.read-char-no-hang)
(dictionary 21.2.terpri)
(dictionary 21.2.unread-char)
(dictionary 21.2.read-line)
(dictionary 21.2.write-string)
(dictionary 21.2.read-sequence)
(dictionary 21.2.write-sequence)
(dictionary 21.2.file-length)
(dictionary 21.2.file-position)
(dictionary 21.2.file-string-length)
(dictionary 21.2.open)
(dictionary 21.2.stream-external-format)
(dictionary 21.2.with-open-file)
(dictionary 21.2.close)
(dictionary 21.2.with-open-stream)
(dictionary 21.2.listen)
(dictionary 21.2.clear-input)
(dictionary 21.2.finish-output)
(dictionary 21.2.y-or-n-p)
(dictionary 21.2.make-synonym-stream)
(dictionary 21.2.synonym-stream-symbol)
(dictionary 21.2.broadcast-stream-streams)
(dictionary 21.2.make-broadcast-stream)
(dictionary 21.2.make-two-way-stream)
(dictionary 21.2.two-way-stream-input-stream)
(dictionary 21.2.echo-stream-input-stream)
(dictionary 21.2.make-echo-stream)
(dictionary 21.2.concatenated-stream-streams)
(dictionary 21.2.make-concatenated-stream)
(dictionary 21.2.get-output-stream-string)
(dictionary 21.2.make-string-input-stream)
(dictionary 21.2.make-string-output-stream)
(dictionary 21.2.with-input-from-string)
(dictionary 21.2.with-output-to-string)
(dictionary 21.2.debug-io)
(dictionary 21.2.terminal-io)
(dictionary 21.2.stream-error)
(dictionary 21.2.stream-error-stream)
(dictionary 21.2.end-of-file)

;; Chapter 22
(index 22.1 "Lispプリンター" "The Lisp Printer")
(text 22.1.3 "標準のPrint-Objectメソッド" "Default Print-Object Methods")
(text 22.1.3.2 "文字の印字" "Printing Characters")
(text 22.1.3.3 "シンボルの印字" "Printing Symbols")
(text 22.1.3.4 "文字列の印字" "Printing Strings")
(text 22.1.3.5 "リストとコンスの印字" "Printing Lists and Conses")
(text 22.1.3.13 "他のオブジェクトの印字" "Printing Other Objects")
(index 22.4 "プリンターの辞書" "Printer Dictionary")
(dictionary 22.4.copy-print-dispatch)
(dictionary 22.4.formatter)
(dictionary 22.4.pprint-dispatch)
(dictionary 22.4.pprint-exit-if-list-exhausted)
(dictionary 22.4.pprint-fill)
(dictionary 22.4.pprint-indent)
(dictionary 22.4.pprint-logical-block)
(dictionary 22.4.pprint-newline)
(dictionary 22.4.pprint-pop)
(dictionary 22.4.pprint-tab)
(dictionary 22.4.print-object)
(dictionary 22.4.print-unreadable-object)
(dictionary 22.4.set-pprint-dispatch)
(dictionary 22.4.write)
(dictionary 22.4.print)  ;; delete
(dictionary 22.4.write-to-string)
(dictionary 22.4.prin1-to-string) ;; delete
(dictionary 22.4.princ-to-string) ;; delete
(dictionary 22.4.format)

;; Chapter 23
(index 23.2 "リーダーの辞書" "Reader Dictionary")
(dictionary 23.2.read)
(dictionary 23.2.set-macro-character)

;; Chapter 24
(index 24.2 "システム構築の辞書" "System Construction Dictionary")
(dictionary 24.2.compile-file)
(dictionary 24.2.load)

;; Chapger 25
(index 25.2 "環境の辞書" "Environment Dictionary")
(dictionary 25.2.documentation)

