(in-package #:ansicl)

(defstruct dictionary name type list)

(defvar *load-begin*)
(defvar *load-parse*)
(defvar *load-list*)
(defvar *load-name*)
(defvar *load-type*)

(defun load-begin-check ()
  (unless *load-begin*
    (error "There is no @begin line.")))

(defun load-push-enqueue (x)
  (dolist (y (parse-markdown *load-parse* x))
    (enqueue *load-list* y))
  (enqueue *load-list* 'eol))

(defun string-comment-p (str)
  (let ((x (trim-left str)))
    (or (zerop (length x))
        (char= (char x 0) #\;))))

(defun load-push (x)
  (cond (*load-begin* (load-push-enqueue x))
        ((string-comment-p x))
        (t (error "There is no @begin line, ~S." x))))

(defun load-begin (cdr)
  (when *load-begin*
    (error "@begin is already exist."))
  (dbind (key) cdr
    (clear-queue *load-list*)
    (clear-queue *load-name*)
    (clear-markdown *load-parse*)
    (setq *load-type* nil)
    (setq *load-begin* (find-contents key))))

(defun load-end-instance ()
  (let* ((type *load-type*)
         (name (queue-root *load-name*))
         (list (queue-root *load-list*))
         (x (make-dictionary :type type :name name :list list)))
    (unless (or (eq type 'text) type)
      (error "There is no @name line."))
    (setf (contents-text *load-begin*) x)))

(defun load-end-reference ()
  (dolist (name (queue-root *load-name*))
    ;; (name 'link "[`name`](key.html)")
    (let* ((key (read-split #\. name))
           (name (delete-attribute name))
           (index (contents-string *load-begin*))
           (file (filename-html index))
           (value (format nil "[`~A`](~A)" name file)))
      (addlink key 'link value))))

(defun load-end (cdr)
  (when cdr
    (error "@end error, ~S." cdr))
  (load-begin-check)
  (unless *load-type*
    (error "There is no @type line."))
  (load-end-instance)
  (load-end-reference)
  (setq *load-begin* nil))

(defun load-name (cdr)
  (load-begin-check)
  (dbind (name) cdr
    (let ((list (queue-root *load-name*)))
      (when (member name list :test 'equal)
        (error "@name ~S is already exist." name))
      (enqueue *load-name* name))))

(defun load-type (cdr)
  (load-begin-check)
  (when *load-type*
    (error "@type is already exist."))
  (dbind (type) cdr
    (setq *load-type* (read-from-string type))))

(defun load-index (cdr)
  (load-begin-check)
  (unless (eq *load-type* 'text)
    (error "@type must be a text at @index operator."))
  (when cdr
    (error "@index must be a null argument, but ~S." cdr))
  (enqueue *load-list* 'index))

(defun load-command (x)
  (dbind (car . cdr) (read-colon x)
    (cond ((string-equal car "@begin")
           (load-begin cdr))
          ((string-equal car "@end")
           (load-end cdr))
          ((string-equal car "@name")
           (load-name cdr))
          ((string-equal car "@type")
           (load-type cdr))
          ((string-equal car "@index")
           (load-index cdr))
          (t (error "Invalid operator, ~S." car)))))

(defun string-first-p (str char)
  (let ((x (trim-left str)))
    (and (< 0 (length x))
         (char= (char x 0) char))))

(defun load-textfile-line (x)
  (if (string-first-p x #\@)
    (load-command x)
    (load-push x)))

(defun load-textfile-file (file)
  (with-open-file (stream file)
    (funcall-read-line stream #'load-textfile-line)))

(defun load-textfile (file)
  (let ((*load-begin* nil)
        (*load-parse* (make-markdown))
        (*load-list* (make-queue))
        (*load-name* (make-queue))
        (*load-type* nil))
    (load-textfile-file file)))

