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

