(in-package #:ansicl)

(defun cons-symbol-p (cons symbol)
  (and (consp cons)
       (eq (car cons) symbol)))

(defun check-code1-p (x)
  (cons-symbol-p x 'code1))

(defun check-code3-p (x)
  (cons-symbol-p x 'code3))

(defun check-strong-p (x)
  (cons-symbol-p x 'strong))

(defun check-chapter-p (x)
  (cons-symbol-p x 'chapter))

(defun null-string-p (x)
  (and (stringp x)
       (= (length x) 0)))

(defun list-null-string-p (x)
  (and (consp x)
       (null (cdr x))
       (null-string-p (car x))))


;;
;;  parse-fasl
;;
(defun group-if (test list &key (key #'values) (include t))
  (let (root child)
    (dolist (x list)
      (if (funcall test (funcall key x))
        (progn
          (when child
            (push (reverse child) root)
            (setq child nil))
          (when include
            (push x child)))
        (push x child)))
    (when child
      (push (nreverse child) root))
    (nreverse root)))

(defun parse-fasl-group-markdown (list)
  (group-if
    (lambda (x) (eq x 'eol))
    list
    :include nil))

(defun parse-fasl-string-markdown (list)
  (when list
    (dolist (x list)
      (unless (stringp x)
        (error "Invalid string, ~S." x)))
    (apply #'concatenate 'string list)))

(defun parse-fasl-markdown (list)
  (mapcar
    #'parse-fasl-string-markdown
    (parse-fasl-group-markdown list)))


;;
;;  code3
;;
(defun check-code3-markdown (x)
  (when (stringp x)
    (let ((y (string-left-trim '(#\Space #\Tab) x)))
      (and (<= 3 (length y))
           (equal (subseq y 0 3) "```")))))

(defun split-code3-markdown (list)
  (let (output group first)
    (dolist (x list)
      (if (check-code3-markdown x)
        (if first
          (progn
            (push (list* 'code3 first x (nreverse group)) output)
            (setq group nil first nil))
          (setq group nil first x))
        (if first
          (if (null-string-p x)
            (push nil group)
            (push x group))
          (push x output))))
    (when first
      (error "code3 ``` error."))
    (nreverse output)))


;;
;;  make-list-markdown
;;
(defun make-list-markdown (list)
  (mapcar
    (lambda (x)
      (cond ((check-code3-p x) x)
            ((stringp x) (list x))
            (t (error "Invalid object, ~S." x))))
    list))


;;
;;  parensis
;;
(defun position-escape (escapep x seq &key (start 0))
  (if (null escapep)
    (position x seq :start start)
    (let ((size (length seq)) escape k y)
      (decf size start)
      (dotimes (i size)
        (setq k (+ i start))
        (setq y (elt seq k))
        (cond (escape (setq escape nil))
              ((eql #\\ y) (setq escape t))
              ((eql x y) (return k)))))))

(defun position-character-markdown (escapep x str)
  (cond ((check-code1-p str) nil)
        ((check-strong-p str) nil)
        ((stringp str)
         (position-escape escapep x str))
        (t (error "Invalid object, ~S." str))))

(defun split-character-markdown (key left right escapep str)
  (let ((x (position-character-markdown escapep left str)))
    (if (null x)
      (list str)
      (let ((y (position-escape escapep right str :start (1+ x))))
        (unless y
          (error "parensis error, ~S, ~S, ~S." right str x))
        (let ((a (subseq str 0 x))
              (b (subseq str (1+ x) y))
              (c (subseq str (1+ y)))
              output)
          (unless (zerop (length a))
            (push a output))
          (push (list key b) output)
          (dolist (y (split-character-markdown key left right escapep c))
            (push y output))
          (nreverse output))))))

(defun mapcan-character-markdown (key left right escapep list)
  (mapcan
    (lambda (x)
      (split-character-markdown key left right escapep x))
    list))

(defun parensis-character-markdown (key left right escapep list)
  (mapcar
    (lambda (x)
      (if (check-code3-p x)
        x
        (mapcan-character-markdown key left right escapep x)))
    list))

(defun parensis-strong-markdown (list)
  (parensis-character-markdown 'strong #\* #\* t list))

(defun parensis-code1-markdown (list)
  (parensis-character-markdown 'code1 #\` #\` nil list))

(defun split-parensis-markdown (list)
  (parensis-strong-markdown
    (parensis-code1-markdown list)))


;;
;;  chapter
;;
(defun split-chapter-length (x &optional (p 0) (v 0))
  (let ((p1 (1+ p)))
    (if (and (<= p1 (length x))
             (char= (char x p) #\#))
      (split-chapter-length x p1 (1+ v))
      v)))

(defun check-chapter-markdown (x)
  (when (and (consp x)
             (stringp (car x)))
    (let* ((y (string-trim '(#\Space #\Tab) (car x)))
           (n (split-chapter-length y)))
      (unless (zerop n)
        (values t x n)))))

(defun remove-null-first (list)
  (if (and (consp list)
           (null (car list)))
    (remove-null-first (cdr list))
    list))

(defun remove-null-last (list)
  (if (and (consp list)
           (null (car (last list))))
    (remove-null-last (nbutlast list))
    list))

(defun split-chapter-body (first number list)
  (list* 'chapter first number
         (remove-null-last
           (remove-null-first
             (nreverse list)))))

(defun spilt-chapter-markdown (list)
  (let (output group first (number 0))
    (dolist (x list)
      (multiple-value-bind (check name id) (check-chapter-markdown x)
        (if check
          (progn
            (push (split-chapter-body first number group) output)
            (setq group nil first name number id))
          (push x group))))
    (when group
      (push (split-chapter-body first number group) output))
    (nreverse output)))


;;
;;  reform
;;
(defun make-eol2-chapter-markdown (list)
  (let (root eol1 eol2)
    (dolist (y list)
      (cond ((null y) (setq eol2 t))
            ((check-code3-p y) (push y root))
            (t (dolist (x y)
                 (cond ((eq x 'eol1) (setq eol1 t))
                       (t (when eol2
                            (push 'eol2 root)
                            (setq eol1 nil eol2 nil))
                          (when eol1
                            (push 'eol1 root)
                            (setq eol1 nil eol2 nil))
                          (push x root)))))))
    (nreverse root)))

(defun eol1-string-p (x)
  (when (stringp x)
    (let ((n (length x)))
      (and (<= 2 n)
           (equal (subseq x (- n 2)) "  ")
           (subseq x 0 (- n 2))))))

(defun list-eol1-chapter-markdown (list)
  (when list
    (let ((head (butlast list))
          (tail (car (last list)))
          root)
      (dolist (x head)
        (push x root))
      (aif (eol1-string-p tail)
        (progn
          (unless (null-string-p it)
            (push it root))
          (push 'eol1 root))
        (push tail root))
      (nreverse root))))

(defun make-eol1-chapter-markdown (list)
  (mapcar
    #'list-eol1-chapter-markdown
    list))

(defun remove-null-chapter-markdown (list)
  (mapcar
    (lambda (x)
      (remove-if #'null-string-p x))
    list))

(defun body-chapter-markdown (list)
  (make-eol2-chapter-markdown
    (make-eol1-chapter-markdown
      (remove-null-chapter-markdown list))))

(defun left-trim-chapter-markdown (x)
  (if (and (consp x)
           (null (car x)))
    (left-trim-chapter-markdown (cdr x))
    x))

(defun right-trim-chapter-markdown (x)
  (if (and (consp x)
           (null (car (last x))))
    (right-trim-chapter-markdown (butlast x))
    x))

(defun null-replace-chapter-markdown (list)
  (mapcar
    (lambda (x)
      (if (list-null-string-p x) nil x))
    list))

(defun null-chapter-markdown (x)
  (destructuring-bind (chapter first number . body) x
    (list* chapter first number
           (body-chapter-markdown
             (right-trim-chapter-markdown
               (left-trim-chapter-markdown
                 (null-replace-chapter-markdown body)))))))

(defun reform-chapter-markdown (list)
  (mapcar
    (lambda (x)
      (if (check-chapter-p x)
        (null-chapter-markdown x)
        x))
    list))

(defun reform-markdown (list)
  (reform-chapter-markdown list))


;;
;;  Interface
;;
(defun parse-markdown (list)
  (reform-markdown
    (spilt-chapter-markdown
      (split-parensis-markdown
        (make-list-markdown
          (split-code3-markdown list))))))

(defun fasl-markdown (list)
  (parse-markdown
    (parse-fasl-markdown list)))

