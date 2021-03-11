(in-package #:replwm-tests)

;; Because running this suite requires the presense of another window manager,
;; we don't yet execute it in our CI pipeline. Pull requests welcome for that
;; use case!
(defsuite startup-error-suite
  (test
   (string=
    (with (*error-output* (make-string-output-stream))
          (setup!)
          (get-output-stream-string *error-output*))
    (format nil
            "Fatal error on startup: Another window manager is running.~%Exiting replwm.")))
  (sb-posix:setenv "DISPLAY" ":2" 1)
  (test (string=
         (with (*error-output* (make-string-output-stream))
               (setup!)
               (get-output-stream-string *error-output*))
         (format nil "Fatal error on startup: Couldn't open X11.~%Exiting replwm.")))
  (sb-posix:setenv "DISPLAY" ":0" 1))
