#!/bin/sh
set -e
REGISTRY_PATHS="$(sbcl --noinform --load dev/list-dirs.lisp --non-interactive)"
DISPLAY=":0" CL_SOURCE_REGISTRY="$REGISTRY_PATHS" sbcl --noinform \
   --non-interactive \
   --load "$PWD"/ci/compile.lisp
