LinkCrew Handoff
Date: 2026-04-08
Session: 3

Checkpoint
- Branch: `main`
- HEAD: `387fb5122796c350475674362773e51de52c27e1`
- Latest commit: `387fb51` Restore pre-remote-control dashboard

Summary
- The dashboard is back to the pre-Remote-Control layout.
- New-job creation still defaults to `active`, so new jobs remain visible after save.
- This session ended by stabilizing the app rather than extending the Remote Control concept further.

Production-safe state now includes
- Resend sender migration to `platform@linkcrew.io`
- Working invite delivery
- Owner-only team-member removal
- Employee `active / vacation / suspended` statuses
- Assignment filtering for unavailable staff
- Calendar availability card
- Appointment optional job link and team notification support
- Client portal invite emails
- Portal service request owner alerts and multi-photo uploads
- Stripe invoice payment working end-to-end
- Standalone invoicing from client page
- Jobs `Active Jobs` / `Job History` and `Recent Outcomes`

Rolled back this session
- Dedicated Remote Control page and sidebar tab
- Remote Control command-center cards
- Remote Control proof snapshot UI
- Remote Control dashboard job-detail planning UI

Notes
- The rollback was intentional per user request.
- Do not reintroduce Remote Control casually into the dashboard. Treat it as a future isolated redesign if it comes back.
- Remaining local uncommitted files are unrelated VPS/logo work and should stay out of normal product commits.

Suggested first checks tomorrow
1. Add a job and confirm it appears immediately.
2. Open Job Detail and verify normal editing still works.
3. Send an invoice and confirm UI feedback still appears.
4. Submit a client portal request and confirm owner email/dashboard visibility.
5. Decide whether the next focus is:
   - more product QA
   - VPS migration prep
