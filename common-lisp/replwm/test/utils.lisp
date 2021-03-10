(in-package #:replwm-tests)

(defun stringify (err)
  (with-output-to-string (s)
    (format s "~A" err)))

(defsuite catch-suite
  (test (string= "hi"
                 (with-catch (err (stringify err))
                   (error "hi"))))
  (test (string= "we failed at the end"
                 (with-catch (err (stringify err))
                   (+ 3 5)
                   (+ 2 4)
                   (error "we failed at the end"))))
  (test (string= "testing" (with-catch (err (signal err))
                             "testing"))))

(defsuite with-suite
  (test (= 4 (with (x 2 y 2)
                   (+ x y))))
  (test (= 10 (with (x (+ 2 2)
                       y (+ 3 3))
                    (+ x y))))
  (test (string= "hello world"
                 (with (hello "hello"
                              space " "
                              world "world")
                       (concatenate 'string hello space world))))
  (test (= 4 (with (x (+ 2 2) y (+ x x))
                   4))))

(defsuite util-suite
  (with-suite)
  (catch-suite))
