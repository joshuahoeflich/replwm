(defpackage #:replwm
  (:use #:common-lisp)
  (:export #:with #:with-catch #:setup-window-manager!))

(defpackage #:replwm-tests
  (:use #:common-lisp
        #:replwm
        #:wm-test))
