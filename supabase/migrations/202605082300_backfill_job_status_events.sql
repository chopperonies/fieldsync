-- Backfill one job_status_events row per existing job so the lifecycle
-- timestamp tooltips on the mobile app aren't blank for jobs that were
-- created before the centralized status audit was wired in. Idempotent
-- via LEFT JOIN — only inserts when the job has no events yet. Uses the
-- job's created_at as the timestamp and 'system' as the trigger so it's
-- distinguishable from genuine user actions.

INSERT INTO job_status_events (job_id, tenant_id, from_status, to_status, trigger, created_at)
SELECT j.id, j.tenant_id, NULL, j.status, 'system', j.created_at
FROM jobs j
LEFT JOIN job_status_events e ON e.job_id = j.id
WHERE e.id IS NULL
  AND j.status IS NOT NULL
  AND j.tenant_id IS NOT NULL;
