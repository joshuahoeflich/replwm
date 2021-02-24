(in-package #:replwm-tests)

(defsuite x11-error-suite
  (multiple-value-bind (stdout stderr)
      (with-unix-streams
        (with-env (("DISPLAY" ":72"))
          (with-wm-state (format t "Hello!~%"))))
    (suite
      (test (not (search "Hello!" stdout)))
      (test (search "Fatal error on startup." stderr))
      (test (search "Moriturus te saluto." stdout)))))

(defsuite x11-success-suite
  (multiple-value-bind (stdout stderr)
      (with-unix-streams
        (with-env (("DISPLAY" ":1"))
          (with-wm-state (format t "Hello!~%"))))
    (suite
      (test (search "Hello!" stdout))
      (test (not (search "Fatal error on startup." stderr)))
      (test (search "Moriturus te saluto." stdout)))))

(defsuite x11-suite
  (x11-success-suite)
  (x11-error-suite))
