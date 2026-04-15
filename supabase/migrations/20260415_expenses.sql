-- Expenses table
CREATE TABLE IF NOT EXISTS expenses (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id             UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  date                  DATE NOT NULL,
  amount                DECIMAL(10,2) NOT NULL,
  name                  TEXT NOT NULL,
  details               TEXT,
  category              TEXT NOT NULL DEFAULT 'other',
  reimburse_to          TEXT NOT NULL DEFAULT 'none',  -- 'none' | 'owner' | 'employee'
  reimburse_employee_id UUID REFERENCES employees(id) ON DELETE SET NULL,
  job_id                UUID REFERENCES jobs(id) ON DELETE SET NULL,
  receipt_url           TEXT,
  status                TEXT NOT NULL DEFAULT 'pending',  -- 'pending' | 'settled'
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS expenses_tenant_idx ON expenses(tenant_id);
CREATE INDEX IF NOT EXISTS expenses_date_idx   ON expenses(tenant_id, date DESC);

-- RLS: only service role accesses this table (same pattern as jobs)
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;
