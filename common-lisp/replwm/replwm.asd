(asdf:defsystem #:replwm
  :serial t
  :components ((:file "packages")
               (:file "src/globals")
               (:file "src/startup")
               (:file "src/events")
               (:file "src/keys")
               (:file "src/main")))

(asdf:defsystem #:replwm/test
  :serial t
  :components ((:file "packages")
               (:file "src/globals")
               (:file "src/startup")
               (:file "src/events")
               (:file "src/keys")
               (:file "src/main")
               (:file "tests/macros")
               (:file "tests/main")))
