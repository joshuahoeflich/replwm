(asdf:defsystem #:replwm
  :serial t
  :components ((:file "packages")
               (:file "src/state")
               (:file "src/startup")
               (:file "src/events")))

(asdf:defsystem #:replwm/test
  :serial t
  :components ((:file "packages")
               (:file "src/state")
               (:file "test/state")
               (:file "src/startup")
               (:file "test/startup")
               (:file "src/events")
               (:file "test/events")
               (:file "src/main")
               (:file "test/main")))
