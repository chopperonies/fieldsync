alter table if exists public.jobs
  add column if not exists plans_notes text,
  add column if not exists execution_plan text,
  add column if not exists checklist_items jsonb not null default '[]'::jsonb,
  add column if not exists missing_items_watchlist text,
  add column if not exists client_communication_plan text,
  add column if not exists expected_duration_hours numeric,
  add column if not exists required_before_photos integer not null default 2,
  add column if not exists required_mid_job_photos integer not null default 1,
  add column if not exists required_completion_photos integer not null default 2,
  add column if not exists required_cleanup_photos integer not null default 1,
  add column if not exists crew_plan_confirmed boolean not null default false;
