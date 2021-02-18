(asdf:defsystem #:replwm
  :serial t
  :components ((:file "packages")
               (:file "globals")
               (:file "replwm")))

(asdf:defsystem #:replwm/test
  :serial t
  :components ((:file "packages")
               (:file "globals")
               (:file "replwm")
               (:file "replwm-tests")))

