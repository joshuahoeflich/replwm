(in-package #:replwm)

(defun to-quit-key (&rest args)
  (declare (ignore args))
  :quit)

(defmethod make-event-handlers ((state wm-state))
  (declare (ignore state))
  (make-list (length xlib::*event-key-vector*)
             :initial-element #'to-quit-key))

(defmethod handle-x11-event! ((state wm-state))
  (xlib:process-event (wm-state-display state)
                      :handler (make-event-handlers state)
                      :discard-p t))

(defmethod clean-up-wm! ((state wm-state))
  (xlib:close-display (wm-state-display state)))

(defmethod event-loop ((state wm-state))
  (let ((event-handler! (wm-state-on-event state))
        (exit-handler! (wm-state-on-exit state)))
    (unwind-protect
         (loop :for event = (funcall event-handler! state)
               :until (eq event :quit))
      (funcall exit-handler! state))))

(defun start ()
  (event-loop
      (or (catch-startup-errors #'setup-replwm!)
          (return-from start))))
