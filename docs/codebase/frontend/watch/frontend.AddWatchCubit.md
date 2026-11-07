---
type: cubit
package: frontend
module: watch
status: implemented
source:
  - frontend/lib/modules/watch/presentation/cubit/add_watch_cubit.dart
  - frontend/lib/modules/watch/presentation/cubit/add_watch_state.dart
tests:
  - frontend/test/modules/watch/presentation/cubit/add_watch_cubit_test.dart
---
# frontend.AddWatchCubit

Module: [[frontend.watch (module)]]
Rules: [[06-frontend-flutter#State service (Cubit)]]

## Purpose

The state of the add form: the picked image, which fields are invalid, and whether the watch is being saved. It holds no rules. It turns the errors of [[frontend.CreateWatchCommand]] into UI state.

## States

Every state carries `image` (the picked `WatchImage` or `null`) and `acceptsImages`.

- `AddWatchEditing`: the form is open. `fieldErrors` maps an `AddWatchField` to the domain error message. `failure` is a message for a problem not tied to a field (the upload or the API failed).
- `AddWatchSubmitting`: the watch is being saved.
- `AddWatchSubmitted`: saved. Carries the new `id`.

## Actions

- `selectImage(WatchImage)`, `removeImage()`
- `submit(...)`: sends a `CreateWatchCommand` through [[frontend.WatchWriteService]]. Errors from [[core.WatchName]], [[core.WatchBrand]], [[core.WatchType]], [[core.WatchCategory]], [[core.WatchDescription]], [[core.WatchTags]] and [[core.WatchTag]] become field errors. An upload or API failure becomes `failure`. The image is kept in every case.

## Relations

- Used by [[frontend.AddWatchPage]]
