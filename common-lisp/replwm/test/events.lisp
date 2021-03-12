(in-package #:replwm-tests)

(defun mock-close-fn (display)
  (format t "Display was: ~A" display))

(defun mock-process-fn (&rest args)
  args)

(defun make-null-connection ()
  (make-wm-connection :display nil :screen nil :root nil))

(defsuite connection-thunk-suite
  (test (string= "Display was: NIL"
                 (stringify-stream *standard-output*
                   (funcall
                    (make-on-exit (make-null-connection) #'mock-close-fn)))))
  (test (eq :handler
            (second (funcall (make-on-event (make-null-connection) #'mock-process-fn)))))
  (test (= (length xlib::*event-key-vector*)
            (length
             (third
              (funcall (make-on-event (make-null-connection) #'mock-process-fn)))))))
