(in-package #:replwm-tests)

(defmacro with-unix-streams (&body code)
  `((lambda ()
      (let ((*standard-output* (make-string-output-stream))
            (*error-output* (make-string-output-stream)))
        ,@code
        (values
         (get-output-stream-string *standard-output*)
         (get-output-stream-string *error-output*))))))

(defsuite x11-success-suite
  (multiple-value-bind (stdout stderr)
      (with-unix-streams
        (with-replwm (format t "Hello!~%")))
    (declare (ignore stderr))
    (suite
      (test (search "Hello!" stdout))
      (test (search "Moriturus te saluto." stdout)))))

(defsuite x11-suite
  (x11-success-suite))
