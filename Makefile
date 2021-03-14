.PHONY: build
build: ## Compile the project.
	@ mkdir -p "dist"
	@ sbcl --noinform --non-interactive --load ci/compile.lisp
	@ mv replwm dist

.PHONY: load
load: ## Load all the files in the project.
	@ sbcl --script ci/load.lisp

.PHONY: test
test: ## Test all files in the project.
	@ cd common-lisp/wm-test && sbcl --script wm-test-check-lib.lisp
	@ sbcl --script ci/test.lisp

.PHONY: clean
clean: ## Clean all binaries associated with the project.
	@ rm -rf dist/*

.PHONY: help
help: ## Display this help message and then exit.
	@ sbcl --script dev/help.lisp

.PHONY: xrepl
xrepl: ## Launch Xephyr on display 1. Useful for hacking on WM internals.
	@ DISPLAY=":0" Xephyr :1 &

.PHONY: test-watch
test-watch: ## Run the project's tests in watch mode. Depends on entr and node.
	@ node dev/list-files.js | entr -r -c sh dev/test-watch.sh
