(asdf:defsystem #:replwm
  :serial t
  :components ((:file "packages")
               (:file "src/utils")))

(asdf:defsystem #:replwm/test
  :serial t
  :components ((:file "packages")
               (:file "src/utils")
               (:file "test/utils")))
