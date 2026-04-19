-- Service PRO phase 1: seed 3 global templates (tenant_id = NULL, is_template = true)
-- Idempotent — deletes the 3 templates by name first (workflow_statuses
-- cascade), then re-inserts. Tenant clones (is_template = false) are untouched.
-- Pure SQL, no PL/pgSQL DO block, no dollar-quoting — works in Supabase SQL editor.

-- 1) Clean slate for these 3 templates
DELETE FROM service_workflows
WHERE tenant_id IS NULL
  AND is_template = true
  AND name IN (
    'HVAC System Installation',
    'General Install',
    'Service Call'
  );

-- 2) Insert the 3 workflow rows
INSERT INTO service_workflows (tenant_id, name, description, industry, is_template)
VALUES
  (NULL, 'HVAC System Installation',
   'Full HVAC install: site prep, removal, install, test, walkthrough, invoice.',
   'hvac', true),
  (NULL, 'General Install',
   'Generic install flow usable across trades.',
   'general', true),
  (NULL, 'Service Call',
   'Diagnostic + repair visits: dispatch, diagnose, quote, fix, collect payment.',
   'general', true);

-- 3) Insert all workflow_statuses in one statement
--    CTE fetches the 3 fresh workflow ids so we can reference by short name.
WITH tpl AS (
  SELECT
    (SELECT id FROM service_workflows
     WHERE tenant_id IS NULL AND is_template = true
       AND name = 'HVAC System Installation') AS hvac_id,
    (SELECT id FROM service_workflows
     WHERE tenant_id IS NULL AND is_template = true
       AND name = 'General Install') AS general_id,
    (SELECT id FROM service_workflows
     WHERE tenant_id IS NULL AND is_template = true
       AND name = 'Service Call') AS service_id
)
INSERT INTO workflow_statuses
  (workflow_id, order_index, name, color, icon, steps, action_buttons)
-- ========== HVAC ==========
SELECT hvac_id, 1, 'New Job', '#3b82f6', 'clipboard',
  jsonb_build_array(
    jsonb_build_object(
      'order', 1, 'label', 'Confirm equipment list with customer',
      'required', true),
    jsonb_build_object(
      'order', 2, 'label', 'Verify arrival window',
      'required', true),
    jsonb_build_object(
      'order', 3, 'label', 'Confirm parking and access',
      'required', false)
  ),
  jsonb_build_array(
    jsonb_build_object(
      'label', 'Call Customer',
      'action_type', 'call_customer', 'style', 'ghost'),
    jsonb_build_object(
      'label', 'Navigate',
      'action_type', 'navigate', 'style', 'ghost')
  )
FROM tpl
UNION ALL
SELECT hvac_id, 2, 'On the Way', '#ec4899', 'truck',
  jsonb_build_array(
    jsonb_build_object(
      'order', 1, 'label', 'Notify customer of ETA',
      'required', true),
    jsonb_build_object(
      'order', 2, 'label', 'Load required equipment',
      'required', true)
  ),
  jsonb_build_array(
    jsonb_build_object(
      'label', 'Send ETA Text',
      'action_type', 'call_customer', 'style', 'ghost',
      'config', jsonb_build_object(
        'template', 'On my way, ETA 15 minutes')),
    jsonb_build_object(
      'label', 'Navigate',
      'action_type', 'navigate', 'style', 'ghost')
  )
FROM tpl
UNION ALL
SELECT hvac_id, 3, 'In Progress', '#16a34a', 'wrench',
  jsonb_build_array(
    jsonb_build_object(
      'order', 1, 'label', 'Arrive at location',
      'required', true),
    jsonb_build_object(
      'order', 2, 'label', 'Take before photos of existing system',
      'required', true),
    jsonb_build_object(
      'order', 3, 'label', 'Verify existing condition of area/equipment',
      'required', true),
    jsonb_build_object(
      'order', 4, 'label', 'Perform removal of old unit',
      'required', true),
    jsonb_build_object(
      'order', 5, 'label', 'Install new system',
      'required', true),
    jsonb_build_object(
      'order', 6, 'label', 'Test operation and pressures',
      'required', true),
    jsonb_build_object(
      'order', 7, 'label', 'Take after photos',
      'required', true)
  ),
  jsonb_build_array(
    jsonb_build_object(
      'label', 'Open Camera',
      'action_type', 'open_camera', 'style', 'ghost'),
    jsonb_build_object(
      'label', 'Add Note',
      'action_type', 'add_note', 'style', 'ghost'),
    jsonb_build_object(
      'label', 'If Needed, Create PO',
      'action_type', 'create_po', 'style', 'primary_solid')
  )
FROM tpl
UNION ALL
SELECT hvac_id, 4, 'Service Complete', '#0f766e', 'check-circle',
  jsonb_build_array(
    jsonb_build_object(
      'order', 1, 'label', 'Walk customer through new system',
      'required', true),
    jsonb_build_object(
      'order', 2, 'label', 'Collect customer signature',
      'required', true),
    jsonb_build_object(
      'order', 3, 'label', 'Create estimate or final invoice',
      'required', true)
  ),
  jsonb_build_array(
    jsonb_build_object(
      'label', 'Generate Estimate',
      'action_type', 'generate_estimate', 'style', 'primary_solid'),
    jsonb_build_object(
      'label', 'Add Note',
      'action_type', 'add_note', 'style', 'ghost')
  )
FROM tpl
UNION ALL
SELECT hvac_id, 5, 'Invoiced', '#64748b', 'file-check',
  jsonb_build_array(
    jsonb_build_object(
      'order', 1, 'label', 'Invoice sent to customer',
      'required', true)
  ),
  '[]'::jsonb
