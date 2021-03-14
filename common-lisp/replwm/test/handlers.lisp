(in-package #:replwm)

(defsuite handler-suite
  (test (= (length xlib::*event-key-vector*)
         (length (register-handlers)))))
