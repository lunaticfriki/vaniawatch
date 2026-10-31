---
type: decision
status: accepted
date: 2026-10-31
---
# ADR-0009 dockerized dev server restarts on change

Index: [[decisions]]

## Context

The backend dev server should run in Docker, like the database, so `make backend-dev` is the whole setup. Dart Frog's hot reload was tried inside the container, and it does not work there:

- File events from the macOS bind mount do reach the container, and `dart_frog dev` regenerates its code.
- The in-process reloader never swaps in the new code, so the old code keeps being served.
- One save often fires two events, and the second code generation stalls.
- Dart Frog only watches `routes/`, `main.dart` and `pubspec.yaml`, so changes in `lib/` or `core` would not reload anyway.

## Decision

The `api-dev` service (compose profile `dev`, `backend/Dockerfile.dev`):

- mounts `core/` and `backend/`, and keeps the container's own `.dart_tool`, `.dart_frog` and pub cache in named volumes, because the host's would hold macOS paths
- runs `backend/docker/dev/entrypoint.sh`, which content-hashes the sources every second and restarts `dart_frog dev` (with `SIGINT`, so its child process exits) when they change
- needs `tty: true`, because `dart_frog dev` sets the terminal echo mode at startup and crashes without a terminal

`make backend-dev` starts only what is missing: the database, then the dev server. It also frees port 8080 from the production-like `api` container if needed.

## Consequences

- Every change, including `backend/lib` and `core/lib`, is live in about 4 seconds. This is a restart, not a stateful hot reload.
- Polling costs a little CPU while the dev server runs.
- `make up` keeps building and running the real AOT image for production-like checks.

## Related

[[06-local-environment]], [[ADR-0008 docker postgres and embedded migrations]], [[backend]]
