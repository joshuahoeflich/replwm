(asdf:defsystem #:replwm
  :serial t
  :components ((:file "packages")
               (:file "src/startup")))

(asdf:defsystem #:replwm/test
  :serial t
  :components ((:file "packages")
               (:file "src/startup")
               (:file "test/startup")))
