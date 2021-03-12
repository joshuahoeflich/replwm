(in-package #:replwm)

(defun to-quit-key (&rest args)
  (format t "Args to handler: ~A~%" args)
  :quit)

(defun create-handlers ()
  (make-list
   (length xlib::*event-key-vector*)
   :initial-element #'to-quit-key))

(defmethod make-on-exit ((conn wm-connection) close-fn)
  (let ((display (wm-connection-display conn)))
    (lambda ()
      (funcall close-fn display))))

(defmethod make-on-event ((conn wm-connection) process-fn)
  (let ((handlers (create-handlers))
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
