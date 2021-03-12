(defpackage #:replwm
  (:use #:common-lisp)
  (:export #:catch-startup-errors))

(defpackage #:replwm-tests
  (:use #:common-lisp
        #:replwm
        #:wm-test))
