(in-package #:replwm)

(defstruct wm-state
  display
  screen
  root
  on-event
  on-exit)

(defun create-wm-state! ()
  (let* ((display (xlib:open-default-display))
         (screen (xlib:display-default-screen display))
         (root (xlib:screen-root screen)))
    (make-wm-state
     :display display
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

(defun setup-replwm! ()
  (check-other-wm! (create-wm-state!)))

(defun catch-startup-errors (fn)
  (handler-case (funcall fn)
    (sb-bsd-sockets:socket-error ()
      (format *error-output* "Could not connect to X11.~%"))
    (xlib:access-error ()
      (format *error-output* "Another window manager is running.~%"))))
