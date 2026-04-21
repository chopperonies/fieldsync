# LinkCrew Handoff — 2026-04-18

## Session goal
Modernize dashboard visuals and UX. Make `linkcrew.io/app` feel cohesive and current before live-Stripe cutover / VPS migration / mobile app build.

## What shipped (7 commits, pushed to main, auto-deployed)

| Commit | Summary |
|---|---|
| b8876ec | Team page + `.lc-btn` button system + dead code removal (~150 lines) |
| 32fd94f | Tier 2: migrate ~25 inline buttons + `.lc-card` flat/elevated card style |
| 669c6a1 | Flatten remaining cards (`.photo-card`, `.tenant-card`, `.report-stat`, `.chart-card`, `.agd-section`, `.cd-section`) |
| 04eff25 | Dashboard stat tiles + overlay modernization (lucide icons in overlays) |
| eba6dda | Dashboard UX sweep — layout cleanups + voice input + icon polish |
| 1bdfafa | Dashboard + Jobs polish — stat chips, compact KPIs, elevated list cards |
| 068a2fc | Team roster avatar redesign + Schedule Availability flat cards |

All changes in single file: `dashboard/index.html`.

## Design system (inline `<style>` in dashboard/index.html)

### `.lc-btn` — compact ghost buttons
Transparent bg, 1px border, colored text, hover-fill pattern.
Variants: `.primary` (blue), `.primary.solid` (filled blue), `.success` (green), `.danger` (red), `.muted` (grey), `.on-dark` (for dark backgrounds).
Sizes: default, `.sm`, `.xs`.
Modifier: `.icon-only`.

### `.lc-link` — text-only action
Blue text, underlines on hover, zero chrome. Variants: `.muted`, `.danger`, `.sm`.

### `.lc-card` — flat elevated container
White bg, 2px radius, 1px @ 6% slate border, layered shadow `0 20px 40px rgba(15,23,42,0.10), 0 8px 16px rgba(15,23,42,0.05)`. Variant: `.flush` (padding 0, overflow hidden — for `<details>` wrappers).

### `.stat-chip` — hero stat pill
Dot + number + label in a rounded-pill button. Dot variants: `.neutral` (blue), `.urgent` (red w/ glow), `.warning` (amber w/ glow), `.filter-active` (blue highlight when used as filter).

### Pre-existing classes restyled to match
`.btn-save`, `.btn-cancel`, `.owner-btn`, `.owner-mini-btn`, `.add-job-btn` — all now compact ghost style (one CSS edit = site-wide effect).

## Team roster redesign
Role-colored gradient avatars, 40×40 rounded-square, 2-letter initials:

| Role | Gradient | Text |
|---|---|---|
| Crew | `#64748b → #475569` slate | `#fbbf24` amber |
| Supervisor | `#14b8a6 → #0f766e` teal | white |
| Manager | `#bae6fd → #7dd3fc` baby blue | `#0f172a` dark |
| Owner | `#10b981 → #047857` emerald | white |

Row info compacted to single line: `Role · Phone · Status`. Role badge pill on the right dropped (avatar color carries the role).

## Consolidated Team edit modal
Click any roster row → opens full edit form covering:
- Name, Phone (with mobile-login warning)
- Role, Status (Active / Vacation / Suspended)
- Dashboard Access: email input + Send/Resend Invite + Copy Link + Revoke (role-gated — crew sees info note instead)
- Danger Zone: Remove from Team

## Dashboard hero
**Left column** (stacked): greeting / date / 4 `.stat-chip`s with urgency dots (red=supplies>0, amber=blockers>0).
**Right column**: 3 nav buttons (Requests / Quotes / Billing). Active chip navigates to Jobs page (Jobs button was redundant, removed).

## Pages cleaned up
- **Jobs page**: top stat strip removed; filter chips (On Site / Supplies / Blockers) in Operations Board filter the job list; Needs Attention panel killed.
- **Job History**: 4 big KPI cards removed; "Record Browser" → "History Browser".
- **Quotes + Requests**: advice cards killed; big summary cards → compact filter-pill row in card header with live counts (e.g., `All (8)  New This Week (3)  Quoted (2)`); clicking a pill filters the queue.
- **Team / Clients / Agreements / Timesheets**: `.owner-kpi-card` tightened (padding 10×16, value 18px, hover tint).
- **Invoices + Expenses**: `.workspace-summary-card` tightened same way.
- **Dashboard layout**: Requests Queue + Active Jobs Snapshot sub-cards removed; Live Feed moved to right column; collapsed to 2-row layout.
- **Recently Closed rows on Jobs**: flat white + 2px + layered shadow + hover lift.
- **Job detail modal**: dropped the redundant "Not visible to the client..." italic sub-line.

## Schedule Assistant voice input
Mic button on Calendar → Schedule Assistant card. Uses native `SpeechRecognition` (Chrome/Safari/Edge/Falkon). Tap → red stop icon → live transcript in input → auto-submit on speech end.

## Sidebar nav behavior
- Schedule tab stays lit on Calendar (schedule routes to calendar).
- Parent labels (Jobs / Quotes / Invoices) toggle their submenu when clicked — plus navigate to parent.
- Chevron still works independently.

## Dead code removed
- `updateEmployeeRole`, `updateEmployeeStatus`, `grantDashboardAccess`, `disableDashboardAccess`, `deleteEmployee` (replaced by modal-scoped versions)
- 4 `teamActions` expand helpers
- Duplicate `.owner-btn.primary` CSS blocks

## Bug fixed
Team tab was stuck at "Loading team summary..." because `loadTeamInline()` never called `renderTeamSummary()`.

## Not touched (intentional or deferred)
- **Auth pages** (`.auth-card`) — separate visual language, didn't migrate.
- **Referral card share buttons on dark backdrop** — migrated but could use a polish pass.
- **Global search "↵" hint** — visual indicator, not a CTA, left as inline style.
- **Owner-facing non-dashboard surfaces** (portal.html, invoice.html, workorder.html) — the avatar/card redesign hasn't propagated there.

## Where things live
- Dashboard: `dashboard/index.html` (single file, ~11k lines)
- API: `api/server.js`
- Backend routes involved in this session:
  - `GET /api/employees` (returns `dashboard_access_enabled`, `dashboard_role`, `dashboard_can_view_financials`; doesn't return the dashboard email — modal shows "Active" without the email when granted)
  - `PATCH /api/employees/:id` accepts `{ name, phone, role, status }`
  - `POST /api/employees/:id/dashboard-access` — grant/resend
  - `DELETE /api/employees/:id/dashboard-access` — revoke
  - `DELETE /api/employees/:id` — remove

## Next session candidates
1. **Live Stripe Connect cutover** — 3 env vars + webhook setup (see `linkcrew_stripe_connect_build.md`)
2. **VPS migration prep** — `deploy/VPS_MIGRATION_PLAN.md`
3. **Mobile app build phase 1** — `fieldsync-app/` WebView shell + phone-OTP login
4. **Landing page go-live** — hero screenshot retake + copy review + mobile pass (held back per owner)
5. **Propagate design system to portal.html, invoice.html, workorder.html** — keep client-facing surfaces consistent
6. **Surface owner email on employee dashboard access** — add backend JOIN so the modal can show "Active for `alice@example.com`"
