-- Track scope-of-work edits on jobs so assigned crew can see what changed
-- and acknowledge. Push is sent server-side on edit; banner + ack happen
-- client-side against these timestamps.

ALTER TABLE jobs ADD COLUMN IF NOT EXISTS scope_updated_at TIMESTAMPTZ;
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS scope_updated_by_user_id UUID;
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS scope_updated_by_name TEXT;

CREATE TABLE IF NOT EXISTS job_scope_acknowledgements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  job_id UUID NOT NULL,
  employee_id UUID NOT NULL,
  acked_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  acked_scope_updated_at TIMESTAMPTZ NOT NULL,
  UNIQUE (job_id, employee_id)
);

CREATE INDEX IF NOT EXISTS job_scope_ack_job_idx
  ON job_scope_acknowledgements (job_id);

ALTER TABLE job_scope_acknowledgements ENABLE ROW LEVEL SECURITY;
