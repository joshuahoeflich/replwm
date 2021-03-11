(defpackage #:replwm
  (:use #:common-lisp)
  (:export #:setup-replwm! #:wm-state-p))

(defpackage #:replwm-tests
  (:use #:common-lisp
        #:replwm
        #:wm-test))
