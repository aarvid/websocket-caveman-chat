(in-package :cl-user)
(defpackage wsd-caveman-chat.chat
  (:nicknames :chat)
  (:use :cl
        :string-case
        :event-emitter
        :alexandria)
  (:export :exit-room
           :wsd-message))

(in-package :wsd-caveman-chat.chat)


(defclass chatroom (event-emitter)
  ((name :accessor get-name :initarg :name)))

(defvar *room* (make-instance 'chatroom :name "chatroom"))

(defclass person ()
  ((name :initarg :name)
   (listener :initarg :listener)) )

(defvar *hash-id-person* (make-hash-table))


(defvar *system-name* "system")

(defun get-person-by-id (id)
  (gethash id *hash-id-person*))

(defun set-person-by-id (id name listener)
  (setf (gethash id *hash-id-person*)
        (make-instance 'person :name name :listener listener)))

(defun clear-person-by-id (id)
  (remhash id *hash-id-person*))

(defun get-name-by-id (id)
  (when-let ((person (gethash id *hash-id-person*)))
    (slot-value person 'name)))

(defun room-send-message (name text)
  (emit :message *room* (jonathan:to-json (list :|name| name :|text| text))))


(defun exit-room (id)
  (when-let ((person (get-person-by-id id)))
    (clear-person-by-id id)
    (room-send-message *system-name*
                       (format nil "~a has left the room." (slot-value person 'name)))
    (event-emitter:remove-listener *room* :message (slot-value person 'listener))))

(defun enter-room (ws id name)
  (when (get-person-by-id id)
    (exit-room id))
  (let ((listener (lambda (msg) (wsd:send ws msg))))
    (set-person-by-id id name listener)
    (event-emitter:on :message *room* listener)
    (room-send-message *system-name*
                       (format nil "~a has entered the room." name))))

(defun wsd-message (ws id message)
  (let ((val (getf (jonathan:parse message) :|value|))
        (typ (getf (jonathan:parse message) :|type|)))
    (log:info "(typ . val)" (cons typ val))
    (string-case (typ)
      ("enter" (enter-room ws id val))
      ("message" (room-send-message (get-name-by-id id) val))
      ("exit" (exit-room id)))))



