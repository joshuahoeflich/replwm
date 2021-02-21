(in-package #:replwm-tests)

(defun set-envs (env-assoc)
  (dolist (el env-assoc)
    (sb-posix:setenv (first el) (second el) 1)))

(defun to-current-envs (env-assoc)
  (labels ((to-current-env (l) (let ((x (first l)))
                                 (list x (sb-ext:posix-getenv x)))))
    (mapcar #'to-current-env env-assoc)))

(defmacro with-env (pairs &body code)
  (let ((old-envs (gensym))
        (new-envs (gensym)))
    `(let ((,new-envs ',pairs)
           (,old-envs (to-current-envs ',pairs)))
       (set-envs ,new-envs)
       ,@code
       (set-envs ,old-envs))))

(defmacro with-unix-streams (&body code)
  `((lambda ()
      (let ((*standard-output* (make-string-output-stream))
            (*error-output* (make-string-output-stream)))
        ,@code
        (values
         (get-output-stream-string *standard-output*)
         (get-output-stream-string *error-output*))))))

(defsuite x11-error-suite
  (multiple-value-bind (stdout stderr)
      (with-unix-streams
        (with-env (("DISPLAY" "non-existing"))
          (with-replwm (format t "Hello!~%"))))
    (suite
      (test (not (search "Hello!" stdout)))
      (test (search "Fatal error on startup." stderr))
      (test (search "Moriturus te saluto." stdout)))))

(defsuite x11-success-suite
  (multiple-value-bind (stdout stderr)
      (with-unix-streams
        (with-env (("DISPLAY" ":1"))
          (with-replwm (format t "Hello!~%"))))
    (declare (ignore stderr))
    (suite
      (test (search "Hello!" stdout))
      (test (not (search "Fatal error on startup." stderr)))
      (test (search "Moriturus te saluto." stdout)))))

(defsuite x11-suite
  (x11-success-suite)
  (x11-error-suite))
