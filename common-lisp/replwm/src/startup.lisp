(in-package #:replwm)

(defun log-fatal-error! (err)
  (format *error-output* "Fatal error: ~A~%Exiting replwm." err))

(defun open-x11! ()
  (let* ((display (xlib:open-default-display))
         (screen (xlib:display-default-screen display))
         (root (xlib:screen-root screen)))
    (values display screen root)))

(defun check-other-wm! (display root)
  (setf (xlib:window-event-mask root)
        '(:substructure-notify :substructure-redirect))
  (xlib:rr-select-input
   root
   '(:screen-change-notify-mask :crtc-change-notify-mask))
  (xlib:display-finish-output display))

(defun setup! ()
  (handler-case
      (multiple-value-bind (display screen root) (open-x11!)
        (check-other-wm! display root)
        (values display screen root))
    (t (err) (log-fatal-error! err))))

(defun handle-x11-event! (display screen root)
  (declare (ignore display screen root))
  :quit)

(defun event-loop (display screen root)
  (loop :for event = (handle-x11-event! display screen root)
        :until (eq event :quit)))

(defun start-wm! ()
  (multiple-value-bind (display screen root) (setup!)
    (when display
      (unwind-protect
           (event-loop display screen root)
        (xlib:close-display display)))))
