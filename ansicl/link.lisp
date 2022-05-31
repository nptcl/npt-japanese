(in-package #:ansicl)

;;
;;  link
;;
(defvar *link*)

(defun addlink-acons (key type value list)
  (when (assoc type list)
    (error "The value is already exist, ~S, ~S." key type))
  (setf (gethash key *link*) (acons type value list)))

(defun addlink (key type value)
  (aif2 (gethash key *link*)
    (addlink-acons key type value it)
    (setf (gethash key *link*) (acons type value nil))))

(defun getlink (key)
  (let ((v (errhash key *link*)))
    (or2 (assocv 'link v)
         (format nil "`~A`" (delete-attribute (car key))))))

(defun init-link ()
  (setq *link* (make-hash-table :test 'equal)))

(init-link)

