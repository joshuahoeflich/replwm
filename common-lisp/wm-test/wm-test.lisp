(defpackage #:wm-test
  (:use #:common-lisp)
  (:export #:xtest #:test #:defsuite #:suite #:run-suites))

(in-package #:wm-test)

(defun write-green (string)
  (format t "~c[~A~A~c[~A~%" #\ESC "32m" string #\ESC "0m"))

(defun log-error (s-exp err)
  (format t
          "~%~c[~A~c[~ATest errored:~c[~A~%~A~%~c[~A~c[~AError was:~c[~A ~A~%"
          #\ESC "1m" #\ESC "31m" #\ESC "0m" s-exp
          #\ESC "1m" #\ESC "31m" #\ESC "0m" err))

(defun log-failure (s-exp)
  (format t
          "~%~c[~A~c[~ATest failed:~c[~A~%~A"
          #\ESC "1m" #\ESC "31m" #\ESC "0m" s-exp))

(defun handle-test-values (result s-exp err)
  (cond
    ((not (null err))
     (log-error s-exp err))
    ((eq result :fail)
     (log-failure s-exp)))
  result)

(defmacro xtest-values (exp)
  (declare (ignore exp))
  `:ignore)

(defmacro test-values (exp)
  `(handler-case (values (if ,exp :pass :fail) ',exp nil)
     (t (err) (values :error ',exp err))))

(defmacro xtest (exp &key (handler 'handle-test-values))
  (declare (ignore exp handler))
  `:ignore)

(defmacro test (exp &key (handler 'handle-test-values))
  `(multiple-value-bind (result s-exp err) (test-values ,exp)
     (,handler result s-exp (or err nil))))

(defstruct (suite-results
            (:print-function
             (lambda (struct stream depth)
               (declare (ignore depth))
               (let ((ignored (suite-results-ignored struct)))
                 (format stream
                         "~A passed, ~A failed, ~A errored~:[.~;, ~A ignored.~]~%"
                         (suite-results-passed struct)
                         (suite-results-failed struct)
                         (suite-results-errored struct)
                         (> ignored 0)
                         ignored)))))
  (passed 0 :type unsigned-byte)
  (failed 0 :type unsigned-byte)
  (errored 0 :type unsigned-byte)
  (ignored 0 :type unsigned-byte))

(defun suite-key-p (field)
  (or (eq field :pass)
      (eq field :fail)
      (eq field :error)
      (eq field :ignore)))

(defun bump-suite-field! (suite field)
  (case field
    (:pass (incf (suite-results-passed suite)))
    (:fail (incf (suite-results-failed suite)))
    (:error (incf (suite-results-errored suite)))
    (:ignore (incf (suite-results-ignored suite)))))

(defun merge-suites! (acc-suite fin-suite)
  (incf (suite-results-passed acc-suite) (suite-results-passed fin-suite))
  (incf (suite-results-failed acc-suite) (suite-results-failed fin-suite))
  (incf (suite-results-errored acc-suite) (suite-results-errored fin-suite))
  (incf (suite-results-ignored acc-suite) (suite-results-ignored fin-suite))
  acc-suite)

(defun update-suite-results! (suite el)
  (cond
    ((suite-key-p el)
     (bump-suite-field! suite el))
    ((suite-results-p el)
     (merge-suites! suite el)))
  suite)

(defmacro suite (&body body)
  `(reduce #'update-suite-results! (list ,@body)
           :initial-value (make-suite-results)))

(defmacro defsuite (name &body body)
  `(defun ,name () (suite ,@body)))

(defun suite-problems-p (suite-result)
  (or
   (> (suite-results-failed suite-result) 0)
   (> (suite-results-errored suite-result) 0)))

(defun run-suite (s)
  (format t "Running ~A... " (string-downcase (symbol-name s)))
  (if (suite-problems-p (funcall s))
      (sb-ext:exit :code 1)
      (write-green "success ✓")))

(defmacro run-suites (&rest suite-names)
  `(progn
     (dolist (s ',suite-names)
       (run-suite s))
     (write-green "All tests passed.")
     (sb-ext:exit :code 0)))
