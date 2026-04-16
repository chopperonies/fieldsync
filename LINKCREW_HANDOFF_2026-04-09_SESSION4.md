LinkCrew Handoff
Date: 2026-04-09
Session: 4

Checkpoint
- Branch: `main`
- HEAD: `a8e11d71396bc45a75e46c059517cc6a245cf9b0`
- Latest commit: `a8e11d7` Add job records page and lifecycle actions

Production
- Render live deploy: `dep-d7c215hj2pic73c45o6g`
- Live commit: `a8e11d7`
- Supabase migrations applied:
  - `202604092145_add_work_type_to_job_assignments.sql`
  - `202604092230_expand_job_status_lifecycle.sql`

Summary
- Timesheets now support owner manual punch, supervisor/manager self-punch, and non-job `Work Type` categories.
- The old stray active `job test 2` row was deleted from the live database so it no longer appears in punch job options.
- Jobs now have a dedicated `Job Records` sidebar page instead of a buried history toggle.
- Job lifecycle/status handling was expanded and normalized.

Production-safe state now includes
- Supervisor/manager `My Shift` self-punch card
- Higher-accuracy GPS handling for punches
- Non-job work-type timesheet entries and print support
- Active-job-only punch dropdown behavior
- Dedicated `Job Records` page
- Job statuses:
  - `quoted`
  - `scheduled`
  - `in_progress`
  - `active`
  - `on_hold`
  - `completed`
  - `invoiced`
  - `saved_for_later`
  - `cancelled`
  - `archived`
- Owner lifecycle actions in Job Detail:
  - reopen
  - complete
  - save for later
  - cancel
  - archive
- Owner-only delete for non-billed cleanup jobs

Operational notes
- If Supabase push fails on remote migration drift, repair `20260408` first:
  - `supabase migration repair --status reverted 20260408 --yes`
  - then run `supabase db push --include-all`
- Render may show a duplicate API-triggered deploy after the new-commit deploy is already live.

Notes
- User preference remains: always ask before pushing/deploying if needed.
- User prefers real sidebar pages over more hidden cards or tiny links when the app has room to expand.
- Keep unrelated VPS/logo/local files out of normal product commits.

Suggested first checks tomorrow
1. Open `Job Records` and verify each filter bucket works.
2. Move a job through `Saved For Later`, `Cancelled`, `Archived`, then `Reopen`.
3. Confirm the main `Jobs` page stays focused on current work only.
4. Re-test Timesheets for:
   - owner manual punch
   - supervisor self-punch
   - non-job work type entries
