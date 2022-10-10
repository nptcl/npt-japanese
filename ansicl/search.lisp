;;
;;  search  [TODO]
;;
(defun search-output (list)
  (dolist (x list)
    (cond ((eq x 'eol)
           (terpri))
          ((stringp x)
           (princ x))
          (t (error "Invalid object, ~S." x)))))

(defun search-partial (x)
  (declare (ignore x)))

(defun gettable (x)
  (gethash (string x) *table*))

(defun search-single (x)
  (multiple-value-bind (value check) (gettable x)
    (if check
      (search-output value)
      (search-partial x))))

(defun search-double (car cdr)
  (declare (ignore car cdr)))

(defun search-fasl (args)
  (destructuring-bind (car . cdr) args
    (if cdr
      (search-double car cdr)
      (search-single car))))

