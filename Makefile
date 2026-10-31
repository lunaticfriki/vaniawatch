.DEFAULT_GOAL := help

-include .env
export

COMPOSE := docker compose
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

.PHONY: help test analyze format check docs up down logs db db-shell db-reset dev test-integration $(SCOPES)

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
	@echo "  up                build and start Postgres and the API (http://localhost:$${API_PORT:-8080})"
	@echo "  down              stop the containers (data is kept)"
	@echo "  logs              follow the API logs"
	@echo "  db                start only Postgres"
	@echo "  db-shell          open psql on the local database"
	@echo "  db-reset          stop everything and DELETE the local database volume"
	@echo "  dev               start Postgres and run the API with hot reload (dart_frog dev)"
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

up:
	@$(COMPOSE) up -d --build --wait

down:
	@$(COMPOSE) down

logs:
	@$(COMPOSE) logs -f api

db:
	@$(COMPOSE) up -d --wait db

db-shell: db
	@$(COMPOSE) exec db psql -U $(DB_USER) $(DB_NAME)

db-reset:
	@$(COMPOSE) down -v

dev: db
	@cd backend && dart_frog dev

test-integration: db
	@cd backend && dart test --run-skipped --tags integration
