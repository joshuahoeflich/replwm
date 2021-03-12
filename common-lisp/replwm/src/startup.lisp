(in-package #:replwm)

(defun check-other-wm! (display root)
  (setf (xlib:window-event-mask root)
        '(:substructure-notify :substructure-redirect))
  (xlib:rr-select-input
   root
   '(:screen-change-notify-mask :crtc-change-notify-mask))
  (xlib:display-finish-output display))

(defun create-wm-connection! (&key (display ":0"))
  (let* ((x-display (xlib:open-default-display display))
         (screen (xlib:display-default-screen x-display))
         (root (xlib:screen-root screen)))
    (check-other-wm! x-display root)
    (make-wm-connection
     :display x-display
     :screen screen
     :root root)))

(defun catch-startup-errors (fn &rest args)
  (handler-case (apply fn args)
    (sb-bsd-sockets:socket-error ()
      (format *error-output* "Could not connect to an X server.~%"))
    (xlib:access-error ()
      (format *error-output* "Another window manager is running.~%"))
    (t (err) (format *error-output* "Unexpected error: ~A~%" err))))
