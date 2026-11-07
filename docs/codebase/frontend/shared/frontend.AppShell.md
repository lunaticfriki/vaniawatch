---
type: component
package: frontend
module: shared
status: implemented
source:
  - frontend/lib/shared/presentation/app_routes.dart
  - frontend/lib/shared/presentation/app_menu.dart
  - frontend/lib/shared/presentation/layout/app_shell_view.dart
  - frontend/lib/shared/presentation/layout/app_header_view.dart
  - frontend/lib/shared/presentation/layout/app_menu_drawer_view.dart
  - frontend/lib/shared/presentation/layout/app_footer_view.dart
tests:
  - frontend/test/shared/presentation/layout/app_shell_view_test.dart
---
# frontend.AppShell

Module: [[frontend.shared (module)]]
Rules: [[06-frontend-flutter#Widgets: page, view, skeleton]]

## Purpose

The layout around every page: `AppHeaderView` on top, the page in the middle, `AppFooterView` at the bottom, and a floating add button. These are views: they receive the current location and an `onNavigate` callback, and know nothing about the router.

- `AppRoutes`: the route paths (`/`, `/watches` and `/add`), shared by the router, the menu and the pages.
- `AppMenu`: the menu links ("Home", "All watches", "Add watch"), each a label and a route. The header and the drawer both render this one list.
- Header: the VaniaWatch title (goes home) and the menu. On a screen at least 600 wide (`AppHeaderView.compactBreakpoint`) the links are inline and the current one is highlighted. On a narrower screen they are hidden behind a burger button.
- `AppMenuDrawerView`: the end drawer the burger opens on a compact screen. It lists the same links, highlights the current one, and closes itself when a link is tapped.
- Floating button: `+`, goes to `/add`. It is hidden on `/add` itself.
- Footer: the app name and a one-line tagline.

## Relations

- Wraps [[frontend.LatestWatchesPage]], [[frontend.WatchListPage]] and [[frontend.AddWatchPage]] through the `ShellRoute` in `frontend/lib/app.dart`
