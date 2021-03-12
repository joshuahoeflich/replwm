(in-package #:replwm-tests)

(defmacro stringify-stream (stream &body code)
  `(let ((,stream (make-string-output-stream)))
     ,@code
     (get-output-stream-string ,stream)))

(defsuite startup-error-suite
  (test
   (string= (format nil "Could not connect to an X server.~%")
            (stringify-stream *error-output*
              (catch-startup-errors
               (lambda () (sb-bsd-sockets:socket-error "Socket connection error."))))))
  (test
   (string= (format nil "Another window manager is running.~%")
            (stringify-stream *error-output*
              (catch-startup-errors
               (lambda () (signal 'xlib:access-error))))))
  (test (string= (format nil "Unexpected error: Success.~%")
                 (stringify-stream *error-output*
                   (catch-startup-errors
                    (lambda () (error "Success."))))))
  (test (string= (format nil "Unexpected error: Args passed.~%")
                 (stringify-stream *error-output*
                   (catch-startup-errors
                    (lambda (arg) (error (format nil "Args ~A." arg)))
                    "passed")))))
