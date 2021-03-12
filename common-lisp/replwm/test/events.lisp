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
         (let ((*standard-output* (make-string-output-stream)))
           (event-loop (make-wm-state :display nil :screen nil :root nil
                                      :on-event #'send-quit-mock
                                      :on-exit #'on-exit-mock))
           (get-output-stream-string *standard-output*))))
  (test (string=
         (format nil "We exited the wm with display NIL~%An error ran!")
         (let ((*standard-output* (make-string-output-stream)))
           (handler-case
               (event-loop (make-wm-state :display nil :screen nil :root nil
                                          :on-event #'error-mock
                                          :on-exit #'on-exit-mock))
             (t () (format t "An error ran!")))
           (get-output-stream-string *standard-output*)))))
