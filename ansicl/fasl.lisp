(in-package #:ansicl)

(defconstant +output-fasl+ #p"npt-japanese.lisp")
(defconstant +search-fasl+ #p"search.lisp")

(defconstant +header-fasl+
  '("draft proposed American National Standard for Information Systems"
    "Programming Language Common Lisp"
    "Version 15.17R, X3J13/94-101R."
    "Fri 12-Aug-1994 6:35pm EDT"
    "http://www.cs.cmu.edu/afs/cs/Web/Groups/AI/lang/lisp/doc/standard/ansi/dpans/"
    ""
    "ドラフト版提案書　ANSIプログラミング言語Common Lisp"
    "Version 15.17R, X3J13/94-101R."
    "1994年8月12日金曜日　午後6時35分（米国東部標準時・夏時間）"
    "https://github.com/nptcl/npt-japanese"))

(defvar *fasl-table*)
(defvar *fasl-name*)

;;
;;  get-table
;;
(defun table-select-fasl (x)
  (declare (type cons x))
  (dbind (car . cdr) x
    (ecase car
      (ref (reference-fasl cdr)))))

(defun replace-reference-fasl (key)
  (mapcar
    (lambda (x)
      (if (consp x)
        (table-select-fasl x)
        x))
    (errhash key *fasl-table*)))

(defun table-fasl (key)
  (fasl-markdown
    (replace-reference-fasl key)))


;;
;;  output
;;
(defun output-variable-fasl (s)
  (format s "(defvar *table*)~%")
  (format s "(defvar *name*)~%"))

(defun fasl-name-keys ()
  (sort (hash-table-keys *fasl-name*) #'string<))

(defun output-name-fasl (s keys)
  (format s "(setq *table* (make-hash-table :test 'equal))~%")
  (format s "(setq *name* (make-hash-table :test 'equal))~%")
  (dolist (x keys)
    (format s "(setf (gethash ~S *name*) '~S)~%" x (errhash x *fasl-name*))))

(defun output-single-fasl (s x y)
  (let* ((key (cons x y))
         (list (table-fasl key)))
    (format s "(setf (gethash ~S *table*)~%  '~S)~%" x list)
    (format s "(setf (gethash '~S *table*) (gethash ~S *table*))~%" key x)))

(defun output-select-fasl (x list)
  (mapcan
    (lambda (y)
      (list (format nil "~A ~A" x y) 'eol1))
    list))

(defun output-multiple-fasl (s x list)
  (let ((select (output-select-fasl x list)))
    (format s "(setf (gethash ~S *table*)~%  '~S)~%" x select)
    (dolist (y list)
      (let* ((key (cons x y))
             (list (table-fasl key)))
        (format s "(setf (gethash '~S *table*)~%  '~S)~%" key list)))))

(defun output-table-fasl (s keys)
  (dolist (x keys)
    (let ((list (errhash x *fasl-name*)))
      (if (single list)
        (output-single-fasl s x (car list))
        (output-multiple-fasl s x list)))))

(defun output-text-fasl (s keys)
  (let ((*print-pretty* t)
        (*print-miser-width* nil)
        (*print-right-margin* 90))
    (output-table-fasl s keys)))

(defun output-fasl (s)
  (output-variable-fasl s)
  (let ((keys (fasl-name-keys)))
    (output-name-fasl s keys)
    (output-text-fasl s keys))
  (terpri s)
  (terpri s))

(defun redirect-fasl (s)
  (with-open-file (input +search-fasl+)
    (funcall-read-line
      input
      (lambda (x)
        (write-line x s))))
  (terpri s))

(defun interface-fasl (s)
  (format s ";;~%")
  (format s ";;  Interface~%")
  (format s ";;~%")
  (format s "(defun doc-japanese (&rest args)~%")
  (format s "  (search-fasl args))~2%")
  (format s "(defmacro docjp (&rest args)~%")
  (format s "  `(doc-japanese ,@(mapcar (lambda (x) `',x) args)))~%")
  (terpri s))


;;
;;  faslpage
;;
(declaim (ftype function linkpage))

(defun dictionary-setf-fasl (name type)
  (let ((x (string-upcase name)))
    (and (< 5 (length x) )
         (string= "(SETF" (subseq x 0 5))
         (dbind (setf name) (read-from-string x)
           (unless (eq setf 'setf)
             (error "setf error"))
           (unless (symbolp name)
             (error "symbol error"))
           (values (string-upcase name) 'setf)))))

(defun dictionary-symbol-fasl (name type)
  (aif (position #\! name)
    (setq name (subseq name 0 it)))
  (string-upcase name))

(defun dictionary-split-fasl (name type)
  (or2 (dictionary-setf-fasl name type)
       (dictionary-symbol-fasl name type)))

(defun dictionary-table-fasl (front type list)
  (let ((key (cons front type)))
    (when (gethash key *fasl-table*)
      (error "key error, ~S." key))
    (setf (gethash key *fasl-table*) list)))

(defun dictionary-name-fasl (front type)
  (push type (gethash front *fasl-name*)))

(defun dictionary-fasl (x)
  (let ((dic (contents-text x)))
    (dolist (name (dictionary-name dic))
      (let* ((type (dictionary-type dic))
             (list (dictionary-list dic)))
        (mvbind (front check) (dictionary-split-fasl name type)
          (when check
            (setq type check))
          (setq type (string-upcase type))
          (dictionary-table-fasl front type list)
          (dictionary-name-fasl front type))))))

(defun index-queue-fasl (x)
  (remove-if
    (lambda (x)
      (let ((x (find-contents x)))
        (and (eq (contents-type x) 'dictionary)
             (null (contents-text x)))))
    (queue-root
      (contents-queue x))))

(defun index-fasl (x)
  (dolist (x (index-queue-fasl x))
    (let ((y (find-contents x)))
      (if (contents-exists-p y)
        (faslpage y)))))

(defun faslpage (x)
  (format t "Fasl: ~A~%" (contents-string x))
  (ecase (contents-type x)
    (text (dictionary-fasl x))
    (index (index-fasl x))
    (dictionary (dictionary-fasl x))))


;;
;;  root
;;
(defun load-fasl ()
  (dolist (x (queue-root *contents-root*))
    (let ((y (find-contents x)))
      (if (contents-exists-p y)
        (faslpage y)))))

(defun header-fasl (s)
  (format s ";;~%")
  (dolist (x +header-fasl+)
    (format s ";;  ~A~%" x))
  (format s ";;~%")
  (format s "(defpackage #:npt-japanese~%")
  (format s "  (:use #:common-lisp)~%")
  (format s "  (:export #:docjp #:doc-japanese))~2%")
  (format s "(in-package #:npt-japanese)~2%"))

(defun stream-fasl (s)
  (load-fasl)
  (header-fasl s)
  (output-fasl s)
  (redirect-fasl s)
  (interface-fasl s))

(defun make-fasl ()
  (let ((file +output-fasl+)
        (*print-pretty* nil)
        (*fasl-table* (make-hash-table :test 'equal))
        (*fasl-name* (make-hash-table :test 'equal)))
    (ensure-directories-exist file)
    (with-overwrite-file (s file)
      (format t "Source: ~S~%" file)
      (stream-fasl s))))

(make-fasl)

