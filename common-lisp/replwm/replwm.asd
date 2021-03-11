(asdf:defsystem #:replwm
  :serial t
  :components ((:file "packages")
               (:file "src/utils")
               (:file "src/startup")))

(asdf:defsystem #:replwm/test
  :serial t
  :components ((:file "packages")
               (:file "src/utils")
               (:file "test/utils")
               (:file "src/startup")
               (:file "test/startup")))
