(defpackage #:replwm
  (:use #:common-lisp)
  (:export
   #:wm
   #:make-wm
   #:make-on-event
   #:make-on-exit
   #:make-wm-handlers
   #:make-wm-connection
   #:make-handle-exit
   #:wm-display
   #:wm-screen
   #:wm-root
   #:wm-on-event
   #:wm-on-exit
   #:catch-startup-errors
   #:event-loop))

(defpackage #:replwm-tests
  (:use #:common-lisp
        #:replwm
        #:wm-test))
