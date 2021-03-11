(in-package #:replwm-tests)

;; Because running this suite requires the presense of another window manager,
;; we don't yet execute it in our CI pipeline. Pull requests welcome for that
;; use case!
(defsuite startup-error-suite
  (test
   (search
    "ACCESS-ERROR"
    (let ((*error-output* (make-string-output-stream)))
      (setup!)
      (get-output-stream-string *error-output*))))
  (test
   (search
    "ACCESS-ERROR"
    (let ((*error-output* (make-string-output-stream)))
      (start-wm!)
      (get-output-stream-string *error-output*))))
  (sb-posix:setenv "DISPLAY" ":2" 1)
  (test (search
         "Socket error"
         (let ((*error-output* (make-string-output-stream)))
           (setup!)
           (get-output-stream-string *error-output*))))
  (sb-posix:setenv "DISPLAY" ":0" 1))
