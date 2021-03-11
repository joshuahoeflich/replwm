(in-package #:replwm)

(defun log-fatal-error! (err)
  (format *error-output* "Fatal error on startup: ~A~%Exiting replwm." err))

(defun open-x11! ()
  (with-catch (err
               (declare (ignore err))
               (error "Couldn't open X11."))
    (with (display (xlib:open-default-display)
                   screen (xlib:display-default-screen display)
                   root (xlib:screen-root screen))
          (values display screen root))))

(defun check-other-wm! (display root)
  (with-catch (err
               (declare (ignore err))
               (xlib:close-display display)
               (error "Another window manager is running."))
    (setf (xlib:window-event-mask root)
          '(:substructure-notify :substructure-redirect))
    (xlib:rr-select-input
     root
     '(:screen-change-notify-mask :crtc-change-notify-mask))
    (xlib:display-finish-output display)))

(defun setup-window-manager! ()
  (with-catch (err (log-fatal-error! err))
    (multiple-value-bind (display screen root) (open-x11!)
      (check-other-wm! display root)
      (values display screen root))))
