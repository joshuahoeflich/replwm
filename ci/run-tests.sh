#!/bin/sh
Xvfb :1 &
sbcl --noinform \
  --non-interactive \
  --load "$PWD"/ci/system.lisp \
  --eval "(in-package #:replwm-tests)" \
  --eval "(run-suites-and-exit x11-suite)"
pkill Xvfb;
