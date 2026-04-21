-- Free-punch clock-in. Separate from per-job check-ins (job_assignments).
-- Lets an owner or crew member punch without selecting a job, and
-- captures GPS for the office map view on Home.

CREATE TABLE IF NOT EXISTS time_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ended_at TIMESTAMPTZ,
  start_lat DOUBLE PRECISION,
  start_lng DOUBLE PRECISION,
  end_lat DOUBLE PRECISION,
  end_lng DOUBLE PRECISION,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS time_entries_tenant_started_idx
  ON time_entries(tenant_id, started_at DESC);

CREATE INDEX IF NOT EXISTS time_entries_employee_started_idx
  ON time_entries(employee_id, started_at DESC);

-- Partial index — fast lookup of "who's currently clocked in" per tenant.
CREATE INDEX IF NOT EXISTS time_entries_tenant_open_idx
  ON time_entries(tenant_id)
  WHERE ended_at IS NULL;

ALTER TABLE time_entries ENABLE ROW LEVEL SECURITY;

-- All server-side access goes through the service-role key, so we add
-- a generous service-role policy and explicit employee self-access.
-- Owners read tenant-wide via the service role in /api/mobile/owner/*.

DROP POLICY IF EXISTS time_entries_service_all ON time_entries;
CREATE POLICY time_entries_service_all ON time_entries
  FOR ALL TO service_role
  USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS time_entries_employee_self ON time_entries;
CREATE POLICY time_entries_employee_self ON time_entries
  FOR ALL TO authenticated
  USING (employee_id = auth.uid())
  WITH CHECK (employee_id = auth.uid());
