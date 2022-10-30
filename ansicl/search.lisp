;;
;;  search
;;
(declaim (ftype function search-object))

(defun search-output-cons (car cdr)
  (case car
    (chapter
      (fresh-line)
      (dolist (x (car cdr))
        (search-object x)
        (terpri))
      (dolist (x (cddr cdr))
        (search-object x))
      (fresh-line)
      (terpri))
    (code1
      (princ (car cdr)))
    (code3
      (fresh-line)
      (dolist (x (cddr cdr))
        (princ x)
        (terpri)))
    (bold
      (search-object (car cdr)))))

(defun search-object (x)
  (cond ((consp x)
         (search-output-cons (car x) (cdr x)))
        ((stringp x)
         (princ x))
        ((eq x 'eol1)
         (fresh-line))
        ((eq x 'eol2)
         (fresh-line)
         (terpri))
        (t (error "Invalid object, ~S." x))))

(defun search-output (list)
  (dolist (x list)
    (search-object x)))

(defun search-partial-list (x)
  (let (list)
    (maphash
      (lambda (key value)
        (declare (ignore value))
        (when (search x key)
          (push key list)))
      *name*)
    (sort list #'string<)))

(defun search-partial (x)
  (dolist (y (search-partial-list x))
    (format t "~A~%" y)))

(defun search-single (x)
  (let ((x (string x)))
    (multiple-value-bind (value check) (gethash x *table*)
      (if check
        (search-output value)
        (search-partial x)))))

(defun search-double (car cdr)
  (destructuring-bind (type) cdr
    (let ((key (cons (string car) (string type))))
      (multiple-value-bind (value check) (gethash key *table*)
        (if check
          (search-output value))))))

(defun search-fasl (args)
  (destructuring-bind (car . cdr) args
    (if cdr
      (search-double car cdr)
      (search-single car))))

