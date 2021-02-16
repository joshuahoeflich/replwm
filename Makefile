.PHONY: build
build: ## Compile the project.
	@ :

.PHONY: xrepl
xrepl: ## Open Xephyr in display :1 and a shell for running programs there.
	@ DISPLAY="${ORIGINAL_DISPLAY}" sbcl --script dev/xrepl.lisp

.PHONY: help
help: ## Display this help message and then exit.
	@ sbcl --script dev/help.lisp

.PHONY: test-tests
test-tests:
	@ cd src/wm-test && sbcl \
		--noinform \
		--load wm-test-check-lib.lisp \
		--non-interactive
