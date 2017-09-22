(in-package :cl-user)
(defpackage wsd-caveman-chat
  (:use :cl)
  (:import-from :wsd-caveman-chat.config
                :config)
  (:import-from :clack
                :clackup)
  (:export :start
           :stop))
(in-package :wsd-caveman-chat)

(defvar *appfile-path*
  (asdf:system-relative-pathname :wsd-caveman-chat #P"app.lisp"))

(defvar *handler* nil)

;; changed to make 8080 the default port.  Clackup uses 5000 as the default port.
(defun start (&rest args &key server (port 8080 portp) debug &allow-other-keys)
  (declare (ignore server debug))
  (when *handler*
    (restart-case (error "Server is already running.")
      (restart-server ()
        :report "Restart the server"
        (stop))))
  (setf *handler*
        (apply #'clackup *appfile-path*
               (if portp
                   args
                   (list* :port port args)))))

(defun stop ()
  (prog1
      (clack:stop *handler*)
    (setf *handler* nil)))
