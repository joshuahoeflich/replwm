(in-package #:replwm)

(defun void (&rest args)
  (declare (ignore args)))

(defparameter *display* nil
  "Our X server's display.")

(defparameter *screen* nil
  "Our X server's screen.")

(defparameter *root* nil
  "Our X server's root.")

(defparameter *handlers*
  (make-list (length xlib::*event-key-vector*)
             :initial-element #'void)
  "A list of X11 event handlers.")

(defmacro defhandler (event keys &body body)
  (let ((fn-name (intern (symbol-name event))))
    `(progn
       (defun ,fn-name (&key ,@keys &allow-other-keys)
         ,@body)
       (setf (elt *handlers* (position ,event xlib::*event-key-vector*)) #',fn-name))))

(defun become-window-manager! ()
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

(defhandler :button-press (state code child x y)
  (declare (ignore state code child x y))
  (write "I ran!"))

(defun main ()
  (with-wm-state
    (handle-events)))

