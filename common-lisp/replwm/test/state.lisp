(in-package #:replwm-tests)

(defun key-fn (key)
  (lambda () key))

(defun create-mock-wm ()
  (make-wm
   :handlers (make-wm-handlers
              :handle-list nil
              :on-event (key-fn :event-ran)
              :on-exit (key-fn :quit-ran))
   :connection (make-wm-connection
                :display 'display
                :screen 'screen
                :root 'root)))

(defsuite accessor-suite
  (test (eq nil (wm-handle-list (create-mock-wm))))
  (test (eq 'display (wm-display (create-mock-wm))))
  (test (eq 'screen (wm-screen (create-mock-wm))))
  (test (eq 'root (wm-root (create-mock-wm))))
  (test (eq :event-ran (funcall (wm-on-event (create-mock-wm)))))
  (test (eq :quit-ran (funcall (wm-on-exit (create-mock-wm))))))
