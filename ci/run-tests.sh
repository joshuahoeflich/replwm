#!/bin/sh
set -e
REGISTRY_PATHS="$(sbcl --noinform --load dev/list-dirs.lisp --non-interactive)"
Xvfb :1 &
CL_SOURCE_REGISTRY="$REGISTRY_PATHS" sbcl --noinform \
  --non-interactive \
  --load "$PWD"/ci/system.lisp \
  --eval "(in-package #:replwm-tests)" \
  --eval "(run-suites x11-suite)"
pkill Xvfb;
