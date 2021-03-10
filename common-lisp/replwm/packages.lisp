(defpackage #:replwm
  (:use #:common-lisp)
  (:export #:with #:with-catch))

(defpackage #:replwm-tests
  (:use #:common-lisp
        #:replwm
        #:wm-test))
