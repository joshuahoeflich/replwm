(in-package #:replwm)

(defun main ()
  (with-global-state
    (format t "~S~%~S~%~S~%"
            *display*
            *screen*
            *root*)))
