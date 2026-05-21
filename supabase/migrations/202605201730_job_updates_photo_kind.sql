alter table job_updates
  add column if not exists photo_kind text;

alter table job_updates
  add constraint job_updates_photo_kind_chk
  check (photo_kind is null or photo_kind in ('before', 'after', 'other'));
