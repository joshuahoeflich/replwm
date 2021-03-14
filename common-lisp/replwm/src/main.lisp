(in-package #:replwm)

(defmethod event-loop ((state wm))
  (let ((event-handler! (wm-on-event state))
        (exit-handler! (wm-on-exit state)))
    (unwind-protect
         (loop :for event = (funcall event-handler!)
               :until (eq event :quit))
      (funcall exit-handler!))))

(defun start (&optional (display ":0"))
  (event-loop
      (or (catch-startup-errors #'setup-replwm! :display display)
          (return-from start))))
