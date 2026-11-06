---
type: component
package: frontend
module: shared
status: implemented
source:
  - frontend/lib/shared/infrastructure/api_config.dart
tests:
  - frontend/test/shared/infrastructure/api_config_test.dart
---
# frontend.ApiConfig

Module: [[frontend.shared (module)]]
Rules: [[05-infrastructure-layer#What belongs here]]

## Purpose

Where the app finds the API and who it says it is. Values come from `--dart-define`, with defaults for local development:

| Define | Default |
|---|---|
| `API_URL` | `http://localhost:8080` |
| `USER_ID` | `00000000-0000-4000-8000-000000000001`, the collector of [[backend.WatchSeedCatalog]] |

`USER_ID` is temporary, until login exists. See [[ADR-0007 temporary user identification and private collections]].

## Relations

- Read by `frontend/lib/composition_root.dart`
- Used by [[frontend.HttpWatchCollectionRepository]]
