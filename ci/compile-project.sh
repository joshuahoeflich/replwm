#!/bin/sh
set -e
REGISTRY_PATHS="$(sbcl --noinform --load dev/list-dirs.lisp --non-interactive)"
CL_SOURCE_REGISTRY="$REGISTRY_PATHS" sbcl --noinform \
  --non-interactive \
  --load "$PWD"/ci/system.lisp
