#!/bin/sh
cd common-lisp/wm-test || exit 1;
sbcl --noinform \
		--load wm-test-check-lib.lisp \
		--non-interactive
