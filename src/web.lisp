(in-package :cl-user)
(defpackage wsd-caveman-chat.web
  (:use :cl
        :caveman2
        :wsd-caveman-chat.config
        :wsd-caveman-chat.view
        :wsd-caveman-chat.db
        :datafly
        :sxql
        :string-case
        :event-emitter
        :alexandria)
  (:import-from :wsd-caveman-chat.ps
   :compile-paren-file)
  (:import-from :wsd-caveman-chat.chat
   :wsd-message
   :exit-room)
  (:export :*web*))

(in-package :wsd-caveman-chat.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;;
;; Routing rules

(defroute "/" ()
  (compile-paren-file "wsd" t)
  (render #P"index.html"))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))


(defvar *id* 0
  "counter to create a unique number to identify websocket connection")

;; this is the websocket chat server.
(defroute wsd-chat-server "/chat-server" ()
  (log:info "env: ~a~%" (request-env *request*))
  (let ((ws (wsd:make-server (request-env *request*)))
        (id (incf *id*))) 
    (wsd:on :message ws
            (lambda (message)
              (log:info 'message message)
              (chat:wsd-message ws id message)))
    (wsd:on :open ws
            (lambda (&rest args)
              (log:info "Connected. " args)))
    (wsd:on :error ws
            (lambda (&rest args)
              (log:info "Error. " args)))
    (wsd:on :close ws
      (lambda (&rest args)
        (log:info "Closed" args)
        (chat:exit-room id)))
    (lambda (responder)
      (declare (ignore responder))
      (wsd:start-connection ws))))
