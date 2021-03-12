(in-package #:replwm-tests)

(defmacro stringify-stderr (&body code)
  `(let ((*error-output* (make-string-output-stream)))
     ,@code
     (get-output-stream-string *error-output*)))

(defsuite startup-error-suite
  (test
   (string= (format nil "Could not connect to X11.~%")
            (stringify-stderr
              (catch-startup-errors
               (lambda () (sb-bsd-sockets:socket-error "Socket connection error."))))))
  (test
   (string= (format nil "Another window manager is running.~%")
            (stringify-stderr
              (catch-startup-errors
               (lambda () (signal 'xlib:access-error))))))
  (test (string= (format nil "Unexpected error: Success.~%")
                 (stringify-stderr
                   (catch-startup-errors
                    (lambda () (error "Success."))))))
  (test (string= (format nil "Unexpected error: Args passed.~%")
                 (stringify-stderr
                   (catch-startup-errors
                    (lambda (arg) (error (format nil "Args ~A." arg)))
                    "passed")))))