FROM tpl
-- ========== GENERAL INSTALL ==========
UNION ALL
SELECT general_id, 1, 'Scheduled', '#3b82f6', 'calendar',
  jsonb_build_array(
    jsonb_build_object(
      'order', 1, 'label', 'Confirm scope with customer',
      'required', true),
    jsonb_build_object(
      'order', 2, 'label', 'Confirm arrival window',
      'required', true)
  ),
  jsonb_build_array(
    jsonb_build_object(
      'label', 'Call Customer',
      'action_type', 'call_customer', 'style', 'ghost')
  )
FROM tpl
UNION ALL
SELECT general_id, 2, 'On the Way', '#ec4899', 'truck',
  jsonb_build_array(
    jsonb_build_object(
      'order', 1, 'label', 'Send ETA',
      'required', true),
    jsonb_build_object(
      'order', 2, 'label', 'Confirm materials loaded',
      'required', true)
  ),
  jsonb_build_array(
    jsonb_build_object(
      'label', 'Navigate',
      'action_type', 'navigate', 'style', 'ghost')
  )
FROM tpl
UNION ALL
SELECT general_id, 3, 'In Progress', '#16a34a', 'wrench',
  jsonb_build_array(
    jsonb_build_object(
      'order', 1, 'label', 'Arrive on site',
      'required', true),
    jsonb_build_object(
      'order', 2, 'label', 'Take before photos',
      'required', true),
    jsonb_build_object(
      'order', 3, 'label', 'Install / complete scope',
      'required', true),
    jsonb_build_object(
      'order', 4, 'label', 'Take after photos',
      'required', true)
  ),
  jsonb_build_array(
    jsonb_build_object(
      'label', 'Open Camera',
      'action_type', 'open_camera', 'style', 'ghost'),
    jsonb_build_object(
      'label', 'Add Note',
      'action_type', 'add_note', 'style', 'ghost')
  )
FROM tpl
UNION ALL
SELECT general_id, 4, 'Complete', '#0f766e', 'check-circle',
  jsonb_build_array(
    jsonb_build_object(
      'order', 1, 'label', 'Walk customer through work',
      'required', true),
    jsonb_build_object(
      'order', 2, 'label', 'Collect signature',
      'required', true),
    jsonb_build_object(
      'order', 3, 'label', 'Invoice or estimate created',
      'required', true)
  ),
  jsonb_build_array(
    jsonb_build_object(
      'label', 'Generate Estimate',
      'action_type', 'generate_estimate', 'style', 'primary_solid')
  )
FROM tpl
UNION ALL
SELECT general_id, 5, 'Invoiced', '#64748b', 'file-check',
  jsonb_build_array(
    jsonb_build_object(
      'order', 1, 'label', 'Invoice sent',
      'required', true)
  ),
  '[]'::jsonb
FROM tpl
-- ========== SERVICE CALL ==========
UNION ALL
SELECT service_id, 1, 'Dispatched', '#3b82f6', 'send',
  jsonb_build_array(
    jsonb_build_object(
      'order', 1, 'label', 'Review customer issue',
      'required', true),
    jsonb_build_object(
      'order', 2, 'label', 'Confirm ETA with customer',
      'required', true)
  ),
  jsonb_build_array(
    jsonb_build_object(
      'label', 'Call Customer',
      'action_type', 'call_customer', 'style', 'ghost'),
    jsonb_build_object(
      'label', 'Navigate',
      'action_type', 'navigate', 'style', 'ghost')
  )
FROM tpl
UNION ALL
SELECT service_id, 2, 'On Site', '#ec4899', 'map-pin',
  jsonb_build_array(
    jsonb_build_object(
      'order', 1, 'label', 'Arrive and greet customer',
      'required', true),
    jsonb_build_object(
      'order', 2, 'label', 'Take photo of reported issue',
      'required', true)
  ),
  jsonb_build_array(
    jsonb_build_object(
      'label', 'Open Camera',
      'action_type', 'open_camera', 'style', 'ghost')
  )
FROM tpl
UNION ALL
SELECT service_id, 3, 'Diagnosing', '#f59e0b', 'search',
  jsonb_build_array(
    jsonb_build_object(
      'order', 1, 'label', 'Run diagnostic checks',
      'required', true),
    jsonb_build_object(
      'order', 2, 'label', 'Document findings',
      'required', true),
    jsonb_build_object(
      'order', 3, 'label', 'Present options to customer',
      'required', true)
  ),
  jsonb_build_array(
    jsonb_build_object(
      'label', 'Add Note',
      'action_type', 'add_note', 'style', 'ghost'),
    jsonb_build_object(
      'label', 'Generate Estimate',
      'action_type', 'generate_estimate', 'style', 'primary_solid')
  )
FROM tpl
UNION ALL
SELECT service_id, 4, 'Repairing', '#16a34a', 'wrench',
  jsonb_build_array(
    jsonb_build_object(
      'order', 1, 'label', 'Complete approved repair',
      'required', true),
    jsonb_build_object(
      'order', 2, 'label', 'Test fix',
      'required', true),
    jsonb_build_object(
      'order', 3, 'label', 'Take after photos',
      'required', true)
  ),
  jsonb_build_array(
    jsonb_build_object(
      'label', 'Open Camera',
      'action_type', 'open_camera', 'style', 'ghost'),
    jsonb_build_object(
      'label', 'If Needed, Create PO',
      'action_type', 'create_po', 'style', 'ghost')
  )
FROM tpl
UNION ALL
SELECT service_id, 5, 'Paid', '#0f766e', 'dollar-sign',
  jsonb_build_array(
    jsonb_build_object(
      'order', 1, 'label', 'Collect payment or send invoice',
      'required', true),
    jsonb_build_object(
      'order', 2, 'label', 'Customer signature collected',
      'required', true)
  ),
  '[]'::jsonb
FROM tpl;
