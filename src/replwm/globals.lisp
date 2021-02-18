(in-package #:replwm)

;; Icky global state and utilities for dealing with it.

(defparameter *display* nil
  "The global X server to which our application is connected.")

(defparameter *screen* nil
  "The default screen of our X11 server.")

(defparameter *root* nil
  "The root window of our X11 server.")

(defun open-display! ()
  (handler-case
      (setf *display* (xlib:open-default-display)
            *screen* (xlib:display-default-screen *display*)
            *root* (xlib:screen-root *screen*))
    (t (err)
      (error "~A~%Cannot open X11." err))))

(defun default-x11-handler (&rest args)
  (declare (ignore args)))

(defparameter *handlers*
  (make-list (length xlib::*event-key-vector*)
             :initial-element #'default-x11-handler)
  "A list of functions for handling X11 events. 
Consider registering custom handlers via the DEFHANDLER macro.")

(defmacro defhandler (event keys &body body)
  (let ((fn-name (intern (symbol-name event))))
    `(progn
       (defun ,fn-name (&key ,@keys &allow-other-keys)
         ,@body)
       (setf (elt *handlers* (position ,event xlib::*event-key-vector*)) #',fn-name))))

(defmacro with-global-state (&body code)
  `(handler-case
       (progn
         (open-display!)
         ,@code)
     (t (err)
       (format t "~A~%Fatal error. Aborting.~%" err))))
