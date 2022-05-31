(in-package #:ansicl)

(defconstant +load-contents+ #p"contents.lisp")
(defvar *contents-dictionary*)
(defvar *contents-root*)
(defvar *contents*)

(defstruct contents index type queue title english text)

(defun find-contents (key &optional (errorp t))
  (let ((list (read-split #\. key)))
    (mvbind (inst check) (gethash list *contents*)
      (cond (check (values inst t))
            (errorp (error "find-contents error, ~S." list))
            (t (values nil nil))))))

(defun filename-join (x)
  (string-downcase
    (join #\. x)))

(defun contents-join (x)
  (join #\. (contents-index x)))

(defun contents-string (x)
  (string-downcase
    (contents-join x)))

(defun contents-instance (index type title english)
  (make-contents
    :index (read-split #\. index)
    :type type
    :queue (make-queue)
    :title title
    :english english))

(defun contents-add-next (key key1)
  (aif2 (gethash key1 *contents*)
    (let ((queue (contents-queue it)))
      (enqueue-new queue key :test 'equal))
    (error "key error, ~S." key1)))

(defun contents-add-loop (key)
  (when key
    (aif* (butlast key)
      (contents-add-next key it)
      (contents-add-loop it)
      :else
      (enqueue-new *contents-root* key :test 'equal))))

(defun contents-add (x)
  (let ((key (contents-index x)))
    (when2 (gethash key *contents*)
      (error "The key ~S already exist." key))
    (setf (gethash key *contents*) x)
    (contents-add-loop key)))

(defun contents-read-type (cdr type)
  (dbind (index title &optional english) cdr
    (unless (or (stringp title) (symbolp title))
      (error "Invalid title, ~S." title))
    (unless (or (stringp english)
                (null english))
      (error "Invalid english, ~S." english))
    (contents-add
      (contents-instance index type title english))))

(defun contents-read-index (cdr)
  (contents-read-type cdr 'index))

(defun contents-read-text (cdr)
  (contents-read-type cdr 'text))

(defun contents-add-dictionary (index)
  (let ((a (car index))
        (b (butlast index))
        (c (car (last index))))
    (unless (assoc a *contents-dictionary* :test 'equal)
      (setq *contents-dictionary* (acons a b *contents-dictionary*)))
    (addlink (read-split #\. c) 'dictionary t)))

(defun contents-read-dictionary (cdr)
  (dbind (index) cdr
    (let ((index (read-split #\. index)))
      (contents-add
        (contents-instance index 'dictionary nil nil))
      (contents-add-dictionary index))))

(defun contents-lambda (x)
  (dbind (car . cdr) x
    (ecase car
      (index (contents-read-index cdr))
      (text (contents-read-text cdr))
      (dictionary (contents-read-dictionary cdr)))))

(defun load-contents ()
  (let ((file (merge-pathnames +load-contents+ +input+)))
    (with-open-file (s file)
      (funcall-read s #'contents-lambda))))

(defun contents-dictionary (key)
  (assocv key *contents-dictionary* :test 'equal))

(defun contents-exists-p (x)
  (let ((type (contents-type x)))
    (if (eq type 'index)
      (and (queue-root (contents-queue x)) t)
      (and (contents-text x) t))))


;;
;;  Interface
;;
(defun init-contents ()
  (setq *contents-dictionary* nil)
  (setq *contents-root* (make-queue))
  (setq *contents* (make-hash-table :test 'equal)))

(defun clear-contents ()
  (setq *contents-dictionary* nil)
  (clear-queue *contents-root*)
  (clrhash *contents*))

(defmacro with-contents (&body body)
  `(let (*contents-dictionary* *contents-root* *contents*)
     ,@body))

(init-contents)
(load-contents)

