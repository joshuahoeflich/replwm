(in-package #:replwm-tests)

(defmethod send-quit-mock ((state wm-state))
  :quit)

(defmethod error-mock ((state wm-state))
  (error "An error was signaled."))

(defmethod on-exit-mock ((state wm-state))
  (format t "We exited the wm with display ~A~%"
          (wm-state-display state)))

(defsuite event-loop-suite
  (test (string=
         (format nil "We exited the wm with display NIL~%")
         (stringify-stream *standard-output*
           (event-loop (make-wm-state :display nil :screen nil :root nil
                                      :on-event #'send-quit-mock
                                      :on-exit #'on-exit-mock)))))
  (test (string=
         (format nil "We exited the wm with display NIL~%An error ran!")
         (stringify-stream *standard-output*
           (handler-case
               (event-loop (make-wm-state :display nil :screen nil :root nil
                                          :on-event #'error-mock
                                          :on-exit #'on-exit-mock))
             (t () (format t "An error ran!")))))))
