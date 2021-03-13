(in-package #:replwm)

(defun to-quit-key (&rest args)
  (format t "Args to handler: ~A~%" args)
  :quit)

(defun find-handler-fn (keyword)
  (let ((keyfn (intern (string keyword))))
    (or
     (and (fboundp keyfn)
          (symbol-function keyfn))
     #'to-quit-key)))

(defun register-handlers ()
  (map 'list #'find-handler-fn xlib::*event-key-vector*))

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
