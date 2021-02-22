(asdf:defsystem #:replwm
  :serial t
  :components ((:file "packages")
               (:file "replwm/startup")
               (:file "replwm/events")
               (:file "replwm/keys")
               (:file "replwm/main")))

(asdf:defsystem #:replwm/test
  :serial t
  :components ((:file "packages")
               (:file "replwm/startup")
               (:file "replwm/events")
               (:file "replwm/keys")
               (:file "replwm/main")
               (:file "replwm-tests/macros")
               (:file "replwm-tests/main")))

