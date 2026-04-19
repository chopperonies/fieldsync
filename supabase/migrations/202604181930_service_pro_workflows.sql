-- Service PRO phase 1: per-status workflow checkpoints
-- Tenants attach a workflow to a job; workflow_statuses drive the status
-- pill row and step checklist shown on the job detail + (later) mobile tech view.
-- RLS enabled with no policies — access goes through the Express API w/ service role.

CREATE TABLE service_workflows (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid REFERENCES tenants(id) ON DELETE CASCADE,
  name text NOT NULL,
  description text,
  industry text,
  is_template boolean DEFAULT false,
  source_template_id uuid REFERENCES service_workflows(id),
  created_at timestamptz DEFAULT now()
);

CREATE TABLE workflow_statuses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workflow_id uuid REFERENCES service_workflows(id) ON DELETE CASCADE,
  order_index int NOT NULL,
  name text NOT NULL,
  color text DEFAULT '#0ea5e9',
  icon text DEFAULT 'wrench',
  steps jsonb DEFAULT '[]',
  action_buttons jsonb DEFAULT '[]',
  UNIQUE(workflow_id, order_index)
);

ALTER TABLE jobs
  ADD COLUMN workflow_id uuid REFERENCES service_workflows(id),
  ADD COLUMN workflow_progress jsonb DEFAULT '{}';

CREATE INDEX idx_service_workflows_tenant ON service_workflows(tenant_id);
CREATE INDEX idx_workflow_statuses_workflow ON workflow_statuses(workflow_id, order_index);

ALTER TABLE service_workflows ENABLE ROW LEVEL SECURITY;
ALTER TABLE workflow_statuses ENABLE ROW LEVEL SECURITY;
