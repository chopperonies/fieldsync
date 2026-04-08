alter table if exists public.employees
  add column if not exists status text not null default 'active';

update public.employees
set status = 'active'
where status is null;

alter table if exists public.employees
  drop constraint if exists employees_status_check;

alter table if exists public.employees
  add constraint employees_status_check
  check (status in ('active', 'vacation', 'suspended'));
