;;
;; parenscript package definition

(defpackage wsd-caveman-chat.ps
  (:use :cl :parenscript)
  (:export :compile-paren-file))

(in-package :wsd-caveman-chat.ps)

(defparameter *base-dir*
  (asdf:system-source-directory :wsd-caveman-chat))

(defparameter *parenscript-dir*
  (merge-pathnames  (make-pathname :directory '(:relative "paren")) *base-dir*))

(defparameter *static-js-dir*
  (merge-pathnames  (make-pathname :directory '(:relative "static" "js")) *base-dir*))

(defun compile-paren-file (name &optional check-date)
  (let ((inf (merge-pathnames (make-pathname :name name :type "paren")
                              *parenscript-dir*))
        (outf (merge-pathnames (make-pathname :name name :type "js")
                               *static-js-dir*)))
    (when (and (uiop:file-exists-p inf)
               (or (not check-date)
                   (not (uiop:file-exists-p outf))
                   (> (file-write-date inf) (file-write-date outf))))
      (with-open-file (in inf :direction :input)
        (with-open-file (out outf :direction :output
                                  :if-exists :supersede
                                  :if-does-not-exist :create)
          (let ((*parenscript-stream* out))
            (ps:ps-compile-stream in))
          outf)))))
