(in-package #:replwm)

(defun send-quit-mock ()
  :quit)

(defun on-error-mock ()
  (error "Something bad happened."))

(defun on-exit-mock ()
  (format t "On exit ran successfully...~%"))

(defun make-event-loop-mock (event-fn)
  (make-wm
   :connection (make-wm-connection
                :display nil
                :screen nil
                :root nil)
   :handlers (make-wm-handlers
              :on-event event-fn
              :on-exit #'on-exit-mock)))

(defsuite event-loop-suite
  (test (string=
         (format nil "On exit ran successfully...~%")
         (stringify-stream *standard-output*
           (event-loop (make-event-loop-mock #'send-quit-mock)))))
  (test (string=
         (format nil "On exit ran successfully...~%An error ran!")
         (stringify-stream *standard-output*
           (handler-case
               (event-loop (make-event-loop-mock #'on-error-mock))
             (t () (format t "An error ran!")))))))

(defsuite main-suite
  (startup-error-suite)
  (connection-thunk-suite)
  (handler-suite)
  (accessor-suite)
  (event-loop-suite))
