(defpackage #:replwm
  (:use #:common-lisp)
  (:export #:main
           #:with-wm-state))

(defpackage #:replwm-tests
  (:use #:common-lisp #:replwm #:wm-test))
