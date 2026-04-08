begin;

alter table if exists public.job_updates
  drop constraint if exists job_updates_type_check;

alter table if exists public.job_updates
  add constraint job_updates_type_check
  check (type in ('checkin', 'update', 'note', 'bottleneck', 'supply_request', 'photo', 'checkout'));

commit;
