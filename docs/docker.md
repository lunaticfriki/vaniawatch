---
title: Docker Workflow
tags:
  - docker
  - workflow
---

# Docker Workflow

The project currently has a shared Dart domain but no running backend or
frontend. Docker therefore provides a repeatable container for core analysis
and tests; it does not start an application server or database.

Run the checks from the repository root:

```sh
docker compose run --build --rm core-checks
```

The image contains a snapshot of `core/` from when it is built. `--build`
rebuilds that snapshot so local edits are included. Compose removes the
one-off container after the checks finish. The build context excludes Git,
local tool output, IDE state, and secrets via `.dockerignore`.

The service runs `dart pub get`, `dart analyze .`, and all co-located domain
tests. When the Dart Frog backend and Flutter app are implemented, add their
runtime services and Dockerfiles here based on their actual ports,
configuration, and persistence requirements rather than starting empty
placeholder containers now.