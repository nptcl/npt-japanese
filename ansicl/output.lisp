(in-package #:ansicl)

(defconstant +toppage+ "index")

(declaim (ftype function  linkpage))

(defun dictionary-title (x)
  (let* ((inst (contents-text x))
         (name (dictionary-name inst))
         (type (dictionary-type inst)))
    (let* ((list (mapcar-delete-attribute name))
           (join (join ", " list)))
      (format nil "~:(~A~) ~:@(~A~)" type join))))

(defun linkpage-title (x)
  (if (eq (contents-type x) 'dictionary)
    (dictionary-title x)
    (contents-title x)))

(defun index-string-title (x)
  (let ((index (contents-string x))
        (title (contents-title x)))
    (format nil "~A. ~A" index title)))

(defun index-string (x)
  (if (eq (contents-type x) 'dictionary)
    (dictionary-title x)
    (index-string-title x)))

(defun index-link (s x)
  (let* ((index (contents-string x))
         (title (index-string x))
         (uri (filename-html index)))
    (linkpage x)
    (format s "- [~A](~A)~%" title uri)))

(defun index-nolink (s x)
  (let ((title (index-string x)))
    (format s "- ~A~%" title)))

(defun index-root (s x)
  (if (contents-exists-p x)
    (index-link s x)
    (index-nolink s x)))

(defun index-queue (x)
  (remove-if
    (lambda (x)
      (let ((x (find-contents x)))
        (and (eq (contents-type x) 'dictionary)
             (null (contents-text x)))))
    (queue-root
      (contents-queue x))))

(defun index-body (s x)
  (dolist (x (index-queue x))
    (index-root s (find-contents x))))


;;
;;  dictionary
;;
(defun dictionary-reference (s cdr)
  (princ (reference cdr) s))

(defun dictionary-operator (s y)
  (dbind (car . cdr) y
    (ecase car
      (ref (dictionary-reference s cdr)))))

(defun dictionary-header (s x)
  (let ((name (dictionary-title x)))
    (format s "% ~A~2%" name)
    (format s "# ~A~2%" name)))

(defun dictionary-body (s x)
  (let ((dic (contents-text x)))
    (dolist (y (dictionary-list dic))
      (cond ((eq y 'eol)
             (terpri s))
            ((consp y)
             (dictionary-operator s y))
            (t (princ y s))))))


;;
;;  text
;;
(defun text-body (s x)
  (declare (ignore s x))
  (error "TODO, text-body"))


;;
;;  linkpage
;;
(defun linkpage-header (s x)
  (let ((index (contents-string x))
        (title (contents-title x)))
    (format s "% ~A. ~A~2%" index title)
    (format s "~A. ~A~2%" index title)))

(defun linkpage-footer (s x)
  (declare (ignore s x)))

(defun text-stream (s x)
  (linkpage-header s x)
  (text-body s x)
  (linkpage-footer s x))

(defun index-stream (s x)
  (linkpage-header s x)
  (index-body s x)
  (linkpage-footer s x))

(defun dictionary-stream (s x)
  (dictionary-header s x)
  (dictionary-body s x)
  (linkpage-footer s x))

(defun linkpage-switch (s x)
  (ecase (contents-type x)
    (text (text-stream s x))
    (index (index-stream s x))
    (dictionary (dictionary-stream s x))))

(defun linkpage (x)
  (let* ((name (contents-string x))
         (file (filename-output name "md")))
    (with-overwrite-file (s file)
      (format t "Output: ~S, ~A~%" file (linkpage-title x))
      (linkpage-switch s x))))


;;
;;  index
;;
(defun toppage-dictionary-find (x)
  (awhen (contents-dictionary
           (car (contents-index x)))
    (filename-html
      (filename-join it))))

(defun toppage-dictionary (x)
  (aif (toppage-dictionary-find x)
    (format nil "[辞書](~A)" it)
    "辞書"))

(defun toppage-link (s x)
  (let* ((index (contents-string x))
         (title (contents-title x))
         (english (contents-english x))
         (dic (toppage-dictionary x))
         (uri (filename-html index)))
    (linkpage x)
    (format s "|[~A.](~A)|[~A](~A)|[~A](~A)|~A|~%"
            index uri english uri title uri dic)))

(defun toppage-root (s x)
  (if (contents-exists-p x)
    (toppage-link s x)
    (let ((index (contents-string x))
          (title (contents-title x))
          (english (contents-english x))
          (dic (toppage-dictionary x)))
      (format s "|~A.|~A|~A|~A|~%" index english title dic))))

(defun toppage-body (s)
  (format s "# 目次~2%")
  (format s "|    |    |    |    |~%")
  (format s "|:---|:---|:---|:---|~%")
  (dolist (x (queue-root *contents-root*))
    (toppage-root s (find-contents x)))
  (terpri s))

(defun toppage-header (s)
  (format s "% ANSI Common Lisp~2%")
  (format s "ANSI Common Lisp仕様書のDictionaryの日本語訳を目指します。~2%")
  (format s "**★★翻訳の対象はDictionaryだけです★★**  ~%")
  (format s "現時点では「13.2 文字の辞書」しか完成していません。  ~%")
  (format s "気が向いたら更新します。~2%"))

(defun toppage-footer (s)
  (format s "# 参考文献~2%")
  (format s "draft proposed American National Standard for Information Systems  ~%")
  (format s "Programming Language Common Lisp  ~%")
  (format s "Version 15.17R, X3J13/94-101R.  ~%")
  (format s "Fri 12-Aug-1994 6:35pm EDT  ~%")
  (format s "[http://www.cs.cmu.edu/afs/cs/Web/Groups/AI/lang/lisp/doc/standard/ansi/dpans/]")
  (format s "(http://www.cs.cmu.edu/afs/cs/Web/Groups/AI/lang/lisp/doc/standard/ansi/dpans/)~2%")

  (format s "ドラフト版提案書　ANSIプログラミング言語Common Lisp  ~%")
  (format s "Version 15.17R, X3J13/94-101R.  ~%")
  (format s "1994年8月12日金曜日　午後6時35分（米国東部標準時・夏時間）~2%")
  (format s "# 配布~2%")
  (let ((x "https://github.com/nptcl/npt-japanese"))
    (format s "[~A](~A)~2%" x x)))

(defun toppage-stream (s)
  (toppage-header s)
  (toppage-body s)
  (toppage-footer s))

(defun toppage ()
  (let ((file (filename-output +toppage+ "md"))
        (*print-pretty* nil))
    (ensure-directories-exist file)
    (with-overwrite-file (s file)
      (format t "Output: ~S~%" file)
      (toppage-stream s))))


;;
;;  Main
;;
(toppage)

