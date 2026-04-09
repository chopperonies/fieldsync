alter table if exists public.appointments
  add column if not exists job_id uuid references public.jobs(id) on delete set null;
