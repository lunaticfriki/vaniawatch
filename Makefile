.DEFAULT_GOAL := help

-include .env
export

COMPOSE := docker compose --profile dev
API_URL := http://localhost:$(or $(API_PORT),8080)
DB_USER := $(or $(DATABASE_USER),vaniawatch)
DB_NAME := $(or $(DATABASE_NAME),vaniawatch)

SCOPES := core back front
EXPLICIT := $(filter $(SCOPES),$(MAKECMDGOALS))
SELECTED := $(or $(EXPLICIT),$(SCOPES))

dir_core := core
dir_back := backend
dir_front := frontend

tool_core := dart
tool_back := dart
tool_front := flutter

define run
	@if [ ! -f $(dir_$(1))/pubspec.yaml ]; then \
		if [ -n "$(EXPLICIT)" ]; then echo "✗ $(dir_$(1)): no pubspec.yaml yet"; exit 1; fi; \
		echo "· $(dir_$(1)): no pubspec.yaml yet, skipped"; \
	else \
		echo "▶ $(firstword $(2)) $(dir_$(1))" && cd $(dir_$(1)) && $(tool_$(1)) $(2); \
	fi
endef

.PHONY: help test analyze format check docs up down logs db db-shell db-reset backend-dev backend-logs backend-stop test-integration $(SCOPES)

help:
	@echo "Usage: make <command> [core|back|front]   (no scope = all)"
	@echo ""
	@echo "  test      run the tests"
	@echo "  analyze   run the analyzer (infos are fatal)"
	@echo "  format    format the code"
	@echo "  check     docs check + format, analyze and test for every package (same as pre-push)"
	@echo "  docs      check the docs vault"
	@echo ""
	@echo "Backend and database (Docker):"
	@echo ""
	@echo "  backend-dev       start Postgres if needed, then the API with hot reload, both in Docker"
	@echo "  backend-logs      follow the API logs (dev or production-like)"
	@echo "  backend-stop      stop the API, keep Postgres running"
	@echo "  up                build and start Postgres and the production-like API image"
	@echo "  down              stop every container (data is kept)"
	@echo "  db                start only Postgres"
	@echo "  db-shell          open psql on the local database"
	@echo "  db-reset          stop everything and DELETE the local database volume"
	@echo "  test-integration  start Postgres and run the backend integration tests"

test: $(addprefix test-,$(SELECTED))
analyze: $(addprefix analyze-,$(SELECTED))
format: $(addprefix format-,$(SELECTED))

test-%:
	$(call run,$*,test)

analyze-%:
	$(call run,$*,analyze --fatal-infos)

format-%:
	$(call run,$*,format .)

check:
	@pnpm check

docs:
	@pnpm docs:check

$(SCOPES):
	@:

define running
$$($(COMPOSE) ps --status running --quiet $(1))
endef

define wait_for_api
	@printf "· waiting for $(API_URL)/health "; \
	for i in $$(seq 1 90); do \
		if curl -fs $(API_URL)/health >/dev/null 2>&1; then echo "ready"; exit 0; fi; \
		printf "."; sleep 1; \
	done; \
	echo " not ready, check: make backend-logs"; exit 1
endef

backend-dev:
	@if [ -z "$(call running,db)" ]; then echo "▶ starting the database"; $(COMPOSE) up -d --wait db; else echo "· database already up"; fi
	@if [ -n "$(call running,api)" ]; then echo "· stopping the production-like api to free the port"; $(COMPOSE) stop api; fi
	@if [ -z "$(call running,api-dev)" ]; then echo "▶ starting the backend dev server"; $(COMPOSE) up -d --build --no-deps api-dev; else echo "· backend dev server already up"; fi
	$(call wait_for_api)
	@echo "✓ API $(API_URL)  ·  Swagger $(API_URL)/docs  ·  logs: make backend-logs"

backend-logs:
	@$(COMPOSE) logs -f api api-dev

backend-stop:
	@$(COMPOSE) stop api api-dev

up:
	@if [ -n "$(call running,api-dev)" ]; then echo "· stopping the backend dev server to free the port"; $(COMPOSE) stop api-dev; fi
	@$(COMPOSE) up -d --build --wait db api

down:
	@$(COMPOSE) down

db:
	@$(COMPOSE) up -d --wait db

db-shell: db
	@$(COMPOSE) exec db psql -U $(DB_USER) $(DB_NAME)

db-reset:
	@$(COMPOSE) down -v

test-integration: db
	@cd backend && dart test --run-skipped --tags integration
