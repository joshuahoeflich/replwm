(in-package #:replwm)

(defvar *wm-state* nil
  "Global singleton holding all window manager state.
If you want to play with the internals of the window manager while
hacking at a REPL, feel free to modify this variable there at your
whim. Otherwise, prefer less stateful abstractions.")

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

(defmethod create-wm-handlers ((conn wm-connection))
  (let ((handlers
          (make-wm-handlers
           :handle-list (register-handlers)
           :on-exit (make-on-exit conn #'xlib:close-display))))
    (setf (wm-handlers-on-event handlers)
          (make-on-event handlers conn #'xlib:process-event))))

(defun setup-replwm! (&key (display ":0"))
  (let ((conn (create-wm-connection! :display display)))
    (setf *wm-state*
          (make-wm
           :connection conn
           :handlers (create-wm-handlers conn)))))

(defun catch-startup-errors (fn &rest args)
  (handler-case (apply fn args)
    (sb-bsd-sockets:socket-error ()
      (format *error-output* "Could not connect to an X server.~%"))
    (xlib:access-error ()
      (format *error-output* "Another window manager is running.~%"))
    (t (err) (format *error-output* "Unexpected error: ~A~%" err))))
