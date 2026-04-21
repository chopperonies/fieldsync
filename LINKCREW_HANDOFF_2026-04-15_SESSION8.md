LinkCrew Handoff
Date: 2026-04-15
Session: 8 (continued from Session 7, same day)

## Git state
- Main branch: `bd3d043` (all pushed to GitHub, auto-deploying to Render)
- Landing page project: `/home/eliott/claude/linkcrew-landing/` (local only, NOT in git yet)

## What changed this session

### Dashboard (fieldsync repo, pushed)
- Reports page rebuilt money-first: revenue, expenses, profit, outstanding, AR aging, conversion funnel, top clients, expense breakdown
- Invoices: AR Aging card replaces filler, clickable stat filters (All/Unpaid/Paid), compact button
- All buttons unified to compact 11px/6-12px style globally
- Job Records renamed to Job History (sidebar, topbar, page eyebrow)
- Jobs page: stat strip replaces duplicate header, Calendar button removed, Client Requests uses clean rows
- Schedule page: 5-day agenda snapshot (lists appointments per day), 4-week planner uses fixed-height cells with compact appointment lines (max 4 visible + overflow), Day Agenda removed, Team Availability moved to right column, Snapshot card removed
- All page titles: duplicate hero titles hidden globally via `.owner-page-copy { display:none }`, each page gets branded topbar kicker (Operations/Billing/Intake/etc.)
- Empty state emoji icons hidden globally
- Quick Add: + dropdown on document.body (z-index fix), search Go button folded into input

### Landing page (local only)
- Real dashboard screenshot in hero with blur-in gradient reveal (crops browser chrome, fades edges)
- Shimmer CTA button effect on hover
- App Store + Google Play badges in hero
- FAQ section: 7 contractor-focused Q&As, accordion style
- Lato font globally, real LinkCrew logo.svg in nav + footer
- Nav scroll state bug fixed (useRef → useEffect)
- All section padding tightened (py-28 → py-16)
- Feature cards compacted (p-7 → p-5, smaller icons/text)
- Pricing cards compacted (p-8 → p-6)
- Page meta: title + description updated for SEO

## What needs fixing before live push

### Dashboard
1. Test invoice save flow with real data end-to-end
2. Test expense save + receipt upload end-to-end
3. Mobile responsiveness check after all CSS changes
4. Client portal pages — may need same design treatment
5. Check if Render auto-deploy broke anything (reports API changed)

### Landing page
1. Crop or retake dashboard screenshot without browser extensions/profile pic visible
2. Review all copy (headlines, features, FAQ, pricing details)
3. Mobile responsiveness pass
4. Decide deployment: replace `landing.html` OR Next.js static export via nginx on VPS
5. Social proof — swap placeholder reviews with real ones when available
6. iOS App Store link — update when build ships

### VPS migration
- Docker Compose ready at `docker-compose.vps.yml`
- Needs: Hetzner VPS provisioned, DNS pointed, SSL certs
- Landing page would deploy as a separate nginx-served static build

## How to resume

```bash
# Dashboard
cd /home/eliott/claude/fieldsync && node start.js &
xdg-open http://localhost:3000/app

# Landing page
cd /home/eliott/claude/linkcrew-landing && npm run dev -- --port 3001 &
xdg-open http://localhost:3001
```
