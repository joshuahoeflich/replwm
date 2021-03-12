(defpackage #:replwm
  (:use #:common-lisp)
  (:export #:catch-startup-errors
           #:wm-state
           #:wm-state-display
           #:event-loop
           #:make-wm-state))

(defpackage #:replwm-tests
  (:use #:common-lisp
        #:replwm
        #:wm-test))
