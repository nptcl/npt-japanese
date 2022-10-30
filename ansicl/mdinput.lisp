(in-package #:ansicl)

;;
;;  structure
;;
(defstruct mdinput mode)

(defun clear-mdinput (inst)
  (declare (type mdinput inst))
  (setf (mdinput-mode inst) nil))


;;
;;  parse
;;
(defun reference-mdinput (str)
  (cons 'ref (read-colon str)))

;;  string
(defun parensis-bracket-mdinput (str)
  (let ((x (position #\{ str)))
    (when x
      (let ((y (position #\} str :start (1+ x))))
        (unless y
          (error "There is no #\} character, ~S." str))
        (values (subseq str 0 x)
                (subseq str (1+ x) y)
                (subseq str (1+ y)))))))

(defun string-mdinput (str)
  (mvbind (x y z) (parensis-bracket-mdinput str)
    (if x
      (list* x (reference-mdinput y) (string-mdinput z))
      (list str))))

;;  `code`
(defun position-escape (a str &optional (start 0))
  (when (and (<= 0 start) (< start (length str)))
    (let ((b (elt str start)))
      (cond ((eql b #\\) (position-escape a str (+ 2 start)))
            ((eql a b) start)
            (t (position-escape a str (1+ start)))))))

(defun parensis-code-mdinput (str)
  (let ((x (position #\` str)))
    (when x
      (let ((y (position #\` str :start (1+ x))))
        (unless y
          (error "There is no #\` character, ~S." str))
        (values (subseq str 0 x)
                (subseq str x (1+ y))
                (subseq str (1+ y)))))))

(defun code-split-mdinput (str)
  (mvbind (x y z) (parensis-code-mdinput str)
    (if x
      (nconc (string-mdinput x)
             (list y)
             (code-split-mdinput z))
      (string-mdinput str))))


;;  ```
(defun begin-code-mdinput (str)
  (setq str (trim str))
  (and (<= 3 (length str))
       (string= (subseq str 0 3) "```")))

(defun end-code-mdinput (str)
  (string= (trim str) "```"))

(defun normal-mdinput (inst str)
  (if* (begin-code-mdinput str)
    (setf (mdinput-mode inst) 'code)
    (list str)
    :else
    (code-split-mdinput str)))

(defun code-mdinput (inst str)
  (if* (end-code-mdinput str)
    (setf (mdinput-mode inst) nil)
    (list str)
    :else
    (list str)))

(defun parse-mdinput (inst str)
  (declare (type mdinput inst))
  (ecase (mdinput-mode inst)
    ((nil) (normal-mdinput inst str))
    (code (code-mdinput inst str))))

