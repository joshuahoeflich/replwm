.PHONY: build
build: ## Compile the project.
	@ sh ci/build.sh

.PHONY: help
help: ## Display this help message and then exit.
	@ sbcl --script dev/help.lisp

.PHONY: test
test:
	@ sh ci/test-tests.sh
	@ sh ci/run-tests.sh

.PHONY: clean
clean:
	@ rm -rf dist/*
