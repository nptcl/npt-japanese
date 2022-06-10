(in-package #:ansicl)

(defconstant +toppage+ "index")

(declaim (ftype function linkpage))

;;
;;  footer
;;
(defun contents-prev (x)
  (declare (ignore x))
  nil)

(defun contents-up (x)
  (aif (butlast (contents-index x))
    (awhen (find-contents it)
      (filename-html
        (contents-string it)))
    "index.html"))

(defun contents-next (x)
  (declare (ignore x))
  nil)

(defun output-header (s x)
  ;;  PREV  UP  NEXT
  (awhen (contents-prev x)
    (format s "[PREV](~A)  " it))
  (awhen (contents-up x)
    (format s "[UP](~A)  " it))
  (awhen (contents-next x)
    (format s "[NEXT](~A)" it))
  (format s "~2&---~2%"))

(defun output-footer (s)
  (format s "~2&---~%")
  (format s "[TOP](index.html),  ")
  (format s "[Github](https://github.com/nptcl/npt-japanese)~2%"))


;;
;;  string
;;
(defun reference-title (x)
  (reference-string
    (contents-title x)))

(defun replace-special (str)
  (replace-string str "*" "\\*"))

;;  dictionary
(defun dictionary-values (x)
  (let* ((inst (contents-text x))
         (name (dictionary-name inst))
         (type (dictionary-type inst)))
    (let* ((list (mapcar-delete-attribute name))
           (join (join ", " list)))
      (values (string-capitalize type)
              (string-upcase join)))))

(defun dictionary-string1 (x)
  (mvbind (x y) (dictionary-values x)
    (setq y (replace-special y))
    (format nil "~A ~A" x y)))

(defun dictionary-string2 (x)
  (mvbind (x y) (dictionary-values x)
    (setq y (replace-special y))
    (format nil "~A **~A**" x y)))

;;  linkpage
(defun linkpage-values (x)
  (values
    (contents-string x)
    (reference-title x)))

(defun linkpage-title (x)
  (if (eq (contents-type x) 'dictionary)
    (dictionary-string1 x)
    (reference-title x)))

;;  index
(defun index-string2 (x)
  (mvbind (index title) (linkpage-values x)
    (replace-special
      (format nil "~A. ~A" index title))))

(defun index-string1 (x)
  (if (eq (contents-type x) 'dictionary)
    (dictionary-string2 x)
    (index-string2 x)))


;;
;;  index
;;
(defun index-link (s x)
  (let* ((index (contents-string x))
         (title (index-string1 x))
         (uri (filename-html index)))
    (linkpage x)
    (format s "- [~A](~A)~%" title uri)))

(defun index-nolink (s x)
  (let ((title (index-string1 x)))
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
  (let ((a (dictionary-string1 x))
        (b (dictionary-string2 x)))
    (format s "% ~A~2%" a)
    (output-header s x)
    (format s "# ~A~2%" b)))

(defun dictionary-body (s x)
  (let ((dic (contents-text x)))
    (dolist (y (dictionary-list dic))
      (cond ((eq y 'eol)
             (terpri s))
            ((eq y 'index)
             (index-body s x))
            ((consp y)
             (dictionary-operator s y))
            (t (princ y s))))))


;;
;;  text
;;
(defun text-body (s x)
  (dictionary-body s x))


;;
;;  linkpage
;;
(defun linkpage-header (s x)
  (mvbind (index title) (linkpage-values x)
    (format s "% ~A. ~A~2%" index title)
    (output-header s x)
    (format s "~A. ~A~2%" index title)))

(defun linkpage-footer (s x)
  (declare (ignore x))
  (output-footer s))

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
(defun toppage-dictionary-string (x)
  (let ((v (car (contents-index x))))
    (case (assocv v *working*)
      (finish "辞書 ★完了")
      (all "辞書 ★完了")
      (work "辞書 ☆作業中")
      (otherwise "辞書"))))

(defun toppage-dictionary-link (x)
  (awhen (contents-dictionary
           (car (contents-index x)))
    (filename-html
      (filename-join it))))

(defun toppage-dictionary (x)
  (aif (toppage-dictionary-link x)
    (format nil "[~A](~A)" (toppage-dictionary-string x) it)
    "辞書"))

(defun toppage-title (x)
  (let ((v (car (contents-index x)))
        (title (reference-title x)))
    (case (assocv v *working*)
      (all (format nil "~A ★完了" title))
      (otherwise title))))

(defun toppage-link (s x)
  (let* ((index (contents-string x))
         (english (contents-english x))
         (title (toppage-title x))
         (dic (toppage-dictionary x))
         (uri (filename-html index)))
    (linkpage x)
    (format s "|[~A.](~A)|[~A](~A)|[~A](~A)|~A|~%"
            index uri english uri title uri dic)))

(defun toppage-root (s x)
  (if (contents-exists-p x)
    (toppage-link s x)
    (let ((index (contents-string x))
          (english (contents-english x))
          (title (toppage-title x))
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
  (format s "現時点であまり完成していません。  ~%")
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
    (format s "[~A](~A)~2%" x x))
  (output-footer s))

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

