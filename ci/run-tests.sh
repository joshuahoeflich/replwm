#!/bin/sh
set -e
REGISTRY_PATHS="$(sbcl --noinform --load dev/list-dirs.lisp --non-interactive)"
Xvfb :1 &
Xvfb :2 &
DISPLAY=":2" openbox &
DISPLAY=":0" CL_SOURCE_REGISTRY="$REGISTRY_PATHS" sbcl --noinform \
   --non-interactive \
   --load "$PWD"/ci/system.lisp \
   --eval "(in-package #:replwm-tests)" \
   --eval "(run-suites-and-exit setup-suite)"
pkill openbox;
pkill Xvfb; 
