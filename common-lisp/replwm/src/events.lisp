#|
Register callbacks for the main event loop of our application.
|#

(in-package #:replwm)

(defmacro defhandler (event keys &body body)
  (let ((fn-name (intern (symbol-name event))))
    `(progn
       (defun ,fn-name (&key ,@keys &allow-other-keys)
         ,@body)
       (setf (elt *handlers* (position ,event xlib::*event-key-vector*)) #',fn-name))))

(defhandler :map-request (window override-redirect-p)
  (declare (ignore window override-redirect-p))
  :quit)
