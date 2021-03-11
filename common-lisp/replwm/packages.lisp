(defpackage #:replwm
  (:use #:common-lisp)
  (:export #:with #:with-catch #:setup! #:start-wm!))

(defpackage #:replwm-tests
  (:use #:common-lisp
        #:replwm
        #:wm-test))
