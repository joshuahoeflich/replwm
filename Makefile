.PHONY: build
build: ## Compile the project.
	@ mkdir -p "dist"
	@ sbcl --noinform --non-interactive --load ci/compile.lisp
	@ mv replwm dist

.PHONY: help
help: ## Display this help message and then exit.
	@ sbcl --script dev/help.lisp

.PHONY: test
test:
	@ cd common-lisp/wm-test && sbcl --script wm-test-check-lib.lisp
	@ sbcl --script ci/test.lisp

.PHONY: clean
clean:
	@ rm -rf dist/*
