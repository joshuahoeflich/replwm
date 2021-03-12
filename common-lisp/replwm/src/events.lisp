(in-package #:replwm)

(defmethod handle-x11-event! ((state wm-state))
  :quit)

(defmethod event-loop ((state wm-state))
    (loop :for event = (handle-x11-event! state)
          :until (eq event :quit)))

(defun start ()
  (event-loop
      (or (catch-startup-errors #'setup-replwm!)
          (return-from start))))
