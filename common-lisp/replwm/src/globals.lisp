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
