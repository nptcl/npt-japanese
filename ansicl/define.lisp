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
(push (cons 7 'all) *working*)
(push (cons 10 'finish) *working*)
(push (cons 13 'finish) *working*)
(push (cons 14 'work) *working*)
(push (cons 16 'finish) *working*)

