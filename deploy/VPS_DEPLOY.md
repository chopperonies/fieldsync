# LinkCrew VPS Deployment

This repo now includes a VPS-oriented Docker Compose layout for:

- `linkcrew-web`: main LinkCrew web app and cron runner
- `linkcrew-bot`: bot worker process
- `kdg-site`: static Kingston Data Group site
- `nginx`: public reverse proxy and TLS terminator

## Why this layout

- The main app and the bot are isolated from each other.
- A runaway bot is less likely to starve the dashboard.
- KDG is separated from LinkCrew traffic and deploys.
- Only one `linkcrew-web` instance runs, which avoids duplicate cron execution.

## Files

- `docker-compose.vps.yml`
- `deploy/nginx/vps.conf`
- `deploy/nginx/kdg-site.conf`
- `.dockerignore`

## Recommended VPS shape

Start with a single Ubuntu 24.04 VPS with:

- `4 vCPU`
- `8 GB RAM`
- `80-160 GB SSD`
- at least `4 TB` monthly transfer

That is enough for:

- LinkCrew web app
- LinkCrew bot worker
- KDG site
- nginx
- room for moderate early production growth

## Weekend deployment order

1. Provision the VPS.
2. Install Docker Engine and Docker Compose plugin.
3. Clone this repo onto the VPS.
4. Copy production `.env`.
5. Create the certbot directories:

```bash
mkdir -p deploy/certbot/conf deploy/certbot/www
```

6. Bring up the app stack without nginx TLS first if you want to validate locally:

```bash
docker compose -f docker-compose.vps.yml up -d linkcrew-web linkcrew-bot kdg-site
```

7. Add TLS certs with certbot, then start nginx:

```bash
docker compose -f docker-compose.vps.yml up -d nginx
```

## Notes

- The self-ping keepalive in `api/server.js` is Render-oriented and can be removed later.
- Keep Render live as rollback until the VPS has passed full smoke testing.
- Do not scale `linkcrew-web` horizontally yet; cron jobs and some in-memory behavior are still single-instance oriented.
