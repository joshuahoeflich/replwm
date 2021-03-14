(in-package #:replwm)

(defun void (&rest args)
  (declare (ignore args)))

(defun find-handler-fn (keyword)
  (let ((keyfn (intern (string keyword))))
    (or
     (and keyfn (fboundp keyfn) (symbol-function keyfn))
     #'void)))

(defun register-handlers ()
  (map 'list #'find-handler-fn xlib::*event-key-vector*))
