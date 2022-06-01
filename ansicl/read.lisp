(in-package #:ansicl)

;;
;;  find-file
;;
(defvar *find-file*)

(defun find-file-directory-p (x)
  (and (pathnamep x)
       (null (pathname-name x))
       (null (pathname-type x))))

(defun find-file-call (base type)
  (let ((base (make-pathname :name :wild :type type :defaults base)))
    (dolist (x (directory base))
      (cond ((find-file-directory-p x)
             (find-file-call x type))
            ((equalp (pathname-type x) type)
             (push x *find-file*))))))

(defun find-file (base type)
  (let (*find-file*)
    (find-file-call base type)
    *find-file*))

(defun main-read ()
  (let* ((list (find-file #p"data/**/" "txt"))
         (files (sort list #'string< :key #'namestring)))
    (dolist (file files)
      (format t "Load: ~S~%" file)
      (load-textfile file))))


;;
;;  main
;;
(main-read)

