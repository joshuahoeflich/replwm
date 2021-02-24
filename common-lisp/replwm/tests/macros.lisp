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
        (handler-case
            (progn ,@code)
          (t (err) (format *error-output* "~S" err)))
        (values
         (get-output-stream-string *standard-output*)
         (get-output-stream-string *error-output*))))))
