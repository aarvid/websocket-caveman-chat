

(defsystem "wsd-caveman-chat"
  :version "0.1"
  :author "andy peterson"
  :license "Unlicense"
  :depends-on ("hunchentoot"
               "clack"
               "lack"
               "caveman2"
               "envy"
               "cl-ppcre"
               "uiop"
               "websocket-driver"
               "log4cl"
               "parenscript"
               "jonathan"
               "string-case"
               "alexandria"

               ;; for @route annotation
               "cl-syntax-annot"

               ;; HTML Template
               "djula"

               ;; for DB
               "datafly"
               "sxql")
  :components ((:module "src"
                :components
                ((:file "main" :depends-on ("config" "view" "db"))
                 (:file "web" :depends-on ("view" "ps" "chat"))
                 (:file "view" :depends-on ("config"))
                 (:file "db" :depends-on ("config"))
                 (:file "ps" :depends-on ("config"))
                 (:file "chat")
                 (:file "config"))))
  :description "websocket-driver, caveman2, parenscript, chat example"
  :in-order-to ((test-op (load-op wsd-caveman-chat-test))))
