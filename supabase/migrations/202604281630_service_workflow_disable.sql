-- Allow tenant workflows to be disabled without deleting historical job data.
ALTER TABLE IF EXISTS public.service_workflows
  ADD COLUMN IF NOT EXISTS disabled_at TIMESTAMPTZ;

CREATE INDEX IF NOT EXISTS idx_service_workflows_tenant_active
  ON public.service_workflows (tenant_id, created_at)
  WHERE disabled_at IS NULL;
