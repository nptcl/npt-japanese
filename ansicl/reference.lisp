(in-package #:ansicl)

(defconstant +load-reference+ #p"replace.lisp")
(defvar *reference-value*)
(defvar *reference-update*)
(defvar *reference-fasl*)

;;
;;  reference
;;
(defun reference-a (key)
  ;;  [Title](index.html)
  (let* ((v (find-contents key))
         (index (contents-join v))
         (title (contents-title v))
         (file (filename-html index)))
    (if (and (null *reference-fasl*)
             (contents-exists-p v))
      (format nil "[~A](~A)" title file)
      title)))

(defun reference-ab (key)
  ;;  [1.2.3 Title](index.html)
  (let* ((v (find-contents key))
         (index (contents-join v))
         (title (contents-title v))
         (file (filename-html index)))
    (if (and (null *reference-fasl*)
             (contents-exists-p v))
      (format nil "[~A. ~A](~A)" index title file)
      (format nil "~A. ~A" index title))))

(defun reference-link (key)
  (if *reference-fasl*
    (format nil "`~A`" (delete-attribute (car key)))
    (getlink key)))

(defun reference-cons (key cdr)
  (dbind (type) cdr
    (ecase type
      (link (reference-link key))
      (a (reference-a key))
      (ab (reference-ab key)))))

(defun reference-single (key)
  (or2 (gethash key *reference-value*)
       (error "There is no value, ~S." key)))

(defun reference-find (key)
  (dbind (key . cdr) key
    (let ((key (read-split #\. key))
          (cdr (mapcar #'read-from-string cdr)))
      (if cdr
        (reference-cons key cdr)
        (reference-single key)))))


;;
;;  recursive replace
;;
(defun reference-update (str)
  (setq *reference-update* t)
  (reference-find (read-colon str)))

(defun reference-parensis (str)
  (mvbind (x y z) (parensis-bracket-markdown str)
    (if x
      (list* x (reference-update y) (reference-parensis z))
      (list str))))

(defun reference-code (str)
  (mvbind (x y z) (parensis-code-markdown str)
    (if x
      (nconc (reference-parensis x)
             (list y)
             (code-split-markdown z))
      (reference-parensis str))))

(defun reference-concatenate (str)
  (let ((list (reference-code str)))
    (when *reference-update*
      (with-output-to-string (s)
        (dolist (x list)
          (princ x s))))))

(defun reference-loop (str)
  (setq *reference-update* nil)
  (let ((value (reference-concatenate str)))
    (if *reference-update*
      (reference-loop value)
      str)))

(defun reference (key)
  (let (*reference-update* *reference-fasl*)
    (reference-loop
      (reference-find key))))

(defun reference-string (str)
  (let (*reference-update* *reference-fasl*)
    (reference-loop str)))

(defun reference-fasl (key)
  (let (*reference-update* (*reference-fasl* t))
    (reference-loop
      (reference-find key))))


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

