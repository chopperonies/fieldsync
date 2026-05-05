-- Owners can require their approval before a job marked "complete" by crew
-- closes out. When TRUE, the owner gets an approval banner on the job detail
-- screen after crew marks the job complete, with options to approve or
-- reject the closure.
ALTER TABLE jobs
  ADD COLUMN IF NOT EXISTS requires_owner_approval BOOLEAN NOT NULL DEFAULT FALSE;
