(in-package #:ansicl)

(defconstant +load-reference+ #p"replace.lisp")
(defvar *reference-value*)

;;
;;  reference
;;
(defun reference-a (key)
  ;;  [Title](index.html)
  (let* ((v (find-contents key))
         (index (contents-join v))
         (title (contents-title v))
         (file (filename-html index)))
    (if (contents-exists-p v)
      (format nil "[~A](~A)" title file)
      title)))

(defun reference-ab (key)
  ;;  [1.2.3 Title](index.html)
  (let* ((v (find-contents key))
         (index (contents-join v))
         (title (contents-title v))
         (file (filename-html index)))
    (if (contents-exists-p v)
      (format nil "[~A. ~A](~A)" index title file)
      (format nil "~A. ~A" index title))))

(defun reference-cons (key cdr)
  (dbind (type) cdr
    (ecase type
      (link (getlink key))
      (a (reference-a key))
      (ab (reference-ab key)))))

(defun reference-single (key)
  (or2 (gethash key *reference-value*)
       (error "There is no value, ~S." key)))

(defun reference (key)
  (dbind (key . cdr) key
    (let ((key (read-split #\. key)))
      (if cdr
        (reference-cons key cdr)
        (reference-single key)))))


;;
;;  Main
;;
(defun reference-replace (cdr)
  (dbind (key value) cdr
    (unless (symbolp key)
      (error "Invalid reference key, ~S." key))
    (unless (stringp value)
      (error "Invalid reference value, ~S." value))
    (let ((key (read-split #\. key)))
      (when2 (gethash key *reference-value*)
        (error "The key ~S already exists." key))
      (setf (gethash key *reference-value*) value))))

(defun reference-call (x)
  (dbind (car . cdr) x
    (ecase car
      (replace (reference-replace cdr)))))

(defun load-reference ()
  (let ((file (merge-pathnames +load-reference+ +input+)))
    (with-open-file (s file)
      (funcall-read s #'reference-call))))

(defun init-reference ()
  (setq *reference-value* (make-hash-table :test 'equal))
  (load-reference))

(init-reference)

