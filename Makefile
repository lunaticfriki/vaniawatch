.DEFAULT_GOAL := help

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

.PHONY: help test analyze format check docs $(SCOPES)

help:
	@echo "Usage: make <command> [core|back|front]   (no scope = all)"
	@echo ""
	@echo "  test      run the tests"
	@echo "  analyze   run the analyzer (infos are fatal)"
	@echo "  format    format the code"
	@echo "  check     docs check + format, analyze and test for every package (same as pre-push)"
	@echo "  docs      check the docs vault"

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
