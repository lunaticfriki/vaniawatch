---
type: component
package: frontend
module: shared
status: implemented
source:
  - frontend/lib/shared/presentation/app_routes.dart
  - frontend/lib/shared/presentation/layout/app_shell_view.dart
  - frontend/lib/shared/presentation/layout/app_header_view.dart
  - frontend/lib/shared/presentation/layout/app_footer_view.dart
tests:
  - frontend/test/shared/presentation/layout/app_shell_view_test.dart
---
# frontend.AppShell

Module: [[frontend.shared (module)]]
Rules: [[06-frontend-flutter#Widgets: page, view, skeleton]]

## Purpose

The layout around every page: `AppHeaderView` on top, the page in the middle, `AppFooterView` at the bottom. These are views: they receive the current location and an `onNavigate` callback, and know nothing about the router.

- Header: the VaniaWatch title (goes home) and the "Home" and "All watches" links. The link of the current page is highlighted.
- Footer: the app name and a one-line tagline.
- `AppRoutes`: the route paths (`/` and `/watches`), shared by the router, the header and the pages.

## Relations

- Wraps [[frontend.LatestWatchesPage]] and [[frontend.WatchListPage]] through the `ShellRoute` in `frontend/lib/app.dart`
