# LinkCrew VPS Migration Plan (Render → VPS)

Drafted 2026-04-16. Builds on the existing `VPS_DEPLOY.md` with a specific day-by-day execution plan and rollback strategy.

Context: VPS is 16 GB RAM, well above the 8 GB we scoped. Headroom for KDG + SupportIQ + LinkCrew on one box per scaling plan.

---

## What actually moves

Only the Node.js Express app (fieldsync/api/server.js) and the bot worker. Everything else is externally hosted and does not move:

- Supabase (DB + Storage)
- Stripe, Resend, Twilio, Anthropic, Tavily
- Cloudflare (DNS + proxy)
- Domain registration

So migration = Docker-ize and re-host one Express app + one bot worker. Domain stays `linkcrew.io`.

---

## Pre-flight checklist (before Day 1)

- [ ] VPS accessible via SSH with a non-root sudo user
- [ ] Firewall open on 80, 443, 22 (close 22 to known IPs if possible)
- [ ] Docker Engine + Docker Compose plugin installed
- [ ] Domain control on Cloudflare (DNS + API token for automation)
- [ ] Full production `.env` file copied from Render → local → VPS (all 20 vars)
- [ ] Decide TLS strategy: Cloudflare Origin Cert (recommended, no Let's Encrypt cron needed) OR certbot auto-renew
- [ ] Pick a process supervisor. Docker `restart: unless-stopped` is enough for now.
- [ ] Create a `staging.linkcrew.io` A record pointed at VPS IP for pre-cutover testing

---

## Day 1 — Provision + Dockerize

- Install Docker + Compose plugin
- Clone `github.com/chopperonies/linkcrew` onto VPS at `/opt/linkcrew`
- Copy `.env` (scp or rsync from a safe source). chmod 600.
- Create `deploy/certbot/conf` and `deploy/certbot/www` directories
- Build the images: `docker compose -f docker-compose.vps.yml build`
- Start web + bot only (no nginx yet): `docker compose -f docker-compose.vps.yml up -d linkcrew-web linkcrew-bot kdg-site`
- Hit `http://<vps-ip>:3000/api/config` from the VPS itself — confirm Express is alive
- Verify Supabase connection: `docker logs linkcrew-web` should show no connection errors

Smoke tests against local container:
- `/` returns landing page
- `/api/config` returns `{ supabaseUrl, supabaseKey }`
- `/app` returns dashboard HTML

---

## Day 2 — Reverse proxy + TLS on staging

Two TLS options — pick one:

**Option A: Cloudflare Origin Certificate (recommended)**
- Generate origin cert in Cloudflare dashboard (15-year validity, Cloudflare-signed only)
- Drop cert + key into `deploy/certbot/conf/` (rename to match nginx config)
- Update `deploy/nginx/vps.conf` to reference the origin cert paths
- Set Cloudflare SSL mode to "Full (strict)"
- Zero cron renewal pain, cert is pinned to Cloudflare

**Option B: Let's Encrypt via certbot**
- Run certbot inside a one-shot container or on the host
- Set up a renewal cron
- Works but adds a moving part

Start nginx: `docker compose -f docker-compose.vps.yml up -d nginx`

Point `staging.linkcrew.io` at the VPS IP via Cloudflare. Test the full stack on staging:
- Sign up a throwaway account
- Create a job, send an invoice, generate a payment link, complete a Stripe test payment
- Trigger a voice call to verify Twilio webhook reaches the VPS (requires temporarily pointing the Twilio webhook at staging — revert after test)
- Trigger the hourly snapshot cron manually

---

## Day 3–4 — Burn-in

Keep staging running with a real (but small) subset of traffic. You can:
- Invite one tenant you trust to use staging.linkcrew.io for 48 hours
- Or just keep it up and hit it yourself with daily workflow end-to-end

Watch for:
- Memory drift (should stay under 1.5 GB for linkcrew-web, 0.8 GB for bot)
- Stripe webhook delivery (Stripe dashboard → Developers → Webhooks → delivery logs)
- Supabase connection pool exhaustion (unlikely with < 10 concurrent users)
- Log volume — decide now if you need to add loki/promtail/journald shipping

If something breaks, fix it on staging without pressure. Render is still serving production.

---

## Day 5 — Cutover

Pre-cutover:
- Set linkcrew.io DNS TTL to 60 seconds at least 12 hours before cutover
- Snapshot the Supabase state (it's not changing, just an extra safety net)
- Confirm no critical deploys are in flight on Render (check last commit = stable)

Cutover steps (in order):
1. Render → Settings → Suspend service (or leave running — Cloudflare will stop routing to it after DNS flip)
2. Cloudflare → DNS → change `linkcrew.io` A record from Render IP to VPS IP
3. Watch logs on VPS: `docker logs -f linkcrew-web`
4. Verify on desktop + phone: login, create job, send invoice
5. Re-point Twilio voice webhook(s) at linkcrew.io (should already be, so no-op)
6. Confirm Stripe webhook still delivers (dashboard → Developers → Webhooks → Recent deliveries)

If anything goes sideways within the first 30 min:
- Revert DNS A record back to Render
- Un-suspend Render
- Continue troubleshooting on VPS without pressure

Keep Render running for 3-5 days as a cold rollback.

---

## Day 6–10 — Observe + decommission Render

Watch metrics:
- Response times (should be ~same or better than Render — VPS co-located with EU if Hetzner, US-east if Vultr, etc.)
- Error rates (0 ideally)
- Cron runs completing
- Stripe events processed
- Twilio calls connecting
- Email sending via Resend

After 5 clean days:
- Cancel the Render subscription
- Remove Render-specific code: the `self-ping keepalive` mentioned in VPS_DEPLOY.md line 67
- Document the new deploy workflow in CLAUDE.md

---

## Things that commonly bite on Render → VPS migrations

1. **Missing env var** — do a diff of `.env` vs Render dashboard. Especially `STRIPE_CONNECT_CLIENT_ID` (new), `TAVILY_API_KEY`, `ADMIN_URL_SECRET`.
2. **Cron jobs double-firing** — if you leave Render running during staging burn-in, disable the cron on Render or both will fire. Simplest: keep Render serving but stop its cron endpoint by commenting out the schedule.
3. **Stripe webhook signing** — webhook secret is tied to the endpoint URL in Stripe. Since domain stays `linkcrew.io`, no signing change needed.
4. **Twilio webhook validation** — same, domain stays the same.
5. **CORS origin list** — check `api/server.js` line 56 for hardcoded origins. Already includes linkcrew.io, so OK.
6. **File uploads** — multer uses memory storage and uploads to Supabase. No local disk dependency. OK.
7. **Self-ping keepalive** — Render-specific anti-sleep. Remove after cutover.
8. **Time zone** — server times in logs will differ. Nothing depends on local system time since everything is stored as UTC in Supabase.

---

## Rollback plan

At any point within the first 7 days:

1. Cloudflare → DNS → change `linkcrew.io` A record back to Render IP (30-60 sec propagation with low TTL)
2. Un-suspend Render service if suspended
3. Post-mortem the VPS issue without pressure
4. Retry cutover when fixed

Data is in Supabase, which doesn't move. Rollback is pure DNS flip. This is the key reason the migration is low-risk.

---

## Parallel-track consolidation (after LinkCrew is stable on VPS)

Once LinkCrew is solid (week 2+):

- Move KDG static site from Render → same VPS (already in docker-compose.vps.yml as `kdg-site`)
- Move SupportIQ → same VPS
- Set up Coolify if the manual docker compose becomes tedious
- Add basic observability: uptimerobot + cron-fail alerts via existing Telegram bot

---

## Estimated total time

- Day 1-2: 6-8 hours active work
- Day 3-4: monitoring, ~1 hour/day
- Day 5: cutover window 30 min + watching 2-3 hours
- Day 6-10: 15 min/day monitoring

Total: ~12-15 hours of active work spread over a week. Very doable without disrupting app-build work.
