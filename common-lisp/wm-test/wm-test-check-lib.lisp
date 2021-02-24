(load "wm-test.lisp")

(in-package #:wm-test)

(with-open-stream (*standard-output* (make-broadcast-stream))
  (assert (eql :ignore (xtest-values (= 2 3))))
  (assert (eql :ignore (xtest-values (= 2 2))))
  (assert (eql :ignore (xtest-values (error "hi"))))
  (assert (eql :ignore (xtest (= 2 3))))
  (assert (eql :ignore (xtest (= 2 2))))
  (assert (eql :ignore (xtest (error "hi"))))
  (assert (eql :ignore (xtest (error "hi") :handler bad-handler)))

  (assert (eql :pass (test-values (= 2 2))))
  (assert (eql :fail (test-values (= 2 3))))
  (assert (eql :error (test-values (error "hi"))))
  (assert (eql :error (handle-test-values :error '(error "hi") 3)))
  (assert (eql :fail (handle-test-values :fail '(= 2 3) nil)))
  (assert (eql :pass (handle-test-values :pass '(= 2 2) nil)))

  (defun bad-handler (result s-exp err)
    (declare (ignore s-exp err))
    (case result
      (:pass "this passed")
      (:fail "this failed")
      (:error "this errored")))

  (assert (string= "this passed" (test t :handler bad-handler)))
  (assert (string= "this failed" (test nil :handler bad-handler)))
  (assert (string= "this errored" (test (error "hi") :handler bad-handler)))
  (assert (string= "potato"
                   (test (error "hi")
                         :handler (lambda (result s-exp err)
                                    (declare (ignore result s-exp err))
                                    "potato"))))

  (assert (= 0 (suite-results-passed (make-suite-results))))
  (assert (= 0 (suite-results-failed (make-suite-results))))
  (assert (= 0 (suite-results-errored (make-suite-results))))
  (assert (= 0 (suite-results-ignored (make-suite-results))))
  (assert (string= (format nil "0 passed, 0 failed, 0 errored.~%")
                   (format nil "~A" (make-suite-results))))
  (assert (string= (format nil "0 passed, 0 failed, 0 errored, 1 ignored.~%")
                   (format nil "~A" (make-suite-results :ignored 1))))

  (assert (suite-key-p :pass))
  (assert (suite-key-p :fail))
  (assert (suite-key-p :error))
  (assert (suite-key-p :ignore))
  (assert (not (suite-key-p :wrong)))

  (assert (= 1 (bump-suite-field! (make-suite-results) :pass)))
  (assert (= 1 (bump-suite-field! (make-suite-results) :fail)))
  (assert (= 1 (bump-suite-field! (make-suite-results) :error)))
  (assert (= 1 (bump-suite-field! (make-suite-results) :ignore)))

  (let ((suite-a (make-suite-results))
        (suite-b (make-suite-results)))
    (bump-suite-field! suite-a :pass)
    (bump-suite-field! suite-b :pass)
    (bump-suite-field! suite-a :fail)
    (bump-suite-field! suite-a :error)
    (merge-suites! suite-a suite-b)
    (assert (string= (format nil "2 passed, 1 failed, 1 errored.~%")
                     (format nil "~A" suite-a))))

  (let ((suite-a (make-suite-results))
        (suite-b (make-suite-results)))
    (bump-suite-field! suite-a :pass)
    (bump-suite-field! suite-b :pass)
    (bump-suite-field! suite-a :fail)
    (bump-suite-field! suite-a :error)
    (bump-suite-field! suite-b :ignore)
    (bump-suite-field! suite-a :ignore)
    (merge-suites! suite-a suite-b)
    (assert (string= (format nil "2 passed, 1 failed, 1 errored, 2 ignored.~%")
                     (format nil "~A" suite-a))))

  (defsuite my-suite
    (test (= 3 3))
    (test (= 3 4))
    (test (error "hi")))

  (assert (string= (format nil "1 passed, 1 failed, 1 errored.~%")
                   (format nil "~A" (my-suite))))

  (defsuite my-other-suite
    (test (= 1 1))
    (test (= 2 2))
    (xtest (error "this fails")))

  (assert (string= (format nil "2 passed, 0 failed, 0 errored, 1 ignored.~%")
                   (format nil "~A" (my-other-suite))))


  (defsuite composed-suite
    (my-suite)
    (my-other-suite))

  (assert (string= (format nil "3 passed, 1 failed, 1 errored, 1 ignored.~%")
                   (format nil "~A" (composed-suite))))

  (defsuite success-suite
    (test t))

  (assert (suite-results-p (run-suites success-suite)))

  (assert (not (suite-problems-p (success-suite))))
  (assert (not (suite-problems-p (my-other-suite))))
  (assert (suite-problems-p (my-suite)))

  (defsuite error-suite
    (test (error "hi")))

  (assert (suite-problems-p (error-suite)))

  (defsuite failure-suite
    (test (= 2 1)))

  (assert (suite-problems-p (failure-suite)))

  (defsuite ignore-suite
    (xtest (error "fail")))

  (assert (not (suite-problems-p (ignore-suite))))

  (defsuite side-effect-suite
    (test (= 2 2))
    (princ "This test has side effects that run in its body!")
    (test (= 3 3)))

  (assert (= 1 (suite-results-passed (suite (test (= 1 1))))))
  (assert (= 1 (suite-results-failed (suite (test (= 1 0))))))
  (assert (= 1 (suite-results-errored (suite (test (error "hi"))))))

  (assert (= 2 (suite-results-passed (side-effect-suite)))))
