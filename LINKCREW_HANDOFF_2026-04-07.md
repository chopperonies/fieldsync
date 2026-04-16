LinkCrew Handoff
Date: 2026-04-07
Repo: /home/eliott/claude/fieldsync

Current pushed state
- Main includes the previously completed owner-dashboard and admin-panel modernization work.
- Today’s work focused on Kingston Data Group homepage cleanup and polish at `kingstondatagroup.com`, served from `/home/eliott/claude/fieldsync/kdg-site/index.html`.

Important routing note
- `kingstondatagroup.com` is served from:
  - `/home/eliott/claude/fieldsync/kdg-site/index.html`
- It is NOT served from:
  - `/home/eliott/claude/fieldsync/dashboard/kdg.html`
- `dashboard/kdg.html` still exists, but live KDG host-based routing in `api/server.js` points the public domain to `kdg-site/index.html`.

Recent important commits
- `f8eb4cc` Replace KDG hero mockup with product composition
- `68a6c69` Replace duplicate KDG product section
- `9a45321` Replace KDG outcomes with leverage section
- `d0a611a` Simplify KDG lower sections
- `63f2a9e` Tighten KDG hero layout
- `d9f30de` Adjust KDG hero product cards
- `7b592e5` Refresh KDG primary CTAs
- `9b51669` Update KDG infrastructure capability label
- `61b80c8` Lighten KDG primary CTA color
- `6b50c35` Remove dead KDG nav link
- `9457b53` Add SupportIQ hero detail
- `a8ee57f` Move KDG process section

KDG homepage highlights
- Reverted the over-busy redesign and polished the older homepage structure one section at a time.
- Hero now uses:
  - left-aligned headline/copy
  - one primary CTA
  - side-by-side LinkCrew and SupportIQ product cards
  - capability strip below
- LinkCrew card has a visible `View Product` link to `https://linkcrew.io`.
- Hero/nav `Start a Project` CTAs are slimmer and use a lighter LinkCrew-like blue.
- Duplicate products section was removed.
- `Built by Engineers, Measured in Outcomes` was replaced by `Where We Create Leverage`.
- Testimonial section was narrowed to reduce vertical dominance.
- Contact section was rebuilt into a cleaner two-column layout.
- `How It Works` now appears directly under `What We Do`.
- Dead `Products` nav link was removed.
- In data center capabilities, `BIOS & Firmware Setup` is now `System Administration`.

Open polish opportunities
- Trust strip may still be denser than necessary.
- Service-card section could be reduced if the page should feel even lighter.
- Footer could be tightened to better match the upgraded hero.

Repo status notes
- Untracked draft logo files remain in `/home/eliott/claude/fieldsync/dashboard/` and were intentionally not committed:
  - `logo-modern-alt.svg`
  - `logo-modern-bold-clean.svg`
  - `logo-modern-bold.svg`
  - `logo-modern-minimal.svg`

Recommended next move if work resumes
1. Review KDG trust strip and services density.
2. If KDG is satisfactory, return to LinkCrew product work or mobile prep.
