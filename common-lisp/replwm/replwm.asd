(asdf:defsystem #:replwm
  :serial t
  :components ((:file "src/packages")
               (:file "src/state")
               (:file "src/startup")
               (:file "src/handlers")
               (:file "src/events")
               (:file "src/main")))

(asdf:defsystem #:replwm/test
  :serial t
  :components ((:file "test/packages")
               (:file "src/state")
               (:file "test/state")
               (:file "src/startup")
               (:file "test/startup")
               (:file "src/handlers")
               (:file "test/handlers")
               (:file "src/events")
               (:file "test/events")
               (:file "src/main")
               (:file "test/main")))
