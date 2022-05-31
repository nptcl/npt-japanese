(in-package #:ansicl)

(defmacro dbind (&rest args)
  `(destructuring-bind ,@args))

(defmacro mvbind (&rest args)
  `(multiple-value-bind ,@args))

(defvar *trim* '(#\Space #\Tab))

(defun trim-left (x)
  (string-left-trim *trim* x))

(defun trim-right (x)
  (string-right-trim *trim* x))

(defun trim (x)
  (string-trim *trim* x))

(defun split (sep str)
  (let ((x (position sep str)))
    (if x
      (cons (subseq str 0 x) (split sep (subseq str (1+ x))))
      (cons str nil))))

(defun join (sep list)
  (with-output-to-string (s)
    (let (second)
      (dolist (x list)
        (if second
          (princ sep s)
          (setq second t))
        (princ x s)))))

(defun single (x)
  (and (consp x)
       (null (cdr x))))

(defun lastcar (x)
  (car (last x)))

(defmacro with-overwrite-file ((stream file) &body body)
  `(with-open-file (,stream ,file :direction :output
                            :if-exists :supersede
                            :if-does-not-exist :create)
     ,@body))

(defun read-split (sep x)
  (if (consp x)
    x
    (mapcar #'read-from-string (split sep (princ-to-string x)))))

(defmacro or2 (&rest args)
  (cond ((null args) nil)
        ((and (consp args) (null (cdr args))) (car args))
        (t (destructuring-bind (car . cdr) args
             (let ((x (gensym)) (y (gensym)))
               `(multiple-value-bind (,x ,y) ,car
                  (if ,y
                    (values ,x ,y)
                    (or2 ,@cdr))))))))

(defun errhash (key hash)
  (multiple-value-bind (value check) (gethash key hash)
    (unless check
      (error "There is no value ~S in ~S." key hash))
    value))

(defun assocv (key list &key errorp (test 'eql))
  (let ((v (assoc key list :test test)))
    (cond (v (values (cdr v) t))
          (errorp (error "There is no value, ~S." key))
          (t (values nil nil)))))


;;
;;  anaphora
;;
(defmacro aif (expr then &optional else)
  (let ((g (gensym)))
    `(let ((,g ,expr))
       (if ,g
         (let ((it ,g))
           (progn ,then))
         ,else))))

(defmacro awhen (expr &body body)
  (let ((g (gensym)))
    `(let ((,g ,expr))
       (if ,g
         (let ((it ,g))
           (progn ,@body))))))

(defmacro aif2 (expr then &optional else)
  (let ((x (gensym)) (y (gensym)))
    `(multiple-value-bind (,x ,y) ,expr
       (if ,y
         (let ((it ,x))
           (progn ,then))
         ,else))))

(defmacro awhen2 (expr &body body)
  (let ((x (gensym)) (y (gensym)))
    `(multiple-value-bind (,x ,y) ,expr
       (if ,y
         (let ((it ,x))
           (progn ,@body))))))


;;
;;  second
;;
(defmacro if2 (expr then &optional else)
  `(if (nth-value 1 ,expr)
     ,then ,else))

(defmacro when2 (expr &body body)
  `(when (nth-value 1 ,expr)
     ,@body))

(defmacro unless2 (expr &body body)
  `(unless (nth-value 1 ,expr)
     ,@body))


;;
;;  if*
;;
(defmacro if* (expr &body body)
  (let ((pos (position-if
               (lambda (x)
                 (and (symbolp x)
                      (string-equal (symbol-name x) "else")))
               body)))
    (if pos
      `(if ,expr
         (progn ,@(subseq body 0 pos))
         (progn ,@(subseq body (1+ pos))))
      `(when ,expr ,@body))))

(defmacro if2* (expr &body body)
  `(if* (nth-value 1 ,expr)
     ,@body))

(defmacro aif* (expr &body body)
  (let ((pos (position-if
               (lambda (x)
                 (and (symbolp x)
                      (string-equal (symbol-name x) "else")))
               body)))
    (if pos
      `(aif ,expr
         (progn ,@(subseq body 0 pos))
         (progn ,@(subseq body (1+ pos))))
      `(awhen ,expr ,@body))))

(defmacro aif2* (expr &body body)
  (let ((pos (position-if
               (lambda (x)
                 (and (symbolp x)
                      (string-equal (symbol-name x) "else")))
               body)))
    (if pos
      `(aif2 ,expr
         (progn ,@(subseq body 0 pos))
         (progn ,@(subseq body (1+ pos))))
      `(awhen2 ,expr ,@body))))


;;
;;  stream
;;
(defun funcall-read (stream call)
  (let ((g '#.(gensym)))
    (do (x) (nil)
      (setq x (read stream nil g))
      (when (eq x g)
        (return nil))
      (funcall call x))))

(defun funcall-read-line (stream call)
  (do (x) (nil)
    (setq x (read-line stream nil nil))
    (unless x
      (return nil))
    (funcall call x)))


;;
;;  queue
;;
(defstruct queue root tail)

(defun enqueue (inst value)
  (declare (type queue inst))
  (let ((x (cons value nil)))
    (if (queue-root inst)
      (progn
        (setf (cdr (queue-tail inst)) x)
        (setf (queue-tail inst) x))
      (progn
        (setf (queue-root inst) x)
        (setf (queue-tail inst) x))))
  value)

(defun enqueue-new (inst value &key (test 'eql))
  (declare (type queue inst))
  (let ((root (queue-root inst)))
    (unless (member value root :test test)
      (enqueue inst value)))
  value)

(defun clear-queue (inst)
  (declare (type queue inst))
  (setf (queue-root inst) nil)
  (setf (queue-tail inst) nil)
  nil)

