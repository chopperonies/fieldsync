LinkCrew Handoff
Date: 2026-04-15
Session: 7

## Branch / Files touched
- `dashboard/index.html` — full visual redesign (CSS + HTML)
- `api/server.js` — expense CRUD, receipt upload, service catalog CRUD endpoints
- `supabase/migrations/20260415_expenses.sql` — expenses table
- `/home/eliott/claude/linkcrew-landing/` — Next.js landing page mockup (separate project)

## What changed this session

### Visual redesign — dashboard/index.html
1. **CSS variables** updated: off-white `#fdfdfc` bg, warm slate palette, `--radius: 12px`
2. **Sidebar** — white background, flat nav items, blue-50 active state, no dark navy
3. **Option B layout** — all card chrome removed. Sections separated by 1px dividers only.
   - `.owner-card` — no border, no shadow, border-bottom dividers
   - `.owner-kpi-grid` — horizontal strip with vertical dividers, no card boxes
   - `.workspace-summary-grid` — same strip treatment
   - `.workspace-row` — tight list rows, border-bottom only
4. **Character layer** — warm slate tones, sky blue only on CTAs/active states, `#fdfdfc` off-white tint on headers
5. **Side tabs** — Lucide icons (package/image) replacing 📦📸 emojis, underline tab style
6. **Team nav** — flattened to direct nav item, Crew subpage removed, all crew content on Team page
7. **Filter buttons** — `.owner-mini-btn.active` CSS class replacing inline style hacks
8. **Refer and Save** — full page rebuild with dark hero, gradient headline, Unsplash testimonial photos, Lucide share buttons, how-it-works strip

### Landing page mockup
- `/home/eliott/claude/linkcrew-landing/` — Next.js 16, Tailwind, framer-motion
- Run: `cd /home/eliott/claude/linkcrew-landing && npm run dev -- --port 3001`
- `landing.html` on Render is UNCHANGED

### Backend (from earlier today, already deployed locally)
- `/api/expenses` CRUD — GET, POST, PATCH, DELETE
- `/api/expenses/:id/receipt` — upload to Supabase Storage `receipts` bucket
- `/api/jobs/:id/receipt` — upload invoice attachment
- `/api/service-catalog` CRUD — invoice line item presets
- Supabase: `expenses` table, `service_catalog` table, `receipts` bucket, `jobs.receipt_url` column

## Remaining work (next session)

### Dashboard
1. **Commit and push to Render** — all local changes need a PR or direct push
2. **Check remaining emoji/old icons** in modals and job detail panels
3. **Invoice worksheet** — test full save flow with real data after redesign
4. **Mobile responsiveness check** — layout changes may need media query tweaks

### Landing page
1. **Approve or iterate** on landing page mockup at localhost:3001
2. **Replace hero mockup** with real dashboard screenshot (after dashboard polish is done)
3. **Deploy landing** — replace `dashboard/landing.html` OR set up Next.js static export served by nginx on VPS
4. **Copy review** — pricing, features section, CTA wording

### VPS migration
- Docker Compose at `docker-compose.vps.yml` is ready
- Needs: target server, DNS pointed, SSL certs via certbot

## How to resume

```bash
# Start local server
cd /home/eliott/claude/fieldsync && node start.js &

# Start landing page preview
cd /home/eliott/claude/linkcrew-landing && npm run dev -- --port 3001 &

# Open both
xdg-open http://localhost:3000/app
xdg-open http://localhost:3001
```
