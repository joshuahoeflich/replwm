.PHONY: build
build: ## Compile the project.
	@ :

.PHONY: help
help: ## Display this help message and then exit.
	@ sbcl --script dev/help.lisp

.PHONY: xrepl
xrepl: ## Open up an X server inside this one in which you can hack.
	@ DISPLAY=:0 Xephyr :1

.PHONY: install-sbcl
install-sbcl: ## Install SBCL onto an Ubuntu system.
	@ sh ci/install-sbcl.sh

.PHONY: test-tests
test-tests: ## Test our testing library.
	@ sh ci/test-tests.sh

.PHONY: compile-project
compile-project: ## Compile the code in our project.
	@ sh ci/compile-project.sh

.PHONY: test-wm
test-wm: ## Test the window manager.
	@ sh ci/run-tests.sh
