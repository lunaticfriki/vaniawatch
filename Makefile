.DEFAULT_GOAL := help

DART ?= dart
DOCKER_COMPOSE ?= docker compose
ACTION ?=
FILES ?=
ARGS ?=

.PHONY: help setup core-get core-analyze core-test check docker-check hooks-install pre-push-check commit change-check

help:
	@printf '%s\n' \
	  'Vaniawatch project commands:' \
	  '  make setup                         Install Git hooks and core dependencies' \
	  '  make check                         Analyze core and run domain tests' \
	  '  make core-get                      Resolve core Dart dependencies' \
	  '  make core-analyze                  Analyze the core package' \
	  '  make core-test                     Run all co-located core tests' \
	  '  make docker-check                  Run core checks in Docker Compose' \
	  '  make hooks-install                 Install the local Git hooks' \
	  '  make pre-push-check                Run pre-push checks with stash/restore' \
	  '  make commit [ARGS="..."]           Run git commit; interactive hook prompts' \
	  '  make change-check ACTION="..." FILES="a,b"' \
	  '                                    Check a proposed or completed change'

setup: hooks-install core-get

core-get:
	cd core && $(DART) pub get

core-analyze:
	cd core && $(DART) analyze .

core-test:
	cd core && $(DART) run test \
	  catalog/entities/__tests__/watch.entity_test.dart \
	  auth/value_objects/__tests__/email_address.value_object_test.dart \
	  auth/entities/__tests__/user.entity_test.dart

check: core-analyze core-test

docker-check:
	$(DOCKER_COMPOSE) run --build --rm core-checks

hooks-install:
	sh scripts/install-hooks.sh

pre-push-check:
	sh scripts/pre-push-tests.sh

commit:
	git commit $(ARGS)

change-check:
	@test -n "$(ACTION)" || (printf '%s\n' 'Set ACTION="..."' >&2; exit 2)
	@test -n "$(FILES)" || (printf '%s\n' 'Set FILES="path,other-path"' >&2; exit 2)
	$(DART) tool/change_harness.dart --action "$(ACTION)" --files "$(FILES)"
