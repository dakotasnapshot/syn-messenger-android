# SYN Messenger Classic-parity roadmap

This roadmap is driven by recurring Element X store-review complaints and the features users cite when returning to Element Classic. Features should share Matrix semantics across Android, iOS, macOS, and web while respecting each platform's native UI.

## P0 — reliability before feature count

1. Notification correctness: prompt delivery, badge/read-state reconciliation, per-room behavior, DND compliance, and background recovery.
2. Session and offline resilience: avoid false offline states, login loops, and sync stalls; expose useful recovery status.
3. Crash and performance work: measure cold start, room opening, timeline scrolling, media loading, and call setup on release builds.

## P1 — Classic features users actively miss

1. In-room search with filters for sender, date, media, links, and files.
2. Public-room exploration with server selection, pagination, previews, join flow, and safety reporting.
3. Notification controls: global and per-room sound, vibration, privacy, mentions, calls, and quiet behavior.
4. Call interoperability:
   - Detect legacy Matrix VoIP events and clearly distinguish them from MatrixRTC calls.
   - Support joining compatible legacy 1:1 voice/video calls where the maintained SDK permits it.
   - Provide separate voice and video call actions.
   - Fall back gracefully when a legacy call cannot be joined; never imply compatibility that is not present.
5. Compact room-list and timeline density options.
6. Reliable threads, link previews, media embeds, and document handling.
7. User-controlled ordering for Spaces and rooms.

## P2 — quality and accessibility

1. Message translation with explicit provider/privacy choices.
2. Better tablet, foldable, desktop, and multi-window layouts.
3. Complete keyboard navigation, screen-reader labels, Dynamic Type/font scaling, and reduced-motion support.
4. Consistent drafts, scheduled sends, voice messages, location sharing, and polls across platforms.

## Current Android audit

| Capability | Current state | Next work |
| --- | --- | --- |
| Custom notification tone | Implemented with Android's system ringtone picker | Verify on physical Android versions and make discovery obvious |
| Public room directory | Implemented in the codebase | Verify entry points, matrix.org results, pagination, join, and empty/error states |
| Legacy call events | Timeline rendering only | Research SDK support and implement safe interoperability |
| Modern calls | Present through Element Call / MatrixRTC path | Harden ringing and background delivery |
| In-room search | Not treated as complete | Build and test sender/date/content filters |

## Cross-platform delivery rule

Define shared behavior and acceptance tests first, then ship native implementations independently. A capability is not considered complete until Android, iPhone/iPad, macOS, and web either support it or document a platform-specific limitation. Apple Watch receives a deliberately smaller companion experience rather than every desktop feature.
