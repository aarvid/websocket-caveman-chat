(in-package :cl-user)
(defpackage wsd-caveman-chat-test-asd
  (:use :cl :asdf))
(in-package :wsd-caveman-chat-test-asd)

(defsystem wsd-caveman-chat-test
  :author "andy peterson"
  :license "Unlicense"
  :depends-on ("wsd-caveman-chat"
               "prove")
  :components ((:module "t"
                :components
                ((:file "wsd-caveman-chat"))))
  :perform (load-op :after (op c) (asdf:clear-system c)))
