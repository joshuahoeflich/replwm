(asdf:defsystem #:replwm
  :serial t
  :components ((:file "packages")
               (:file "replwm")))

(asdf:defsystem #:replwm/test
  :serial t
  :components ((:file "packages")
               (:file "replwm")
               (:file "replwm-tests")))

