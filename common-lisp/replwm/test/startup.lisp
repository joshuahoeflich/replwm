(in-package #:replwm-tests)

(defsuite startup-error-suite
  (test
   (string= (format nil "Could not connect to X11.~%")
            (let ((*error-output* (make-string-output-stream)))
              (catch-startup-errors
               (lambda ()
                 (sb-bsd-sockets:socket-error "Socket connection error.")))
              (get-output-stream-string *error-output*))))
  (test
   (string= (format nil "Another window manager is running.~%")
            (let ((*error-output* (make-string-output-stream)))
              (catch-startup-errors (lambda () (signal 'xlib:access-error)))
              (get-output-stream-string *error-output*))))
  (test (string= "Unexpected error thrown."
                 (handler-case
                     (catch-startup-errors
                      (lambda ()
                        (error "Unexpected error thrown.")))
                   (t (err) (format nil "~A" err))))))
