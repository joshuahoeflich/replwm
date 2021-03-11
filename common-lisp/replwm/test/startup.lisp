(in-package #:replwm-tests)

;; Because running this suite requires the presense of another window manager,
;; we don't yet execute it in our CI pipeline. Pull requests welcome for that
;; use case!
(defsuite startup-error-suite
  (test
   (string=
    (with (*error-output* (make-string-output-stream))
          (setup-window-manager!)
          (get-output-stream-string *error-output*))
    (format nil
            "Fatal error on startup: Another window manager is running.~%Exiting replwm.")))
  )






(defsuite setup-suite
  )
