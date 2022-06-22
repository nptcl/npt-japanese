(in-package #:ansicl)

;;
;;  structure
;;
(defstruct markdown mode)

(defun clear-markdown (inst)
  (declare (type markdown inst))
  (setf (markdown-mode inst) nil))


;;
;;  parse
;;
(defun reference-markdown (str)
  (cons 'ref (read-colon str)))

;;  string
(defun parensis-bracket-markdown (str)
  (let ((x (position #\{ str)))
    (when x
      (let ((y (position #\} str :start (1+ x))))
        (unless y
          (error "There is no #\} character, ~S." str))
        (values (subseq str 0 x)
                (subseq str (1+ x) y)
                (subseq str (1+ y)))))))

(defun string-markdown (str)
  (mvbind (x y z) (parensis-bracket-markdown str)
    (if x
      (list* x (reference-markdown y) (string-markdown z))
      (list str))))

;;  `code`
(defun position-escape (a str &optional (start 0))
  (when (and (<= 0 start) (< start (length str)))
    (let ((b (elt str start)))
      (cond ((eql b #\\) (position-escape a str (+ 2 start)))
            ((eql a b) start)
            (t (position-escape a str (1+ start)))))))

(defun parensis-code-markdown (str)
  (let ((x (position #\` str)))
    (when x
      (let ((y (position #\` str :start (1+ x))))
        (unless y
          (error "There is no #\` character, ~S." str))
        (values (subseq str 0 x)
                (subseq str x (1+ y))
                (subseq str (1+ y)))))))

(defun code-split-markdown (str)
  (mvbind (x y z) (parensis-code-markdown str)
    (if x
      (nconc (string-markdown x)
             (list y)
             (code-split-markdown z))
      (string-markdown str))))


;;  ```
(defun begin-code-markdown (str)
  (setq str (trim str))
  (and (<= 3 (length str))
       (string= (subseq str 0 3) "```")))

(defun end-code-markdown (str)
  (string= (trim str) "```"))

(defun normal-markdown (inst str)
  (if* (begin-code-markdown str)
    (setf (markdown-mode inst) 'code)
    (list str)
    :else
    (code-split-markdown str)))

(defun code-markdown (inst str)
  (if* (end-code-markdown str)
    (setf (markdown-mode inst) nil)
    (list str)
    :else
    (list str)))

(defun parse-markdown (inst str)
  (declare (type markdown inst))
  (ecase (markdown-mode inst)
    ((nil) (normal-markdown inst str))
    (code (code-markdown inst str))))

