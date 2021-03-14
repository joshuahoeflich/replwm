(in-package #:replwm)

(defmethod make-on-exit ((conn wm-connection) close-fn)
  (let ((display (wm-connection-display conn)))
    (lambda ()
      (funcall close-fn display))))

(defmethod make-on-event ((conn wm-connection) process-fn)
  (let ((handlers (register-handlers))
        (display (wm-connection-display conn)))
    (lambda ()
      (funcall
       process-fn
       display
       :handler handlers
       :discard-p t))))

(defmethod create-wm-handlers ((conn wm-connection))
  (make-wm-handlers
   :on-event (make-on-event conn #'xlib:process-event)
   :on-exit (make-on-exit conn #'xlib:close-display)))
