ALTER TABLE service_agreements
ADD COLUMN IF NOT EXISTS due_time time;
