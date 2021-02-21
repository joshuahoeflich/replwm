(defpackage #:replwm
  (:use #:common-lisp)
  (:export #:main #:with-replwm))

(defpackage #:replwm-tests
  (:use #:common-lisp #:replwm #:wm-test))
