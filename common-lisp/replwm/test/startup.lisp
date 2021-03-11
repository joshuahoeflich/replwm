(in-package #:replwm-tests)

(defun stringify-stderr (fn)
  (let ((*error-output* (make-string-output-stream)))
    (funcall fn)
    (get-output-stream-string *error-output*)))

;; Because running this suite requires another window manager to exist on
;; DISPLAY :0, we don't yet execute it in our CI pipeline. Pull requests
;; welcome!
(defsuite startup-error-suite
  (test
   (string= (format nil "Another window manager is running.~%")
            (stringify-stderr #'setup-replwm!)))
  (sb-posix:setenv "DISPLAY" ":2" 1)
  (test
   (string= (format nil "Could not connect to X11.~%")
            (stringify-stderr #'setup-replwm!)))
  (sb-posix:setenv "DISPLAY" ":0" 1))

(defsuite startup-success-suite
  (sb-posix:setenv "DISPLAY" ":1" 1)
  (test (wm-state-p (setup-replwm!)))
  (sb-posix:setenv "DISPLAY" ":0" 1))
