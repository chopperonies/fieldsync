-- LinkCrew role and capability rollout
-- Apply in Supabase SQL Editor or via your normal migration flow.

begin;

alter table if exists public.tenants
  add column if not exists manager_financials_enabled boolean not null default false;

alter table if exists public.tenant_users
  add column if not exists role text,
  add column if not exists can_view_financials boolean,
  add column if not exists employee_id uuid references public.employees(id) on delete set null;

update public.tenant_users
set role = 'owner'
where role is null;

update public.tenant_users
set can_view_financials = case
  when role = 'owner' then true
  else false
end
where can_view_financials is null;

alter table if exists public.tenant_users
  alter column role set default 'owner';

alter table if exists public.tenant_users
  alter column can_view_financials set default false;

do $$
begin
  if exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'tenant_users'
      and column_name = 'role'
  ) and not exists (
    select 1
    from pg_constraint
    where conname = 'tenant_users_role_check'
  ) then
    alter table public.tenant_users
      add constraint tenant_users_role_check
      check (role in ('owner', 'manager', 'crew', 'client'));
  end if;
end $$;

create index if not exists tenant_users_tenant_id_idx on public.tenant_users (tenant_id);
create index if not exists tenant_users_employee_id_idx on public.tenant_users (employee_id);
create index if not exists tenant_users_role_idx on public.tenant_users (role);

comment on column public.tenants.manager_financials_enabled is
  'Owner-controlled toggle that enables financial visibility for manager dashboard users.';

comment on column public.tenant_users.role is
  'Application role for dashboard access. owner keeps full access, manager is operational by default.';

comment on column public.tenant_users.can_view_financials is
  'Per-user financial visibility flag. Owners should remain true; managers inherit the tenant toggle by default.';

comment on column public.tenant_users.employee_id is
  'Optional link from a dashboard user to the employee record used across jobs, assignments, and timesheets.';

commit;
