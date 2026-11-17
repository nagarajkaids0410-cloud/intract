-- ====================================================================
-- SURYAS MiB ENTERPRISES - HISTORICAL BACKUP DATA MIGRATION
-- Includes extra requests, guest inquiries, and past users from .data/backups
-- ====================================================================

-- ==================== GUEST INQUIRIES ====================

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

INSERT INTO public.guest_inquiries (
  id, name, email, phone, purpose, message, status, created_at, meta
) VALUES (
  'inquiry-1770793715313', 'Manigandan C', 'manigandanc@gmail.com', NULL, 'HI', 'HI', 'new', '2026-02-11T07:08:35.313Z'::timestamptz, '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status;


-- ==================== HISTORICAL REQUESTS ====================
INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  'req-1792228562545', NULL, 'internal-service', 'Internal Service Request from G K BHARATH', 'pending', 'admin',
  'G K BHARATH', 'founder-001', 'legacy',
  '2026-10-17T09:16:02.545Z'::timestamptz, '2026-10-17T09:16:02.545Z'::timestamptz, '{"createdByRole": "founder", "createdByDesignation": "FOUNDER", "payload": {"description": "Hi", "remarks": "", "files": [], "status": "pending", "replies": []}}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  'req-1770795011526', NULL, 'certificate', 'Certificate Request', 'pending', 'admin',
  'Mr. R. ABINESH B.E.(ECE).', 'contact-006', 'legacy',
  '2026-02-11T07:30:11.527Z'::timestamptz, '2026-02-11T07:30:11.527Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "Intern", "payload": {"fullName": "Mr. R. ABINESH B.E.(ECE).", "empId": "contact-006", "mentorName": "JAYEDRA M", "mentorPhone": "", "mentorEmail": "", "collegeName": "MKCE", "yearDept": "FINAL YEAR", "certificateType": "intern", "noDemandFileName": "1.pdf", "reportFileName": "1.pdf", "forwardedBy": "HARESH V", "submittedAt": "2026-02-11T07:30:11.503Z"}, "remarks": "NIL", "uploadedFile": {"name": "1.pdf", "size": 225083, "type": "application/pdf", "base64": "[FILE_STRIPPED]", "uploadedAt": "2026-02-11T07:30:11.503Z"}, "signatureFrom": "Hareesh"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  'req-1770794230137', NULL, 'report', 'Weekly Report', 'pending', 'admin',
  'Mr. R. ABINESH B.E.(ECE).', 'contact-006', 'legacy',
  '2026-02-11T07:17:10.137Z'::timestamptz, '2026-02-11T07:17:10.137Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "Intern", "payload": {"name": "Mr. R. ABINESH B.E.(ECE).", "id": "contact-006", "reportContent": "Hi Sir This week report", "reportFileName": "1.pdf", "reportType": "weekly", "submittedAt": "2026-02-11T07:17:10.115Z"}, "uploadedFile": {"name": "1.pdf", "size": 225083, "type": "application/pdf", "base64": "[FILE_STRIPPED]", "uploadedAt": "2026-02-11T07:17:10.115Z"}, "signatureFrom": "Hareesh"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  'req-1770794043300', NULL, 'proposal', 'Project Proposal', 'rejected', 'admin',
  'Mr. R. ABINESH B.E.(ECE).', 'contact-006', 'legacy',
  '2026-02-11T07:14:03.300Z'::timestamptz, '2026-02-11T07:41:12.252Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "Intern", "payload": {"projectTitle": "Auto-log of Resistance and Insolation - Product", "projectStatus": "review", "createdBy": "Mr. R. ABINESH B.E.(ECE).", "abstractFileName": "Letter.pdf", "clientName": "NA", "clientOrganization": "NA", "clientDesignation": "NA", "clientAddress": "NA", "clientPhone": "NA", "clientEmail": "NA@NA.COM", "projectAmount": "0", "forwardedBy": "SATHANA KUMAR V", "submittedAt": "2026-02-11T07:14:03.257Z"}, "uploadedFile": {"name": "Letter.pdf", "size": 578636, "type": "application/pdf", "base64": "[FILE_STRIPPED]", "uploadedAt": "2026-02-11T07:14:03.257Z"}, "signatureFrom": "Hareesh"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  'req-1770793900729', NULL, 'ta', 'Allowance Claim Request', 'rejected', 'admin',
  'Mr. R. ABINESH B.E.(ECE).', 'contact-006', 'legacy',
  '2026-02-11T07:11:40.729Z'::timestamptz, '2026-02-11T07:35:16.246Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "Intern", "payload": {"name": "Mr. R. ABINESH B.E.(ECE).", "id": "contact-006", "designation": "Intern", "email": "pcb.designers@suryas.in", "claimType": "expenses", "amount": "4630", "description": "For College and Companies Visit By PCB Desgin Team.", "remarks": "", "filledFormFileName": "", "billFileName": "", "submittedAt": "2026-02-11T07:11:40.715Z"}, "signatureFrom": "Hareesh"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  'req-1770793853422', NULL, 'leave', 'PERSONAL Leave Request', 'rejected', 'admin',
  'Mr. R. ABINESH B.E.(ECE).', 'contact-006', 'legacy',
  '2026-02-11T07:10:53.422Z'::timestamptz, '2026-02-11T07:35:07.463Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "Intern", "payload": {"name": "Mr. R. ABINESH B.E.(ECE).", "id": "contact-006", "designation": "Intern", "email": "pcb.designers@suryas.in", "phone": "", "leaveType": "personal", "fromDate": "2026-02-11", "toDate": "2026-02-11", "reason": "Personal", "remarks": "", "isPastDateRequest": false, "filledFormFileName": "", "medicalCertificateName": "", "medicalProofName": "", "submittedAt": "2026-02-11T07:10:52.436Z"}, "signatureFrom": "Hareesh"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  'req-1792230162272', NULL, 'internal-service', 'Internal Service Request from GOLLA KUMAR BHARATH', 'pending', 'admin',
  'GOLLA KUMAR BHARATH', 'founder-001', 'legacy',
  '2026-10-17T09:42:42.272Z'::timestamptz, '2026-10-17T09:45:23.849Z'::timestamptz, '{"createdByRole": "founder", "createdByDesignation": "Founder & Chief Executive Partner", "payload": {"description": "Hi Bharath, Please Follow up the Netwokring Quote 1.5 L.", "remarks": "", "files": [], "status": "pending", "assignedHeadId": "user-003", "replies": [{"repliedBy": "santhanakumarv", "repliedById": "user-003", "repliedAt": "2026-10-17T09:43:32.833Z", "message": "Yes Please Follow Up"}, {"repliedBy": "gkbharath", "repliedById": "founder-001", "repliedAt": "2026-10-17T09:45:23.846Z", "message": "Ok"}]}}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  payload = EXCLUDED.payload;


-- ==================== HISTORICAL USERS (JayendranM) ====================
INSERT INTO public.users (
  id, employee_id, username, email, password_hash, role, employment_type,
  full_name, phone, designation, department, status, must_change_password,
  session_version, email_verified, is_profile_completed, created_at, approved_at
) VALUES (
  'admin-001', 'MIB00', 'JayendranM', 'administrator@suryas.in',
  '$2b$10$Ba/u/FCErcSKaqGZ2KR0y.G1OijRFl5nugGPkz/HT4OHr97X6rOy6', 'admin', 'full-time',
  'JAYEDRA M', '', 'Administrator', 'Management',
  'active', FALSE, 0,
  TRUE, TRUE,
  '2026-10-17 08:34:51.731Z'::timestamptz, '2026-10-17 08:34:51.731Z'::timestamptz
) ON CONFLICT (id) DO NOTHING;


-- ==================== VERIFICATION ====================
SELECT 'users' as table_name, count(*) as record_count FROM public.users
UNION ALL SELECT 'requests', count(*) FROM public.requests
UNION ALL SELECT 'attendance', count(*) FROM public.attendance
UNION ALL SELECT 'notifications', count(*) FROM public.notifications
UNION ALL SELECT 'tasks', count(*) FROM public.tasks
UNION ALL SELECT 'circulars', count(*) FROM public.circulars
UNION ALL SELECT 'audit_logs', count(*) FROM public.audit_logs
UNION ALL SELECT 'company_ledger', count(*) FROM public.company_ledger
UNION ALL SELECT 'guest_inquiries', count(*) FROM public.guest_inquiries;
