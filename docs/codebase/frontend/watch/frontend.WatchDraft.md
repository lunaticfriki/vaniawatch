---
type: read-model
package: frontend
module: watch
status: implemented
source:
  - frontend/lib/modules/watch/application/watch_draft.dart
tests:
  - frontend/test/modules/watch/application/watch_draft_test.dart
---
# frontend.WatchDraft

Module: [[frontend.watch (module)]]
Rules: [[04-application-layer-cqrs]]

## Purpose

A new watch that has not been saved yet. It has no id, owner or timestamps, because the backend assigns them. It holds only [[core]] value objects, so every rule stays in the domain.

## Factories

- `create(name, brand, type, category, description, tags, complications)`: builds [[core.WatchName]], [[core.WatchBrand]], [[core.WatchType]], [[core.WatchCategory]], [[core.WatchDescription]] and [[core.WatchTags]]. It tries every field, collects each `DomainError`, and throws one `WatchDraftRejectedException` with all of them, so the form can flag every invalid field at once. The image starts empty.
- `withImage(WatchImageUrl)`: a copy with the image set.

## Form options

`types` and `categories` list the values of [[core.WatchType]] and [[core.WatchCategory]], read from their factories, so the form cannot offer a value the domain rejects.

## Relations

- Built by [[frontend.CreateWatchCommand]]
- Sent by [[frontend.WatchCollectionRepository]] `add`
