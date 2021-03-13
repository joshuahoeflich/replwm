.PHONY: build
build: ## Compile the project.
	@ :

.PHONY: help
help: ## Display this help message and then exit.
	@ sbcl --script dev/help.lisp

.PHONY: test
test:
	@ sh ci/test-tests.sh
	@ sh ci/run-tests.sh

.PHONY: xrepl
xrepl: ## Open up an X server inside this one in which you can hack.
	@ DISPLAY=:0 Xephyr :1

.PHONY: test-tests
test-tests: ## Test our testing library.
	@ sh ci/test-tests.sh

.PHONY: compile-project
compile-project: ## Compile the code in our project.
	@ sh ci/compile-project.sh
