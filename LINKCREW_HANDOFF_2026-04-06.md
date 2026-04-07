LinkCrew Handoff
Date: 2026-04-06
Repo: /home/eliott/claude/fieldsync

Current pushed state
- Main contains the full owner dashboard modernization plus follow-up fixes through commit f4069a3.
- Recent work focused on jobs workspace depth, calendar usability, Twilio/SMS clarity, refresh-state persistence, and plan-usage visibility.

Recent important commits
- 1e441ab Expand owner job workspace and calendar planner
- f087257 Fix calendar day rendering and add crew assignment alerts
- e1818ab Fix dashboard template break and finalize crew alert modes
- c812068 Fix appointment schema mismatch and add day agenda modal
- be13cbc Turn calendar day modal into direct day workspace
- 2051978 Improve calendar day timeline and quick-add services
- e82dd0a Auto-fill quick-add duration from selected services
- 7af86dd Restore owner tab from URL hash on refresh
- 66231db Add plan usage card to settings
- f4069a3 Clarify plan usage labels for crew seats

Owner dashboard highlights
- Jobs: detail modal acts as a real job workspace with editable overview, owner notes, supplies, blockers, and full activity.
- Crew notifications: per-assignment App/Text/Both actions exist; SMS depends on company Twilio config.
- Calendar: 4-week planner, clickable day cards, day workspace modal, extended hourly timeline, quick-add form, service selection, service-duration-based end-time auto-fill, and scrollable day-agenda preview.
- Settings: plan usage card now shows crew seats included, crew added, and crew seats left. Wording clarifies owner access is separate.
- Refresh behavior: last main tab, Clients subtab, and calendar state are persisted; current tab is mirrored to URL hash.

Important implementation notes
- Appointment save logic in api/server.js no longer writes appointments.notify_client because that column does not exist in the current schema.
- Client confirmations still work via send_confirmation at save time; reminder cron no longer depends on notify_client.
- Twilio-dependent UI is intentionally disabled with tooltips in the owner dashboard where SMS is offered.

Next requested task
- Redesign the admin panel at /lc-ops to match the newer, more integrated LinkCrew visual system.
- Source file: /home/eliott/claude/fieldsync/dashboard/admin.html
- Existing route handler: /home/eliott/claude/fieldsync/api/server.js app.get('/lc-ops', ...)

Recommended lc-ops redesign direction
- Keep existing admin capabilities and APIs.
- Rebuild admin.html around:
  - stronger header and modern shell
  - overview KPIs
  - account ops workspace
  - clearer trials/invites/analytics sections
  - tenant detail workspace instead of hiding important actions in expandable rows
- Preserve admin-specific darker tone if desired, but align spacing, cards, actions, and hierarchy with the owner dashboard system.

Open product note
- Calendar sync should be staged:
  - outbound Google first
  - outbound Outlook second
  - inbound read-only overlay only later
  - no two-way sync yet
