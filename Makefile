.PHONY: build
build: ## Compile the project.
	@ :

.PHONY: help
help: ## Display this help message and then exit.
	@ sbcl --script dev/help.lisp

.PHONY: xrepl
xrepl: ## Open up an X server inside this one in which you can hack.
	@ DISPLAY=:0 Xephyr :1

.PHONY: test-tests
test-tests:
	@ cd src/wm-test && sbcl \
		--noinform \
		--load wm-test-check-lib.lisp \
		--non-interactive
