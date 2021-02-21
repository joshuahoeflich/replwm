(in-package #:replwm)

(defparameter *display* nil
  "Our X server's display.")

(defparameter *screen* nil
  "Our X server's screen.")

(defparameter *root* nil
  "Our X server's root.")

(defun setup-replwm! ()
  (handler-case
      (setf
       *display* (xlib:open-default-display)
       *screen* (xlib:display-default-screen *display*)
       *root* (xlib:screen-root *screen*))
    (t (err) (format *error-output* "~A~%~A~%" err
                     "Fatal error on startup."))))

(defun teardown-replwm! ()
  (when *display*
    (xlib:close-display *display*))
  (setf *display* nil *screen* nil *root* nil)
  (write-line "Moriturus te saluto."))

(defmacro with-replwm (&body code)
  `(unwind-protect
        (when (setup-replwm!)
          ,@code)
     (teardown-replwm!)))


