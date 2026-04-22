-- Employee self-profile: avatar_url lets a crew member upload their own
-- photo from the mobile app. Stored in the existing 'photos' bucket
-- under avatars/{employee_id}.{ext} (no new bucket needed).

ALTER TABLE employees
  ADD COLUMN IF NOT EXISTS avatar_url TEXT;
