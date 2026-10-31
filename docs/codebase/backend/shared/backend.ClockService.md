---
type: component
package: backend
module: shared
status: implemented
source:
  - backend/lib/shared/application/clock_service.dart
  - backend/lib/shared/infrastructure/system_clock_service.dart
tests: []
---
# backend.ClockService

Module: [[backend.shared (module)]]
Rules: [[02-hexagonal-architecture#Ports and adapters]]

## Purpose

An application port for "now", so handlers stay deterministic in tests (see [[ADR-0005 entities receive time and reference owners by id]]). `SystemClockService` returns `DateTime.now().toUtc()`. Tests mock the port.

## Relations

- Used by [[backend.CreateWatchCommand]] and [[backend.UpdateWatchCommand]]
