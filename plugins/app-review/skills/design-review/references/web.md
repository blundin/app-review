# Web Conventions

Check these on the core path first.

## Navigation and URLs
- The browser Back button returns to the previous view and never discards unsaved work without warning.
- Each meaningful view has its own URL, so refresh, bookmarks, and shared links land in the same place.
- Links navigate and buttons act; a link styled as a button, or the reverse, misleads.
- Current location is visible in the navigation.

## Forms
- Labels sit outside the field; placeholder text is never the only label.
- Inputs use the matching type (`email`, `tel`, `number`, `date`) so phones show the right keyboard.
- Submit buttons disable or show progress after the first press, preventing double submits.
- Errors appear beside the field they concern and the form keeps every valid value.
- Long forms save progress or warn before navigation discards it.

## Layout
- The layout works from a 360px-wide phone to a wide desktop without horizontal scrolling or overlapping elements.
- Primary actions stay reachable on a phone without zooming.
- Hover-only affordances have a touch equivalent.

## Feedback and loading
- Pages and actions that take longer than a second show progress.
- Layout does not jump as content loads.
- Toasts and banners that report errors stay until dismissed.

## Email and notifications
- Emails the app sends render on phone and desktop clients, name the sender clearly, and link to the exact screen they discuss.
