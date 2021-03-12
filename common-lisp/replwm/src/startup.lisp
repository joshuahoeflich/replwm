(in-package #:replwm)

(defstruct wm-state
  display
  screen
  root
  on-event
  on-exit)

(defun create-wm-state! (&key (display ":0"))
  (let* ((x-display (xlib:open-default-display display))
         (screen (xlib:display-default-screen x-display))
         (root (xlib:screen-root screen)))
    (make-wm-state
     :display x-display
     :screen screen
     :root root
     :on-event #'handle-x11-event!
     :on-exit #'clean-up-wm!)))

(defmethod check-other-wm! ((state wm-state))
  (let ((display (wm-state-display state))
        (root (wm-state-root state)))
    (setf (xlib:window-event-mask root)
          '(:substructure-notify :substructure-redirect))
    (xlib:rr-select-input
     root
     '(:screen-change-notify-mask :crtc-change-notify-mask))
    (xlib:display-finish-output display)
    state))

(defun setup-replwm! (&key (display ":0"))
  (check-other-wm! (create-wm-state! :display display)))

(defun catch-startup-errors (fn &rest args)
  (handler-case (apply fn args)
    (sb-bsd-sockets:socket-error ()
      (format *error-output* "Could not connect to X11.~%"))
    (xlib:access-error ()
      (format *error-output* "Another window manager is running.~%"))
    (t (err) (format *error-output* "Unexpected error: ~A~%" err))))
