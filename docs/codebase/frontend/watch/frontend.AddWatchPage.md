---
type: page
package: frontend
module: watch
status: implemented
source:
  - frontend/lib/modules/watch/presentation/add_watch_page.dart
  - frontend/lib/modules/watch/presentation/add_watch_form_view.dart
  - frontend/lib/modules/watch/presentation/add_watch_form_values.dart
  - frontend/lib/modules/watch/presentation/add_watch_image_view.dart
tests:
  - frontend/test/modules/watch/presentation/add_watch_page_test.dart
  - frontend/test/modules/watch/presentation/add_watch_form_view_test.dart
  - frontend/test/modules/watch/presentation/add_watch_form_values_test.dart
---
# frontend.AddWatchPage

Module: [[frontend.watch (module)]]
Rules: [[06-frontend-flutter#Widgets: page, view, skeleton]]

## Purpose

The `/add` page: a form to add a watch to the collection, with an optional photo.

- `AddWatchFormView`: name, brand, type and movement (segmented buttons offering [[frontend.WatchDraft]] `types` and `categories`), description, tags and complications (comma-separated), the photo, and "Save watch". It owns only the text controllers. It shows each field's domain error under that field, and a banner when the upload or the save fails.
- `AddWatchFormValues`: what the user typed. It splits tags and complications on commas and drops blanks. It does not validate anything.
- `AddWatchImageView`: "Choose image" or "Change image", a preview of the picked file with its name, and "Remove". When uploads are not configured, the button is disabled and a note says the watch can still be saved without a photo.

The page loads nothing, so it has no skeleton.

## Branches

- editing: the form, with any field errors or failure from [[frontend.AddWatchCubit]]
- submitting: the same form, disabled, with "Saving…"
- submitted: a "Watch added to your collection" snack bar, then `/watches`

## User actions

- Choose, change or remove the photo. Choosing opens [[frontend.WatchImagePicker]]; a cancelled dialog changes nothing.
- Save the watch.

## Relations

- State: [[frontend.AddWatchCubit]], saving through [[frontend.WatchWriteService]]
- Reached from the "Add watch" menu link and the floating add button of [[frontend.AppShell]]
- Routed in `frontend/lib/app.dart`, inside [[frontend.AppShell]]. `onSaved` defaults to going to `/watches`.
