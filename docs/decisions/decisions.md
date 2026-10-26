---
type: map
---
# decisions

Architecture decision records. Add a new one from the `decision` template whenever a task makes or changes an architectural choice. Never edit an accepted decision: supersede it with a new one.

| ADR | Decision | Status |
|---|---|---|
| [[ADR-0001 core holds only the domain]] | `core` holds only the domain layer. The application layer lives in each app. | accepted |
| [[ADR-0002 tests mirror lib]] | Tests live under `test/`, mirroring `lib/`. Shared Mothers are exported from `core/lib/testing.dart`. | accepted |
| [[ADR-0003 commit menu in prepare-commit-msg]] | The commit menu runs in the `prepare-commit-msg` hook, with commitlint as a backstop. | accepted |
| [[ADR-0004 docs vault is the map of the code]] | The Obsidian vault is read before the code and updated after every task. | accepted |
