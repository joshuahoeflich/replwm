(common-lisp:require "asdf")
(common-lisp:require 'sb-posix)
(asdf:load-system "wm-test")
(asdf:load-system "clx")
(asdf:load-system "replwm/test")
(in-package #:replwm)
(run-suites-and-exit main-suite)
