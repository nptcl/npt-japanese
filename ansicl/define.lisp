(in-package #:ansicl)

(defconstant +input+ #p"data/")
(defconstant +output+ #p"root/")

;;
;;  filename
;;
(defun filename-defaults (name type defaults)
  (make-pathname
    :name (string-downcase (substitute #\- #\! name))
    :type (string-downcase type)
    :defaults defaults))

(defun filename-input (name type)
  (filename-defaults name type +input+))

(defun filename-output (name type)
  (filename-defaults name type +output+))

(defun filename-html (name)
  (format nil "~A.html" (string-downcase (substitute #\- #\! name))))

(defun delete-attribute (str)
  (let ((str (string-downcase str)))
    (aif (position #\! str)
      (subseq str 0 it)
      str)))

(defun mapcar-delete-attribute (list)
  (mapcar #'delete-attribute list))


;;
;;  Dictionary
;;
(defvar *working* nil)

;;  Finish
(push (cons 3 'finish) *working*)
(push (cons 4 'all) *working*)
(push (cons 5 'finish) *working*)
(push (cons 6 'finish) *working*)
(push (cons 7 'all) *working*)
(push (cons 8 'all) *working*)
(push (cons 9 'finish) *working*)
(push (cons 10 'finish) *working*)
(push (cons 11 'finish) *working*)
(push (cons 12 'finish) *working*)
(push (cons 13 'finish) *working*)
(push (cons 14 'finish) *working*)
(push (cons 15 'finish) *working*)
(push (cons 16 'finish) *working*)
(push (cons 17 'finish) *working*)
(push (cons 18 'finish) *working*)
(push (cons 19 'finish) *working*)
(push (cons 20 'finish) *working*)
(push (cons 21 'finish) *working*)
(push (cons 22 'finish) *working*)
(push (cons 23 'finish) *working*)
(push (cons 24 'finish) *working*)
(push (cons 25 'finish) *working*)

