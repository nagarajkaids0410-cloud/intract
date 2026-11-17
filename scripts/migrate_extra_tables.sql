-- ====================================================================
-- SURYAS MiB ENTERPRISES - EXTRA TABLES & DATA MIGRATION
-- Tasks, Circulars, Audit Logs, Company Ledger, Guest Inquiries, Events
-- ====================================================================

-- ==================== TABLE DEFINITIONS ====================

CREATE TABLE IF NOT EXISTS public.tasks (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  deadline TEXT,
  status TEXT NOT NULL DEFAULT 'not_started',
  progress INTEGER DEFAULT 0,
  assigned_to_id TEXT,
  assigned_to_name TEXT,
  assigned_to_username TEXT,
  assigned_by_id TEXT,
  assigned_by_name TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  comments JSONB DEFAULT '[]'::jsonb
);

CREATE TABLE IF NOT EXISTS public.circulars (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  posted_by TEXT NOT NULL,
  posted_by_role TEXT,
  posted_at TIMESTAMPTZ DEFAULT NOW(),
  recipients JSONB DEFAULT '["all"]'::jsonb,
  priority TEXT DEFAULT 'medium',
  meta JSONB DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS public.audit_logs (
  id TEXT PRIMARY KEY,
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  action TEXT NOT NULL,
  actor TEXT NOT NULL,
  actor_id TEXT,
  details JSONB DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS public.company_ledger (
  id TEXT PRIMARY KEY DEFAULT 'primary',
  balance NUMERIC DEFAULT 0,
  transactions JSONB DEFAULT '[]'::jsonb,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.guest_inquiries (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT,
  purpose TEXT,
  department TEXT,
  target_user TEXT,
  message TEXT,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  meta JSONB DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS public.events (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ,
  location TEXT,
  created_by TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  meta JSONB DEFAULT '{}'::jsonb
);

CREATE INDEX IF NOT EXISTS idx_tasks_assigned_to ON public.tasks(assigned_to_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_timestamp ON public.audit_logs(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_audit_logs_actor ON public.audit_logs(actor);
CREATE INDEX IF NOT EXISTS idx_circulars_posted_at ON public.circulars(posted_at DESC);

-- ==================== TASKS (3 records) ====================
INSERT INTO public.tasks (
  id, title, description, deadline, status, progress,
  assigned_to_id, assigned_to_name, assigned_to_username,
  assigned_by_id, assigned_by_name, created_at, updated_at, comments
) VALUES (
  '45d3a6cf-4a2d-4c59-8b68-48ec194311d6', 'Projects', 'Follow up the Mini Project and Projects Upto50.', '2026-10-19', 'in_progress', 30,
  'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'SABIR MOHAMMED S', 'sabir',
  'founder-001', 'GOLLA KUMAR BHARATH', '2026-10-18T07:08:48.485Z'::timestamptz, '2026-10-18T07:09:17.995Z'::timestamptz, '[]'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  progress = EXCLUDED.progress,
  updated_at = EXCLUDED.updated_at,
  comments = EXCLUDED.comments;

INSERT INTO public.tasks (
  id, title, description, deadline, status, progress,
  assigned_to_id, assigned_to_name, assigned_to_username,
  assigned_by_id, assigned_by_name, created_at, updated_at, comments
) VALUES (
  'c2aef7d9-3af9-4c7e-a7e3-16270086bb9e', 'PCB Layout', 'Shared Circuit PCB Layout is Done?', '2026-10-19', 'not_started', 0,
  'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'VISHNU VARSHINI M', 'vishnuu',
  'founder-001', 'GOLLA KUMAR BHARATH', '2026-10-18T06:54:01.499Z'::timestamptz, '2026-10-18T06:54:01.499Z'::timestamptz, '[]'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  progress = EXCLUDED.progress,
  updated_at = EXCLUDED.updated_at,
  comments = EXCLUDED.comments;

INSERT INTO public.tasks (
  id, title, description, deadline, status, progress,
  assigned_to_id, assigned_to_name, assigned_to_username,
  assigned_by_id, assigned_by_name, created_at, updated_at, comments
) VALUES (
  'a225dd6d-a25c-49f8-b35a-38cb47148736', 'Hi, Monday 26-10-2026 R&D WORKS STRAT', 'Follow up the activates', '2026-10-18', 'not_started', 0,
  'user-003', 'SANTHANA KUMAR V', 'santhanakumarv',
  'user-002', 'HAREESH V', '2026-10-18T06:36:57.685Z'::timestamptz, '2026-10-18T06:54:11.006Z'::timestamptz, '[]'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  progress = EXCLUDED.progress,
  updated_at = EXCLUDED.updated_at,
  comments = EXCLUDED.comments;


-- ==================== CIRCULARS (1 record) ====================
INSERT INTO public.circulars (
  id, title, content, posted_by, posted_by_role, posted_at, recipients, priority, meta
) VALUES (
  'circular-9dd24afa-e673-4666-947d-bb8e598b36ed', 'Hi', 'Hi', 'gkbharath', 'founder', '2026-10-18T06:47:00.907Z'::timestamptz, '["all"]'::jsonb, 'medium', '{"date": "2026-10-18", "time": "", "category": "Notice"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  priority = EXCLUDED.priority,
  meta = EXCLUDED.meta;


-- ==================== COMPANY LEDGER ====================
INSERT INTO public.company_ledger (
  id, balance, transactions, updated_at
) VALUES (
  'primary', 0, '[]'::jsonb, NOW()
) ON CONFLICT (id) DO UPDATE SET
  balance = EXCLUDED.balance,
  transactions = EXCLUDED.transactions,
  updated_at = NOW();


-- ==================== AUDIT LOGS (255 records) ====================
INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792307635711-255', '2026-10-18T07:13:55.711Z'::timestamptz, 'request:guide-recommendation', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"requestId": "6823", "nextApprover": "hareeshv", "remarks": "Recommend"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792307635578-568', '2026-10-18T07:13:55.578Z'::timestamptz, 'request:forwarded', 'hareeshv', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', '{"id": "6823", "updates": {"payload": {"name": "VISHNU VARSHINI M", "id": "MIB05", "designation": "PCB & EMS/IoT Designer-T", "department": "PCB Designs & Fabrication Team", "email": "pcb.designers@suryas.in", "phone": "6380551370", "leaveType": "medical", "fromDate": "2026-10-12", "toDate": "2026-10-13", "reason": "Medical leave", "remarks": "As I am diagnosed with dengue, doctors have advised 3 days bed test and blood test on daily basis to monitor platelets count and I have been prescribed with heavy doses of tablets for recovery. On account of this I am applying medical leave on 12.10.2026 and 13.10.2026(Monday & Tuesday).", "isPastDateRequest": true, "filledFormFileName": "IMG_20261011_203454.jpg", "medicalDocument": {"name": "IMG_20261011_203401.jpg", "size": 5625470, "type": "image/jpeg", "base64": "[FILE_STRIPPED]", "uploadedAt": "2026-10-18T07:11:30.811Z"}, "submittedAt": "2026-10-18T07:11:30.811Z", "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "sabir", "comment": "Recommend", "decision": "recommend", "stageIndex": 0, "at": "2026-10-18T07:13:55.437Z"}]}, "forwardedTo": "hareeshv"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792307515434-127', '2026-10-18T07:11:55.434Z'::timestamptz, 'request:created', 'VISHNU VARSHINI M', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', '{"id": "6823", "type": "leave", "title": "Past-Date Medical Leave Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792307390876-660', '2026-10-18T07:09:50.876Z'::timestamptz, 'attendance:report-submitted', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"requestId": "9475", "fromDate": "2026-10-17", "toDate": "2026-10-17", "daysRecorded": 0}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792307390861-66', '2026-10-18T07:09:50.861Z'::timestamptz, 'request:created', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "9475", "type": "attendance-report", "title": "Attendance report: 2026-10-17 to 2026-10-17"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792307358001-479', '2026-10-18T07:09:18.001Z'::timestamptz, 'task:updated', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"taskId": "45d3a6cf-4a2d-4c59-8b68-48ec194311d6", "progress": 30, "hasComment": false}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792307357917-212', '2026-10-18T07:09:17.917Z'::timestamptz, 'task:updated', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"taskId": "45d3a6cf-4a2d-4c59-8b68-48ec194311d6", "progress": 30, "hasComment": false}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792307357845-725', '2026-10-18T07:09:17.845Z'::timestamptz, 'task:updated', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"taskId": "45d3a6cf-4a2d-4c59-8b68-48ec194311d6", "progress": 25, "hasComment": false}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792307357784-321', '2026-10-18T07:09:17.784Z'::timestamptz, 'task:updated', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"taskId": "45d3a6cf-4a2d-4c59-8b68-48ec194311d6", "progress": 25, "hasComment": false}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792307357718-783', '2026-10-18T07:09:17.718Z'::timestamptz, 'task:updated', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"taskId": "45d3a6cf-4a2d-4c59-8b68-48ec194311d6", "progress": 20, "hasComment": false}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792307357649-456', '2026-10-18T07:09:17.649Z'::timestamptz, 'task:updated', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"taskId": "45d3a6cf-4a2d-4c59-8b68-48ec194311d6", "progress": 30, "hasComment": false}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792307357520-575', '2026-10-18T07:09:17.520Z'::timestamptz, 'task:updated', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"taskId": "45d3a6cf-4a2d-4c59-8b68-48ec194311d6", "progress": 25, "hasComment": false}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792307357425-491', '2026-10-18T07:09:17.425Z'::timestamptz, 'task:updated', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"taskId": "45d3a6cf-4a2d-4c59-8b68-48ec194311d6", "progress": 20, "hasComment": false}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792307357346-210', '2026-10-18T07:09:17.346Z'::timestamptz, 'task:updated', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"taskId": "45d3a6cf-4a2d-4c59-8b68-48ec194311d6", "progress": 20, "hasComment": false}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792307357197-74', '2026-10-18T07:09:17.197Z'::timestamptz, 'task:updated', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"taskId": "45d3a6cf-4a2d-4c59-8b68-48ec194311d6", "progress": 15, "hasComment": false}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792307357130-877', '2026-10-18T07:09:17.130Z'::timestamptz, 'task:updated', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"taskId": "45d3a6cf-4a2d-4c59-8b68-48ec194311d6", "progress": 15, "hasComment": false}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792307357054-994', '2026-10-18T07:09:17.054Z'::timestamptz, 'task:updated', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"taskId": "45d3a6cf-4a2d-4c59-8b68-48ec194311d6", "progress": 10, "hasComment": false}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792307356975-63', '2026-10-18T07:09:16.975Z'::timestamptz, 'task:updated', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"taskId": "45d3a6cf-4a2d-4c59-8b68-48ec194311d6", "progress": 5, "hasComment": false}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792307356891-314', '2026-10-18T07:09:16.891Z'::timestamptz, 'task:updated', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"taskId": "45d3a6cf-4a2d-4c59-8b68-48ec194311d6", "progress": 10, "hasComment": false}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792307356763-214', '2026-10-18T07:09:16.763Z'::timestamptz, 'task:updated', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"taskId": "45d3a6cf-4a2d-4c59-8b68-48ec194311d6", "progress": 5, "hasComment": false}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792307351064-309', '2026-10-18T07:09:11.064Z'::timestamptz, 'task:updated', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"taskId": "45d3a6cf-4a2d-4c59-8b68-48ec194311d6", "status": "in_progress", "hasComment": false}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792307328492-928', '2026-10-18T07:08:48.492Z'::timestamptz, 'task:created', 'gkbharath', 'founder-001', '{"taskId": "45d3a6cf-4a2d-4c59-8b68-48ec194311d6", "assignedToId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "deadline": "2026-10-19"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792307259092-338', '2026-10-18T07:07:39.092Z'::timestamptz, 'request:created', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "4906", "type": "leave", "title": "Past-Date Casual Leave Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792307211119-936', '2026-10-18T07:06:51.119Z'::timestamptz, 'request:created', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "8222", "type": "ta", "title": "Allowance Claim Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792307077208-437', '2026-10-18T07:04:37.208Z'::timestamptz, 'auth:password_changed', 'vishnuu', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', '{"userId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792306946939-873', '2026-10-18T07:02:26.939Z'::timestamptz, 'auth:admin_password_reset', 'gkbharath', 'founder-001', '{"targetEmployeeId": "MIB05", "targetUsername": "vishnuu", "mustChangePassword": true}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792306569497-184', '2026-10-18T06:56:09.497Z'::timestamptz, 'request:created', 'GOLLA KUMAR BHARATH', 'founder-001', '{"id": "2063", "type": "leave", "title": "Past-Date Casual Leave Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792306451013-118', '2026-10-18T06:54:11.013Z'::timestamptz, 'task:reassigned', 'gkbharath', 'founder-001', '{"taskId": "a225dd6d-a25c-49f8-b35a-38cb47148736", "previousAssigneeId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "assignedToId": "user-003"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792306441514-428', '2026-10-18T06:54:01.514Z'::timestamptz, 'task:created', 'gkbharath', 'founder-001', '{"taskId": "c2aef7d9-3af9-4c7e-a7e3-16270086bb9e", "assignedToId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3", "deadline": "2026-10-19"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792305827010-337', '2026-10-18T06:43:47.010Z'::timestamptz, 'request:approve', 'santhanakumarv', 'user-003', '{"requestId": "1115", "remarks": "Approved"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792305827002-896', '2026-10-18T06:43:47.002Z'::timestamptz, 'request:approved', 'GOLLA KUMAR BHARATH', 'founder-001', '{"id": "1115", "updates": {"payload": {"name": "GOLLA KUMAR BHARATH", "id": "MIB01", "designation": "Founder & Chief Executive Partner", "department": "Executive Management Team", "email": "gollakumarbharath@suryas.in", "phone": "", "leaveType": "casual", "fromDate": "2026-10-10", "toDate": "2026-10-10", "reason": "Casual Leave", "remarks": "Casual Leave", "isPastDateRequest": true, "filledFormFileName": "", "submittedAt": "2026-10-18T06:41:04.465Z", "approvalChain": ["hareeshv", "santhanakumarv"], "currentApproverIndex": 1, "comments": [{"by": "santhanakumarv", "comment": "Approved", "decision": "approve", "stageIndex": 1, "at": "2026-10-18T06:43:46.993Z"}, {"by": "hareeshv", "comment": "Approve.", "decision": "approve", "stageIndex": 0, "at": "2026-10-18T06:41:55.452Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792305715489-674', '2026-10-18T06:41:55.489Z'::timestamptz, 'request:forward', 'hareeshv', 'user-002', '{"requestId": "1115", "from": "hareeshv", "to": "santhanakumarv", "remarks": "Approve."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792305715472-947', '2026-10-18T06:41:55.472Z'::timestamptz, 'request:forwarded', 'santhanakumarv', 'founder-001', '{"id": "1115", "updates": {"payload": {"name": "GOLLA KUMAR BHARATH", "id": "MIB01", "designation": "Founder & Chief Executive Partner", "department": "Executive Management Team", "email": "gollakumarbharath@suryas.in", "phone": "", "leaveType": "casual", "fromDate": "2026-10-10", "toDate": "2026-10-10", "reason": "Casual Leave", "remarks": "Casual Leave", "isPastDateRequest": true, "filledFormFileName": "", "submittedAt": "2026-10-18T06:41:04.465Z", "approvalChain": ["hareeshv", "santhanakumarv"], "currentApproverIndex": 1, "comments": [{"by": "hareeshv", "comment": "Approve.", "decision": "approve", "stageIndex": 0, "at": "2026-10-18T06:41:55.452Z"}]}, "forwardedTo": "santhanakumarv"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792305664633-882', '2026-10-18T06:41:04.633Z'::timestamptz, 'request:created', 'GOLLA KUMAR BHARATH', 'founder-001', '{"id": "1115", "type": "leave", "title": "Past-Date Casual Leave Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792305628152-892', '2026-10-18T06:40:28.152Z'::timestamptz, 'request:reject', 'gkbharath', 'founder-001', '{"requestId": "1539", "remarks": "Due to No Medical Certificate."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792305628144-647', '2026-10-18T06:40:28.144Z'::timestamptz, 'request:rejected', 'SANTHANA KUMAR V', 'user-003', '{"id": "1539", "updates": {"payload": {"name": "SANTHANA KUMAR V", "id": "MIB03", "designation": "Managing Partner - Operations & Business Development", "department": "Executive Management Team", "email": "santhanakumarv@suryas.in", "phone": "7010353723", "leaveType": "casual", "fromDate": "2026-10-19", "toDate": "2026-10-19", "reason": "Medical leave", "remarks": "Pooja holiday", "isPastDateRequest": false, "filledFormFileName": "", "submittedAt": "2026-10-18T06:33:18.853Z", "approvalChain": ["hareeshv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "gkbharath", "comment": "Due to No Medical Certificate.", "decision": "reject", "stageIndex": 1, "at": "2026-10-18T06:40:28.131Z"}, {"by": "hareeshv", "comment": "Approved.", "decision": "approve", "stageIndex": 0, "at": "2026-10-18T06:34:10.306Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792305469550-924', '2026-10-18T06:37:49.550Z'::timestamptz, 'task:reassigned', 'hareeshv', 'user-002', '{"taskId": "a225dd6d-a25c-49f8-b35a-38cb47148736", "previousAssigneeId": "user-003", "assignedToId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792305417692-102', '2026-10-18T06:36:57.693Z'::timestamptz, 'task:created', 'hareeshv', 'user-002', '{"taskId": "a225dd6d-a25c-49f8-b35a-38cb47148736", "assignedToId": "user-003", "deadline": "2026-10-18"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792305250342-779', '2026-10-18T06:34:10.342Z'::timestamptz, 'request:forward', 'hareeshv', 'user-002', '{"requestId": "1539", "from": "hareeshv", "to": "gkbharath", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792305250326-309', '2026-10-18T06:34:10.326Z'::timestamptz, 'request:forwarded', 'gkbharath', 'user-003', '{"id": "1539", "updates": {"payload": {"name": "SANTHANA KUMAR V", "id": "MIB03", "designation": "Managing Partner - Operations & Business Development", "department": "Executive Management Team", "email": "santhanakumarv@suryas.in", "phone": "7010353723", "leaveType": "casual", "fromDate": "2026-10-19", "toDate": "2026-10-19", "reason": "Medical leave", "remarks": "Pooja holiday", "isPastDateRequest": false, "filledFormFileName": "", "submittedAt": "2026-10-18T06:33:18.853Z", "approvalChain": ["hareeshv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "hareeshv", "comment": "Approved.", "decision": "approve", "stageIndex": 0, "at": "2026-10-18T06:34:10.306Z"}]}, "forwardedTo": "gkbharath"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792305200590-904', '2026-10-18T06:33:20.590Z'::timestamptz, 'request:created', 'SANTHANA KUMAR V', 'user-003', '{"id": "1539", "type": "leave", "title": "Casual Leave Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792304982015-251', '2026-10-18T06:29:42.015Z'::timestamptz, 'request:reject', 'santhanakumarv', 'user-003', '{"requestId": "7063", "remarks": "Date?"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792304982006-979', '2026-10-18T06:29:42.006Z'::timestamptz, 'request:rejected', 'HAREESH V', 'user-002', '{"id": "7063", "updates": {"payload": {"name": "HAREESH V", "id": "MIB02", "designation": "Managing Partner - Projects & Administration", "department": "Executive Management Team", "email": "hareeshv@suryas.in", "phone": "8124227370", "leaveType": "casual", "fromDate": "2026-10-10", "toDate": "2026-10-10", "reason": "Casual Leave", "remarks": "Request to Approve.", "isPastDateRequest": true, "filledFormFileName": "", "submittedAt": "2026-10-18T06:26:41.064Z", "approvalChain": ["santhanakumarv", "gkbharath"], "currentApproverIndex": 0, "comments": [{"by": "santhanakumarv", "comment": "Date?", "decision": "reject", "stageIndex": 0, "at": "2026-10-18T06:29:41.996Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792304960694-535', '2026-10-18T06:29:20.694Z'::timestamptz, 'internal-request:created', 'HAREESH V', 'user-002', '{"id": "2894", "description": "Hi Santhana Kumar V, "}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792304960682-179', '2026-10-18T06:29:20.682Z'::timestamptz, 'request:created', 'HAREESH V', 'user-002', '{"id": "2894", "type": "internal-service", "title": "Internal Service Request from HAREESH V"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792304958101-13', '2026-10-18T06:29:18.101Z'::timestamptz, 'request:reject', 'santhanakumarv', 'user-003', '{"requestId": "8393", "remarks": "Due to no bills rejected"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792304958094-531', '2026-10-18T06:29:18.094Z'::timestamptz, 'request:rejected', 'HAREESH V', 'user-002', '{"id": "8393", "updates": {"payload": {"name": "HAREESH V", "id": "MIB02", "designation": "Managing Partner - Projects & Administration", "department": "Executive Management Team", "email": "hareeshv@suryas.in", "claimType": "expenses", "amount": "1500", "description": "RSR Gummdipoondi to Nellore, Petrol Bill Summited to Auditor. ", "remarks": "Request to Approve.", "filledFormFileName": "", "billFileName": "", "submittedAt": "2026-10-18T06:28:41.316Z", "approvalChain": ["santhanakumarv", "gkbharath"], "currentApproverIndex": 0, "comments": [{"by": "santhanakumarv", "comment": "Due to no bills rejected", "decision": "reject", "stageIndex": 0, "at": "2026-10-18T06:29:18.087Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792304921464-397', '2026-10-18T06:28:41.464Z'::timestamptz, 'request:created', 'HAREESH V', 'user-002', '{"id": "8393", "type": "ta", "title": "Allowance Claim Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792304801272-733', '2026-10-18T06:26:41.272Z'::timestamptz, 'request:created', 'HAREESH V', 'user-002', '{"id": "7063", "type": "leave", "title": "Past-Date Casual Leave Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792298031183-802', '2026-10-18T04:33:51.183Z'::timestamptz, 'user:updated', 'gkbharath', 'founder-001', '{"targetUserId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3", "updatedFields": ["guideId"]}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792297978627-427', '2026-10-18T04:32:58.627Z'::timestamptz, 'request:approve', 'gkbharath', 'founder-001', '{"requestId": "5018", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792297978620-844', '2026-10-18T04:32:58.620Z'::timestamptz, 'request:approved', 'MATHIYAZHAGAN D', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', '{"id": "5018", "updates": {"payload": {"name": "MATHIYAZHAGAN D", "id": "MIB06", "designation": "Not Set", "department": "", "email": "mathiyazhagandhanapalmathiyazh@gmail.com", "phone": "", "leaveType": "casual", "fromDate": "2026-10-17", "toDate": "2026-10-17", "reason": "Casual Leave.", "remarks": "Casual Leave.", "isPastDateRequest": true, "filledFormFileName": "", "submittedAt": "2026-10-18T04:09:52.028Z", "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "comments": [{"by": "gkbharath", "comment": "Approved.", "decision": "approve", "stageIndex": 3, "at": "2026-10-18T04:32:58.613Z"}, {"by": "santhanakumarv", "comment": "Approved.", "decision": "approve", "stageIndex": 2, "at": "2026-10-18T04:32:30.999Z"}, {"by": "hareeshv", "comment": "Approved.", "decision": "approve", "stageIndex": 1, "at": "2026-10-18T04:31:02.315Z"}, {"by": "sabir", "comment": "Forward to Approval", "decision": "recommend", "stageIndex": 0, "at": "2026-10-18T04:30:01.268Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792297951011-250', '2026-10-18T04:32:31.011Z'::timestamptz, 'request:forward', 'santhanakumarv', 'user-003', '{"requestId": "5018", "from": "santhanakumarv", "to": "gkbharath", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792297951006-46', '2026-10-18T04:32:31.006Z'::timestamptz, 'request:forwarded', 'gkbharath', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', '{"id": "5018", "updates": {"payload": {"name": "MATHIYAZHAGAN D", "id": "MIB06", "designation": "Not Set", "department": "", "email": "mathiyazhagandhanapalmathiyazh@gmail.com", "phone": "", "leaveType": "casual", "fromDate": "2026-10-17", "toDate": "2026-10-17", "reason": "Casual Leave.", "remarks": "Casual Leave.", "isPastDateRequest": true, "filledFormFileName": "", "submittedAt": "2026-10-18T04:09:52.028Z", "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "comments": [{"by": "santhanakumarv", "comment": "Approved.", "decision": "approve", "stageIndex": 2, "at": "2026-10-18T04:32:30.999Z"}, {"by": "hareeshv", "comment": "Approved.", "decision": "approve", "stageIndex": 1, "at": "2026-10-18T04:31:02.315Z"}, {"by": "sabir", "comment": "Forward to Approval", "decision": "recommend", "stageIndex": 0, "at": "2026-10-18T04:30:01.268Z"}]}, "forwardedTo": "gkbharath"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792297862331-781', '2026-10-18T04:31:02.331Z'::timestamptz, 'request:forward', 'hareeshv', 'user-002', '{"requestId": "5018", "from": "hareeshv", "to": "santhanakumarv", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792297862324-369', '2026-10-18T04:31:02.324Z'::timestamptz, 'request:forwarded', 'santhanakumarv', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', '{"id": "5018", "updates": {"payload": {"name": "MATHIYAZHAGAN D", "id": "MIB06", "designation": "Not Set", "department": "", "email": "mathiyazhagandhanapalmathiyazh@gmail.com", "phone": "", "leaveType": "casual", "fromDate": "2026-10-17", "toDate": "2026-10-17", "reason": "Casual Leave.", "remarks": "Casual Leave.", "isPastDateRequest": true, "filledFormFileName": "", "submittedAt": "2026-10-18T04:09:52.028Z", "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "hareeshv", "comment": "Approved.", "decision": "approve", "stageIndex": 1, "at": "2026-10-18T04:31:02.315Z"}, {"by": "sabir", "comment": "Forward to Approval", "decision": "recommend", "stageIndex": 0, "at": "2026-10-18T04:30:01.268Z"}]}, "forwardedTo": "santhanakumarv"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792297856942-728', '2026-10-18T04:30:56.942Z'::timestamptz, 'request:reject', 'hareeshv', 'user-002', '{"requestId": "3203", "remarks": "2 Time Application."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792297856938-673', '2026-10-18T04:30:56.938Z'::timestamptz, 'request:rejected', 'MATHIYAZHAGAN D', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', '{"id": "3203", "updates": {"payload": {"name": "MATHIYAZHAGAN D", "id": "MIB06", "designation": "Not Set", "department": "", "email": "mathiyazhagandhanapalmathiyazh@gmail.com", "phone": "", "leaveType": "casual", "fromDate": "2026-10-17", "toDate": "2026-10-17", "reason": "Casual Leave", "remarks": "Casual Leave", "isPastDateRequest": true, "filledFormFileName": "", "submittedAt": "2026-10-18T04:26:32.070Z", "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "hareeshv", "comment": "2 Time Application.", "decision": "reject", "stageIndex": 1, "at": "2026-10-18T04:30:56.932Z"}, {"by": "sabir", "comment": "Doble Time Request to Rejected.", "decision": "recommend", "stageIndex": 0, "at": "2026-10-18T04:29:47.356Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792297801282-266', '2026-10-18T04:30:01.282Z'::timestamptz, 'request:guide-recommendation', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"requestId": "5018", "nextApprover": "hareeshv", "remarks": "Forward to Approval"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792297801275-979', '2026-10-18T04:30:01.276Z'::timestamptz, 'request:forwarded', 'hareeshv', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', '{"id": "5018", "updates": {"payload": {"name": "MATHIYAZHAGAN D", "id": "MIB06", "designation": "Not Set", "department": "", "email": "mathiyazhagandhanapalmathiyazh@gmail.com", "phone": "", "leaveType": "casual", "fromDate": "2026-10-17", "toDate": "2026-10-17", "reason": "Casual Leave.", "remarks": "Casual Leave.", "isPastDateRequest": true, "filledFormFileName": "", "submittedAt": "2026-10-18T04:09:52.028Z", "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "sabir", "comment": "Forward to Approval", "decision": "recommend", "stageIndex": 0, "at": "2026-10-18T04:30:01.268Z"}]}, "forwardedTo": "hareeshv"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792297787375-94', '2026-10-18T04:29:47.375Z'::timestamptz, 'request:guide-recommendation', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"requestId": "3203", "nextApprover": "hareeshv", "remarks": "Doble Time Request to Rejected."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792297787369-257', '2026-10-18T04:29:47.369Z'::timestamptz, 'request:forwarded', 'hareeshv', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', '{"id": "3203", "updates": {"payload": {"name": "MATHIYAZHAGAN D", "id": "MIB06", "designation": "Not Set", "department": "", "email": "mathiyazhagandhanapalmathiyazh@gmail.com", "phone": "", "leaveType": "casual", "fromDate": "2026-10-17", "toDate": "2026-10-17", "reason": "Casual Leave", "remarks": "Casual Leave", "isPastDateRequest": true, "filledFormFileName": "", "submittedAt": "2026-10-18T04:26:32.070Z", "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "sabir", "comment": "Doble Time Request to Rejected.", "decision": "recommend", "stageIndex": 0, "at": "2026-10-18T04:29:47.356Z"}]}, "forwardedTo": "hareeshv"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792297592126-113', '2026-10-18T04:26:32.126Z'::timestamptz, 'request:created', 'MATHIYAZHAGAN D', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', '{"id": "3203", "type": "leave", "title": "Past-Date Casual Leave Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792296592181-398', '2026-10-18T04:09:52.181Z'::timestamptz, 'request:created', 'MATHIYAZHAGAN D', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', '{"id": "5018", "type": "leave", "title": "Past-Date Casual Leave Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792296452420-193', '2026-10-18T04:07:32.420Z'::timestamptz, 'registration:approved', 'gkbharath', 'founder-001', '{"userId": "SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01", "stage": 2, "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792296381537-562', '2026-10-18T04:06:21.537Z'::timestamptz, 'registration:forwarded', 'santhanakumarv', 'user-003', '{"userId": "SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01", "stage": 1, "nextApprover": "gkbharath", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792296343229-393', '2026-10-18T04:05:43.229Z'::timestamptz, 'registration:forwarded', 'hareeshv', 'user-002', '{"userId": "SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01", "stage": 0, "nextApprover": "santhanakumarv", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792296172326-697', '2026-10-18T04:02:52.326Z'::timestamptz, 'request:approve', 'gkbharath', 'founder-001', '{"requestId": "7985", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792296172317-844', '2026-10-18T04:02:52.317Z'::timestamptz, 'request:approved', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "7985", "updates": {"payload": {"fromDate": "2026-10-17", "toDate": "2026-10-17", "remarks": "Task Completed.", "daysRecorded": 0, "attendance": [], "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "gkbharath", "comment": "Approved.", "decision": "approve", "stageIndex": 2, "at": "2026-10-18T04:02:52.307Z"}, {"by": "santhanakumarv", "comment": "Approved.", "decision": "approve", "stageIndex": 1, "at": "2026-10-18T04:00:19.661Z"}, {"by": "hareeshv", "comment": "Approved.", "decision": "approve", "stageIndex": 0, "at": "2026-10-18T03:59:03.568Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792296019678-176', '2026-10-18T04:00:19.678Z'::timestamptz, 'request:forward', 'santhanakumarv', 'user-003', '{"requestId": "7985", "from": "santhanakumarv", "to": "gkbharath", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792296019669-380', '2026-10-18T04:00:19.669Z'::timestamptz, 'request:forwarded', 'gkbharath', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "7985", "updates": {"payload": {"fromDate": "2026-10-17", "toDate": "2026-10-17", "remarks": "Task Completed.", "daysRecorded": 0, "attendance": [], "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "santhanakumarv", "comment": "Approved.", "decision": "approve", "stageIndex": 1, "at": "2026-10-18T04:00:19.661Z"}, {"by": "hareeshv", "comment": "Approved.", "decision": "approve", "stageIndex": 0, "at": "2026-10-18T03:59:03.568Z"}]}, "forwardedTo": "gkbharath"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792296014365-933', '2026-10-18T04:00:14.365Z'::timestamptz, 'request:forward', 'santhanakumarv', 'user-003', '{"requestId": "5264", "from": "santhanakumarv", "to": "gkbharath", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792296014357-109', '2026-10-18T04:00:14.357Z'::timestamptz, 'request:forwarded', 'gkbharath', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "5264", "updates": {"payload": {"purpose": "Project Technician and Project Coordinator Removed and Changed us PCB Fab engineer.", "remarks": "Project Technician and Project Coordinator Removed and Changed us PCB Fab engineer.", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "santhanakumarv", "comment": "Approved.", "decision": "approve", "stageIndex": 1, "at": "2026-10-18T04:00:14.347Z"}, {"by": "hareeshv", "comment": "Approved.", "decision": "approve", "stageIndex": 0, "at": "2026-10-18T03:58:57.050Z"}]}, "forwardedTo": "gkbharath"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792295943589-380', '2026-10-18T03:59:03.589Z'::timestamptz, 'request:forward', 'hareeshv', 'user-002', '{"requestId": "7985", "from": "hareeshv", "to": "santhanakumarv", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792295943579-53', '2026-10-18T03:59:03.579Z'::timestamptz, 'request:forwarded', 'santhanakumarv', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "7985", "updates": {"payload": {"fromDate": "2026-10-17", "toDate": "2026-10-17", "remarks": "Task Completed.", "daysRecorded": 0, "attendance": [], "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "hareeshv", "comment": "Approved.", "decision": "approve", "stageIndex": 0, "at": "2026-10-18T03:59:03.568Z"}]}, "forwardedTo": "santhanakumarv"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792295937071-278', '2026-10-18T03:58:57.071Z'::timestamptz, 'request:forward', 'hareeshv', 'user-002', '{"requestId": "5264", "from": "hareeshv", "to": "santhanakumarv", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792295937063-132', '2026-10-18T03:58:57.063Z'::timestamptz, 'request:forwarded', 'santhanakumarv', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "5264", "updates": {"payload": {"purpose": "Project Technician and Project Coordinator Removed and Changed us PCB Fab engineer.", "remarks": "Project Technician and Project Coordinator Removed and Changed us PCB Fab engineer.", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "hareeshv", "comment": "Approved.", "decision": "approve", "stageIndex": 0, "at": "2026-10-18T03:58:57.050Z"}]}, "forwardedTo": "santhanakumarv"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792295864515-750', '2026-10-18T03:57:44.515Z'::timestamptz, 'request:created', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "5264", "type": "relieving", "title": "Relieving letter request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792295762299-453', '2026-10-18T03:56:02.299Z'::timestamptz, 'attendance:report-submitted', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"requestId": "7985", "fromDate": "2026-10-17", "toDate": "2026-10-17", "daysRecorded": 0}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792295762285-903', '2026-10-18T03:56:02.285Z'::timestamptz, 'request:created', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "7985", "type": "attendance-report", "title": "Attendance report: 2026-10-17 to 2026-10-17"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792258310783-127', '2026-10-17T17:31:50.783Z'::timestamptz, 'auth:password_changed', 'vishnuu', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', '{"userId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792258265317-83', '2026-10-17T17:31:05.317Z'::timestamptz, 'auth:admin_password_reset', 'gkbharath', 'founder-001', '{"targetEmployeeId": "MIB05", "targetUsername": "vishnuu", "mustChangePassword": true}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792258039235-481', '2026-10-17T17:27:19.235Z'::timestamptz, 'user:updated', 'gkbharath', 'founder-001', '{"targetUserId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3", "updatedFields": ["status"]}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792258037309-71', '2026-10-17T17:27:17.309Z'::timestamptz, 'user:updated', 'gkbharath', 'founder-001', '{"targetUserId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3", "updatedFields": ["status"]}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792256168478-891', '2026-10-17T16:56:08.478Z'::timestamptz, 'request:reject', 'gkbharath', 'founder-001', '{"requestId": "2032", "remarks": "Bill Required."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792256168465-346', '2026-10-17T16:56:08.465Z'::timestamptz, 'request:rejected', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "2032", "updates": {"payload": {"name": "SABIR MOHAMMED S", "id": "MIB04", "designation": "PCB Fabrication Engineer", "department": "PCB Designs & Fabrication Team", "email": "sabirmohammeds@suryas.in", "claimType": "bill", "amount": "300", "description": "RSR NELLORE", "remarks": "Request to Approve", "filledFormFileName": "", "billFileName": "", "submittedAt": "2026-10-17T16:53:58.943Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "gkbharath", "comment": "Bill Required.", "decision": "reject", "at": "2026-10-17T16:56:08.450Z"}, {"by": "santhanakumarv", "comment": "Approved, Subject to Check Bill.", "decision": "approve", "at": "2026-10-17T16:55:31.802Z"}, {"by": "hareeshv", "comment": "Approved, Subject to Check Bill.", "decision": "approve", "at": "2026-10-17T16:55:07.632Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792256131840-151', '2026-10-17T16:55:31.840Z'::timestamptz, 'request:forward', 'santhanakumarv', 'user-003', '{"requestId": "2032", "from": "santhanakumarv", "to": "gkbharath", "remarks": "Approved, Subject to Check Bill."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792256131827-862', '2026-10-17T16:55:31.827Z'::timestamptz, 'request:forwarded', 'gkbharath', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "2032", "updates": {"payload": {"name": "SABIR MOHAMMED S", "id": "MIB04", "designation": "PCB Fabrication Engineer", "department": "PCB Designs & Fabrication Team", "email": "sabirmohammeds@suryas.in", "claimType": "bill", "amount": "300", "description": "RSR NELLORE", "remarks": "Request to Approve", "filledFormFileName": "", "billFileName": "", "submittedAt": "2026-10-17T16:53:58.943Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "santhanakumarv", "comment": "Approved, Subject to Check Bill.", "decision": "approve", "at": "2026-10-17T16:55:31.802Z"}, {"by": "hareeshv", "comment": "Approved, Subject to Check Bill.", "decision": "approve", "at": "2026-10-17T16:55:07.632Z"}]}, "forwardedTo": "gkbharath"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792256107692-533', '2026-10-17T16:55:07.692Z'::timestamptz, 'request:forward', 'hareeshv', 'user-002', '{"requestId": "2032", "from": "hareeshv", "to": "santhanakumarv", "remarks": "Approved, Subject to Check Bill."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792256107644-559', '2026-10-17T16:55:07.645Z'::timestamptz, 'request:forwarded', 'santhanakumarv', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "2032", "updates": {"payload": {"name": "SABIR MOHAMMED S", "id": "MIB04", "designation": "PCB Fabrication Engineer", "department": "PCB Designs & Fabrication Team", "email": "sabirmohammeds@suryas.in", "claimType": "bill", "amount": "300", "description": "RSR NELLORE", "remarks": "Request to Approve", "filledFormFileName": "", "billFileName": "", "submittedAt": "2026-10-17T16:53:58.943Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "hareeshv", "comment": "Approved, Subject to Check Bill.", "decision": "approve", "at": "2026-10-17T16:55:07.632Z"}]}, "forwardedTo": "santhanakumarv"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792256039126-617', '2026-10-17T16:53:59.126Z'::timestamptz, 'request:created', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "2032", "type": "ta", "title": "Allowance Claim Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792255821120-317', '2026-10-17T16:50:21.120Z'::timestamptz, 'registration:approved', 'gkbharath', 'founder-001', '{"userId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3", "stage": 2, "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792255799172-159', '2026-10-17T16:49:59.172Z'::timestamptz, 'registration:forwarded', 'santhanakumarv', 'user-003', '{"userId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3", "stage": 1, "nextApprover": "gkbharath", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792255781591-30', '2026-10-17T16:49:41.592Z'::timestamptz, 'registration:forwarded', 'hareeshv', 'user-002', '{"userId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3", "stage": 0, "nextApprover": "santhanakumarv", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792255498365-430', '2026-10-17T16:44:58.365Z'::timestamptz, 'auth:password_changed', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"userId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792255306091-27', '2026-10-17T16:41:46.091Z'::timestamptz, 'request:approve', 'gkbharath', 'founder-001', '{"requestId": "8238", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792255306055-981', '2026-10-17T16:41:46.055Z'::timestamptz, 'request:approved', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "8238", "updates": {"payload": {"projectTitle": "TEQTIS INFO PVT LTD", "projectStatus": "review", "createdBy": "SABIR MOHAMMED S", "abstractFileName": "Hybrid_Urinal_Controller_FINAL_Manufacturer_Spec.pdf", "clientName": "TEQTIS INFO PVT LTD", "clientOrganization": "", "clientDesignation": "", "clientAddress": "", "clientPhone": "", "clientEmail": "", "projectAmount": "", "forwardedBy": "", "submittedAt": "2026-10-17T16:40:55.760Z", "remarks": "Please find the PDF.", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "gkbharath", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T16:41:46.033Z"}, {"by": "santhanakumarv", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T16:41:32.669Z"}, {"by": "hareeshv", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T16:41:13.420Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792255292714-511', '2026-10-17T16:41:32.714Z'::timestamptz, 'request:forward', 'santhanakumarv', 'user-003', '{"requestId": "8238", "from": "santhanakumarv", "to": "gkbharath", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792255292691-290', '2026-10-17T16:41:32.691Z'::timestamptz, 'request:forwarded', 'gkbharath', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "8238", "updates": {"payload": {"projectTitle": "TEQTIS INFO PVT LTD", "projectStatus": "review", "createdBy": "SABIR MOHAMMED S", "abstractFileName": "Hybrid_Urinal_Controller_FINAL_Manufacturer_Spec.pdf", "clientName": "TEQTIS INFO PVT LTD", "clientOrganization": "", "clientDesignation": "", "clientAddress": "", "clientPhone": "", "clientEmail": "", "projectAmount": "", "forwardedBy": "", "submittedAt": "2026-10-17T16:40:55.760Z", "remarks": "Please find the PDF.", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "santhanakumarv", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T16:41:32.669Z"}, {"by": "hareeshv", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T16:41:13.420Z"}]}, "forwardedTo": "gkbharath"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792255273456-442', '2026-10-17T16:41:13.456Z'::timestamptz, 'request:forward', 'hareeshv', 'user-002', '{"requestId": "8238", "from": "hareeshv", "to": "santhanakumarv", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792255273439-642', '2026-10-17T16:41:13.439Z'::timestamptz, 'request:forwarded', 'santhanakumarv', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "8238", "updates": {"payload": {"projectTitle": "TEQTIS INFO PVT LTD", "projectStatus": "review", "createdBy": "SABIR MOHAMMED S", "abstractFileName": "Hybrid_Urinal_Controller_FINAL_Manufacturer_Spec.pdf", "clientName": "TEQTIS INFO PVT LTD", "clientOrganization": "", "clientDesignation": "", "clientAddress": "", "clientPhone": "", "clientEmail": "", "projectAmount": "", "forwardedBy": "", "submittedAt": "2026-10-17T16:40:55.760Z", "remarks": "Please find the PDF.", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "hareeshv", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T16:41:13.420Z"}]}, "forwardedTo": "santhanakumarv"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792255255929-853', '2026-10-17T16:40:55.929Z'::timestamptz, 'request:created', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "8238", "type": "proposal", "title": "Project Proposal"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792254306416-764', '2026-10-17T16:25:06.416Z'::timestamptz, 'request:approve', 'gkbharath', 'founder-001', '{"requestId": "3662", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792254306403-312', '2026-10-17T16:25:06.403Z'::timestamptz, 'request:approved', 'HAREESH V', 'user-002', '{"id": "3662", "updates": {"payload": {"name": "HAREESH V", "id": "MIB02", "designation": "Managing Partner - Projects & Administration", "email": "hareesh@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-01", "toDate": "2026-10-01", "reason": "Casual Leave", "remarks": "Request to Approve.", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T16:20:56.590Z", "approvalChain": ["santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "gkbharath", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T16:25:06.388Z"}, {"by": "santhanakumarv", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T16:24:50.799Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792254290829-89', '2026-10-17T16:24:50.829Z'::timestamptz, 'request:forward', 'santhanakumarv', 'user-003', '{"requestId": "3662", "from": "santhanakumarv", "to": "gkbharath", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792254290817-914', '2026-10-17T16:24:50.817Z'::timestamptz, 'request:forwarded', 'gkbharath', 'user-002', '{"id": "3662", "updates": {"payload": {"name": "HAREESH V", "id": "MIB02", "designation": "Managing Partner - Projects & Administration", "email": "hareesh@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-01", "toDate": "2026-10-01", "reason": "Casual Leave", "remarks": "Request to Approve.", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T16:20:56.590Z", "approvalChain": ["santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "santhanakumarv", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T16:24:50.799Z"}]}, "forwardedTo": "gkbharath"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792254056769-548', '2026-10-17T16:20:56.769Z'::timestamptz, 'request:created', 'HAREESH V', 'user-002', '{"id": "3662", "type": "leave", "title": "Past-Date PERSONAL Leave Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792253821801-733', '2026-10-17T16:17:01.801Z'::timestamptz, 'internal-request:replied', 'hareeshv', 'user-002', '{"requestId": "5388", "message": "Hi"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792253803043-445', '2026-10-17T16:16:43.044Z'::timestamptz, 'internal-request:created', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "5388", "description": "Hi"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792253802993-909', '2026-10-17T16:16:42.993Z'::timestamptz, 'request:created', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "5388", "type": "internal-service", "title": "Internal Service Request from SABIR MOHAMMED S"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792253460910-636', '2026-10-17T16:11:00.910Z'::timestamptz, 'request:approve', 'gkbharath', 'founder-001', '{"requestId": "4718", "remarks": "Approved"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792253460896-309', '2026-10-17T16:11:00.896Z'::timestamptz, 'request:approved', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "4718", "updates": {"payload": {"name": "SABIR MOHAMMED S", "id": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "designation": "Employee", "email": "sabirmohammeds@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-12", "toDate": "2026-10-12", "reason": "Casual Leave Due to the My Personal Bank Issue.", "remarks": "Request to Approve.", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T16:09:27.228Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "gkbharath", "comment": "Approved", "decision": "approve", "at": "2026-10-17T16:11:00.882Z"}, {"by": "santhanakumarv", "comment": "Approve", "decision": "approve", "at": "2026-10-17T16:10:40.063Z"}, {"by": "hareeshv", "comment": "Approve", "decision": "approve", "at": "2026-10-17T16:10:25.917Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792253440100-524', '2026-10-17T16:10:40.100Z'::timestamptz, 'request:forward', 'santhanakumarv', 'user-003', '{"requestId": "4718", "from": "santhanakumarv", "to": "gkbharath", "remarks": "Approve"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792253440087-892', '2026-10-17T16:10:40.087Z'::timestamptz, 'request:forwarded', 'gkbharath', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "4718", "updates": {"payload": {"name": "SABIR MOHAMMED S", "id": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "designation": "Employee", "email": "sabirmohammeds@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-12", "toDate": "2026-10-12", "reason": "Casual Leave Due to the My Personal Bank Issue.", "remarks": "Request to Approve.", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T16:09:27.228Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "santhanakumarv", "comment": "Approve", "decision": "approve", "at": "2026-10-17T16:10:40.063Z"}, {"by": "hareeshv", "comment": "Approve", "decision": "approve", "at": "2026-10-17T16:10:25.917Z"}]}, "forwardedTo": "gkbharath"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792253425947-353', '2026-10-17T16:10:25.947Z'::timestamptz, 'request:forward', 'hareeshv', 'user-002', '{"requestId": "4718", "from": "hareeshv", "to": "santhanakumarv", "remarks": "Approve"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792253425932-514', '2026-10-17T16:10:25.932Z'::timestamptz, 'request:forwarded', 'santhanakumarv', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "4718", "updates": {"payload": {"name": "SABIR MOHAMMED S", "id": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "designation": "Employee", "email": "sabirmohammeds@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-12", "toDate": "2026-10-12", "reason": "Casual Leave Due to the My Personal Bank Issue.", "remarks": "Request to Approve.", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T16:09:27.228Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "hareeshv", "comment": "Approve", "decision": "approve", "at": "2026-10-17T16:10:25.917Z"}]}, "forwardedTo": "santhanakumarv"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792253367422-638', '2026-10-17T16:09:27.422Z'::timestamptz, 'request:created', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "4718", "type": "leave", "title": "Past-Date PERSONAL Leave Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792252633622-10', '2026-10-17T15:57:13.622Z'::timestamptz, 'request:reject', 'gkbharath', 'founder-001', '{"requestId": "SMIB-REQ-2026-5CBB50E5-3230-44DB-8CA3-C7F46EC81E26", "remarks": "Not Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792252633612-735', '2026-10-17T15:57:13.612Z'::timestamptz, 'request:rejected', 'SANTHANA KUMAR V', 'user-003', '{"id": "SMIB-REQ-2026-5CBB50E5-3230-44DB-8CA3-C7F46EC81E26", "updates": {"payload": {"name": "SANTHANA KUMAR V", "id": "user-003", "designation": "Managing Partner - Operations & Business Development", "email": "santhana@suryas.in", "claimType": "bill", "amount": "300", "description": "R&D COMPO", "remarks": "Request to Approve.", "filledFormFileName": "", "billFileName": "", "submittedAt": "2026-10-17T15:26:30.517Z", "approvalChain": ["hareeshv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "gkbharath", "comment": "Not Approved.", "decision": "reject", "at": "2026-10-17T15:57:13.602Z"}, {"by": "hareeshv", "comment": "Subject to Verfiy the Bill", "decision": "approve", "at": "2026-10-17T15:37:22.212Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792252595067-703', '2026-10-17T15:56:35.067Z'::timestamptz, 'request:approve', 'santhanakumarv', 'user-003', '{"requestId": "SMIB-REQ-2026-A57E06D2-6C29-4A17-BB90-AE080587A423", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792252595043-854', '2026-10-17T15:56:35.043Z'::timestamptz, 'request:approved', 'GOLLA KUMAR BHARATH', 'founder-001', '{"id": "SMIB-REQ-2026-A57E06D2-6C29-4A17-BB90-AE080587A423", "updates": {"payload": {"name": "GOLLA KUMAR BHARATH", "id": "founder-001", "designation": "Founder & chief executive partner", "email": "proprietor@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-03", "toDate": "2026-10-03", "reason": "Casual Leave.", "remarks": "Request to Approve.", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T15:29:42.192Z", "approvalChain": ["hareeshv", "santhanakumarv"], "currentApproverIndex": 1, "comments": [{"by": "santhanakumarv", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T15:56:35.014Z"}, {"by": "santhanakumarv", "comment": "Leave Approved.", "decision": "approve", "at": "2026-10-17T15:38:33.156Z"}, {"by": "hareeshv", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T15:32:37.590Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792252418794-632', '2026-10-17T15:53:38.794Z'::timestamptz, 'request:approval-chain-migrated', 'system', 'system', '{"requestId": "SMIB-REQ-2026-A57E06D2-6C29-4A17-BB90-AE080587A423", "oldChain": ["hareeshv", "santhanakumarv", "gkbharath"], "newChain": ["hareeshv", "santhanakumarv"], "currentApprover": "santhanakumarv"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251543766-879', '2026-10-17T15:39:03.766Z'::timestamptz, 'request:reject', 'santhanakumarv', 'user-003', '{"requestId": "SMIB-REQ-2026-109CE918-59D0-4E47-BEC4-470AA5BBC54A", "remarks": "Rejected Due to No Bill."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251543756-293', '2026-10-17T15:39:03.756Z'::timestamptz, 'request:rejected', 'GOLLA KUMAR BHARATH', 'founder-001', '{"id": "SMIB-REQ-2026-109CE918-59D0-4E47-BEC4-470AA5BBC54A", "updates": {"payload": {"name": "GOLLA KUMAR BHARATH", "id": "founder-001", "designation": "Founder & chief executive partner", "email": "proprietor@suryas.in", "claimType": "bill", "amount": "300", "description": "Petrol", "remarks": "Petrol", "filledFormFileName": "", "billFileName": "", "submittedAt": "2026-10-17T15:31:11.920Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "santhanakumarv", "comment": "Rejected Due to No Bill.", "decision": "reject", "at": "2026-10-17T15:39:03.743Z"}, {"by": "hareeshv", "comment": "Subject to Verfiy the Bill.", "decision": "approve", "at": "2026-10-17T15:37:10.162Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251513178-94', '2026-10-17T15:38:33.178Z'::timestamptz, 'request:forward', 'santhanakumarv', 'user-003', '{"requestId": "SMIB-REQ-2026-A57E06D2-6C29-4A17-BB90-AE080587A423", "from": "santhanakumarv", "to": "gkbharath", "remarks": "Leave Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251513167-498', '2026-10-17T15:38:33.168Z'::timestamptz, 'request:forwarded', 'gkbharath', 'founder-001', '{"id": "SMIB-REQ-2026-A57E06D2-6C29-4A17-BB90-AE080587A423", "updates": {"payload": {"name": "GOLLA KUMAR BHARATH", "id": "founder-001", "designation": "Founder & chief executive partner", "email": "proprietor@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-03", "toDate": "2026-10-03", "reason": "Casual Leave.", "remarks": "Request to Approve.", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T15:29:42.192Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "santhanakumarv", "comment": "Leave Approved.", "decision": "approve", "at": "2026-10-17T15:38:33.156Z"}, {"by": "hareeshv", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T15:32:37.590Z"}]}, "forwardedTo": "gkbharath"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251442236-101', '2026-10-17T15:37:22.236Z'::timestamptz, 'request:forward', 'hareeshv', 'user-002', '{"requestId": "SMIB-REQ-2026-5CBB50E5-3230-44DB-8CA3-C7F46EC81E26", "from": "hareeshv", "to": "gkbharath", "remarks": "Subject to Verfiy the Bill"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251442224-961', '2026-10-17T15:37:22.224Z'::timestamptz, 'request:forwarded', 'gkbharath', 'user-003', '{"id": "SMIB-REQ-2026-5CBB50E5-3230-44DB-8CA3-C7F46EC81E26", "updates": {"payload": {"name": "SANTHANA KUMAR V", "id": "user-003", "designation": "Managing Partner - Operations & Business Development", "email": "santhana@suryas.in", "claimType": "bill", "amount": "300", "description": "R&D COMPO", "remarks": "Request to Approve.", "filledFormFileName": "", "billFileName": "", "submittedAt": "2026-10-17T15:26:30.517Z", "approvalChain": ["hareeshv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "hareeshv", "comment": "Subject to Verfiy the Bill", "decision": "approve", "at": "2026-10-17T15:37:22.212Z"}]}, "forwardedTo": "gkbharath"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251430192-552', '2026-10-17T15:37:10.192Z'::timestamptz, 'request:forward', 'hareeshv', 'user-002', '{"requestId": "SMIB-REQ-2026-109CE918-59D0-4E47-BEC4-470AA5BBC54A", "from": "hareeshv", "to": "santhanakumarv", "remarks": "Subject to Verfiy the Bill."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251430182-23', '2026-10-17T15:37:10.182Z'::timestamptz, 'request:forwarded', 'santhanakumarv', 'founder-001', '{"id": "SMIB-REQ-2026-109CE918-59D0-4E47-BEC4-470AA5BBC54A", "updates": {"payload": {"name": "GOLLA KUMAR BHARATH", "id": "founder-001", "designation": "Founder & chief executive partner", "email": "proprietor@suryas.in", "claimType": "bill", "amount": "300", "description": "Petrol", "remarks": "Petrol", "filledFormFileName": "", "billFileName": "", "submittedAt": "2026-10-17T15:31:11.920Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "hareeshv", "comment": "Subject to Verfiy the Bill.", "decision": "approve", "at": "2026-10-17T15:37:10.162Z"}]}, "forwardedTo": "santhanakumarv"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251310890-532', '2026-10-17T15:35:10.890Z'::timestamptz, 'request:approve', 'gkbharath', 'founder-001', '{"requestId": "SMIB-REQ-2026-0B453876-6A34-441B-A649-AA397A66DAE9", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251310883-313', '2026-10-17T15:35:10.883Z'::timestamptz, 'request:approved', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-0B453876-6A34-441B-A649-AA397A66DAE9", "updates": {"payload": {"description": "Training Report \u2013 PCB Design & Fabrication\n\nOrganized by: CRANES VARSITY PRIVATE LIMITED\nVenue: RSR Engineering College, Nellore\nTraining Period: 09-10-2026 to 15-10-2026\n\nThe six-day training program covered electronics fundamentals, PCB basics, KiCad EDA tools, schematic and PCB layout design, analog and digital circuit design.\n\nFrom 13-10-2026 to 15-10-2026, students participated in practical, hands-on PCB fabrication activities using the PCB Fabrication Kit, including PCB etching, drilling, soldering, component mounting, and board assembly.\n\nThe program aimed to provide students with practical knowledge and hands-on experience in PCB design, fabrication, testing, and hardware realization.", "reportFrequency": "weekly", "attachments": [], "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "gkbharath", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T15:35:10.869Z"}, {"by": "santhanakumarv", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T15:28:25.611Z"}, {"by": "hareeshv", "comment": "Forwarded", "decision": "approve", "at": "2026-10-17T15:19:49.598Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251235740-895', '2026-10-17T15:33:55.740Z'::timestamptz, 'request:approve', 'gkbharath', 'founder-001', '{"requestId": "SMIB-REQ-2026-F414A91F-6B7B-4F75-8E42-0DC1667B9B52", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251235731-814', '2026-10-17T15:33:55.731Z'::timestamptz, 'request:approved', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-F414A91F-6B7B-4F75-8E42-0DC1667B9B52", "updates": {"payload": {"projectTitle": "TEQTIS INFO PVT LTD", "projectStatus": "review", "createdBy": "SABIR MOHAMMED S", "abstractFileName": "Hybrid_Urinal_Controller_FINAL_Manufacturer_Spec.pdf", "clientName": "TEQTIS INFO PVT LTD", "clientOrganization": "", "clientDesignation": "", "clientAddress": "", "clientPhone": "", "clientEmail": "", "projectAmount": "", "forwardedBy": "", "submittedAt": "2026-10-17T15:16:34.171Z", "remarks": "Request to Check the PDF.", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "gkbharath", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T15:33:55.717Z"}, {"by": "santhanakumarv", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T15:27:15.694Z"}, {"by": "hareeshv", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T15:24:31.116Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251224356-902', '2026-10-17T15:33:44.356Z'::timestamptz, 'request:reject', 'gkbharath', 'founder-001', '{"requestId": "SMIB-REQ-2026-5E934C04-6BCA-46A3-8A23-92BA689539AE", "remarks": "Subject to Summit Bill"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251224346-946', '2026-10-17T15:33:44.346Z'::timestamptz, 'request:rejected', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-5E934C04-6BCA-46A3-8A23-92BA689539AE", "updates": {"payload": {"name": "SABIR MOHAMMED S", "id": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "designation": "Employee", "email": "sabirmohammeds@suryas.in", "claimType": "bill", "amount": "300", "description": "RSR NELLORE FOOD", "remarks": "Request to Approve.", "filledFormFileName": "", "billFileName": "", "submittedAt": "2026-10-17T15:17:05.930Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "gkbharath", "comment": "Subject to Summit Bill", "decision": "reject", "at": "2026-10-17T15:33:44.335Z"}, {"by": "santhanakumarv", "comment": "Subject to Check Bill", "decision": "approve", "at": "2026-10-17T15:28:14.667Z"}, {"by": "hareeshv", "comment": "Subject to Check the Bills.", "decision": "approve", "at": "2026-10-17T15:20:29.442Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251210851-940', '2026-10-17T15:33:30.852Z'::timestamptz, 'request:reject', 'gkbharath', 'founder-001', '{"requestId": "SMIB-REQ-2026-A242549F-0147-4758-8D92-27182CD960EB", "remarks": "Rejected."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251210842-168', '2026-10-17T15:33:30.842Z'::timestamptz, 'request:rejected', 'HAREESH V', 'user-002', '{"id": "SMIB-REQ-2026-A242549F-0147-4758-8D92-27182CD960EB", "updates": {"payload": {"name": "HAREESH V", "id": "user-002", "designation": "Managing Partner - Projects & Administration", "email": "hareesh@suryas.in", "claimType": "bill", "amount": "300", "description": "RSR FOOD", "remarks": "Request to Approve", "filledFormFileName": "", "billFileName": "", "submittedAt": "2026-10-17T15:21:27.177Z", "approvalChain": ["santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "gkbharath", "comment": "Rejected.", "decision": "reject", "at": "2026-10-17T15:33:30.826Z"}, {"by": "santhanakumarv", "comment": "Approved", "decision": "approve", "at": "2026-10-17T15:27:26.290Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251166282-996', '2026-10-17T15:32:46.282Z'::timestamptz, 'request:approve', 'gkbharath', 'founder-001', '{"requestId": "SMIB-REQ-2026-F7AF45DE-6D4B-47E1-9616-626A52B3C4A4", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251166269-872', '2026-10-17T15:32:46.269Z'::timestamptz, 'request:approved', 'SANTHANA KUMAR V', 'user-003', '{"id": "SMIB-REQ-2026-F7AF45DE-6D4B-47E1-9616-626A52B3C4A4", "updates": {"payload": {"name": "SANTHANA KUMAR V", "id": "user-003", "designation": "Managing Partner - Operations & Business Development", "email": "santhana@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-03", "toDate": "2026-10-03", "reason": "Casual Leave.", "remarks": "Casual Leave.", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T15:26:47.195Z", "approvalChain": ["hareeshv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "gkbharath", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T15:32:46.256Z"}, {"by": "hareeshv", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T15:32:31.390Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251157624-439', '2026-10-17T15:32:37.624Z'::timestamptz, 'request:forward', 'hareeshv', 'user-002', '{"requestId": "SMIB-REQ-2026-A57E06D2-6C29-4A17-BB90-AE080587A423", "from": "hareeshv", "to": "santhanakumarv", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251157613-831', '2026-10-17T15:32:37.613Z'::timestamptz, 'request:forwarded', 'santhanakumarv', 'founder-001', '{"id": "SMIB-REQ-2026-A57E06D2-6C29-4A17-BB90-AE080587A423", "updates": {"payload": {"name": "GOLLA KUMAR BHARATH", "id": "founder-001", "designation": "Founder & chief executive partner", "email": "proprietor@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-03", "toDate": "2026-10-03", "reason": "Casual Leave.", "remarks": "Request to Approve.", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T15:29:42.192Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "hareeshv", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T15:32:37.590Z"}]}, "forwardedTo": "santhanakumarv"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251151422-426', '2026-10-17T15:32:31.422Z'::timestamptz, 'request:forward', 'hareeshv', 'user-002', '{"requestId": "SMIB-REQ-2026-F7AF45DE-6D4B-47E1-9616-626A52B3C4A4", "from": "hareeshv", "to": "gkbharath", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251151406-995', '2026-10-17T15:32:31.406Z'::timestamptz, 'request:forwarded', 'gkbharath', 'user-003', '{"id": "SMIB-REQ-2026-F7AF45DE-6D4B-47E1-9616-626A52B3C4A4", "updates": {"payload": {"name": "SANTHANA KUMAR V", "id": "user-003", "designation": "Managing Partner - Operations & Business Development", "email": "santhana@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-03", "toDate": "2026-10-03", "reason": "Casual Leave.", "remarks": "Casual Leave.", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T15:26:47.195Z", "approvalChain": ["hareeshv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "hareeshv", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T15:32:31.390Z"}]}, "forwardedTo": "gkbharath"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251127830-168', '2026-10-17T15:32:07.831Z'::timestamptz, 'request:approve', 'gkbharath', 'founder-001', '{"requestId": "SMIB-REQ-2026-6168040F-36C2-40D3-86E7-F954EA274DB8", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251127821-954', '2026-10-17T15:32:07.821Z'::timestamptz, 'request:approved', 'HAREESH V', 'user-002', '{"id": "SMIB-REQ-2026-6168040F-36C2-40D3-86E7-F954EA274DB8", "updates": {"payload": {"name": "HAREESH V", "id": "user-002", "designation": "Managing Partner - Projects & Administration", "email": "hareesh@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-10", "toDate": "2026-10-10", "reason": "Casual Leave", "remarks": "Request to Approve.", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T15:22:31.479Z", "approvalChain": ["santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "gkbharath", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T15:32:07.807Z"}, {"by": "santhanakumarv", "comment": "Approved", "decision": "approve", "at": "2026-10-17T15:27:36.797Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251121379-999', '2026-10-17T15:32:01.379Z'::timestamptz, 'request:approve', 'gkbharath', 'founder-001', '{"requestId": "SMIB-REQ-2026-D87AA2E0-653C-4CD6-A274-5F6A2DDB3FA0", "remarks": "Approvedl"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251121353-672', '2026-10-17T15:32:01.353Z'::timestamptz, 'request:approved', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-D87AA2E0-653C-4CD6-A274-5F6A2DDB3FA0", "updates": {"payload": {"name": "SABIR MOHAMMED S", "id": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "designation": "Employee", "email": "sabirmohammeds@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-12", "toDate": "2026-10-12", "reason": "Casual Leave", "remarks": "Request to Approve.", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T15:17:32.740Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "gkbharath", "comment": "Approvedl", "decision": "approve", "at": "2026-10-17T15:32:01.327Z"}, {"by": "santhanakumarv", "comment": "Approved", "decision": "approve", "at": "2026-10-17T15:28:00.630Z"}, {"by": "hareeshv", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T15:20:40.805Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792251072046-338', '2026-10-17T15:31:12.046Z'::timestamptz, 'request:created', 'GOLLA KUMAR BHARATH', 'founder-001', '{"id": "SMIB-REQ-2026-109CE918-59D0-4E47-BEC4-470AA5BBC54A", "type": "ta", "title": "Allowance Claim Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250982282-818', '2026-10-17T15:29:42.283Z'::timestamptz, 'request:created', 'GOLLA KUMAR BHARATH', 'founder-001', '{"id": "SMIB-REQ-2026-A57E06D2-6C29-4A17-BB90-AE080587A423", "type": "leave", "title": "Past-Date PERSONAL Leave Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250905626-226', '2026-10-17T15:28:25.626Z'::timestamptz, 'request:forward', 'santhanakumarv', 'user-003', '{"requestId": "SMIB-REQ-2026-0B453876-6A34-441B-A649-AA397A66DAE9", "from": "santhanakumarv", "to": "gkbharath", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250905620-404', '2026-10-17T15:28:25.620Z'::timestamptz, 'request:forwarded', 'gkbharath', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-0B453876-6A34-441B-A649-AA397A66DAE9", "updates": {"payload": {"description": "Training Report \u2013 PCB Design & Fabrication\n\nOrganized by: CRANES VARSITY PRIVATE LIMITED\nVenue: RSR Engineering College, Nellore\nTraining Period: 09-10-2026 to 15-10-2026\n\nThe six-day training program covered electronics fundamentals, PCB basics, KiCad EDA tools, schematic and PCB layout design, analog and digital circuit design.\n\nFrom 13-10-2026 to 15-10-2026, students participated in practical, hands-on PCB fabrication activities using the PCB Fabrication Kit, including PCB etching, drilling, soldering, component mounting, and board assembly.\n\nThe program aimed to provide students with practical knowledge and hands-on experience in PCB design, fabrication, testing, and hardware realization.", "reportFrequency": "weekly", "attachments": [], "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "santhanakumarv", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T15:28:25.611Z"}, {"by": "hareeshv", "comment": "Forwarded", "decision": "approve", "at": "2026-10-17T15:19:49.598Z"}]}, "forwardedTo": "gkbharath"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250894686-965', '2026-10-17T15:28:14.686Z'::timestamptz, 'request:forward', 'santhanakumarv', 'user-003', '{"requestId": "SMIB-REQ-2026-5E934C04-6BCA-46A3-8A23-92BA689539AE", "from": "santhanakumarv", "to": "gkbharath", "remarks": "Subject to Check Bill"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250894678-910', '2026-10-17T15:28:14.678Z'::timestamptz, 'request:forwarded', 'gkbharath', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-5E934C04-6BCA-46A3-8A23-92BA689539AE", "updates": {"payload": {"name": "SABIR MOHAMMED S", "id": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "designation": "Employee", "email": "sabirmohammeds@suryas.in", "claimType": "bill", "amount": "300", "description": "RSR NELLORE FOOD", "remarks": "Request to Approve.", "filledFormFileName": "", "billFileName": "", "submittedAt": "2026-10-17T15:17:05.930Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "santhanakumarv", "comment": "Subject to Check Bill", "decision": "approve", "at": "2026-10-17T15:28:14.667Z"}, {"by": "hareeshv", "comment": "Subject to Check the Bills.", "decision": "approve", "at": "2026-10-17T15:20:29.442Z"}]}, "forwardedTo": "gkbharath"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250880652-284', '2026-10-17T15:28:00.652Z'::timestamptz, 'request:forward', 'santhanakumarv', 'user-003', '{"requestId": "SMIB-REQ-2026-D87AA2E0-653C-4CD6-A274-5F6A2DDB3FA0", "from": "santhanakumarv", "to": "gkbharath", "remarks": "Approved"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250880643-882', '2026-10-17T15:28:00.643Z'::timestamptz, 'request:forwarded', 'gkbharath', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-D87AA2E0-653C-4CD6-A274-5F6A2DDB3FA0", "updates": {"payload": {"name": "SABIR MOHAMMED S", "id": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "designation": "Employee", "email": "sabirmohammeds@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-12", "toDate": "2026-10-12", "reason": "Casual Leave", "remarks": "Request to Approve.", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T15:17:32.740Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "santhanakumarv", "comment": "Approved", "decision": "approve", "at": "2026-10-17T15:28:00.630Z"}, {"by": "hareeshv", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T15:20:40.805Z"}]}, "forwardedTo": "gkbharath"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250856816-261', '2026-10-17T15:27:36.817Z'::timestamptz, 'request:forward', 'santhanakumarv', 'user-003', '{"requestId": "SMIB-REQ-2026-6168040F-36C2-40D3-86E7-F954EA274DB8", "from": "santhanakumarv", "to": "gkbharath", "remarks": "Approved"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250856809-380', '2026-10-17T15:27:36.809Z'::timestamptz, 'request:forwarded', 'gkbharath', 'user-002', '{"id": "SMIB-REQ-2026-6168040F-36C2-40D3-86E7-F954EA274DB8", "updates": {"payload": {"name": "HAREESH V", "id": "user-002", "designation": "Managing Partner - Projects & Administration", "email": "hareesh@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-10", "toDate": "2026-10-10", "reason": "Casual Leave", "remarks": "Request to Approve.", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T15:22:31.479Z", "approvalChain": ["santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "santhanakumarv", "comment": "Approved", "decision": "approve", "at": "2026-10-17T15:27:36.797Z"}]}, "forwardedTo": "gkbharath"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250846305-248', '2026-10-17T15:27:26.305Z'::timestamptz, 'request:forward', 'santhanakumarv', 'user-003', '{"requestId": "SMIB-REQ-2026-A242549F-0147-4758-8D92-27182CD960EB", "from": "santhanakumarv", "to": "gkbharath", "remarks": "Approved"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250846300-235', '2026-10-17T15:27:26.300Z'::timestamptz, 'request:forwarded', 'gkbharath', 'user-002', '{"id": "SMIB-REQ-2026-A242549F-0147-4758-8D92-27182CD960EB", "updates": {"payload": {"name": "HAREESH V", "id": "user-002", "designation": "Managing Partner - Projects & Administration", "email": "hareesh@suryas.in", "claimType": "bill", "amount": "300", "description": "RSR FOOD", "remarks": "Request to Approve", "filledFormFileName": "", "billFileName": "", "submittedAt": "2026-10-17T15:21:27.177Z", "approvalChain": ["santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "santhanakumarv", "comment": "Approved", "decision": "approve", "at": "2026-10-17T15:27:26.290Z"}]}, "forwardedTo": "gkbharath"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250835712-742', '2026-10-17T15:27:15.712Z'::timestamptz, 'request:forward', 'santhanakumarv', 'user-003', '{"requestId": "SMIB-REQ-2026-F414A91F-6B7B-4F75-8E42-0DC1667B9B52", "from": "santhanakumarv", "to": "gkbharath", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250835704-610', '2026-10-17T15:27:15.704Z'::timestamptz, 'request:forwarded', 'gkbharath', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-F414A91F-6B7B-4F75-8E42-0DC1667B9B52", "updates": {"payload": {"projectTitle": "TEQTIS INFO PVT LTD", "projectStatus": "review", "createdBy": "SABIR MOHAMMED S", "abstractFileName": "Hybrid_Urinal_Controller_FINAL_Manufacturer_Spec.pdf", "clientName": "TEQTIS INFO PVT LTD", "clientOrganization": "", "clientDesignation": "", "clientAddress": "", "clientPhone": "", "clientEmail": "", "projectAmount": "", "forwardedBy": "", "submittedAt": "2026-10-17T15:16:34.171Z", "remarks": "Request to Check the PDF.", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "santhanakumarv", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T15:27:15.694Z"}, {"by": "hareeshv", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T15:24:31.116Z"}]}, "forwardedTo": "gkbharath"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250807309-54', '2026-10-17T15:26:47.310Z'::timestamptz, 'request:created', 'SANTHANA KUMAR V', 'user-003', '{"id": "SMIB-REQ-2026-F7AF45DE-6D4B-47E1-9616-626A52B3C4A4", "type": "leave", "title": "Past-Date PERSONAL Leave Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250790609-151', '2026-10-17T15:26:30.609Z'::timestamptz, 'request:created', 'SANTHANA KUMAR V', 'user-003', '{"id": "SMIB-REQ-2026-5CBB50E5-3230-44DB-8CA3-C7F46EC81E26", "type": "ta", "title": "Allowance Claim Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250728167-771', '2026-10-17T15:25:28.167Z'::timestamptz, 'internal-request:head-assigned', 'hareeshv', 'user-002', '{"requestId": "req-1792250060077", "assignedHeadId": "user-002", "assignedHeadName": "HAREESH V"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250671136-552', '2026-10-17T15:24:31.136Z'::timestamptz, 'request:forward', 'hareeshv', 'user-002', '{"requestId": "SMIB-REQ-2026-F414A91F-6B7B-4F75-8E42-0DC1667B9B52", "from": "hareeshv", "to": "santhanakumarv", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250671130-686', '2026-10-17T15:24:31.130Z'::timestamptz, 'request:forwarded', 'santhanakumarv', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-F414A91F-6B7B-4F75-8E42-0DC1667B9B52", "updates": {"payload": {"projectTitle": "TEQTIS INFO PVT LTD", "projectStatus": "review", "createdBy": "SABIR MOHAMMED S", "abstractFileName": "Hybrid_Urinal_Controller_FINAL_Manufacturer_Spec.pdf", "clientName": "TEQTIS INFO PVT LTD", "clientOrganization": "", "clientDesignation": "", "clientAddress": "", "clientPhone": "", "clientEmail": "", "projectAmount": "", "forwardedBy": "", "submittedAt": "2026-10-17T15:16:34.171Z", "remarks": "Request to Check the PDF.", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "hareeshv", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T15:24:31.116Z"}]}, "forwardedTo": "santhanakumarv"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250551628-602', '2026-10-17T15:22:31.629Z'::timestamptz, 'request:created', 'HAREESH V', 'user-002', '{"id": "SMIB-REQ-2026-6168040F-36C2-40D3-86E7-F954EA274DB8", "type": "leave", "title": "Past-Date PERSONAL Leave Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250487297-431', '2026-10-17T15:21:27.297Z'::timestamptz, 'request:created', 'HAREESH V', 'user-002', '{"id": "SMIB-REQ-2026-A242549F-0147-4758-8D92-27182CD960EB", "type": "ta", "title": "Allowance Claim Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250440851-317', '2026-10-17T15:20:40.851Z'::timestamptz, 'request:forward', 'hareeshv', 'user-002', '{"requestId": "SMIB-REQ-2026-D87AA2E0-653C-4CD6-A274-5F6A2DDB3FA0", "from": "hareeshv", "to": "santhanakumarv", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250440832-848', '2026-10-17T15:20:40.832Z'::timestamptz, 'request:forwarded', 'santhanakumarv', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-D87AA2E0-653C-4CD6-A274-5F6A2DDB3FA0", "updates": {"payload": {"name": "SABIR MOHAMMED S", "id": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "designation": "Employee", "email": "sabirmohammeds@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-12", "toDate": "2026-10-12", "reason": "Casual Leave", "remarks": "Request to Approve.", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T15:17:32.740Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "hareeshv", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T15:20:40.805Z"}]}, "forwardedTo": "santhanakumarv"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250429460-20', '2026-10-17T15:20:29.460Z'::timestamptz, 'request:forward', 'hareeshv', 'user-002', '{"requestId": "SMIB-REQ-2026-5E934C04-6BCA-46A3-8A23-92BA689539AE", "from": "hareeshv", "to": "santhanakumarv", "remarks": "Subject to Check the Bills."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250429454-925', '2026-10-17T15:20:29.454Z'::timestamptz, 'request:forwarded', 'santhanakumarv', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-5E934C04-6BCA-46A3-8A23-92BA689539AE", "updates": {"payload": {"name": "SABIR MOHAMMED S", "id": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "designation": "Employee", "email": "sabirmohammeds@suryas.in", "claimType": "bill", "amount": "300", "description": "RSR NELLORE FOOD", "remarks": "Request to Approve.", "filledFormFileName": "", "billFileName": "", "submittedAt": "2026-10-17T15:17:05.930Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "hareeshv", "comment": "Subject to Check the Bills.", "decision": "approve", "at": "2026-10-17T15:20:29.442Z"}]}, "forwardedTo": "santhanakumarv"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250389626-743', '2026-10-17T15:19:49.626Z'::timestamptz, 'request:forward', 'hareeshv', 'user-002', '{"requestId": "SMIB-REQ-2026-0B453876-6A34-441B-A649-AA397A66DAE9", "from": "hareeshv", "to": "santhanakumarv", "remarks": "Forwarded"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250389617-400', '2026-10-17T15:19:49.617Z'::timestamptz, 'request:forwarded', 'santhanakumarv', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-0B453876-6A34-441B-A649-AA397A66DAE9", "updates": {"payload": {"description": "Training Report \u2013 PCB Design & Fabrication\n\nOrganized by: CRANES VARSITY PRIVATE LIMITED\nVenue: RSR Engineering College, Nellore\nTraining Period: 09-10-2026 to 15-10-2026\n\nThe six-day training program covered electronics fundamentals, PCB basics, KiCad EDA tools, schematic and PCB layout design, analog and digital circuit design.\n\nFrom 13-10-2026 to 15-10-2026, students participated in practical, hands-on PCB fabrication activities using the PCB Fabrication Kit, including PCB etching, drilling, soldering, component mounting, and board assembly.\n\nThe program aimed to provide students with practical knowledge and hands-on experience in PCB design, fabrication, testing, and hardware realization.", "reportFrequency": "weekly", "attachments": [], "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "hareeshv", "comment": "Forwarded", "decision": "approve", "at": "2026-10-17T15:19:49.598Z"}]}, "forwardedTo": "santhanakumarv"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250364108-833', '2026-10-17T15:19:24.108Z'::timestamptz, 'internal-request:replied', 'hareeshv', 'user-002', '{"requestId": "req-1792250060077", "message": "Hi"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250358868-576', '2026-10-17T15:19:18.868Z'::timestamptz, 'internal-request:status-updated', 'hareeshv', 'user-002', '{"requestId": "req-1792250060077", "newStatus": "completed"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250252866-776', '2026-10-17T15:17:32.866Z'::timestamptz, 'request:created', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-D87AA2E0-653C-4CD6-A274-5F6A2DDB3FA0", "type": "leave", "title": "Past-Date PERSONAL Leave Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250226067-944', '2026-10-17T15:17:06.067Z'::timestamptz, 'request:created', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-5E934C04-6BCA-46A3-8A23-92BA689539AE", "type": "ta", "title": "Allowance Claim Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250194272-168', '2026-10-17T15:16:34.272Z'::timestamptz, 'request:created', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-F414A91F-6B7B-4F75-8E42-0DC1667B9B52", "type": "proposal", "title": "Project Proposal"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250109640-685', '2026-10-17T15:15:09.640Z'::timestamptz, 'report:submitted', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-0B453876-6A34-441B-A649-AA397A66DAE9", "title": "RSR NELLORE", "reportFrequency": "weekly", "remarks": "Request to Approve."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250109620-921', '2026-10-17T15:15:09.621Z'::timestamptz, 'request:created', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-0B453876-6A34-441B-A649-AA397A66DAE9", "type": "report", "title": "RSR NELLORE"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250060120-543', '2026-10-17T15:14:20.120Z'::timestamptz, 'internal-request:created', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "req-1792250060077", "description": "Hi Hareesh,"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792250060101-412', '2026-10-17T15:14:20.101Z'::timestamptz, 'request:created', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "req-1792250060077", "type": "internal-service", "title": "Internal Service Request from SABIR MOHAMMED S"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792249364229-856', '2026-10-17T15:02:44.229Z'::timestamptz, 'request:approve', 'gkbharath', 'founder-001', '{"requestId": "SMIB-REQ-2026-2298A37E-BB77-40DA-A6C7-3750FC775C90", "remarks": "Approved"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792249364220-671', '2026-10-17T15:02:44.220Z'::timestamptz, 'request:approved', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-2298A37E-BB77-40DA-A6C7-3750FC775C90", "updates": {"payload": {"name": "SABIR MOHAMMED S", "id": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "designation": "Employee", "email": "sabirmohammeds@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-09", "toDate": "2026-10-09", "reason": "casual", "remarks": "casual", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T15:01:52.206Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "gkbharath", "comment": "Approved", "decision": "approve", "at": "2026-10-17T15:02:44.213Z"}, {"by": "santhanakumarv", "comment": "Approved", "decision": "approve", "at": "2026-10-17T15:02:35.633Z"}, {"by": "hareeshv", "comment": "Approved", "decision": "approve", "at": "2026-10-17T15:02:14.147Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792249355652-229', '2026-10-17T15:02:35.653Z'::timestamptz, 'request:forward', 'santhanakumarv', 'user-003', '{"requestId": "SMIB-REQ-2026-2298A37E-BB77-40DA-A6C7-3750FC775C90", "from": "santhanakumarv", "to": "gkbharath", "remarks": "Approved"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792249355648-27', '2026-10-17T15:02:35.648Z'::timestamptz, 'request:forwarded', 'gkbharath', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-2298A37E-BB77-40DA-A6C7-3750FC775C90", "updates": {"payload": {"name": "SABIR MOHAMMED S", "id": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "designation": "Employee", "email": "sabirmohammeds@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-09", "toDate": "2026-10-09", "reason": "casual", "remarks": "casual", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T15:01:52.206Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "santhanakumarv", "comment": "Approved", "decision": "approve", "at": "2026-10-17T15:02:35.633Z"}, {"by": "hareeshv", "comment": "Approved", "decision": "approve", "at": "2026-10-17T15:02:14.147Z"}]}, "forwardedTo": "gkbharath"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792249334171-420', '2026-10-17T15:02:14.172Z'::timestamptz, 'request:forward', 'hareeshv', 'user-002', '{"requestId": "SMIB-REQ-2026-2298A37E-BB77-40DA-A6C7-3750FC775C90", "from": "hareeshv", "to": "santhanakumarv", "remarks": "Approved"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792249334167-919', '2026-10-17T15:02:14.167Z'::timestamptz, 'request:forwarded', 'santhanakumarv', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-2298A37E-BB77-40DA-A6C7-3750FC775C90", "updates": {"payload": {"name": "SABIR MOHAMMED S", "id": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "designation": "Employee", "email": "sabirmohammeds@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-09", "toDate": "2026-10-09", "reason": "casual", "remarks": "casual", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T15:01:52.206Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "hareeshv", "comment": "Approved", "decision": "approve", "at": "2026-10-17T15:02:14.147Z"}]}, "forwardedTo": "santhanakumarv"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792249312292-450', '2026-10-17T15:01:52.292Z'::timestamptz, 'request:created', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-2298A37E-BB77-40DA-A6C7-3750FC775C90", "type": "leave", "title": "Past-Date PERSONAL Leave Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792249217777-661', '2026-10-17T15:00:17.777Z'::timestamptz, 'request:approve', 'gkbharath', 'founder-001', '{"requestId": "SMIB-REQ-2026-F696527D-E51D-4493-8A3E-FEB93BB407D5", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792249217773-731', '2026-10-17T15:00:17.773Z'::timestamptz, 'request:approved', 'GOLLA KUMAR BHARATH', 'founder-001', '{"id": "SMIB-REQ-2026-F696527D-E51D-4493-8A3E-FEB93BB407D5", "updates": {"payload": {"name": "GOLLA KUMAR BHARATH", "id": "founder-001", "designation": "Founder & Chief Executive Partner", "email": "proprietor@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-10", "toDate": "2026-10-10", "reason": "Casual Leave", "remarks": "Casual Leave", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T14:45:08.372Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "gkbharath", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T15:00:17.767Z"}, {"by": "santhanakumarv", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T14:59:11.127Z"}, {"by": "hareeshv", "comment": "Casual Leave", "decision": "approve", "at": "2026-10-17T14:45:15.217Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792249208104-431', '2026-10-17T15:00:08.104Z'::timestamptz, 'request:approve', 'gkbharath', 'founder-001', '{"requestId": "SMIB-REQ-2026-01605CF8-4772-447A-A88E-54C97261ECBD", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792249208097-869', '2026-10-17T15:00:08.097Z'::timestamptz, 'request:approved', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-01605CF8-4772-447A-A88E-54C97261ECBD", "updates": {"payload": {"name": "SABIR MOHAMMED S", "id": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "designation": "Employee", "email": "sabirmohammeds@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-09", "toDate": "2026-10-09", "reason": "casual leave", "remarks": "casual leave", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T14:22:46.369Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "gkbharath", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T15:00:08.087Z"}, {"by": "santhanakumarv", "comment": "Approved", "decision": "approve", "at": "2026-10-17T14:59:24.299Z"}, {"by": "hareeshv", "comment": "casual leave", "decision": "approve", "at": "2026-10-17T14:22:54.550Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792249164314-839', '2026-10-17T14:59:24.314Z'::timestamptz, 'request:forward', 'santhanakumarv', 'user-003', '{"requestId": "SMIB-REQ-2026-01605CF8-4772-447A-A88E-54C97261ECBD", "from": "santhanakumarv", "to": "gkbharath", "remarks": "Approved"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792249164304-445', '2026-10-17T14:59:24.304Z'::timestamptz, 'request:forwarded', 'gkbharath', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-01605CF8-4772-447A-A88E-54C97261ECBD", "updates": {"payload": {"name": "SABIR MOHAMMED S", "id": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "designation": "Employee", "email": "sabirmohammeds@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-09", "toDate": "2026-10-09", "reason": "casual leave", "remarks": "casual leave", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T14:22:46.369Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "santhanakumarv", "comment": "Approved", "decision": "approve", "at": "2026-10-17T14:59:24.299Z"}, {"by": "hareeshv", "comment": "casual leave", "decision": "approve", "at": "2026-10-17T14:22:54.550Z"}]}, "forwardedTo": "gkbharath"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792249151137-155', '2026-10-17T14:59:11.137Z'::timestamptz, 'request:forward', 'santhanakumarv', 'user-003', '{"requestId": "SMIB-REQ-2026-F696527D-E51D-4493-8A3E-FEB93BB407D5", "from": "santhanakumarv", "to": "gkbharath", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792249151134-209', '2026-10-17T14:59:11.134Z'::timestamptz, 'request:forwarded', 'gkbharath', 'founder-001', '{"id": "SMIB-REQ-2026-F696527D-E51D-4493-8A3E-FEB93BB407D5", "updates": {"payload": {"name": "GOLLA KUMAR BHARATH", "id": "founder-001", "designation": "Founder & Chief Executive Partner", "email": "proprietor@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-10", "toDate": "2026-10-10", "reason": "Casual Leave", "remarks": "Casual Leave", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T14:45:08.372Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "santhanakumarv", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T14:59:11.127Z"}, {"by": "hareeshv", "comment": "Casual Leave", "decision": "approve", "at": "2026-10-17T14:45:15.217Z"}]}, "forwardedTo": "gkbharath"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792248974616-976', '2026-10-17T14:56:14.616Z'::timestamptz, 'request:approve', 'gkbharath', 'founder-001', '{"requestId": "SMIB-REQ-2026-BF08B71C-B702-4BE7-9478-58F65674FE30", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792248974612-726', '2026-10-17T14:56:14.612Z'::timestamptz, 'request:approved', 'SANTHANA KUMAR V', 'user-003', '{"id": "SMIB-REQ-2026-BF08B71C-B702-4BE7-9478-58F65674FE30", "updates": {"payload": {"name": "SANTHANA KUMAR V", "id": "user-003", "designation": "Managing Partner - Operations & Business Development", "email": "santhana@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-09", "toDate": "2026-10-09", "reason": "Casual Leave", "remarks": "Casual Leave", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T14:42:33.690Z", "approvalChain": ["hareeshv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "gkbharath", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T14:56:14.607Z"}, {"by": "hareeshv", "comment": "Casual Leave", "decision": "approve", "at": "2026-10-17T14:42:44.081Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792248970174-338', '2026-10-17T14:56:10.174Z'::timestamptz, 'request:approve', 'gkbharath', 'founder-001', '{"requestId": "SMIB-REQ-2026-4AD66B4A-E9BF-4212-B8BE-8144C0581976", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792248970167-925', '2026-10-17T14:56:10.167Z'::timestamptz, 'request:approved', 'HAREESH V', 'user-002', '{"id": "SMIB-REQ-2026-4AD66B4A-E9BF-4212-B8BE-8144C0581976", "updates": {"payload": {"name": "HAREESH V", "id": "user-002", "designation": "Managing Partner - Projects & Administration", "email": "hareesh@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-05", "toDate": "2026-10-05", "reason": "Casual Leave", "remarks": "Casual Leave", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T14:11:03.346Z", "approvalChain": ["santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "gkbharath", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T14:56:10.158Z"}, {"by": "santhanakumarv", "comment": "Approved", "decision": "approve", "at": "2026-10-17T14:11:53.410Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792248396727-618', '2026-10-17T14:46:36.727Z'::timestamptz, 'request:forward', 'hareeshv', 'user-002', '{"requestId": "SMIB-REQ-2026-E9A8AA0B-6555-4A10-B94C-8FE03F56F842", "from": "hareeshv", "to": "santhanakumarv", "remarks": "Approve"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792248396724-896', '2026-10-17T14:46:36.724Z'::timestamptz, 'request:forwarded', 'santhanakumarv', 'founder-001', '{"id": "SMIB-REQ-2026-E9A8AA0B-6555-4A10-B94C-8FE03F56F842", "updates": {"payload": {"name": "GOLLA KUMAR BHARATH", "id": "founder-001", "designation": "Founder & Chief Executive Partner", "email": "proprietor@suryas.in", "claimType": "expenses", "amount": "300", "description": "petrol", "remarks": "petrol", "filledFormFileName": "", "billFileName": "", "submittedAt": "2026-10-17T14:46:21.506Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "hareeshv", "comment": "Approve", "decision": "approve", "at": "2026-10-17T14:46:36.717Z"}]}, "forwardedTo": "santhanakumarv"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792248381629-302', '2026-10-17T14:46:21.629Z'::timestamptz, 'request:created', 'GOLLA KUMAR BHARATH', 'founder-001', '{"id": "SMIB-REQ-2026-E9A8AA0B-6555-4A10-B94C-8FE03F56F842", "type": "ta", "title": "Allowance Claim Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792248315226-585', '2026-10-17T14:45:15.226Z'::timestamptz, 'request:forward', 'hareeshv', 'user-002', '{"requestId": "SMIB-REQ-2026-F696527D-E51D-4493-8A3E-FEB93BB407D5", "from": "hareeshv", "to": "santhanakumarv", "remarks": "Casual Leave"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792248315223-758', '2026-10-17T14:45:15.223Z'::timestamptz, 'request:forwarded', 'santhanakumarv', 'founder-001', '{"id": "SMIB-REQ-2026-F696527D-E51D-4493-8A3E-FEB93BB407D5", "updates": {"payload": {"name": "GOLLA KUMAR BHARATH", "id": "founder-001", "designation": "Founder & Chief Executive Partner", "email": "proprietor@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-10", "toDate": "2026-10-10", "reason": "Casual Leave", "remarks": "Casual Leave", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T14:45:08.372Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "hareeshv", "comment": "Casual Leave", "decision": "approve", "at": "2026-10-17T14:45:15.217Z"}]}, "forwardedTo": "santhanakumarv"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792248308471-570', '2026-10-17T14:45:08.471Z'::timestamptz, 'request:created', 'GOLLA KUMAR BHARATH', 'founder-001', '{"id": "SMIB-REQ-2026-F696527D-E51D-4493-8A3E-FEB93BB407D5", "type": "leave", "title": "Past-Date PERSONAL Leave Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792248164099-829', '2026-10-17T14:42:44.099Z'::timestamptz, 'request:forward', 'hareeshv', 'user-002', '{"requestId": "SMIB-REQ-2026-BF08B71C-B702-4BE7-9478-58F65674FE30", "from": "hareeshv", "to": "gkbharath", "remarks": "Casual Leave"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792248164095-783', '2026-10-17T14:42:44.095Z'::timestamptz, 'request:forwarded', 'gkbharath', 'user-003', '{"id": "SMIB-REQ-2026-BF08B71C-B702-4BE7-9478-58F65674FE30", "updates": {"payload": {"name": "SANTHANA KUMAR V", "id": "user-003", "designation": "Managing Partner - Operations & Business Development", "email": "santhana@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-09", "toDate": "2026-10-09", "reason": "Casual Leave", "remarks": "Casual Leave", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T14:42:33.690Z", "approvalChain": ["hareeshv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "hareeshv", "comment": "Casual Leave", "decision": "approve", "at": "2026-10-17T14:42:44.081Z"}]}, "forwardedTo": "gkbharath"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792248153827-34', '2026-10-17T14:42:33.827Z'::timestamptz, 'request:created', 'SANTHANA KUMAR V', 'user-003', '{"id": "SMIB-REQ-2026-BF08B71C-B702-4BE7-9478-58F65674FE30", "type": "leave", "title": "Past-Date PERSONAL Leave Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792246974558-739', '2026-10-17T14:22:54.558Z'::timestamptz, 'request:forward', 'hareeshv', 'user-002', '{"requestId": "SMIB-REQ-2026-01605CF8-4772-447A-A88E-54C97261ECBD", "from": "hareeshv", "to": "santhanakumarv", "remarks": "casual leave"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792246974556-53', '2026-10-17T14:22:54.556Z'::timestamptz, 'request:forwarded', 'santhanakumarv', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-01605CF8-4772-447A-A88E-54C97261ECBD", "updates": {"payload": {"name": "SABIR MOHAMMED S", "id": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "designation": "Employee", "email": "sabirmohammeds@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-09", "toDate": "2026-10-09", "reason": "casual leave", "remarks": "casual leave", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T14:22:46.369Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "hareeshv", "comment": "casual leave", "decision": "approve", "at": "2026-10-17T14:22:54.550Z"}]}, "forwardedTo": "santhanakumarv"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792246966466-127', '2026-10-17T14:22:46.466Z'::timestamptz, 'request:created', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-01605CF8-4772-447A-A88E-54C97261ECBD", "type": "leave", "title": "Past-Date PERSONAL Leave Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792246313427-641', '2026-10-17T14:11:53.427Z'::timestamptz, 'request:forward', 'santhanakumarv', 'user-003', '{"requestId": "SMIB-REQ-2026-4AD66B4A-E9BF-4212-B8BE-8144C0581976", "from": "santhanakumarv", "to": "gkbharath", "remarks": "Approved"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792246313420-441', '2026-10-17T14:11:53.420Z'::timestamptz, 'request:forwarded', 'gkbharath', 'user-002', '{"id": "SMIB-REQ-2026-4AD66B4A-E9BF-4212-B8BE-8144C0581976", "updates": {"payload": {"name": "HAREESH V", "id": "user-002", "designation": "Managing Partner - Projects & Administration", "email": "hareesh@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-05", "toDate": "2026-10-05", "reason": "Casual Leave", "remarks": "Casual Leave", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T14:11:03.346Z", "approvalChain": ["santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "santhanakumarv", "comment": "Approved", "decision": "approve", "at": "2026-10-17T14:11:53.410Z"}]}, "forwardedTo": "gkbharath"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792246301969-997', '2026-10-17T14:11:41.969Z'::timestamptz, 'request:forward', 'hareeshv', 'user-002', '{"requestId": "SMIB-REQ-2026-8ED5C87C-86D6-4F2A-B356-B7F176A0987D", "from": "hareeshv", "to": "santhanakumarv", "remarks": "Subject to Verify the Bill"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792246301964-976', '2026-10-17T14:11:41.964Z'::timestamptz, 'request:forwarded', 'santhanakumarv', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-8ED5C87C-86D6-4F2A-B356-B7F176A0987D", "updates": {"payload": {"name": "SABIR MOHAMMED S", "id": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "designation": "Employee", "email": "sabirmohammeds@suryas.in", "claimType": "expenses", "amount": "300", "description": "RSR FOOD", "remarks": "REQUEST TO APPROVE", "filledFormFileName": "", "billFileName": "", "submittedAt": "2026-10-17T14:10:22.436Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "hareeshv", "comment": "Subject to Verify the Bill", "decision": "approve", "at": "2026-10-17T14:11:41.954Z"}]}, "forwardedTo": "santhanakumarv"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792246263444-670', '2026-10-17T14:11:03.444Z'::timestamptz, 'request:created', 'HAREESH V', 'user-002', '{"id": "SMIB-REQ-2026-4AD66B4A-E9BF-4212-B8BE-8144C0581976", "type": "leave", "title": "Past-Date PERSONAL Leave Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792246222546-863', '2026-10-17T14:10:22.546Z'::timestamptz, 'request:created', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-8ED5C87C-86D6-4F2A-B356-B7F176A0987D", "type": "ta", "title": "Allowance Claim Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792246067635-891', '2026-10-17T14:07:47.635Z'::timestamptz, 'request:forward', 'hareeshv', 'user-002', '{"requestId": "SMIB-REQ-2026-E60BE6C2-A700-48B3-A454-9C2C9ECE562D", "from": "hareeshv", "to": "santhanakumarv", "remarks": "Casual Leave Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792246067620-887', '2026-10-17T14:07:47.621Z'::timestamptz, 'request:forwarded', 'santhanakumarv', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-E60BE6C2-A700-48B3-A454-9C2C9ECE562D", "updates": {"payload": {"name": "SABIR MOHAMMED S", "id": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "designation": "Employee", "email": "sabirmohammeds@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-10-12", "toDate": "2026-10-12", "reason": "Casual Leave", "remarks": "Request to Approve.", "isPastDateRequest": true, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-10-17T14:07:04.796Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "hareeshv", "comment": "Casual Leave Approved.", "decision": "approve", "at": "2026-10-17T14:07:47.599Z"}]}, "forwardedTo": "santhanakumarv"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792246025299-748', '2026-10-17T14:07:05.299Z'::timestamptz, 'request:created', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-E60BE6C2-A700-48B3-A454-9C2C9ECE562D", "type": "leave", "title": "Past-Date PERSONAL Leave Request"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792243350907-566', '2026-10-17T13:22:30.907Z'::timestamptz, 'request:approve', 'gkbharath', 'founder-001', '{"requestId": "SMIB-REQ-2026-88CA292D-AA64-43D0-8521-21C4FAAA1E0A", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792243350902-615', '2026-10-17T13:22:30.902Z'::timestamptz, 'request:approved', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-88CA292D-AA64-43D0-8521-21C4FAAA1E0A", "updates": {"payload": {"description": "RSR NELLORE-PCB FAB DONE.", "reportFrequency": "weekly", "attachments": [], "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "gkbharath", "comment": "Approved.", "decision": "approve", "at": "2026-10-17T13:22:30.892Z"}, {"by": "santhanakumarv", "comment": "Recommed", "decision": "approve", "at": "2026-10-17T13:22:06.800Z"}, {"by": "hareeshv", "comment": "Recommeded", "decision": "approve", "at": "2026-10-17T13:17:08.839Z"}]}}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792243326815-616', '2026-10-17T13:22:06.815Z'::timestamptz, 'request:forward', 'santhanakumarv', 'user-003', '{"requestId": "SMIB-REQ-2026-88CA292D-AA64-43D0-8521-21C4FAAA1E0A", "from": "santhanakumarv", "to": "gkbharath", "remarks": "Recommed"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792243326810-163', '2026-10-17T13:22:06.810Z'::timestamptz, 'request:forwarded', 'gkbharath', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-88CA292D-AA64-43D0-8521-21C4FAAA1E0A", "updates": {"payload": {"description": "RSR NELLORE-PCB FAB DONE.", "reportFrequency": "weekly", "attachments": [], "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "santhanakumarv", "comment": "Recommed", "decision": "approve", "at": "2026-10-17T13:22:06.800Z"}, {"by": "hareeshv", "comment": "Recommeded", "decision": "approve", "at": "2026-10-17T13:17:08.839Z"}]}, "forwardedTo": "gkbharath"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792243205293-408', '2026-10-17T13:20:05.293Z'::timestamptz, 'request:forward', 'hareeshv', 'user-002', '{"requestId": "SMIB-REQ-2026-DABAE5BB-9B07-4923-9EC9-16F8F2CE753F", "from": "hareeshv", "to": "santhanakumarv", "remarks": "Quote need to Prepare"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792243205288-262', '2026-10-17T13:20:05.288Z'::timestamptz, 'request:forwarded', 'santhanakumarv', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-DABAE5BB-9B07-4923-9EC9-16F8F2CE753F", "updates": {"payload": {"projectTitle": "Teqtis Info Pvt Ltd", "projectStatus": "in-progress", "createdBy": "SABIR MOHAMMED S", "abstractFileName": "Hybrid_Urinal_Controller_FINAL_Manufacturer_Spec.pdf", "clientName": "Teqtis Info Pvt Ltd", "clientOrganization": "", "clientDesignation": "", "clientAddress": "", "clientPhone": "", "clientEmail": "", "projectAmount": "", "forwardedBy": "", "submittedAt": "2026-10-17T13:10:58.268Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "hareeshv", "comment": "Quote need to Prepare", "decision": "approve", "at": "2026-10-17T13:20:05.280Z"}]}, "forwardedTo": "santhanakumarv"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792243028859-849', '2026-10-17T13:17:08.859Z'::timestamptz, 'request:forward', 'hareeshv', 'user-002', '{"requestId": "SMIB-REQ-2026-88CA292D-AA64-43D0-8521-21C4FAAA1E0A", "from": "hareeshv", "to": "santhanakumarv", "remarks": "Recommeded"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792243028854-311', '2026-10-17T13:17:08.854Z'::timestamptz, 'request:forwarded', 'santhanakumarv', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-88CA292D-AA64-43D0-8521-21C4FAAA1E0A", "updates": {"payload": {"description": "RSR NELLORE-PCB FAB DONE.", "reportFrequency": "weekly", "attachments": [], "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "hareeshv", "comment": "Recommeded", "decision": "approve", "at": "2026-10-17T13:17:08.839Z"}]}, "forwardedTo": "santhanakumarv"}}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792242658385-939', '2026-10-17T13:10:58.385Z'::timestamptz, 'request:created', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-DABAE5BB-9B07-4923-9EC9-16F8F2CE753F", "type": "proposal", "title": "Project Proposal"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792242446536-434', '2026-10-17T13:07:26.536Z'::timestamptz, 'internal-request:status-updated', 'hareeshv', 'user-002', '{"requestId": "req-1792242412678", "newStatus": "completed"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792242412705-333', '2026-10-17T13:06:52.705Z'::timestamptz, 'internal-request:created', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "req-1792242412678", "description": "Hi Hareesh V,"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792242412692-687', '2026-10-17T13:06:52.692Z'::timestamptz, 'request:created', 'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "req-1792242412678", "type": "internal-service", "title": "Internal Service Request from SABIR MOHAMMED S"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792242254293-410', '2026-10-17T13:04:14.293Z'::timestamptz, 'report:submitted', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-88CA292D-AA64-43D0-8521-21C4FAAA1E0A", "title": "RSR NELLORE", "reportFrequency": "weekly", "remarks": "ALL GOOD"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792242254285-752', '2026-10-17T13:04:14.285Z'::timestamptz, 'request:created', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '{"id": "SMIB-REQ-2026-88CA292D-AA64-43D0-8521-21C4FAAA1E0A", "type": "report", "title": "RSR NELLORE"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792242133951-846', '2026-10-17T13:02:13.951Z'::timestamptz, 'registration:approved', 'gkbharath', 'founder-001', '{"userId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "stage": 2, "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792242117026-557', '2026-10-17T13:01:57.026Z'::timestamptz, 'registration:forwarded', 'santhanakumarv', 'user-003', '{"userId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "stage": 1, "nextApprover": "gkbharath", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792242012949-685', '2026-10-17T13:00:12.949Z'::timestamptz, 'registration:forwarded', 'hareeshv', 'user-002', '{"userId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "stage": 0, "nextApprover": "santhanakumarv", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-ab0de2a1-449a-47d3-860d-457a897f5d3b', '2026-10-17T10:01:05.945Z'::timestamptz, 'system:fresh_reset', 'workspace-operator', 'founder-001', '{"retainedUserIds": ["founder-001", "user-003", "user-002"], "removedUsers": 1, "requestsCleared": true, "notificationsCleared": true, "guestRecordsCleared": true, "ledgerReset": true, "eventsCleared": true, "passwordValuesRecorded": false}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792231015323-297', '2026-10-17T09:56:55.323Z'::timestamptz, 'registration:approved', 'gkbharath', 'founder-001', '{"userId": "SMIB-EMP-849a77c3-c9e8-4c34-a7f0-ad906abcfbc9", "stage": 2, "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792231000449-664', '2026-10-17T09:56:40.449Z'::timestamptz, 'registration:forwarded', 'santhanakumarv', 'user-003', '{"userId": "SMIB-EMP-849a77c3-c9e8-4c34-a7f0-ad906abcfbc9", "stage": 1, "nextApprover": "gkbharath", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792230984365-482', '2026-10-17T09:56:24.365Z'::timestamptz, 'registration:forwarded', 'hareeshv', 'user-002', '{"userId": "SMIB-EMP-849a77c3-c9e8-4c34-a7f0-ad906abcfbc9", "stage": 0, "nextApprover": "santhanakumarv", "remarks": "Approved."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792230871014-872', '2026-10-17T09:54:31.014Z'::timestamptz, 'registration:workflow_migrated', 'system', NULL, '{"userId": "SMIB-EMP-849a77c3-c9e8-4c34-a7f0-ad906abcfbc9", "previousStage": 0, "approvalStage": 0}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792230323855-940', '2026-10-17T09:45:23.855Z'::timestamptz, 'internal-request:replied', 'gkbharath', 'founder-001', '{"requestId": "req-1792230162272", "message": "Ok"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792230212841-810', '2026-10-17T09:43:32.841Z'::timestamptz, 'internal-request:replied', 'santhanakumarv', 'user-003', '{"requestId": "req-1792230162272", "message": "Yes Please Follow Up"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792230162297-577', '2026-10-17T09:42:42.298Z'::timestamptz, 'internal-request:created', 'GOLLA KUMAR BHARATH', 'founder-001', '{"id": "req-1792230162272", "description": "Hi Bharath, Please Follow up the Netwokring Quote 1.5 L."}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792230162282-856', '2026-10-17T09:42:42.282Z'::timestamptz, 'request:created', 'GOLLA KUMAR BHARATH', 'founder-001', '{"id": "req-1792230162272", "type": "internal-service", "title": "Internal Service Request from GOLLA KUMAR BHARATH"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792230065264-463', '2026-10-17T09:41:05.264Z'::timestamptz, 'auth:password_changed', 'gkbharath', 'founder-001', '{"userId": "founder-001"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792230018797-160', '2026-10-17T09:40:18.797Z'::timestamptz, 'auth:password_changed', 'santhanakumarv', 'user-003', '{"userId": "user-003"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-1792229931840-867', '2026-10-17T09:38:51.840Z'::timestamptz, 'auth:password_changed', 'hareeshv', 'user-002', '{"userId": "user-002"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-2142f0b2-695e-45e8-9e4e-7d40ed6e19ea', '2026-10-17T09:34:42.616Z'::timestamptz, 'auth:leadership_credentials_updated', 'workspace-operator', 'founder-001', '{"users": [{"id": "founder-001", "username": "gkbharath", "role": "founder"}, {"id": "user-003", "username": "santhanakumarv", "role": "managing-partner"}, {"id": "user-002", "username": "hareeshv", "role": "managing-partner"}], "passwordRecorded": false}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.audit_logs (
  id, timestamp, action, actor, actor_id, details
) VALUES (
  'audit-7aaf4445-443d-4a74-86a8-354d8fca8348', '2026-10-17T09:31:53.102Z'::timestamptz, 'system:fresh_reset', 'workspace-operator', 'founder-001', '{"retainedUserIds": ["founder-001", "user-003", "user-002"], "removedUserCount": 2, "passwordValuesRecorded": false}'::jsonb
) ON CONFLICT (id) DO NOTHING;


-- ==================== VERIFICATION ====================
SELECT 'users' as table_name, count(*) as record_count FROM public.users
UNION ALL SELECT 'requests', count(*) FROM public.requests
UNION ALL SELECT 'attendance', count(*) FROM public.attendance
UNION ALL SELECT 'notifications', count(*) FROM public.notifications
UNION ALL SELECT 'tasks', count(*) FROM public.tasks
UNION ALL SELECT 'circulars', count(*) FROM public.circulars
UNION ALL SELECT 'audit_logs', count(*) FROM public.audit_logs
UNION ALL SELECT 'company_ledger', count(*) FROM public.company_ledger;
