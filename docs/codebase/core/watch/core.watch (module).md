---
type: module
package: core
module: watch
status: implemented
---
# core.watch (module)

Package: [[core]]

## Purpose

The watches in a user's private collection.

## Concepts

### Domain

- Entity (aggregate root): [[core.Watch]]
- Port: [[core.WatchRepository]]
- Errors: [[core.WatchNotFoundError]]
- Value objects: [[core.WatchId]], [[core.WatchName]], [[core.WatchDescription]], [[core.WatchBrand]], [[core.WatchType]], [[core.WatchCategory]], [[core.WatchTag]], [[core.WatchTags]], [[core.WatchImageUrl]]
- Complications are plain strings on [[core.Watch]] ([[ADR-0006 complications are plain strings]])
- Mothers: one per value object, plus `WatchComplicationsMother` (`List<String>`) and `WatchMother`

## Depends on

- [[core.shared (module)]]
- [[core.user (module)]], through [[core.UserId]] as the owner reference
