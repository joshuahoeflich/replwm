(in-package #:replwm-tests)

(defun stringify-stderr (fn)
  (let ((*error-output* (make-string-output-stream)))
    (funcall fn)
    (get-output-stream-string *error-output*)))

(defmacro with-display (display &body code)
  (let ((initial-display (sb-posix:getenv "DISPLAY")))
    `(progn
       (sb-posix:setenv "DISPLAY" ,display 1)
       (unwind-protect
            (suite ,@code)
         (sb-posix:setenv "DISPLAY" ,initial-display 1)))))

(defsuite startup-error-suite
  (with-display ":2"
    (test
     (string= (format nil "Another window manager is running.~%")
              (stringify-stderr #'setup-replwm!))))
  (with-display ":3"
    (test
     (string= (format nil "Could not connect to X11.~%")
              (stringify-stderr #'setup-replwm!)))))

(defsuite startup-success-suite
  (with-display ":1"
    (test (wm-state-p (setup-replwm!)))))

(defsuite setup-suite
  (startup-error-suite)
  (startup-success-suite))
