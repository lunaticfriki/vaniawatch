---
type: decision
status: accepted
date: 2026-11-07
---
# ADR-0013 watch images upload to cloudinary from the app

Index: [[decisions]]

## Context

The add form lets the user pick a photo of the watch from their computer. The domain already models the photo as a URL ([[core.WatchImageUrl]]), and the API already accepts an `imageUrl` on create ([[backend.WatchesRoute]]). The photos are to be hosted on Cloudinary, but the Cloudinary account is not set up yet.

## Decision

- The app uploads the photo straight to Cloudinary, with an **unsigned upload preset**, and sends the returned `secure_url` as `imageUrl` in `POST /watches`. The backend stores the URL and never handles image bytes.
- The upload sits behind an application port, [[frontend.WatchImageStorage]]. [[frontend.CreateWatchCommand]] validates the fields first, then uploads, then saves, so an invalid form never uploads anything.
- [[frontend.CloudinaryWatchImageStorage]] is configured with `CLOUDINARY_CLOUD_NAME` and `CLOUDINARY_UPLOAD_PRESET` (`--dart-define`, passed by `make dev` from `.env`). When either is missing, the composition root uses `UnavailableWatchImageStorage`: the picker is disabled and a watch can still be saved without a photo.
- Picking goes through its own port, [[frontend.WatchImagePicker]], backed by `package:file_selector`.

## Consequences

- No backend change was needed, and the backend stays free of file storage.
- Anyone with the cloud name and the unsigned preset can upload to it. Restrict the preset in Cloudinary (folder, allowed formats, maximum size). If that is not enough, move to signed uploads: a backend endpoint signs each upload, and only `CloudinaryWatchImageStorage` changes.
- A photo uploaded for a watch that then fails to save stays in Cloudinary unused.
- Until Cloudinary is configured, watches are saved without photos.

## Related

[[frontend]], [[06-local-environment]], [[ADR-0011 frontend app shell routing and api access]]
