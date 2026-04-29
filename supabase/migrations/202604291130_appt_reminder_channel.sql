ALTER TABLE tenants
ADD COLUMN IF NOT EXISTS appt_reminder_channel TEXT DEFAULT 'email';

UPDATE tenants
SET appt_reminder_channel = 'email'
WHERE appt_reminder_channel IS NULL;

ALTER TABLE tenants
DROP CONSTRAINT IF EXISTS tenants_appt_reminder_channel_check;

ALTER TABLE tenants
ADD CONSTRAINT tenants_appt_reminder_channel_check
CHECK (appt_reminder_channel IN ('email', 'app', 'sms', 'email_app', 'email_sms', 'all'));
