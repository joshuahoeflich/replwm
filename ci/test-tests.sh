#!/bin/sh
cd src/wm-test || exit 1;
sbcl --noinform \
		--load wm-test-check-lib.lisp \
		--non-interactive
