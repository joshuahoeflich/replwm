#|
Register the global state which our window manager needs to manage internally 
and provide macros to simplify the process of setup and teardown.
|#

(in-package #:replwm)

(defparameter *display* nil
  "Our X server's display.")

(defparameter *screen* nil
  "Our X server's screen.")

(defparameter *root* nil
  "Our X server's root.")

(defparameter *handlers*
  (make-list (length xlib::*event-key-vector*)
             :initial-element #'(lambda (&rest args)
                                  (declare (ignore args))))
  "Our of X11 event handlers.")

(defun become-window-manager! ()
  (xlib:display-finish-output *display*)
  (xlib:intern-atom *display* :_MOTIF_WM_HINTS)
  (setf (xlib:window-event-mask *root*)
        '(:substructure-notify :substructure-redirect))
  (xlib:rr-select-input
   *root*
   '(:screen-change-notify-mask :crtc-change-notify-mask)))

(defun setup-replwm! ()
  (handler-case
      (and (setf
            *display* (xlib:open-default-display)
            *screen* (xlib:display-default-screen *display*)
            *root* (xlib:screen-root *screen*))
           (become-window-manager!))
    (t (err) (format *error-output* "~A~%~A~%" err
                     "Fatal error on startup."))))

(defun teardown-replwm! ()
  (when *display*
    (xlib:close-display *display*))
  (setf *display* nil *screen* nil *root* nil)
  (write-line "Moriturus te saluto."))

(defun handle-events ()
  (do ()
      ((eq
        (xlib:process-event *display* :handler *handlers* :discard-p t)
        :quit))))

(defmacro with-wm-state (&body code)
  `(unwind-protect
        (when (setup-replwm!)
          ,@code)
     (teardown-replwm!)))
