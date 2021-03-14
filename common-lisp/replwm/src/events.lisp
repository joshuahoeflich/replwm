(in-package #:replwm)

#|
Creating an X11 event handler is as easy as writing a function with
the name of the keyword CLX associates with that event (e.g., the
:map-notify keyword corresponds to the map-notify function). If
you need to access global window manager state in your handler,
add a "wm" key with *wm-state* as the default argument; that way,
you can test the function in isolation, and REPLWM will give you
the right value at runtime.
|#

(defun map-request (&key window (wm *wm-state*) &allow-other-keys)
  (format t "window is ~S~%" window)
  (format t "wm state is ~S~%" wm)
  :quit)

(defun void (&rest args)
  (declare (ignore args)))

(defun find-handler-fn (keyword)
  (let ((keyfn (intern (string keyword))))
    (or
     (and (fboundp keyfn) keyfn)
     #'void)))

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
