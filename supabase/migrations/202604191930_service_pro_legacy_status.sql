-- Service PRO phase 2: add legacy_status to workflow_statuses so the
-- legacy jobs.status column can be derived from the current workflow
-- status (keeps Jobs list / dashboard chips / reports in sync).
-- Pure SQL — no PL/pgSQL, paste-safe.

ALTER TABLE workflow_statuses
  ADD COLUMN IF NOT EXISTS legacy_status text;

-- Backfill the 15 seeded statuses by name.
-- Mapping against JOB_STATUS_OPTIONS in dashboard/index.html:
--   quoted, scheduled, in_progress, active, on_hold,
--   completed, invoiced, saved_for_later, cancelled, archived
UPDATE workflow_statuses
SET legacy_status = 'scheduled'
WHERE legacy_status IS NULL
  AND name IN ('New Job', 'Scheduled', 'Dispatched');

UPDATE workflow_statuses
SET legacy_status = 'in_progress'
WHERE legacy_status IS NULL
  AND name IN (
    'On the Way',
    'In Progress',
    'On Site',
    'Diagnosing',
    'Repairing'
  );

UPDATE workflow_statuses
SET legacy_status = 'completed'
WHERE legacy_status IS NULL
  AND name IN ('Service Complete', 'Complete', 'Paid');

UPDATE workflow_statuses
SET legacy_status = 'invoiced'
WHERE legacy_status IS NULL
  AND name = 'Invoiced';
