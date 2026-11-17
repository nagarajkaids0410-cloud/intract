-- ====================================================================
-- SURYAS MiB ENTERPRISES - COMPLETE MASTER DATABASE MIGRATION SCRIPT
-- All Users, 68 Attendance records, 64 Requests, 17 Tasks, Ledger, Circulars, Logs
-- ====================================================================

-- ==================== TABLE DEFINITIONS ====================

CREATE TABLE IF NOT EXISTS public.users (
  id TEXT PRIMARY KEY,
  employee_id TEXT,
  username TEXT UNIQUE NOT NULL,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'intern',
  employment_type TEXT DEFAULT 'full-time',
  full_name TEXT NOT NULL,
  phone TEXT,
  profile_photo TEXT,
  designation TEXT DEFAULT 'User',
  department TEXT,
  guide_id TEXT,
  guide_name TEXT,
  status TEXT NOT NULL DEFAULT 'pending_approval',
  must_change_password BOOLEAN DEFAULT FALSE,
  session_version INTEGER DEFAULT 0,
  approval_stage INTEGER DEFAULT 0,
  registration_approval_version INTEGER DEFAULT 3,
  approval_history JSONB DEFAULT '[]'::jsonb,
  approval_remarks TEXT,
  approved_at TIMESTAMPTZ,
  requested_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  email_verified BOOLEAN DEFAULT FALSE,
  verification_token TEXT,
  reset_token TEXT,
  reset_token_expires_at TIMESTAMPTZ,
  is_profile_completed BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS public.requests (
  id TEXT PRIMARY KEY,
  submission_id TEXT,
  type TEXT NOT NULL,
  title TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  target TEXT DEFAULT 'admin',
  created_by TEXT NOT NULL,
  created_by_id TEXT NOT NULL,
  created_by_username TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ,
  payload JSONB DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS public.attendance (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  username TEXT NOT NULL,
  full_name TEXT NOT NULL,
  date TEXT NOT NULL,
  check_in TIMESTAMPTZ NOT NULL,
  check_out TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS public.notifications (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  target_user TEXT NOT NULL,
  related_id TEXT,
  read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

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

CREATE INDEX IF NOT EXISTS idx_users_username ON public.users(username);
CREATE INDEX IF NOT EXISTS idx_users_email ON public.users(email);
CREATE INDEX IF NOT EXISTS idx_attendance_user_date ON public.attendance(user_id, date);
CREATE INDEX IF NOT EXISTS idx_requests_created_by ON public.requests(created_by_id);
CREATE INDEX IF NOT EXISTS idx_tasks_assigned_to ON public.tasks(assigned_to_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_timestamp ON public.audit_logs(timestamp DESC);

-- ==================== USERS ====================
INSERT INTO public.users (
  id, employee_id, username, email, password_hash, role, employment_type,
  full_name, phone, profile_photo, designation, department, guide_id, guide_name,
  status, must_change_password, session_version, approval_stage,
  registration_approval_version, approval_history, approval_remarks, approved_at,
  requested_at, created_at, email_verified, verification_token,
  reset_token, reset_token_expires_at, is_profile_completed
) VALUES (
  'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'MIB04', 'sabir', 'sabirmohammeds@suryas.in', '$2b$12$5rSLrHKbwwhsWFyQfuJku.JMXUIKNwtk7iAu5Ge.edTLiMYeZDH3S', 'employee', 'full-time',
  'SABIR MOHAMMED S', '8754479660', NULL, 'PCB Fabrication Engineer', 'PCB Designs & Fabrication Team', NULL, NULL,
  'active', FALSE, 36, 2,
  3, '[]'::jsonb, NULL, '2026-10-17 13:02:13.911000+00:00'::timestamptz,
  '2026-10-17 12:58:52.238000+00:00'::timestamptz, '2026-10-17 12:58:52.238000+00:00'::timestamptz, TRUE, NULL,
  NULL, NULL::timestamptz, TRUE
) ON CONFLICT (id) DO UPDATE SET
  employee_id = EXCLUDED.employee_id,
  username = EXCLUDED.username,
  email = EXCLUDED.email,
  password_hash = EXCLUDED.password_hash,
  role = EXCLUDED.role,
  employment_type = EXCLUDED.employment_type,
  full_name = EXCLUDED.full_name,
  phone = EXCLUDED.phone,
  designation = EXCLUDED.designation,
  department = EXCLUDED.department,
  guide_id = EXCLUDED.guide_id,
  guide_name = EXCLUDED.guide_name,
  status = EXCLUDED.status,
  must_change_password = EXCLUDED.must_change_password,
  session_version = EXCLUDED.session_version,
  approval_stage = EXCLUDED.approval_stage,
  registration_approval_version = EXCLUDED.registration_approval_version,
  approval_history = EXCLUDED.approval_history,
  approval_remarks = EXCLUDED.approval_remarks,
  approved_at = EXCLUDED.approved_at,
  requested_at = EXCLUDED.requested_at,
  email_verified = EXCLUDED.email_verified,
  is_profile_completed = EXCLUDED.is_profile_completed;

INSERT INTO public.users (
  id, employee_id, username, email, password_hash, role, employment_type,
  full_name, phone, profile_photo, designation, department, guide_id, guide_name,
  status, must_change_password, session_version, approval_stage,
  registration_approval_version, approval_history, approval_remarks, approved_at,
  requested_at, created_at, email_verified, verification_token,
  reset_token, reset_token_expires_at, is_profile_completed
) VALUES (
  'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'MIB05', 'vishnuu', 'pcb.designers@suryas.in', '$2b$12$OOlRAOPfYz2S/rK6ti/CMe8.vEgndxBWy0ijDISF8Gz2mE1xnJ76S', 'employee', 'full-time',
  'VISHNU VARSHINI M', '6380551370', NULL, 'PCB & EMS/IoT Designer-T', 'PCB Designs & Fabrication Team', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'SABIR MOHAMMED S',
  'active', FALSE, 9, 2,
  3, '[]'::jsonb, NULL, '2026-10-17 16:50:21.073000+00:00'::timestamptz,
  '2026-10-17 16:48:15.424000+00:00'::timestamptz, '2026-10-17 16:48:15.424000+00:00'::timestamptz, TRUE, NULL,
  NULL, NULL::timestamptz, TRUE
) ON CONFLICT (id) DO UPDATE SET
  employee_id = EXCLUDED.employee_id,
  username = EXCLUDED.username,
  email = EXCLUDED.email,
  password_hash = EXCLUDED.password_hash,
  role = EXCLUDED.role,
  employment_type = EXCLUDED.employment_type,
  full_name = EXCLUDED.full_name,
  phone = EXCLUDED.phone,
  designation = EXCLUDED.designation,
  department = EXCLUDED.department,
  guide_id = EXCLUDED.guide_id,
  guide_name = EXCLUDED.guide_name,
  status = EXCLUDED.status,
  must_change_password = EXCLUDED.must_change_password,
  session_version = EXCLUDED.session_version,
  approval_stage = EXCLUDED.approval_stage,
  registration_approval_version = EXCLUDED.registration_approval_version,
  approval_history = EXCLUDED.approval_history,
  approval_remarks = EXCLUDED.approval_remarks,
  approved_at = EXCLUDED.approved_at,
  requested_at = EXCLUDED.requested_at,
  email_verified = EXCLUDED.email_verified,
  is_profile_completed = EXCLUDED.is_profile_completed;

INSERT INTO public.users (
  id, employee_id, username, email, password_hash, role, employment_type,
  full_name, phone, profile_photo, designation, department, guide_id, guide_name,
  status, must_change_password, session_version, approval_stage,
  registration_approval_version, approval_history, approval_remarks, approved_at,
  requested_at, created_at, email_verified, verification_token,
  reset_token, reset_token_expires_at, is_profile_completed
) VALUES (
  'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', 'MIB06', 'mathi', 'mathiyazhagandhanapalmathiyazh@gmail.com', '$2b$10$SEhLmBDf7eUL.75GGMkBq.wljmE6L2Zw6piUB3Nrp36QKxFzEJtui', 'intern', 'full-time',
  'MATHIYAZHAGAN D', '8056197704', NULL, 'PCB Design Intern', 'PCB Designs & Fabrication Team', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'SABIR MOHAMMED S',
  'suspended', FALSE, 7, 2,
  3, '[]'::jsonb, NULL, '2026-10-18 04:07:32.294000+00:00'::timestamptz,
  '2026-10-18 04:04:57.266000+00:00'::timestamptz, '2026-10-18 04:04:57.266000+00:00'::timestamptz, TRUE, NULL,
  NULL, NULL::timestamptz, TRUE
) ON CONFLICT (id) DO UPDATE SET
  employee_id = EXCLUDED.employee_id,
  username = EXCLUDED.username,
  email = EXCLUDED.email,
  password_hash = EXCLUDED.password_hash,
  role = EXCLUDED.role,
  employment_type = EXCLUDED.employment_type,
  full_name = EXCLUDED.full_name,
  phone = EXCLUDED.phone,
  designation = EXCLUDED.designation,
  department = EXCLUDED.department,
  guide_id = EXCLUDED.guide_id,
  guide_name = EXCLUDED.guide_name,
  status = EXCLUDED.status,
  must_change_password = EXCLUDED.must_change_password,
  session_version = EXCLUDED.session_version,
  approval_stage = EXCLUDED.approval_stage,
  registration_approval_version = EXCLUDED.registration_approval_version,
  approval_history = EXCLUDED.approval_history,
  approval_remarks = EXCLUDED.approval_remarks,
  approved_at = EXCLUDED.approved_at,
  requested_at = EXCLUDED.requested_at,
  email_verified = EXCLUDED.email_verified,
  is_profile_completed = EXCLUDED.is_profile_completed;

INSERT INTO public.users (
  id, employee_id, username, email, password_hash, role, employment_type,
  full_name, phone, profile_photo, designation, department, guide_id, guide_name,
  status, must_change_password, session_version, approval_stage,
  registration_approval_version, approval_history, approval_remarks, approved_at,
  requested_at, created_at, email_verified, verification_token,
  reset_token, reset_token_expires_at, is_profile_completed
) VALUES (
  'SMIB-EMP-8cc825a5-7d82-43b1-accf-684074846929', 'MIB07', 'nidhi', 'admin@hearthaxor.in', '$2b$12$BjUBn5Csm8X01AUfHjhOquBEhqYPvM1UWeKrBhTVCVfFk/g7D4bjO', 'user', 'part-time',
  'NIDHI TIWARI', '8148636158', NULL, 'AI Engineer - C', 'Software Team', NULL, NULL,
  'active', FALSE, 0, 0,
  3, '[]'::jsonb, NULL, '2026-10-19 10:01:58.271000+00:00'::timestamptz,
  '2026-10-19 10:01:58.271000+00:00'::timestamptz, '2026-10-19 10:01:58.271000+00:00'::timestamptz, TRUE, NULL,
  NULL, NULL::timestamptz, TRUE
) ON CONFLICT (id) DO UPDATE SET
  employee_id = EXCLUDED.employee_id,
  username = EXCLUDED.username,
  email = EXCLUDED.email,
  password_hash = EXCLUDED.password_hash,
  role = EXCLUDED.role,
  employment_type = EXCLUDED.employment_type,
  full_name = EXCLUDED.full_name,
  phone = EXCLUDED.phone,
  designation = EXCLUDED.designation,
  department = EXCLUDED.department,
  guide_id = EXCLUDED.guide_id,
  guide_name = EXCLUDED.guide_name,
  status = EXCLUDED.status,
  must_change_password = EXCLUDED.must_change_password,
  session_version = EXCLUDED.session_version,
  approval_stage = EXCLUDED.approval_stage,
  registration_approval_version = EXCLUDED.registration_approval_version,
  approval_history = EXCLUDED.approval_history,
  approval_remarks = EXCLUDED.approval_remarks,
  approved_at = EXCLUDED.approved_at,
  requested_at = EXCLUDED.requested_at,
  email_verified = EXCLUDED.email_verified,
  is_profile_completed = EXCLUDED.is_profile_completed;

INSERT INTO public.users (
  id, employee_id, username, email, password_hash, role, employment_type,
  full_name, phone, profile_photo, designation, department, guide_id, guide_name,
  status, must_change_password, session_version, approval_stage,
  registration_approval_version, approval_history, approval_remarks, approved_at,
  requested_at, created_at, email_verified, verification_token,
  reset_token, reset_token_expires_at, is_profile_completed
) VALUES (
  'SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13', 'MIB08', 'smrithik', 'smrithik2005@gmail.com', '$2b$12$89QW8XMKF4.VE24ohksrV.ErcyUTltZqNduOpa0S4jgowyQc8i27q', 'intern', 'full-time',
  'SMRITHI K', '8610492864', NULL, 'PCB Design Intern', 'PCB Designs & Fabrication Team', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'SABIR MOHAMMED S',
  'active', FALSE, 0, 0,
  3, '[]'::jsonb, NULL, '2026-10-19 10:14:47.293000+00:00'::timestamptz,
  '2026-10-19 10:14:47.293000+00:00'::timestamptz, '2026-10-19 10:14:47.293000+00:00'::timestamptz, TRUE, NULL,
  NULL, NULL::timestamptz, TRUE
) ON CONFLICT (id) DO UPDATE SET
  employee_id = EXCLUDED.employee_id,
  username = EXCLUDED.username,
  email = EXCLUDED.email,
  password_hash = EXCLUDED.password_hash,
  role = EXCLUDED.role,
  employment_type = EXCLUDED.employment_type,
  full_name = EXCLUDED.full_name,
  phone = EXCLUDED.phone,
  designation = EXCLUDED.designation,
  department = EXCLUDED.department,
  guide_id = EXCLUDED.guide_id,
  guide_name = EXCLUDED.guide_name,
  status = EXCLUDED.status,
  must_change_password = EXCLUDED.must_change_password,
  session_version = EXCLUDED.session_version,
  approval_stage = EXCLUDED.approval_stage,
  registration_approval_version = EXCLUDED.registration_approval_version,
  approval_history = EXCLUDED.approval_history,
  approval_remarks = EXCLUDED.approval_remarks,
  approved_at = EXCLUDED.approved_at,
  requested_at = EXCLUDED.requested_at,
  email_verified = EXCLUDED.email_verified,
  is_profile_completed = EXCLUDED.is_profile_completed;

INSERT INTO public.users (
  id, employee_id, username, email, password_hash, role, employment_type,
  full_name, phone, profile_photo, designation, department, guide_id, guide_name,
  status, must_change_password, session_version, approval_stage,
  registration_approval_version, approval_history, approval_remarks, approved_at,
  requested_at, created_at, email_verified, verification_token,
  reset_token, reset_token_expires_at, is_profile_completed
) VALUES (
  'SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb', 'MIB09', 'rithanyad', 'rithanya07cbe@gmail.com', '$2b$12$6kZ5J6s60NFa4AYSqj8SDea0qq3GqETMJjxMKYYDd9Rtp7igG8l5O', 'intern', 'full-time',
  'RITHANYA D', '9384304331', NULL, 'PCB Design Intern', 'PCB Designs & Fabrication Team', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'VISHNU VARSHINI M',
  'active', FALSE, 0, 0,
  3, '[]'::jsonb, NULL, '2026-10-19 10:17:39.102000+00:00'::timestamptz,
  '2026-10-19 10:17:39.102000+00:00'::timestamptz, '2026-10-19 10:17:39.102000+00:00'::timestamptz, TRUE, NULL,
  NULL, NULL::timestamptz, TRUE
) ON CONFLICT (id) DO UPDATE SET
  employee_id = EXCLUDED.employee_id,
  username = EXCLUDED.username,
  email = EXCLUDED.email,
  password_hash = EXCLUDED.password_hash,
  role = EXCLUDED.role,
  employment_type = EXCLUDED.employment_type,
  full_name = EXCLUDED.full_name,
  phone = EXCLUDED.phone,
  designation = EXCLUDED.designation,
  department = EXCLUDED.department,
  guide_id = EXCLUDED.guide_id,
  guide_name = EXCLUDED.guide_name,
  status = EXCLUDED.status,
  must_change_password = EXCLUDED.must_change_password,
  session_version = EXCLUDED.session_version,
  approval_stage = EXCLUDED.approval_stage,
  registration_approval_version = EXCLUDED.registration_approval_version,
  approval_history = EXCLUDED.approval_history,
  approval_remarks = EXCLUDED.approval_remarks,
  approved_at = EXCLUDED.approved_at,
  requested_at = EXCLUDED.requested_at,
  email_verified = EXCLUDED.email_verified,
  is_profile_completed = EXCLUDED.is_profile_completed;

INSERT INTO public.users (
  id, employee_id, username, email, password_hash, role, employment_type,
  full_name, phone, profile_photo, designation, department, guide_id, guide_name,
  status, must_change_password, session_version, approval_stage,
  registration_approval_version, approval_history, approval_remarks, approved_at,
  requested_at, created_at, email_verified, verification_token,
  reset_token, reset_token_expires_at, is_profile_completed
) VALUES (
  'admin-002', 'MIB02', 'hareeshv', 'hareeshv@suryas.in', '$2b$10$Ba/u/FCErcSKaqGZ2KR0y.G1OijRFl5nugGPkz/HT4OHr97X6rOy6', 'managing-partner', 'full-time',
  'HAREESH V', '6383014533', NULL, 'Managing Partner - Projects & Administration', 'Executive Management Team', NULL, NULL,
  'active', FALSE, 1, 0,
  3, '[]'::jsonb, NULL, NULL::timestamptz,
  '2026-11-16 06:12:10.866000+00:00'::timestamptz, '2026-11-16 06:12:10.866144+00:00'::timestamptz, FALSE, NULL,
  NULL, NULL::timestamptz, TRUE
) ON CONFLICT (id) DO UPDATE SET
  employee_id = EXCLUDED.employee_id,
  username = EXCLUDED.username,
  email = EXCLUDED.email,
  password_hash = EXCLUDED.password_hash,
  role = EXCLUDED.role,
  employment_type = EXCLUDED.employment_type,
  full_name = EXCLUDED.full_name,
  phone = EXCLUDED.phone,
  designation = EXCLUDED.designation,
  department = EXCLUDED.department,
  guide_id = EXCLUDED.guide_id,
  guide_name = EXCLUDED.guide_name,
  status = EXCLUDED.status,
  must_change_password = EXCLUDED.must_change_password,
  session_version = EXCLUDED.session_version,
  approval_stage = EXCLUDED.approval_stage,
  registration_approval_version = EXCLUDED.registration_approval_version,
  approval_history = EXCLUDED.approval_history,
  approval_remarks = EXCLUDED.approval_remarks,
  approved_at = EXCLUDED.approved_at,
  requested_at = EXCLUDED.requested_at,
  email_verified = EXCLUDED.email_verified,
  is_profile_completed = EXCLUDED.is_profile_completed;

INSERT INTO public.users (
  id, employee_id, username, email, password_hash, role, employment_type,
  full_name, phone, profile_photo, designation, department, guide_id, guide_name,
  status, must_change_password, session_version, approval_stage,
  registration_approval_version, approval_history, approval_remarks, approved_at,
  requested_at, created_at, email_verified, verification_token,
  reset_token, reset_token_expires_at, is_profile_completed
) VALUES (
  'admin-007', 'MIB10', 'nagarajkaids0410', 'nagarajkaids0410@gmail.com', '$2b$10$Ba/u/FCErcSKaqGZ2KR0y.G1OijRFl5nugGPkz/HT4OHr97X6rOy6', 'admin', 'full-time',
  'Nagaraj K', NULL, NULL, 'Not Set', NULL, NULL, NULL,
  'active', FALSE, 0, 0,
  3, '[]'::jsonb, NULL, NULL::timestamptz,
  NULL::timestamptz, '2026-11-16 06:12:10.866144+00:00'::timestamptz, FALSE, NULL,
  NULL, NULL::timestamptz, FALSE
) ON CONFLICT (id) DO UPDATE SET
  employee_id = EXCLUDED.employee_id,
  username = EXCLUDED.username,
  email = EXCLUDED.email,
  password_hash = EXCLUDED.password_hash,
  role = EXCLUDED.role,
  employment_type = EXCLUDED.employment_type,
  full_name = EXCLUDED.full_name,
  phone = EXCLUDED.phone,
  designation = EXCLUDED.designation,
  department = EXCLUDED.department,
  guide_id = EXCLUDED.guide_id,
  guide_name = EXCLUDED.guide_name,
  status = EXCLUDED.status,
  must_change_password = EXCLUDED.must_change_password,
  session_version = EXCLUDED.session_version,
  approval_stage = EXCLUDED.approval_stage,
  registration_approval_version = EXCLUDED.registration_approval_version,
  approval_history = EXCLUDED.approval_history,
  approval_remarks = EXCLUDED.approval_remarks,
  approved_at = EXCLUDED.approved_at,
  requested_at = EXCLUDED.requested_at,
  email_verified = EXCLUDED.email_verified,
  is_profile_completed = EXCLUDED.is_profile_completed;

INSERT INTO public.users (
  id, employee_id, username, email, password_hash, role, employment_type,
  full_name, phone, profile_photo, designation, department, guide_id, guide_name,
  status, must_change_password, session_version, approval_stage,
  registration_approval_version, approval_history, approval_remarks, approved_at,
  requested_at, created_at, email_verified, verification_token,
  reset_token, reset_token_expires_at, is_profile_completed
) VALUES (
  'admin-003', 'MIB03', 'santhanakumarv', 'santhanakumarv@suryas.in', '$2b$10$Ba/u/FCErcSKaqGZ2KR0y.G1OijRFl5nugGPkz/HT4OHr97X6rOy6', 'managing-partner', 'full-time',
  'SANTHANA KUMAR V', '7010353723', NULL, 'Managing Partner - Operations & Business Development', 'Executive Management Team', NULL, NULL,
  'active', FALSE, 0, 0,
  3, '[]'::jsonb, NULL, NULL::timestamptz,
  NULL::timestamptz, '2026-11-16 06:12:10.866144+00:00'::timestamptz, FALSE, NULL,
  NULL, NULL::timestamptz, FALSE
) ON CONFLICT (id) DO UPDATE SET
  employee_id = EXCLUDED.employee_id,
  username = EXCLUDED.username,
  email = EXCLUDED.email,
  password_hash = EXCLUDED.password_hash,
  role = EXCLUDED.role,
  employment_type = EXCLUDED.employment_type,
  full_name = EXCLUDED.full_name,
  phone = EXCLUDED.phone,
  designation = EXCLUDED.designation,
  department = EXCLUDED.department,
  guide_id = EXCLUDED.guide_id,
  guide_name = EXCLUDED.guide_name,
  status = EXCLUDED.status,
  must_change_password = EXCLUDED.must_change_password,
  session_version = EXCLUDED.session_version,
  approval_stage = EXCLUDED.approval_stage,
  registration_approval_version = EXCLUDED.registration_approval_version,
  approval_history = EXCLUDED.approval_history,
  approval_remarks = EXCLUDED.approval_remarks,
  approved_at = EXCLUDED.approved_at,
  requested_at = EXCLUDED.requested_at,
  email_verified = EXCLUDED.email_verified,
  is_profile_completed = EXCLUDED.is_profile_completed;

INSERT INTO public.users (
  id, employee_id, username, email, password_hash, role, employment_type,
  full_name, phone, profile_photo, designation, department, guide_id, guide_name,
  status, must_change_password, session_version, approval_stage,
  registration_approval_version, approval_history, approval_remarks, approved_at,
  requested_at, created_at, email_verified, verification_token,
  reset_token, reset_token_expires_at, is_profile_completed
) VALUES (
  'founder-001', 'MIB01', 'gkbharath', 'gollakumarbharath@suryas.in', '$2b$10$Ba/u/FCErcSKaqGZ2KR0y.G1OijRFl5nugGPkz/HT4OHr97X6rOy6', 'founder', 'full-time',
  'GOLLA KUMAR BHARATH', '8124227370', NULL, 'Founder & Chief Executive Partner', 'Executive Management Team', NULL, NULL,
  'active', FALSE, 0, 0,
  3, '[]'::jsonb, NULL, NULL::timestamptz,
  NULL::timestamptz, '2026-11-16 06:12:10.866144+00:00'::timestamptz, FALSE, NULL,
  NULL, NULL::timestamptz, FALSE
) ON CONFLICT (id) DO UPDATE SET
  employee_id = EXCLUDED.employee_id,
  username = EXCLUDED.username,
  email = EXCLUDED.email,
  password_hash = EXCLUDED.password_hash,
  role = EXCLUDED.role,
  employment_type = EXCLUDED.employment_type,
  full_name = EXCLUDED.full_name,
  phone = EXCLUDED.phone,
  designation = EXCLUDED.designation,
  department = EXCLUDED.department,
  guide_id = EXCLUDED.guide_id,
  guide_name = EXCLUDED.guide_name,
  status = EXCLUDED.status,
  must_change_password = EXCLUDED.must_change_password,
  session_version = EXCLUDED.session_version,
  approval_stage = EXCLUDED.approval_stage,
  registration_approval_version = EXCLUDED.registration_approval_version,
  approval_history = EXCLUDED.approval_history,
  approval_remarks = EXCLUDED.approval_remarks,
  approved_at = EXCLUDED.approved_at,
  requested_at = EXCLUDED.requested_at,
  email_verified = EXCLUDED.email_verified,
  is_profile_completed = EXCLUDED.is_profile_completed;

INSERT INTO public.users (
  id, employee_id, username, email, password_hash, role, employment_type,
  full_name, phone, profile_photo, designation, department, guide_id, guide_name,
  status, must_change_password, session_version, approval_stage,
  registration_approval_version, approval_history, approval_remarks, approved_at,
  requested_at, created_at, email_verified, verification_token,
  reset_token, reset_token_expires_at, is_profile_completed
) VALUES (
  'SMIB-EMP-ba45b474-f583-4802-af93-26555c8c6b72', 'MIB04', 'kumar', 'nagarajmsdraj@gmail.com', '$2b$10$Ba/u/FCErcSKaqGZ2KR0y.G1OijRFl5nugGPkz/HT4OHr97X6rOy6', 'intern', 'full-time',
  'Kumar', NULL, NULL, 'Intern', NULL, NULL, NULL,
  'suspended', FALSE, 2, 3,
  3, '[]'::jsonb, NULL, '2026-11-16 09:15:11.928000+00:00'::timestamptz,
  '2026-11-16 08:58:19.187000+00:00'::timestamptz, '2026-11-16 08:58:19.187347+00:00'::timestamptz, FALSE, NULL,
  NULL, NULL::timestamptz, FALSE
) ON CONFLICT (id) DO UPDATE SET
  employee_id = EXCLUDED.employee_id,
  username = EXCLUDED.username,
  email = EXCLUDED.email,
  password_hash = EXCLUDED.password_hash,
  role = EXCLUDED.role,
  employment_type = EXCLUDED.employment_type,
  full_name = EXCLUDED.full_name,
  phone = EXCLUDED.phone,
  designation = EXCLUDED.designation,
  department = EXCLUDED.department,
  guide_id = EXCLUDED.guide_id,
  guide_name = EXCLUDED.guide_name,
  status = EXCLUDED.status,
  must_change_password = EXCLUDED.must_change_password,
  session_version = EXCLUDED.session_version,
  approval_stage = EXCLUDED.approval_stage,
  registration_approval_version = EXCLUDED.registration_approval_version,
  approval_history = EXCLUDED.approval_history,
  approval_remarks = EXCLUDED.approval_remarks,
  approved_at = EXCLUDED.approved_at,
  requested_at = EXCLUDED.requested_at,
  email_verified = EXCLUDED.email_verified,
  is_profile_completed = EXCLUDED.is_profile_completed;

INSERT INTO public.users (
  id, employee_id, username, email, password_hash, role, employment_type,
  full_name, phone, profile_photo, designation, department, guide_id, guide_name,
  status, must_change_password, session_version, approval_stage,
  registration_approval_version, approval_history, approval_remarks, approved_at,
  requested_at, created_at, email_verified, verification_token,
  reset_token, reset_token_expires_at, is_profile_completed
) VALUES (
  'SMIB-EMP-4dbc0097-2c05-42d3-b7c9-8a8530045d8a', 'MIB05', 'kumar04', 'nagarajnk0413@gmail.com', '$2b$10$qC0KNDf/191mu16A.5wPGuD1DFp5AxsI1ryfUdnlRSGwOH7YZQapO', 'intern', 'part-time',
  'Kumar', NULL, NULL, 'Not Set', NULL, 'admin-002', 'HAREESH V',
  'suspended', FALSE, 2, 3,
  3, '[]'::jsonb, NULL, '2026-11-16 09:15:17.181000+00:00'::timestamptz,
  '2026-11-16 09:14:44.469000+00:00'::timestamptz, '2026-11-16 09:14:44.469000+00:00'::timestamptz, FALSE, NULL,
  NULL, NULL::timestamptz, FALSE
) ON CONFLICT (id) DO UPDATE SET
  employee_id = EXCLUDED.employee_id,
  username = EXCLUDED.username,
  email = EXCLUDED.email,
  password_hash = EXCLUDED.password_hash,
  role = EXCLUDED.role,
  employment_type = EXCLUDED.employment_type,
  full_name = EXCLUDED.full_name,
  phone = EXCLUDED.phone,
  designation = EXCLUDED.designation,
  department = EXCLUDED.department,
  guide_id = EXCLUDED.guide_id,
  guide_name = EXCLUDED.guide_name,
  status = EXCLUDED.status,
  must_change_password = EXCLUDED.must_change_password,
  session_version = EXCLUDED.session_version,
  approval_stage = EXCLUDED.approval_stage,
  registration_approval_version = EXCLUDED.registration_approval_version,
  approval_history = EXCLUDED.approval_history,
  approval_remarks = EXCLUDED.approval_remarks,
  approved_at = EXCLUDED.approved_at,
  requested_at = EXCLUDED.requested_at,
  email_verified = EXCLUDED.email_verified,
  is_profile_completed = EXCLUDED.is_profile_completed;


-- ==================== ATTENDANCE (68 records across 10 dates) ====================
INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '36038cff-e5a7-4986-bb1c-eb57a1e4c1af', 'founder-001', 'gkbharath', 'GOLLA KUMAR BHARATH', '2026-10-18',
  '2026-10-18T06:54:46.309Z'::timestamptz, '2026-10-18T06:54:51.514Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '5927cd18-435a-487a-bfe2-30dfa3e4e441', 'user-002', 'hareeshv', 'HAREESH V', '2026-10-18',
  '2026-10-18T06:31:24.868Z'::timestamptz, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  'ab21157d-3eb6-4637-8e44-2de4e89c713d', 'user-003', 'santhanakumarv', 'SANTHANA KUMAR V', '2026-10-18',
  '2026-10-18T04:00:25.834Z'::timestamptz, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  'a2f65e0f-81b5-4486-9eb2-ddc99c602cca', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'sabir', 'SABIR MOHAMMED S', '2026-10-18',
  '2026-10-18T03:55:41.608Z'::timestamptz, '2026-10-18T07:08:57.034Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '4e199962-19c9-45b2-93eb-52c0e3cb7cc7', 'founder-001', 'gkbharath', 'GOLLA KUMAR BHARATH', '2026-10-19',
  '2026-10-19T02:11:01.626Z'::timestamptz, '2026-10-19T10:59:43.543Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '040ef418-56fb-421d-9f20-e12495b4affb', 'user-003', 'santhanakumarv', 'SANTHANA KUMAR V', '2026-10-19',
  '2026-10-19T02:01:44.423Z'::timestamptz, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '59d0ecde-c5a0-467e-acd9-34f4f2f65fca', 'user-002', 'hareeshv', 'HAREESH V', '2026-10-19',
  '2026-10-19T03:44:52.669Z'::timestamptz, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '36000a88-7cc0-424c-a9a7-2ff37cbf2f29', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'vishnuu', 'VISHNU VARSHINI M', '2026-10-19',
  '2026-10-19T03:46:45.319Z'::timestamptz, '2026-10-19T11:37:04.927Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  'c000a4fa-41ff-4297-a084-bb3d55b841fb', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', 'mathi', 'MATHIYAZHAGAN D', '2026-10-19',
  '2026-10-19T03:48:14.699Z'::timestamptz, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '083fa447-7f56-4d22-a256-32e59af7506d', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'sabir', 'SABIR MOHAMMED S', '2026-10-19',
  '2026-10-19T03:59:09.529Z'::timestamptz, '2026-10-19T11:49:37.533Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  'd66298c5-4265-4952-96ec-3baa52c8ad6b', 'user-003', 'santhanakumarv', 'SANTHANA KUMAR V', '2026-10-26',
  '2026-10-26T02:27:58.495Z'::timestamptz, '2026-10-26T11:59:30.799Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '4edda6db-9985-4f71-b63a-dc4373012091', 'founder-001', 'gkbharath', 'GOLLA KUMAR BHARATH', '2026-10-26',
  '2026-10-26T02:49:32.924Z'::timestamptz, '2026-10-26T12:01:42.970Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '68b176a6-2aed-4ab9-860f-4ee4c66d5503', 'SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb', 'rithanyad', 'RITHANYA D', '2026-10-26',
  '2026-10-26T02:52:46.332Z'::timestamptz, '2026-10-26T11:57:02.048Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  'a2a6b5c9-6e69-4501-9ef2-cc416641012d', 'SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13', 'smrithik', 'SMRITHI K', '2026-10-26',
  '2026-10-26T02:57:54.171Z'::timestamptz, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '37537ff1-dfeb-4a35-97ec-607e1cedba91', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'vishnuu', 'VISHNU VARSHINI M', '2026-10-26',
  '2026-10-26T03:26:38.358Z'::timestamptz, '2026-10-26T11:52:33.577Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '959473d4-3e76-40de-a3a4-fea57e5ed55b', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'sabir', 'SABIR MOHAMMED S', '2026-10-26',
  '2026-10-26T03:33:37.075Z'::timestamptz, '2026-10-26T12:04:10.539Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '0ec1430f-ca51-4212-8691-1050f32eed46', 'user-002', 'hareeshv', 'HAREESH V', '2026-10-26',
  '2026-10-26T03:36:47.541Z'::timestamptz, '2026-10-26T03:47:27.046Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '33fef29c-df11-4af2-849b-8c66f37ef777', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', 'mathi', 'MATHIYAZHAGAN D', '2026-10-26',
  '2026-10-26T03:36:59.493Z'::timestamptz, '2026-10-26T12:00:47.980Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  'add9484d-70c0-4f6f-ac07-c8970d2e2e4b', 'user-003', 'santhanakumarv', 'SANTHANA KUMAR V', '2026-10-27',
  '2026-10-27T03:14:34.859Z'::timestamptz, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '01b5ec32-4811-40cb-a11b-32b4530c5631', 'SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13', 'smrithik', 'SMRITHI K', '2026-10-27',
  '2026-10-27T03:14:46.993Z'::timestamptz, '2026-10-27T12:21:41.361Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  'f2d02a84-c177-4447-8ffe-3186543ad241', 'founder-001', 'gkbharath', 'GOLLA KUMAR BHARATH', '2026-10-27',
  '2026-10-27T03:15:35.732Z'::timestamptz, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '978dd5df-fcf5-461a-909c-636d99660ac0', 'SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb', 'rithanyad', 'RITHANYA D', '2026-10-27',
  '2026-10-27T03:16:18.362Z'::timestamptz, '2026-10-27T12:10:04.089Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '92def774-92a1-4168-a73a-b3b15364a4a0', 'user-002', 'hareeshv', 'HAREESH V', '2026-10-27',
  '2026-10-27T03:18:45.078Z'::timestamptz, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  'ac72454a-6f65-4963-8370-290bd823b22a', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'vishnuu', 'VISHNU VARSHINI M', '2026-10-27',
  '2026-10-27T03:21:40.243Z'::timestamptz, '2026-10-27T11:31:49.902Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '66e7a27c-2a23-4bb4-888f-f06831f39fd5', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'sabir', 'SABIR MOHAMMED S', '2026-10-27',
  '2026-10-27T03:30:38.983Z'::timestamptz, '2026-10-27T12:58:57.048Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  'bd0c1c85-11c9-47cc-9bdd-2d6f33500c4b', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', 'mathi', 'MATHIYAZHAGAN D', '2026-10-27',
  '2026-10-27T03:31:05.220Z'::timestamptz, '2026-10-27T11:34:53.528Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '466098a1-988b-445c-9be4-5331c8b9e823', 'SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13', 'smrithik', 'SMRITHI K', '2026-10-28',
  '2026-10-28T03:12:44.352Z'::timestamptz, '2026-10-28T12:00:43.304Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '838304b2-2a45-46a2-82c9-908f84216a52', 'founder-001', 'gkbharath', 'GOLLA KUMAR BHARATH', '2026-10-28',
  '2026-10-28T03:21:04.081Z'::timestamptz, '2026-10-28T11:33:36.346Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  'a49f1095-72f3-40bd-b55a-9ccbe92174bc', 'user-002', 'hareeshv', 'HAREESH V', '2026-10-28',
  '2026-10-28T03:22:45.127Z'::timestamptz, '2026-10-28T11:42:01.642Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '34d4d901-1f12-4c35-a7d9-775fcb37e57d', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'vishnuu', 'VISHNU VARSHINI M', '2026-10-28',
  '2026-10-28T03:26:25.755Z'::timestamptz, '2026-10-28T11:32:03.354Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '5868bc16-156c-42c9-b966-ca6eabd1a911', 'SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb', 'rithanyad', 'RITHANYA D', '2026-10-28',
  '2026-10-28T03:31:43.857Z'::timestamptz, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  'fa570b7b-4697-4b0f-915a-29e918f629e1', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', 'mathi', 'MATHIYAZHAGAN D', '2026-10-28',
  '2026-10-28T03:32:12.608Z'::timestamptz, '2026-10-28T11:41:26.092Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  'f5a48999-73ec-4f2e-b622-ae67f78209fc', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'sabir', 'SABIR MOHAMMED S', '2026-10-28',
  '2026-10-28T03:47:32.805Z'::timestamptz, '2026-10-28T11:34:32.321Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '7d71f70e-3c6d-4de6-bdae-2b438012b3ef', 'SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13', 'smrithik', 'SMRITHI K', '2026-10-30',
  '2026-10-30T03:12:58.782Z'::timestamptz, '2026-10-30T12:47:08.982Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  'a4953458-998c-48e9-818b-f779ac9bfe26', 'user-002', 'hareeshv', 'HAREESH V', '2026-10-30',
  '2026-10-30T03:14:18.256Z'::timestamptz, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '92d42d1b-2aa7-4b91-9a83-904528106efd', 'user-003', 'santhanakumarv', 'SANTHANA KUMAR V', '2026-10-30',
  '2026-10-30T03:15:05.872Z'::timestamptz, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '028b96c9-270f-4dc3-bb28-184ffccd989e', 'SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb', 'rithanyad', 'RITHANYA D', '2026-10-30',
  '2026-10-30T03:17:02.207Z'::timestamptz, '2026-10-30T12:37:02.256Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  'a5a3a10d-5a7b-4901-b247-6caf3f51c5c0', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'vishnuu', 'VISHNU VARSHINI M', '2026-10-30',
  '2026-10-30T03:27:27.566Z'::timestamptz, '2026-10-30T11:40:50.613Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  'f0e14014-5ffa-4983-961a-09c714ededf5', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'sabir', 'SABIR MOHAMMED S', '2026-10-30',
  '2026-10-30T03:30:04.654Z'::timestamptz, '2026-10-30T11:30:03.813Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '7ba6be4c-e1d3-49e8-b69e-1463fa77743d', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', 'mathi', 'MATHIYAZHAGAN D', '2026-10-30',
  '2026-10-30T03:30:05.430Z'::timestamptz, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  'dc361e35-2899-4e40-9098-b8ec8fc65c21', 'founder-001', 'gkbharath', 'GOLLA KUMAR BHARATH', '2026-10-30',
  '2026-10-30T03:39:03.622Z'::timestamptz, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '27ace3e8-0806-4ea9-9a64-c0d75bc4201c', 'user-003', 'santhanakumarv', 'SANTHANA KUMAR V', '2026-11-03',
  '2026-11-03T02:52:05.814Z'::timestamptz, '2026-11-03T11:50:12.620Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '3324650e-2f43-4497-bd64-e185f42bc7cb', 'founder-001', 'gkbharath', 'GOLLA KUMAR BHARATH', '2026-11-03',
  '2026-11-03T03:13:53.281Z'::timestamptz, '2026-11-03T11:49:25.076Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  'eb0ff3b3-da3b-452e-98ed-474dc471b1a7', 'SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13', 'smrithik', 'SMRITHI K', '2026-11-03',
  '2026-11-03T03:24:32.553Z'::timestamptz, '2026-11-03T11:37:08.230Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '7177cdb8-45ad-4345-b9fc-b8db2ed471d5', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'vishnuu', 'VISHNU VARSHINI M', '2026-11-03',
  '2026-11-03T03:25:53.912Z'::timestamptz, '2026-11-03T11:35:25.547Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '935b72d3-b93e-432b-ac20-d3e768fb14a0', 'SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb', 'rithanyad', 'RITHANYA D', '2026-11-03',
  '2026-11-03T03:31:12.076Z'::timestamptz, '2026-11-03T11:30:16.819Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  'bf31b7d8-164e-4468-89bb-87a12a58fd41', 'user-002', 'hareeshv', 'HAREESH V', '2026-11-03',
  '2026-11-03T04:21:08.177Z'::timestamptz, '2026-11-03T11:25:12.844Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  'bbb448d2-fd78-4ecb-a73c-e9e7417a1500', 'user-002', 'hareeshv', 'HAREESH V', '2026-11-04',
  '2026-11-04T03:08:08.800Z'::timestamptz, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '78b416b4-0437-4afa-b995-28ff388cb442', 'SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb', 'rithanyad', 'RITHANYA D', '2026-11-04',
  '2026-11-04T03:10:32.302Z'::timestamptz, '2026-11-04T11:19:45.983Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  'b8c299ab-86df-484c-9cfd-b55ab4c1b399', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'vishnuu', 'VISHNU VARSHINI M', '2026-11-04',
  '2026-11-04T03:17:25.518Z'::timestamptz, '2026-11-04T11:27:32.652Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '8eca8808-1d8d-4957-bdc8-563d8b4699bb', 'user-003', 'santhanakumarv', 'SANTHANA KUMAR V', '2026-11-04',
  '2026-11-04T03:17:27.622Z'::timestamptz, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '8c65215c-1c0d-4b27-9b26-19c79e28887b', 'founder-001', 'gkbharath', 'GOLLA KUMAR BHARATH', '2026-11-04',
  '2026-11-04T03:20:47.869Z'::timestamptz, '2026-11-04T11:38:28.054Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  'd885bfe7-e745-4f5e-91e0-ee5d4f780ac2', 'SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13', 'smrithik', 'SMRITHI K', '2026-11-04',
  '2026-11-04T03:40:28.310Z'::timestamptz, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '89abc3b9-7bf5-48f5-94a2-8ed4373efdb7', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'sabir', 'SABIR MOHAMMED S', '2026-11-04',
  '2026-11-04T03:44:28.189Z'::timestamptz, '2026-11-04T11:26:03.481Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '99787047-d215-4341-b19f-471678a0a685', 'user-003', 'santhanakumarv', 'SANTHANA KUMAR V', '2026-11-05',
  '2026-11-05T02:40:25.758Z'::timestamptz, '2026-11-05T11:30:47.913Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '38be8e8c-4aeb-4518-a663-52b7f3bf1648', 'founder-001', 'gkbharath', 'GOLLA KUMAR BHARATH', '2026-11-05',
  '2026-11-05T02:47:44.099Z'::timestamptz, '2026-11-05T11:29:38.985Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '03d1dda7-5ca4-4121-9ea2-8cd42435920d', 'SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb', 'rithanyad', 'RITHANYA D', '2026-11-05',
  '2026-11-05T02:55:02.032Z'::timestamptz, '2026-11-05T11:22:33.775Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '682fae0e-cd6e-410b-b566-c62d4cb0dcf7', 'user-002', 'hareeshv', 'HAREESH V', '2026-11-05',
  '2026-11-05T02:56:02.610Z'::timestamptz, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  'a25b0988-1583-4fde-85e2-e5d4da43c0bb', 'SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13', 'smrithik', 'SMRITHI K', '2026-11-05',
  '2026-11-05T03:07:36.987Z'::timestamptz, '2026-11-05T11:18:37.117Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '63262d90-4941-4238-ab79-84abba7a3691', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'sabir', 'SABIR MOHAMMED S', '2026-11-05',
  '2026-11-05T03:22:00.471Z'::timestamptz, '2026-11-05T11:27:40.333Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  'dcf50e58-11d8-4275-8221-56576dc05a5e', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'vishnuu', 'VISHNU VARSHINI M', '2026-11-05',
  '2026-11-05T03:28:29.738Z'::timestamptz, '2026-11-05T11:23:39.150Z'::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  'ac299800-7ef4-42c9-8cfb-610f643308e0', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'vishnuu', 'VISHNU VARSHINI M', '2026-11-06',
  '2026-11-06T03:25:35.003Z'::timestamptz, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  'd0f8bff8-7ec0-4e6d-8efe-7e3be0d5dba6', 'SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb', 'rithanyad', 'RITHANYA D', '2026-11-06',
  '2026-11-06T03:29:42.357Z'::timestamptz, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '87eb9add-6c92-440a-b599-bd368de8c61d', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'sabir', 'SABIR MOHAMMED S', '2026-11-06',
  '2026-11-06T03:38:29.852Z'::timestamptz, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '543a9e61-d2e2-4ba1-93c4-c52677b1e306', 'user-003', 'santhanakumarv', 'SANTHANA KUMAR V', '2026-11-06',
  '2026-11-06T03:39:00.300Z'::timestamptz, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '8512249b-b67f-4ede-99f4-be64db31deb1', 'founder-001', 'gkbharath', 'GOLLA KUMAR BHARATH', '2026-11-06',
  '2026-11-06T03:39:25.930Z'::timestamptz, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '75407615-b1bb-4784-b93b-49a922526f91', 'SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13', 'smrithik', 'SMRITHI K', '2026-11-06',
  '2026-11-06T03:45:33.025Z'::timestamptz, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;

INSERT INTO public.attendance (
  id, user_id, username, full_name, date, check_in, check_out
) VALUES (
  '83ca9e31-4880-434a-ba8b-f8827670aa1f', 'user-002', 'hareeshv', 'HAREESH V', '2026-11-06',
  '2026-11-06T03:58:57.514Z'::timestamptz, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  check_out = EXCLUDED.check_out;


-- ==================== REQUESTS (64 records) ====================
INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '4831', '1968', 'attendance-report', 'Attendance report: 2026-11-05 to 2026-11-05', 'approved', 'admin',
  'VISHNU VARSHINI M', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'vishnuu',
  '2026-11-05T11:23:31.323Z'::timestamptz, '2026-11-06T04:10:05.551Z'::timestamptz, '{"createdByRole": "employee", "createdByDesignation": "PCB & EMS/IoT Designer-T", "createdByEmployeeId": "MIB05", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "6380551370", "payload": {"fromDate": "2026-11-05", "toDate": "2026-11-05", "remarks": "DAILY WORK REPORT\n\nDate: 05 November 2026\nLocation: Mudhalvar Padaipagam, George Town\n\n1. Employee Training: Trained a new employee on the working principles and circuit-level operation of two electronic circuits.\n2. College Workshop Preparation: Designed and prepared three electronic circuits for the upcoming college workshops.\n3. Quotation Preparation: Prepared a quotation for PCB reverse engineering, including the scope of work and estimated project cost.", "daysRecorded": 1, "attendance": [{"id": "dcf50e58-11d8-4275-8221-56576dc05a5e", "userId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3", "username": "vishnuu", "fullName": "VISHNU VARSHINI M", "employeeId": "MIB05", "date": "2026-11-05", "checkIn": "2026-11-05T03:28:29.738Z"}], "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-11-06T04:10:05.551Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-11-06T04:09:10.800Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 0, "at": "2026-11-06T03:59:34.811Z"}]}, "remarks": "DAILY WORK REPORT\n\nDate: 05 November 2026\nLocation: Mudhalvar Padaipagam, George Town\n\n1. Employee Training: Trained a new employee on the working principles and circuit-level operation of two electronic circuits.\n2. College Workshop Preparation: Designed and prepared three electronic circuits for the upcoming college workshops.\n3. Quotation Preparation: Prepared a quotation for PCB reverse engineering, including the scope of work and estimated project cost.", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '8521', '9347', 'attendance-report', 'Attendance report: 2026-11-05 to 2026-11-05', 'approved', 'admin',
  'RITHANYA D', 'SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb', 'rithanyad',
  '2026-11-05T11:22:31.391Z'::timestamptz, '2026-11-06T04:10:08.015Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB Design Intern", "createdByEmployeeId": "MIB09", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "9384304331", "payload": {"fromDate": "2026-11-05", "toDate": "2026-11-05", "remarks": "Prepared and submitted quotations for Section A and Section D for both 100 and 500 quantities. Also generated the corresponding Bill of Materials (BOM), including component details and specifications.", "daysRecorded": 1, "attendance": [{"id": "03d1dda7-5ca4-4121-9ea2-8cd42435920d", "userId": "SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb", "username": "rithanyad", "fullName": "RITHANYA D", "employeeId": "MIB09", "date": "2026-11-05", "checkIn": "2026-11-05T02:55:02.032Z"}], "approvalChain": ["vishnuu", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "guideId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3", "guideUsername": "vishnuu", "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 3, "at": "2026-11-06T04:10:08.014Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-11-06T04:09:14.412Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-11-06T03:59:37.416Z"}, {"by": "vishnuu", "comment": "", "decision": "recommend", "stageIndex": 0, "at": "2026-11-05T11:23:14.462Z"}]}, "remarks": "Prepared and submitted quotations for Section A and Section D for both 100 and 500 quantities. Also generated the corresponding Bill of Materials (BOM), including component details and specifications.", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '5557', '2827', 'attendance-report', 'Attendance report: 2026-11-04 to 2026-11-05', 'approved', 'admin',
  'SMRITHI K', 'SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13', 'smrithik',
  '2026-11-05T11:19:14.170Z'::timestamptz, '2026-11-06T04:10:12.967Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB Design Intern", "createdByEmployeeId": "MIB08", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "8610492864", "payload": {"fromDate": "2026-11-04", "toDate": "2026-11-05", "remarks": "Completed the schematic and submitted for review and also updated the Bill Of Materials (BOM).", "daysRecorded": 2, "attendance": [{"id": "a25b0988-1583-4fde-85e2-e5d4da43c0bb", "userId": "SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13", "username": "smrithik", "fullName": "SMRITHI K", "employeeId": "MIB08", "date": "2026-11-05", "checkIn": "2026-11-05T03:07:36.987Z", "checkOut": "2026-11-05T11:18:37.117Z"}, {"id": "d885bfe7-e745-4f5e-91e0-ee5d4f780ac2", "userId": "SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13", "username": "smrithik", "fullName": "SMRITHI K", "employeeId": "MIB08", "date": "2026-11-04", "checkIn": "2026-11-04T03:40:28.310Z"}], "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 3, "at": "2026-11-06T04:10:12.966Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-11-06T04:09:17.597Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-11-06T03:59:39.074Z"}, {"by": "sabir", "comment": "", "decision": "recommend", "stageIndex": 0, "at": "2026-11-05T11:29:12.884Z"}]}, "remarks": "Completed the schematic and submitted for review and also updated the Bill Of Materials (BOM).", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '1663', '2111', 'attendance-report', 'Attendance report: 2026-11-04 to 2026-11-04', 'approved', 'admin',
  'RITHANYA D', 'SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb', 'rithanyad',
  '2026-11-04T11:19:43.859Z'::timestamptz, '2026-11-05T03:22:54.377Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB Design Intern", "createdByEmployeeId": "MIB09", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "9384304331", "payload": {"fromDate": "2026-11-04", "toDate": "2026-11-04", "remarks": "The schematic design for Sections A (Power Supply Unit) and D (User Interface and Logic Block) of the Motor Starter PCB project is fully completed, validated with zero compilation errors, and exported as a Smart PDF. All power connections, SWD programming headers, local decoupling capacitor banks, and TM1637 display driver lines have been thoroughly verified for design integrity. The generated schematics have been emailed to Mr. Golla Kumar for review and approval, while Sections B and C are currently being handled by Smrithi, and any requested updates will be implemented upon feedback.", "daysRecorded": 1, "attendance": [{"id": "78b416b4-0437-4afa-b995-28ff388cb442", "userId": "SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb", "username": "rithanyad", "fullName": "RITHANYA D", "employeeId": "MIB09", "date": "2026-11-04", "checkIn": "2026-11-04T03:10:32.302Z"}], "approvalChain": ["vishnuu", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "guideId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3", "guideUsername": "vishnuu", "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 3, "at": "2026-11-05T03:22:54.375Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-11-05T03:17:06.210Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-11-05T02:56:43.554Z"}, {"by": "vishnuu", "comment": "", "decision": "recommend", "stageIndex": 0, "at": "2026-11-04T11:32:58.571Z"}]}, "remarks": "The schematic design for Sections A (Power Supply Unit) and D (User Interface and Logic Block) of the Motor Starter PCB project is fully completed, validated with zero compilation errors, and exported as a Smart PDF. All power connections, SWD programming headers, local decoupling capacitor banks, and TM1637 display driver lines have been thoroughly verified for design integrity. The generated schematics have been emailed to Mr. Golla Kumar for review and approval, while Sections B and C are currently being handled by Smrithi, and any requested updates will be implemented upon feedback.", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '2745', '9200', 'attendance-report', 'Attendance report: 2026-11-04 to 2026-11-04', 'approved', 'admin',
  'VISHNU VARSHINI M', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'vishnuu',
  '2026-11-04T11:14:48.705Z'::timestamptz, '2026-11-05T03:23:09.389Z'::timestamptz, '{"createdByRole": "employee", "createdByDesignation": "PCB & EMS/IoT Designer-T", "createdByEmployeeId": "MIB05", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "6380551370", "payload": {"fromDate": "2026-11-04", "toDate": "2026-11-04", "remarks": "DAILY WORK REPORT\n\nDate: 04 November 2026\nLocation: Mudhalvar Padaipagam, Georgetown\n\n1. PCB Design Training: Conducted PCB design training for a new company joinee, explaining the fundamentals of PCB design and developing two basic circuits using KiCad.\n\n2. Company Database & Business Development: Updated the company database and sent emails to other companies regarding project opportunities and potential collaborations.\n\n3. PCB Reverse Engineering Analysis: Studied the reverse engineering process for the provided PCB, focusing on the feasibility, methodology, and technical considerations involved in analyzing a four-layer PCB.", "daysRecorded": 1, "attendance": [{"id": "b8c299ab-86df-484c-9cfd-b55ab4c1b399", "userId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3", "username": "vishnuu", "fullName": "VISHNU VARSHINI M", "employeeId": "MIB05", "date": "2026-11-04", "checkIn": "2026-11-04T03:17:25.518Z"}], "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-11-05T03:23:09.389Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-11-05T03:17:13.015Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 0, "at": "2026-11-05T02:56:46.923Z"}]}, "remarks": "DAILY WORK REPORT\n\nDate: 04 November 2026\nLocation: Mudhalvar Padaipagam, Georgetown\n\n1. PCB Design Training: Conducted PCB design training for a new company joinee, explaining the fundamentals of PCB design and developing two basic circuits using KiCad.\n\n2. Company Database & Business Development: Updated the company database and sent emails to other companies regarding project opportunities and potential collaborations.\n\n3. PCB Reverse Engineering Analysis: Studied the reverse engineering process for the provided PCB, focusing on the feasibility, methodology, and technical considerations involved in analyzing a four-layer PCB.", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '1000', '4939', 'attendance-report', 'Attendance report: 2026-11-03 to 2026-11-03', 'approved', 'admin',
  'RITHANYA D', 'SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb', 'rithanyad',
  '2026-11-03T11:55:44.744Z'::timestamptz, '2026-11-05T03:23:14.337Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB Design Intern", "createdByEmployeeId": "MIB09", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "9384304331", "payload": {"fromDate": "2026-11-03", "toDate": "2026-11-03", "remarks": "Today''s design session focused on completing the core controller and telemetry interface for Section D (UI and Logic Block) of the Motor Starter PCB in Altium Designer. After finalizing the STM32G431CBT6 microcontroller (U401) power supply connections, 100 nF decoupling capacitor bank (C401\u2013C405), reset RC filter (C406), 10 k\u03a9 BOOT0 pulldown resistor (R401), and 5-pin SWD programming header (J401), attention turned to the display subsystem. You configured the bare 20-pin TM1637 IC driver in an SOIC-20 package (U402), connected its power rail to +5V and ground to GND, and wired a local 100 nF SMT ceramic decoupling capacitor (C407) across pins 20 and 10 to ensure robust power supply noise suppression before routing the serial CLK and DIO telemetry lines to the MCU.", "daysRecorded": 1, "attendance": [{"id": "935b72d3-b93e-432b-ac20-d3e768fb14a0", "userId": "SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb", "username": "rithanyad", "fullName": "RITHANYA D", "employeeId": "MIB09", "date": "2026-11-03", "checkIn": "2026-11-03T03:31:12.076Z", "checkOut": "2026-11-03T11:30:16.819Z"}], "approvalChain": ["vishnuu", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "guideId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3", "guideUsername": "vishnuu", "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 3, "at": "2026-11-05T03:23:14.337Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-11-05T03:17:14.706Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-11-05T02:56:49.565Z"}, {"by": "vishnuu", "comment": "", "decision": "recommend", "stageIndex": 0, "at": "2026-11-04T03:18:20.650Z"}]}, "remarks": "Today''s design session focused on completing the core controller and telemetry interface for Section D (UI and Logic Block) of the Motor Starter PCB in Altium Designer. After finalizing the STM32G431CBT6 microcontroller (U401) power supply connections, 100 nF decoupling capacitor bank (C401\u2013C405), reset RC filter (C406), 10 k\u03a9 BOOT0 pulldown resistor (R401), and 5-pin SWD programming header (J401), attention turned to the display subsystem. You configured the bare 20-pin TM1637 IC driver in an SOIC-20 package (U402), connected its power rail to +5V and ground to GND, and wired a local 100 nF SMT ceramic decoupling capacitor (C407) across pins 20 and 10 to ensure robust power supply noise suppression before routing the serial CLK and DIO telemetry lines to the MCU.", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '9601', '9322', 'attendance-report', 'Attendance report: 2026-11-03 to 2026-11-03', 'approved', 'admin',
  'VISHNU VARSHINI M', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'vishnuu',
  '2026-11-03T11:39:49.120Z'::timestamptz, '2026-11-04T03:21:31.784Z'::timestamptz, '{"createdByRole": "employee", "createdByDesignation": "PCB & EMS/IoT Designer-T", "createdByEmployeeId": "MIB05", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "6380551370", "payload": {"fromDate": "2026-11-03", "toDate": "2026-11-03", "remarks": "Daily work report \n03.11.2026\n\nContacted colleges for collaborations \nDrafted mail and contacted the colleges from the database through mail seeking for organising workshops and value added courses at their institution for their students \n\nVLSI quotation \nApproached ocean student projects company for receiving the quotation, list of components for VLSI project and list of components for PLC kit", "daysRecorded": 1, "attendance": [{"id": "7177cdb8-45ad-4345-b9fc-b8db2ed471d5", "userId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3", "username": "vishnuu", "fullName": "VISHNU VARSHINI M", "employeeId": "MIB05", "date": "2026-11-03", "checkIn": "2026-11-03T03:25:53.912Z", "checkOut": "2026-11-03T11:35:25.547Z"}], "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-11-04T03:21:31.783Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-11-04T03:18:04.370Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 0, "at": "2026-11-04T03:08:29.757Z"}]}, "remarks": "Daily work report \n03.11.2026\n\nContacted colleges for collaborations \nDrafted mail and contacted the colleges from the database through mail seeking for organising workshops and value added courses at their institution for their students \n\nVLSI quotation \nApproached ocean student projects company for receiving the quotation, list of components for VLSI project and list of components for PLC kit", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '8054', '1841', 'attendance-report', 'Attendance report: 2026-11-03 to 2026-11-03', 'approved', 'admin',
  'SMRITHI K', 'SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13', 'smrithik',
  '2026-11-03T11:38:17.065Z'::timestamptz, '2026-11-05T03:23:18.908Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB Design Intern", "createdByEmployeeId": "MIB08", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "8610492864", "payload": {"fromDate": "2026-11-03", "toDate": "2026-11-03", "remarks": "Completed block b and c schematic rendering and executed Electrical Rule Check(ERC)", "daysRecorded": 1, "attendance": [{"id": "eb0ff3b3-da3b-452e-98ed-474dc471b1a7", "userId": "SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13", "username": "smrithik", "fullName": "SMRITHI K", "employeeId": "MIB08", "date": "2026-11-03", "checkIn": "2026-11-03T03:24:32.553Z", "checkOut": "2026-11-03T11:37:08.230Z"}], "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 3, "at": "2026-11-05T03:23:18.908Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-11-05T03:17:15.879Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-11-05T02:56:51.954Z"}, {"by": "sabir", "comment": "", "decision": "recommend", "stageIndex": 0, "at": "2026-11-04T03:44:55.338Z"}]}, "remarks": "Completed block b and c schematic rendering and executed Electrical Rule Check(ERC)", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '2663', '6533', 'leave', 'Past-Date Casual Leave Request', 'approved', 'admin',
  'RITHANYA D', 'SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb', 'rithanyad',
  '2026-11-03T03:40:36.575Z'::timestamptz, '2026-11-04T03:21:49.953Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB Design Intern", "createdByEmployeeId": "MIB09", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "9384304331", "payload": {"name": "RITHANYA D", "id": "MIB09", "designation": "PCB Design Intern", "department": "PCB Designs & Fabrication Team", "email": "rithanya07cbe@gmail.com", "phone": "9384304331", "leaveType": "casual", "fromDate": "2026-11-02", "toDate": "2026-11-02", "reason": "I would like to apply for post casual leave as I was engaged in college related work. Kindly consider my request and approve the leave.", "remarks": "Engaged in college related work. Requesting approval for post casual work.", "isPastDateRequest": true, "filledFormFileName": "", "submittedAt": "2026-11-03T03:40:36.670Z", "guideId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3", "guideUsername": "vishnuu", "approvalChain": ["vishnuu", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 3, "at": "2026-11-04T03:21:49.952Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-11-04T03:18:22.841Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-11-04T03:08:37.090Z"}, {"by": "vishnuu", "comment": "", "decision": "recommend", "stageIndex": 0, "at": "2026-11-03T11:34:51.757Z"}]}, "remarks": "Engaged in college related work. Requesting approval for post casual work.", "signatureFrom": "Hareesh", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '1131', '4941', 'attendance-report', 'Attendance report: 2026-10-29 to 2026-10-30', 'pending', 'admin',
  'RITHANYA D', 'SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb', 'rithanyad',
  '2026-10-30T13:19:41.479Z'::timestamptz, '2026-10-30T13:19:41.479Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB Design Intern", "createdByEmployeeId": "MIB09", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "9384304331", "payload": {"fromDate": "2026-10-29", "toDate": "2026-10-30", "remarks": "Continued working on the Bill of Materials (BOM) by collecting component details for the different functional blocks. Currently organizing component names, technical specifications, ratings, quantities, and purposes. Reviewing component compatibility and gathering the necessary information to prepare the preliminary BOM for supervisor review.", "daysRecorded": 1, "attendance": [{"id": "028b96c9-270f-4dc3-bb28-184ffccd989e", "userId": "SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb", "username": "rithanyad", "fullName": "RITHANYA D", "employeeId": "MIB09", "date": "2026-10-30", "checkIn": "2026-10-30T03:17:02.207Z", "checkOut": "2026-10-30T12:37:02.256Z"}], "approvalChain": ["vishnuu", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 0, "guideId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3", "guideUsername": "vishnuu"}, "remarks": "Continued working on the Bill of Materials (BOM) by collecting component details for the different functional blocks. Currently organizing component names, technical specifications, ratings, quantities, and purposes. Reviewing component compatibility and gathering the necessary information to prepare the preliminary BOM for supervisor review."}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '2056', '2566', 'attendance-report', 'Attendance report: 2026-10-28 to 2026-10-28', 'pending', 'admin',
  'RITHANYA D', 'SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb', 'rithanyad',
  '2026-10-30T13:19:06.899Z'::timestamptz, '2026-10-30T13:19:06.899Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB Design Intern", "createdByEmployeeId": "MIB09", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "9384304331", "payload": {"fromDate": "2026-10-28", "toDate": "2026-10-28", "remarks": "Completed the preliminary selection of components for Sections A and S of the Electronic Motor Starter with SSR-Based Protection project. Reviewed the functions, ratings, and specifications of the selected components and organized them according to the project''s functional blocks.", "daysRecorded": 1, "attendance": [{"id": "5868bc16-156c-42c9-b966-ca6eabd1a911", "userId": "SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb", "username": "rithanyad", "fullName": "RITHANYA D", "employeeId": "MIB09", "date": "2026-10-28", "checkIn": "2026-10-28T03:31:43.857Z"}], "approvalChain": ["vishnuu", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 0, "guideId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3", "guideUsername": "vishnuu"}, "remarks": "Completed the preliminary selection of components for Sections A and S of the Electronic Motor Starter with SSR-Based Protection project. Reviewed the functions, ratings, and specifications of the selected components and organized them according to the project''s functional blocks."}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '1303', '9860', 'attendance-report', 'Attendance report: 2026-10-30 to 2026-10-30', 'pending', 'admin',
  'SMRITHI K', 'SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13', 'smrithik',
  '2026-10-30T12:48:54.210Z'::timestamptz, '2026-10-30T12:48:54.210Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB Design Intern", "createdByEmployeeId": "MIB08", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "8610492864", "payload": {"fromDate": "2026-10-30", "toDate": "2026-10-30", "remarks": "Task 1: Finalized the system block diagram for the programmable electronic motor starter.\nTask 2: Completed a full BOM audit and optimization, shifting from modular breakout boards to a fully discrete, SMT-heavy design suitable for mass manufacturing.\nTask 3: Resolved hardware design traps, specifically focusing on the 440V galvanic isolation barrier (AMC1311DWV), SSR thermal derating limits (85\u00b0C KSD9700), and UI mechanical durability (22mm industrial switches).\nTask 4: Prepared the final component list for the transition into Altium Designer schematic capture.", "daysRecorded": 1, "attendance": [{"id": "7d71f70e-3c6d-4de6-bdae-2b438012b3ef", "userId": "SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13", "username": "smrithik", "fullName": "SMRITHI K", "employeeId": "MIB08", "date": "2026-10-30", "checkIn": "2026-10-30T03:12:58.782Z", "checkOut": "2026-10-30T12:47:08.982Z"}], "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 0, "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir"}, "remarks": "Task 1: Finalized the system block diagram for the programmable electronic motor starter.\nTask 2: Completed a full BOM audit and optimization, shifting from modular breakout boards to a fully discrete, SMT-heavy design suitable for mass manufacturing.\nTask 3: Resolved hardware design traps, specifically focusing on the 440V galvanic isolation barrier (AMC1311DWV), SSR thermal derating limits (85\u00b0C KSD9700), and UI mechanical durability (22mm industrial switches).\nTask 4: Prepared the final component list for the transition into Altium Designer schematic capture."}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '9752', '2054', 'attendance-report', 'Attendance report: 2026-10-30 to 2026-10-30', 'pending', 'admin',
  'VISHNU VARSHINI M', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'vishnuu',
  '2026-10-30T11:17:36.840Z'::timestamptz, '2026-10-30T11:17:36.840Z'::timestamptz, '{"createdByRole": "employee", "createdByDesignation": "PCB & EMS/IoT Designer-T", "createdByEmployeeId": "MIB05", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "6380551370", "payload": {"fromDate": "2026-10-30", "toDate": "2026-10-30", "remarks": "DAILY WORK REPORT\n\n1. SSR Project \u2013 Circuit Design\n   \n   - Worked on circuit-level connections based on the finalized block diagram.\n   - Reviewed component interconnections and signal flow between different circuit blocks.\n\n2. Adapter Project \u2013 Technical Analysis\n   \n   - Analysed the adapter reference and project requirements.\n   - Reviewed the feasibility of adapting the existing design with an Indian-standard plug pin.\n\n3. Marketing Agency Coordination\n   \n   - Contacted marketing agencies for project-related follow-ups.\n   - Requested quotations and gathered preliminary details for further evaluation.", "daysRecorded": 1, "attendance": [{"id": "a5a3a10d-5a7b-4901-b247-6caf3f51c5c0", "userId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3", "username": "vishnuu", "fullName": "VISHNU VARSHINI M", "employeeId": "MIB05", "date": "2026-10-30", "checkIn": "2026-10-30T03:27:27.566Z"}], "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 0}, "remarks": "DAILY WORK REPORT\n\n1. SSR Project \u2013 Circuit Design\n   \n   - Worked on circuit-level connections based on the finalized block diagram.\n   - Reviewed component interconnections and signal flow between different circuit blocks.\n\n2. Adapter Project \u2013 Technical Analysis\n   \n   - Analysed the adapter reference and project requirements.\n   - Reviewed the feasibility of adapting the existing design with an Indian-standard plug pin.\n\n3. Marketing Agency Coordination\n   \n   - Contacted marketing agencies for project-related follow-ups.\n   - Requested quotations and gathered preliminary details for further evaluation."}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '2423', '8034', 'leave', 'Casual Leave Request', 'pending', 'admin',
  'GOLLA KUMAR BHARATH', 'founder-001', 'gkbharath',
  '2026-10-30T07:22:12.395Z'::timestamptz, '2026-10-30T07:22:12.395Z'::timestamptz, '{"createdByRole": "founder", "createdByDesignation": "Founder & Chief Executive Partner", "createdByEmployeeId": "MIB01", "createdByDepartment": "Executive Management Team", "createdByPhone": "8124227370", "payload": {"name": "GOLLA KUMAR BHARATH", "id": "MIB01", "designation": "Founder & Chief Executive Partner", "department": "Executive Management Team", "email": "gollakumarbharath@suryas.in", "phone": "8124227370", "leaveType": "casual", "fromDate": "2026-11-13", "toDate": "2026-11-13", "reason": "Casual Leave", "remarks": "", "isPastDateRequest": false, "filledFormFileName": "", "submittedAt": "2026-10-30T07:22:12.301Z", "approvalChain": ["hareeshv", "santhanakumarv"], "currentApproverIndex": 0}, "remarks": "", "signatureFrom": "Admin"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '8844', '1620', 'leave', 'Casual Leave Request', 'pending', 'admin',
  'GOLLA KUMAR BHARATH', 'founder-001', 'gkbharath',
  '2026-10-30T07:21:51.540Z'::timestamptz, '2026-10-30T07:21:51.540Z'::timestamptz, '{"createdByRole": "founder", "createdByDesignation": "Founder & Chief Executive Partner", "createdByEmployeeId": "MIB01", "createdByDepartment": "Executive Management Team", "createdByPhone": "8124227370", "payload": {"name": "GOLLA KUMAR BHARATH", "id": "MIB01", "designation": "Founder & Chief Executive Partner", "department": "Executive Management Team", "email": "gollakumarbharath@suryas.in", "phone": "8124227370", "leaveType": "casual", "fromDate": "2026-11-12", "toDate": "2026-11-12", "reason": "Casual Leave", "remarks": "", "isPastDateRequest": false, "filledFormFileName": "", "submittedAt": "2026-10-30T07:21:51.438Z", "approvalChain": ["hareeshv", "santhanakumarv"], "currentApproverIndex": 0}, "remarks": "", "signatureFrom": "Admin"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '5073', '3390', 'attendance-report', 'Attendance report: 2026-10-29 to 2026-10-29', 'rejected', 'admin',
  'MATHIYAZHAGAN D', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', 'mathi',
  '2026-10-30T03:46:48.766Z'::timestamptz, '2026-10-30T05:56:55.299Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB Design Intern", "createdByEmployeeId": "MIB06", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "8056197704", "payload": {"fromDate": "2026-10-29", "toDate": "2026-10-29", "remarks": "Today''s Work Report \n\nWork Done :\n- Continued collecting information about companies and their technical domains.\n- Reviewed company services related to embedded systems, PCB design, IoT, and automation.\n- Continued collecting project ideas and details.\n- Interacted with students regarding project collection and discussed their project requirements.\n\nStatus :  Work completed.", "daysRecorded": 0, "attendance": [], "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "comments": [{"by": "hareeshv", "comment": "", "decision": "reject", "stageIndex": 1, "at": "2026-10-30T05:56:55.298Z"}, {"by": "sabir", "comment": "", "decision": "recommend", "stageIndex": 0, "at": "2026-10-30T05:31:40.248Z"}]}, "remarks": "Today''s Work Report \n\nWork Done :\n- Continued collecting information about companies and their technical domains.\n- Reviewed company services related to embedded systems, PCB design, IoT, and automation.\n- Continued collecting project ideas and details.\n- Interacted with students regarding project collection and discussed their project requirements.\n\nStatus :  Work completed.", "forwardedTo": "hareeshv"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '4273', '8588', 'attendance-report', 'Attendance report: 2026-10-28 to 2026-10-28', 'approved', 'admin',
  'SMRITHI K', 'SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13', 'smrithik',
  '2026-10-28T12:05:16.273Z'::timestamptz, '2026-10-30T05:59:43.408Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB Design Intern", "createdByEmployeeId": "MIB08", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "8610492864", "payload": {"fromDate": "2026-10-28", "toDate": "2026-10-28", "remarks": "Finalized the modular architecture strategy, separating the low-voltage control board from the high-voltage SSR power stages.\n\nDetermined the component specifications for the Power Supply Unit (Section A), including wide-input AC-DC modules and MOV surge protection.\n\nDesigned the Core Sensing network (Section B), specifying burden resistors for the CTs and Zener clamping for safe MCU voltage readings.\n\nUpdated the User Interface hardware to match the provided physical enclosure, finalizing the 7-segment displays, LED indicators, and selector switch logic.", "daysRecorded": 1, "attendance": [{"id": "466098a1-988b-445c-9be4-5331c8b9e823", "userId": "SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13", "username": "smrithik", "fullName": "SMRITHI K", "employeeId": "MIB08", "date": "2026-10-28", "checkIn": "2026-10-28T03:12:44.352Z", "checkOut": "2026-10-28T12:00:43.304Z"}], "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 3, "at": "2026-10-30T05:59:43.408Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-10-30T05:58:30.685Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-30T05:57:03.947Z"}, {"by": "sabir", "comment": "", "decision": "recommend", "stageIndex": 0, "at": "2026-10-30T03:33:37.234Z"}]}, "remarks": "Finalized the modular architecture strategy, separating the low-voltage control board from the high-voltage SSR power stages.\n\nDetermined the component specifications for the Power Supply Unit (Section A), including wide-input AC-DC modules and MOV surge protection.\n\nDesigned the Core Sensing network (Section B), specifying burden resistors for the CTs and Zener clamping for safe MCU voltage readings.\n\nUpdated the User Interface hardware to match the provided physical enclosure, finalizing the 7-segment displays, LED indicators, and selector switch logic.", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '6887', '7248', 'ta', 'Allowance Claim Request', 'pending', 'admin',
  'MATHIYAZHAGAN D', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', 'mathi',
  '2026-10-28T11:48:45.872Z'::timestamptz, '2026-10-28T11:48:45.872Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB Design Intern", "createdByEmployeeId": "MIB06", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "8056197704", "payload": {"name": "MATHIYAZHAGAN D", "id": "MIB06", "designation": "PCB Design Intern", "department": "PCB Designs & Fabrication Team", "email": "mathiyazhagandhanapalmathiyazh@gmail.com", "phone": "8056197704", "claimType": "bill", "amount": "300", "description": "Tommorow vendor office visit to collect the quote ", "remarks": "Travel and food", "filledFormFileName": "", "billFileName": "", "submittedAt": "2026-10-28T11:48:45.921Z", "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 0}, "remarks": "Travel and food", "signatureFrom": "Hareesh"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '3079', '6774', 'attendance-report', 'Attendance report: 2026-10-28 to 2026-10-28', 'approved', 'admin',
  'MATHIYAZHAGAN D', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', 'mathi',
  '2026-10-28T11:41:18.769Z'::timestamptz, '2026-10-30T09:13:39.676Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB Design Intern", "createdByEmployeeId": "MIB06", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "8056197704", "payload": {"fromDate": "2026-10-28", "toDate": "2026-10-28", "remarks": "Work Report \n\nWork Done:\n\n- Continued collecting information about companies and their technical domains.\n- Reviewed services related to embedded systems, PCB design, IoT, and automation.\n- Collected project ideas and details.\n- Interacted with students regarding project collection and discussed their project requirements.\n\nStatus: Work completed.", "daysRecorded": 1, "attendance": [{"id": "fa570b7b-4697-4b0f-915a-29e918f629e1", "userId": "SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01", "username": "mathi", "fullName": "MATHIYAZHAGAN D", "employeeId": "MIB06", "date": "2026-10-28", "checkIn": "2026-10-28T03:32:12.608Z"}], "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 3, "at": "2026-10-30T09:13:39.675Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-10-30T09:12:46.586Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-30T06:05:58.445Z"}, {"by": "sabir", "comment": "", "decision": "recommend", "stageIndex": 0, "at": "2026-10-30T03:33:23.343Z"}]}, "remarks": "Work Report \n\nWork Done:\n\n- Continued collecting information about companies and their technical domains.\n- Reviewed services related to embedded systems, PCB design, IoT, and automation.\n- Collected project ideas and details.\n- Interacted with students regarding project collection and discussed their project requirements.\n\nStatus: Work completed.", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '3261', '9296', 'attendance-report', 'Attendance report: 2026-10-28 to 2026-10-28', 'approved', 'admin',
  'VISHNU VARSHINI M', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'vishnuu',
  '2026-10-28T11:26:27.759Z'::timestamptz, '2026-10-30T05:59:58.410Z'::timestamptz, '{"createdByRole": "employee", "createdByDesignation": "PCB & EMS/IoT Designer-T", "createdByEmployeeId": "MIB05", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "6380551370", "payload": {"fromDate": "2026-10-28", "toDate": "2026-10-28", "remarks": "Daily Work Report\n\n1. Marketing Agency Outreach: Contacted marketing agencies to explore potential collaborations for promoting company internship programs and increasing student registrations. Initiated discussions regarding marketing strategies, outreach methods, and registration support.\n\n2. SSR Project \u2013 Component Sourcing: Worked on identifying and sourcing the required electronic components for the SSR project. Reviewed component specifications, availability, and potential suppliers to support project development and procurement planning.", "daysRecorded": 1, "attendance": [{"id": "34d4d901-1f12-4c35-a7d9-775fcb37e57d", "userId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3", "username": "vishnuu", "fullName": "VISHNU VARSHINI M", "employeeId": "MIB05", "date": "2026-10-28", "checkIn": "2026-10-28T03:26:25.755Z"}], "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-10-30T05:59:58.409Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-28T11:48:55.728Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 0, "at": "2026-10-28T11:41:30.245Z"}]}, "remarks": "Daily Work Report\n\n1. Marketing Agency Outreach: Contacted marketing agencies to explore potential collaborations for promoting company internship programs and increasing student registrations. Initiated discussions regarding marketing strategies, outreach methods, and registration support.\n\n2. SSR Project \u2013 Component Sourcing: Worked on identifying and sourcing the required electronic components for the SSR project. Reviewed component specifications, availability, and potential suppliers to support project development and procurement planning.", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '6911', '1546', 'leave', 'Casual Leave Request', 'approved', 'admin',
  'SANTHANA KUMAR V', 'user-003', 'santhanakumarv',
  '2026-10-28T03:34:48.718Z'::timestamptz, '2026-10-28T03:52:56.844Z'::timestamptz, '{"createdByRole": "managing-partner", "createdByDesignation": "Managing Partner - Operations & Business Development", "createdByEmployeeId": "MIB03", "createdByDepartment": "Executive Management Team", "createdByPhone": "7010353723", "payload": {"name": "SANTHANA KUMAR V", "id": "MIB03", "designation": "Managing Partner - Operations & Business Development", "department": "Executive Management Team", "email": "santhanakumarv@suryas.in", "phone": "7010353723", "leaveType": "casual", "fromDate": "2026-10-28", "toDate": "2026-10-28", "reason": "Casual Leave", "remarks": "", "isPastDateRequest": false, "filledFormFileName": "", "submittedAt": "2026-10-28T03:34:48.653Z", "approvalChain": ["hareeshv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-28T03:52:56.843Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 0, "at": "2026-10-28T03:46:44.205Z"}]}, "remarks": "", "signatureFrom": "Admin", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '1516', '2157', 'leave', 'Casual Leave Request', 'approved', 'admin',
  'SMRITHI K', 'SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13', 'smrithik',
  '2026-10-28T03:20:00.938Z'::timestamptz, '2026-10-30T06:00:16.252Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB Design Intern", "createdByEmployeeId": "MIB08", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "8610492864", "payload": {"name": "SMRITHI K", "id": "MIB08", "designation": "PCB Design Intern", "department": "PCB Designs & Fabrication Team", "email": "smrithik2005@gmail.com", "phone": "8610492864", "leaveType": "casual", "fromDate": "2026-10-31", "toDate": "2026-10-31", "reason": "Anna University Degree Certificate photo is been taken on 31st October. Hence, requesting casual leave on the same day. Thank you", "remarks": "", "isPastDateRequest": false, "filledFormFileName": "", "submittedAt": "2026-10-28T03:20:01.272Z", "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 3, "at": "2026-10-30T06:00:16.251Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-10-30T05:58:41.251Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-30T05:57:12.636Z"}, {"by": "sabir", "comment": "", "decision": "recommend", "stageIndex": 0, "at": "2026-10-30T05:31:25.072Z"}]}, "remarks": "", "signatureFrom": "Hareesh", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '4894', '2426', 'attendance-report', 'Attendance report: 2026-10-26 to 2026-10-27', 'approved', 'admin',
  'SMRITHI K', 'SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13', 'smrithik',
  '2026-10-27T12:21:57.291Z'::timestamptz, '2026-10-30T09:13:42.635Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB Design Intern", "createdByEmployeeId": "MIB08", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "8610492864", "payload": {"fromDate": "2026-10-26", "toDate": "2026-10-27", "remarks": "We have completed the requirements analysis for both the single-phase and three-phase motor starter applications and decided on a modular architecture. This approach uses a single universal control PCB, while heavy-duty components like SSRs and heat sinks are mounted externally to safely manage thermal differences. To streamline development, we divided the schematic into four functional blocks: Power Supply, MCU & User Interface, Sensing, and SSR Isolation. We selected the STM32G474 microcontroller for its accurate analog monitoring capabilities, and chose Current Transformers (CT) over Hall-effect sensors to keep dangerous high-current traces off the board. We are now proceeding with drafting the schematics in Altium Designer to meet the upcoming submission deadline.", "daysRecorded": 2, "attendance": [{"id": "01b5ec32-4811-40cb-a11b-32b4530c5631", "userId": "SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13", "username": "smrithik", "fullName": "SMRITHI K", "employeeId": "MIB08", "date": "2026-10-27", "checkIn": "2026-10-27T03:14:46.993Z", "checkOut": "2026-10-27T12:21:41.361Z"}, {"id": "a2a6b5c9-6e69-4501-9ef2-cc416641012d", "userId": "SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13", "username": "smrithik", "fullName": "SMRITHI K", "employeeId": "MIB08", "date": "2026-10-26", "checkIn": "2026-10-26T02:57:54.171Z"}], "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 3, "at": "2026-10-30T09:13:42.634Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-10-30T09:12:53.898Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-30T06:06:03.176Z"}, {"by": "sabir", "comment": "", "decision": "recommend", "stageIndex": 0, "at": "2026-10-30T03:32:47.069Z"}]}, "remarks": "We have completed the requirements analysis for both the single-phase and three-phase motor starter applications and decided on a modular architecture. This approach uses a single universal control PCB, while heavy-duty components like SSRs and heat sinks are mounted externally to safely manage thermal differences. To streamline development, we divided the schematic into four functional blocks: Power Supply, MCU & User Interface, Sensing, and SSR Isolation. We selected the STM32G474 microcontroller for its accurate analog monitoring capabilities, and chose Current Transformers (CT) over Hall-effect sensors to keep dangerous high-current traces off the board. We are now proceeding with drafting the schematics in Altium Designer to meet the upcoming submission deadline.", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '5124', '6000', 'attendance-report', 'Attendance report: 2026-10-27 to 2026-10-27', 'approved', 'admin',
  'RITHANYA D', 'SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb', 'rithanyad',
  '2026-10-27T12:11:11.517Z'::timestamptz, '2026-10-28T03:10:50.571Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB Design Intern", "createdByEmployeeId": "MIB09", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "9384304331", "payload": {"fromDate": "2026-10-27", "toDate": "2026-10-27", "remarks": "Today, the project was divided into four functional blocks to organize the system design and component selection systematically:\n\nPower Supply Unit (PSU)\n\nCore Sensing and Protection\n\nIsolation and SSR Switching\n\nUser Interface and Logic\n\nFor the Core Sensing and Protection block, the STM32G474 microcontroller was shortlisted based on its high-resolution ADC, integrated comparators, and fast fault-detection capabilities.\n\nResearch was initiated to identify suitable voltage and current sensing components compatible with the selected microcontroller. The associated signal-conditioning circuits and protection requirements are also being evaluated.\n\nFor the Power Supply Unit, the requirements for both single-phase and three-phase operation were identified as key factors to be analysed before finalizing the circuit design and component selection.\n\nThe component selection process is being organized block-wise to simplify design decisions, identify component dependencies, and support systematic prototype development.\n\nNext Steps\n\nFinalize suitable voltage and current sensing components.\n\nAnalyse signal-conditioning and input-protection requirements.\n\nEvaluate PSU requirements for single-phase and three-phase operation.\n\nSelect suitable isolation and SSR switching components.\n\nPrepare the preliminary circuit design and verify component compatibility.\n\nCurrent Status\n\nThe project is in the functional block planning and component research phase. The microcontroller has been shortlisted, and further component evaluation is required before finalizing the circuit design and proceeding to prototyping.", "daysRecorded": 1, "attendance": [{"id": "978dd5df-fcf5-461a-909c-636d99660ac0", "userId": "SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb", "username": "rithanyad", "fullName": "RITHANYA D", "employeeId": "MIB09", "date": "2026-10-27", "checkIn": "2026-10-27T03:16:18.362Z", "checkOut": "2026-10-27T12:10:04.089Z"}], "approvalChain": ["vishnuu", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "guideId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3", "guideUsername": "vishnuu", "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 3, "at": "2026-10-28T03:10:50.571Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-10-28T03:10:05.263Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-27T12:32:39.251Z"}, {"by": "vishnuu", "comment": "", "decision": "recommend", "stageIndex": 0, "at": "2026-10-27T12:32:20.689Z"}]}, "remarks": "Today, the project was divided into four functional blocks to organize the system design and component selection systematically:\n\nPower Supply Unit (PSU)\n\nCore Sensing and Protection\n\nIsolation and SSR Switching\n\nUser Interface and Logic\n\nFor the Core Sensing and Protection block, the STM32G474 microcontroller was shortlisted based on its high-resolution ADC, integrated comparators, and fast fault-detection capabilities.\n\nResearch was initiated to identify suitable voltage and current sensing components compatible with the selected microcontroller. The associated signal-conditioning circuits and protection requirements are also being evaluated.\n\nFor the Power Supply Unit, the requirements for both single-phase and three-phase operation were identified as key factors to be analysed before finalizing the circuit design and component selection.\n\nThe component selection process is being organized block-wise to simplify design decisions, identify component dependencies, and support systematic prototype development.\n\nNext Steps\n\nFinalize suitable voltage and current sensing components.\n\nAnalyse signal-conditioning and input-protection requirements.\n\nEvaluate PSU requirements for single-phase and three-phase operation.\n\nSelect suitable isolation and SSR switching components.\n\nPrepare the preliminary circuit design and verify component compatibility.\n\nCurrent Status\n\nThe project is in the functional block planning and component research phase. The microcontroller has been shortlisted, and further component evaluation is required before finalizing the circuit design and proceeding to prototyping.", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '1292', '5215', 'attendance-report', 'Attendance report: 2026-10-27 to 2026-10-27', 'approved', 'admin',
  'MATHIYAZHAGAN D', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', 'mathi',
  '2026-10-27T11:32:08.861Z'::timestamptz, '2026-10-30T09:13:44.653Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB Design Intern", "createdByEmployeeId": "MIB06", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "8056197704", "payload": {"fromDate": "2026-10-27", "toDate": "2026-10-27", "remarks": "Today''s Work Report \n\nWork Done :\n- Researched companies related to embedded systems and electronics.\n- Collected information about company services and technical domains.\n- Reviewed PCB design, embedded hardware, IoT, and automation-related services.\n- Organized the collected information for documentation.", "daysRecorded": 1, "attendance": [{"id": "bd0c1c85-11c9-47cc-9bdd-2d6f33500c4b", "userId": "SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01", "username": "mathi", "fullName": "MATHIYAZHAGAN D", "employeeId": "MIB06", "date": "2026-10-27", "checkIn": "2026-10-27T03:31:05.220Z"}], "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 3, "at": "2026-10-30T09:13:44.653Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-10-30T09:12:59.933Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-30T06:06:10.831Z"}, {"by": "sabir", "comment": "", "decision": "recommend", "stageIndex": 0, "at": "2026-10-30T03:32:21.955Z"}]}, "remarks": "Today''s Work Report \n\nWork Done :\n- Researched companies related to embedded systems and electronics.\n- Collected information about company services and technical domains.\n- Reviewed PCB design, embedded hardware, IoT, and automation-related services.\n- Organized the collected information for documentation.", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '3955', '6250', 'attendance-report', 'Attendance report: 2026-10-27 to 2026-10-27', 'approved', 'admin',
  'VISHNU VARSHINI M', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'vishnuu',
  '2026-10-27T11:12:31.494Z'::timestamptz, '2026-10-28T03:10:53.696Z'::timestamptz, '{"createdByRole": "employee", "createdByDesignation": "PCB & EMS/IoT Designer-T", "createdByEmployeeId": "MIB05", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "6380551370", "payload": {"fromDate": "2026-10-27", "toDate": "2026-10-27", "remarks": "DAILY WORK REPORT\nDate: 27 October 2026\n\nDIN-Rail Industrial IoT Controller \u2013 Requirement Analysis\n\nReviewed the project requirements for the industrial IoT controller.\n\nExamined the proposed scope covering schematic design, PCB layout, firmware development, prototype fabrication, and testing.\n\nConsidered the initial prototype quantity of 5\u201310 units and the subsequent production batch of 60 units.\n\nQuotation Preparation\n\nPrepared a preliminary quotation document for the DIN-Rail Industrial IoT Controller project.\n\nOrganized the project scope and deliverables for quotation submission.\n\nIdentified the need for final technical confirmation before preparing the final quotation.\n\nTechnical Clarifications\n\nClarified points regarding universal input channels, analog and digital inputs, relay output ratings, power supply and other requirements for industrial controller project\n\nFunctional blocks preparation\n\nWorked on preparing the functional block and the respective components required to build the schematic for SSR based motor starter project.", "daysRecorded": 1, "attendance": [{"id": "ac72454a-6f65-4963-8370-290bd823b22a", "userId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3", "username": "vishnuu", "fullName": "VISHNU VARSHINI M", "employeeId": "MIB05", "date": "2026-10-27", "checkIn": "2026-10-27T03:21:40.243Z"}], "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-10-28T03:10:53.695Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-28T03:10:07.173Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 0, "at": "2026-10-27T12:01:21.650Z"}]}, "remarks": "DAILY WORK REPORT\nDate: 27 October 2026\n\nDIN-Rail Industrial IoT Controller \u2013 Requirement Analysis\n\nReviewed the project requirements for the industrial IoT controller.\n\nExamined the proposed scope covering schematic design, PCB layout, firmware development, prototype fabrication, and testing.\n\nConsidered the initial prototype quantity of 5\u201310 units and the subsequent production batch of 60 units.\n\nQuotation Preparation\n\nPrepared a preliminary quotation document for the DIN-Rail Industrial IoT Controller project.\n\nOrganized the project scope and deliverables for quotation submission.\n\nIdentified the need for final technical confirmation before preparing the final quotation.\n\nTechnical Clarifications\n\nClarified points regarding universal input channels, analog and digital inputs, relay output ratings, power supply and other requirements for industrial controller project\n\nFunctional blocks preparation\n\nWorked on preparing the functional block and the respective components required to build the schematic for SSR based motor starter project.", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '2609', '9807', 'leave', 'Casual Leave Request', 'approved', 'admin',
  'HAREESH V', 'user-002', 'hareeshv',
  '2026-10-27T09:45:33.501Z'::timestamptz, '2026-10-27T11:45:45.026Z'::timestamptz, '{"createdByRole": "managing-partner", "createdByDesignation": "Managing Partner - Projects & Administration", "createdByEmployeeId": "MIB02", "createdByDepartment": "Executive Management Team", "createdByPhone": "6383014533", "payload": {"name": "HAREESH V", "id": "MIB02", "designation": "Managing Partner - Projects & Administration", "department": "Executive Management Team", "email": "hareeshv@suryas.in", "phone": "6383014533", "leaveType": "casual", "fromDate": "2026-10-27", "toDate": "2026-10-27", "reason": "Casual Leave.", "remarks": "", "isPastDateRequest": false, "filledFormFileName": "", "submittedAt": "2026-10-27T09:45:33.395Z", "approvalChain": ["santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-27T11:45:45.025Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 0, "at": "2026-10-27T09:46:17.894Z"}]}, "remarks": "", "signatureFrom": "Admin", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '6732', '1169', 'attendance-report', 'Attendance report: 2026-10-26 to 2026-10-26', 'approved', 'admin',
  'MATHIYAZHAGAN D', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', 'mathi',
  '2026-10-26T13:09:37.195Z'::timestamptz, '2026-10-30T09:13:47.122Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB Design Intern", "createdByEmployeeId": "MIB06", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "8056197704", "payload": {"fromDate": "2026-10-26", "toDate": "2026-10-26", "remarks": "Today''s work report \n\nWork Summary:\nToday, I researched and reviewed the websites of companies working in electronics design, embedded hardware, PCB design, IoT, and automation.\n\nTasks Completed:\n\n1. Reviewed the company website of DSIB Technologies.\n2. Reviewed Circuitronica''s website and its business domain.\n3. Reviewed RV Circuits'' website and its services.\n4. Reviewed Dexcel Designs'' website and its areas of specialization.\n5. Identified and organized the companies'' domains based on their technical services.\n6. Submitted the college data base", "daysRecorded": 1, "attendance": [{"id": "33fef29c-df11-4af2-849b-8c66f37ef777", "userId": "SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01", "username": "mathi", "fullName": "MATHIYAZHAGAN D", "employeeId": "MIB06", "date": "2026-10-26", "checkIn": "2026-10-26T03:36:59.493Z", "checkOut": "2026-10-26T12:00:47.980Z"}], "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 3, "at": "2026-10-30T09:13:47.122Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-10-30T09:13:05.502Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-30T06:06:15.606Z"}, {"by": "sabir", "comment": "", "decision": "recommend", "stageIndex": 0, "at": "2026-10-30T03:32:11.788Z"}]}, "remarks": "Today''s work report \n\nWork Summary:\nToday, I researched and reviewed the websites of companies working in electronics design, embedded hardware, PCB design, IoT, and automation.\n\nTasks Completed:\n\n1. Reviewed the company website of DSIB Technologies.\n2. Reviewed Circuitronica''s website and its business domain.\n3. Reviewed RV Circuits'' website and its services.\n4. Reviewed Dexcel Designs'' website and its areas of specialization.\n5. Identified and organized the companies'' domains based on their technical services.\n6. Submitted the college data base", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '6548', '5244', 'attendance-report', 'Attendance report: 2026-10-26 to 2026-10-26', 'approved', 'admin',
  'RITHANYA D', 'SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb', 'rithanyad',
  '2026-10-26T12:58:43.418Z'::timestamptz, '2026-10-27T03:25:13.763Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB Design Intern", "createdByEmployeeId": "MIB09", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "9384304331", "payload": {"fromDate": "2026-10-26", "toDate": "2026-10-26", "remarks": "Session Summary\n\n- Studied the project requirements for developing an SSR-based electronic motor starter supporting single-phase and three-phase motors.\n- Reviewed the required protection functions, including over-voltage, under-voltage, overload, dry-run and phase-failure protection.\n- Discussed the feasibility of a common control platform for both motor configurations.\n- Identified the major system sections: Main Control PCB, Display and Keypad PCB, and Power Interface and Protection Assembly.\n- Prepared a preliminary list of component categories with proposed specifications, quantities and purposes.\n- Reviewed possible microcontroller options and identified motor specifications required before final component selection.\n\nOutcome\n- Gained an understanding of the proposed motor starter architecture and its major functional blocks.\n- Prepared an initial component list to support further circuit design.\n- Identified pending technical requirements, including motor ratings, current-sensing specifications and SSR selection criteria.\n- Established the next steps for preliminary schematic development and design review.\n\nNext Plan\nPrepare the system block diagram, finalize the preliminary controller input/output requirements and begin the low-voltage control circuit schematic for the upcoming design submission.", "daysRecorded": 1, "attendance": [{"id": "68b176a6-2aed-4ab9-860f-4ee4c66d5503", "userId": "SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb", "username": "rithanyad", "fullName": "RITHANYA D", "employeeId": "MIB09", "date": "2026-10-26", "checkIn": "2026-10-26T02:52:46.332Z", "checkOut": "2026-10-26T11:57:02.048Z"}], "approvalChain": ["vishnuu", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "guideId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3", "guideUsername": "vishnuu", "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 3, "at": "2026-10-27T03:25:13.763Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-10-27T03:24:33.245Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-27T03:18:26.724Z"}, {"by": "vishnuu", "comment": "", "decision": "recommend", "stageIndex": 0, "at": "2026-10-26T13:02:58.020Z"}]}, "remarks": "Session Summary\n\n- Studied the project requirements for developing an SSR-based electronic motor starter supporting single-phase and three-phase motors.\n- Reviewed the required protection functions, including over-voltage, under-voltage, overload, dry-run and phase-failure protection.\n- Discussed the feasibility of a common control platform for both motor configurations.\n- Identified the major system sections: Main Control PCB, Display and Keypad PCB, and Power Interface and Protection Assembly.\n- Prepared a preliminary list of component categories with proposed specifications, quantities and purposes.\n- Reviewed possible microcontroller options and identified motor specifications required before final component selection.\n\nOutcome\n- Gained an understanding of the proposed motor starter architecture and its major functional blocks.\n- Prepared an initial component list to support further circuit design.\n- Identified pending technical requirements, including motor ratings, current-sensing specifications and SSR selection criteria.\n- Established the next steps for preliminary schematic development and design review.\n\nNext Plan\nPrepare the system block diagram, finalize the preliminary controller input/output requirements and begin the low-voltage control circuit schematic for the upcoming design submission.", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '6072', '4461', 'attendance-report', 'Attendance report: 2026-10-26 to 2026-10-26', 'approved', 'admin',
  'VISHNU VARSHINI M', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'vishnuu',
  '2026-10-26T12:00:00.694Z'::timestamptz, '2026-10-26T13:07:42.802Z'::timestamptz, '{"createdByRole": "employee", "createdByDesignation": "PCB & EMS/IoT Designer-T", "createdByEmployeeId": "MIB05", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "6380551370", "payload": {"fromDate": "2026-10-26", "toDate": "2026-10-26", "remarks": "DAILY WORK REPORT \nDate: 26 October 2026\n\n1. Servo Power Distribution Board (PDB) \u2013 Technical Analysis\n- Reviewed the servo power requirements for four servos, including continuous current of 2.8 A and peak current of 8.4 A per servo.\n- Analysed the requirement for redundant 8 V DC-DC converters, ensuring that a single converter can support the complete servo load.\n- Reviewed power distribution, load capacity, and redundancy requirements.\n\n2. Motor Starter Project \u2013 Design Review\n- Reviewed the project diagrams and technical information.\n- Analysed the project requirements to understand the system operation and major functional blocks.\n- Created block diagram and flow chart for building the schematic.\n\n3. Project Quotation Revision\n- Worked on preparing a professional quotation document with altered pricing for the Motor Starter project based on the available technical requirements.\n- Reviewed the project scope and quotation structure for clarity and professional presentation.\n\n4. Debugging in Kicad\n* Worked on the schematic of the 4 layer project and debugging of warnings related to footprints and pin configuration.", "daysRecorded": 1, "attendance": [{"id": "37537ff1-dfeb-4a35-97ec-607e1cedba91", "userId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3", "username": "vishnuu", "fullName": "VISHNU VARSHINI M", "employeeId": "MIB05", "date": "2026-10-26", "checkIn": "2026-10-26T03:26:38.358Z", "checkOut": "2026-10-26T11:52:33.577Z"}], "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-10-26T13:07:42.801Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-26T13:02:56.417Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 0, "at": "2026-10-26T12:52:40.193Z"}]}, "remarks": "DAILY WORK REPORT \nDate: 26 October 2026\n\n1. Servo Power Distribution Board (PDB) \u2013 Technical Analysis\n- Reviewed the servo power requirements for four servos, including continuous current of 2.8 A and peak current of 8.4 A per servo.\n- Analysed the requirement for redundant 8 V DC-DC converters, ensuring that a single converter can support the complete servo load.\n- Reviewed power distribution, load capacity, and redundancy requirements.\n\n2. Motor Starter Project \u2013 Design Review\n- Reviewed the project diagrams and technical information.\n- Analysed the project requirements to understand the system operation and major functional blocks.\n- Created block diagram and flow chart for building the schematic.\n\n3. Project Quotation Revision\n- Worked on preparing a professional quotation document with altered pricing for the Motor Starter project based on the available technical requirements.\n- Reviewed the project scope and quotation structure for clarity and professional presentation.\n\n4. Debugging in Kicad\n* Worked on the schematic of the 4 layer project and debugging of warnings related to footprints and pin configuration.", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '8625', '5730', 'report', 'Daily Work Report – Company Website Research', 'rejected', 'admin',
  'MATHIYAZHAGAN D', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', 'mathi',
  '2026-10-26T11:59:55.873Z'::timestamptz, '2026-10-26T13:02:42.741Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB Design Intern", "createdByEmployeeId": "MIB06", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "8056197704", "payload": {"description": "Today, I researched the websites of DSIB Technologies, Circuitronica, RV Circuits, and Dexcel Designs. I reviewed their business domains and technical service areas, including custom PCB design, embedded hardware, IoT sensor networks, electronics design, and automation prototypes. I organized the collected information to understand each company''s technical focus.", "reportFrequency": "weekly", "reportPeriodMode": "period", "reportPeriodYear": 2026, "reportPeriodMonth": 10, "reportPeriodWeek": 44, "periodStartDate": "2026-10-26", "periodEndDate": "2026-11-01", "periodLabel": "2026-10-26", "reportDate": "2026-10-26", "attachments": [], "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "santhanakumarv", "comment": "Summited Under Weekly. Summit to Attdance Page.", "decision": "reject", "stageIndex": 2, "at": "2026-10-26T13:02:42.740Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-26T12:52:46.987Z"}, {"by": "sabir", "comment": "", "decision": "recommend", "stageIndex": 0, "at": "2026-10-26T12:07:51.795Z"}]}, "remarks": "The purpose of this report is to document today''s company research activities and improve my understanding of companies working in embedded systems, PCB design, IoT, and electronics engineering. The research will help in identifying companies and their areas of specialization.", "forwardedTo": "santhanakumarv"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '3137', '3813', 'report', 'Daily report', 'rejected', 'admin',
  'VISHNU VARSHINI M', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'vishnuu',
  '2026-10-26T11:51:39.015Z'::timestamptz, '2026-10-26T13:01:44.118Z'::timestamptz, '{"createdByRole": "employee", "createdByDesignation": "PCB & EMS/IoT Designer-T", "createdByEmployeeId": "MIB05", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "6380551370", "payload": {"description": "DAILY WORK REPORT \nDate: 26 October 2026\n\n1. Servo Power Distribution Board (PDB) \u2013 Technical Analysis\n- Reviewed the servo power requirements for four servos, including continuous current of 2.8 A and peak current of 8.4 A per servo.\n- Analysed the requirement for redundant 8 V DC-DC converters, ensuring that a single converter can support the complete servo load.\n- Reviewed power distribution, load capacity, and redundancy requirements.\n\n2. Motor Starter Project \u2013 Design Review\n- Reviewed the project diagrams and technical information.\n- Analysed the project requirements to understand the system operation and major functional blocks.\n- Created block diagram and flow chart for building the schematic.\n\n3. Project Quotation Revision\n- Worked on preparing a professional quotation document with altered pricing for the Motor Starter project based on the available technical requirements.\n- Reviewed the project scope and quotation structure for clarity and professional presentation.\n\n4. Debugging in Kicad\n- Worked on the schematic of the 4 layer project and debugging of warnings related to footprints and pin configuration.", "reportFrequency": "weekly", "reportPeriodMode": "period", "reportPeriodYear": 2026, "reportPeriodMonth": 10, "reportPeriodWeek": 43, "periodStartDate": "2026-10-19", "periodEndDate": "2026-10-25", "periodLabel": "2026-10-25", "reportDate": "2026-10-25", "attachments": [], "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "santhanakumarv", "comment": "Two Time Summited.", "decision": "reject", "stageIndex": 1, "at": "2026-10-26T13:01:44.117Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 0, "at": "2026-10-26T12:52:56.554Z"}]}, "remarks": "Daily report (Date: 26 October 2026)", "forwardedTo": "santhanakumarv"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '4591', '7079', 'leave', 'Casual Leave Request', 'approved', 'admin',
  'GOLLA KUMAR BHARATH', 'founder-001', 'gkbharath',
  '2026-10-26T05:33:14.952Z'::timestamptz, '2026-10-26T05:45:45.954Z'::timestamptz, '{"createdByRole": "founder", "createdByDesignation": "Founder & Chief Executive Partner", "createdByEmployeeId": "MIB01", "createdByDepartment": "Executive Management Team", "createdByPhone": "8124227370", "payload": {"name": "GOLLA KUMAR BHARATH", "id": "MIB01", "designation": "Founder & Chief Executive Partner", "department": "Executive Management Team", "email": "gollakumarbharath@suryas.in", "phone": "8124227370", "leaveType": "casual", "fromDate": "2026-10-29", "toDate": "2026-10-29", "reason": "Casual Leave, Personal.", "remarks": "", "isPastDateRequest": false, "filledFormFileName": "", "submittedAt": "2026-10-26T05:33:14.886Z", "approvalChain": ["hareeshv", "santhanakumarv"], "currentApproverIndex": 1, "comments": [{"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-26T05:45:45.954Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 0, "at": "2026-10-26T05:44:24.958Z"}]}, "remarks": "", "signatureFrom": "Admin", "forwardedTo": "santhanakumarv"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '4973', '5501', 'leave', 'Casual Leave Request', 'rejected', 'admin',
  'MATHIYAZHAGAN D', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', 'mathi',
  '2026-10-26T04:45:57.687Z'::timestamptz, '2026-10-28T03:11:00.140Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB Design Intern", "createdByEmployeeId": "MIB06", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "8056197704", "payload": {"name": "MATHIYAZHAGAN D", "id": "MIB06", "designation": "PCB Design Intern", "department": "PCB Designs & Fabrication Team", "email": "mathiyazhagandhanapalmathiyazh@gmail.com", "phone": "8056197704", "leaveType": "casual", "fromDate": "2026-10-31", "toDate": "2026-10-31", "reason": "Casual leave", "remarks": "", "isPastDateRequest": false, "filledFormFileName": "", "submittedAt": "2026-10-26T04:45:58.958Z", "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "comments": [{"by": "gkbharath", "comment": "", "decision": "reject", "stageIndex": 3, "at": "2026-10-28T03:11:00.140Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-10-26T13:02:49.989Z"}, {"by": "hareeshv", "comment": "With out my permission can''t approve the leave", "decision": "approve", "stageIndex": 1, "at": "2026-10-26T12:54:10.361Z"}, {"by": "sabir", "comment": "", "decision": "recommend", "stageIndex": 0, "at": "2026-10-26T04:49:24.501Z"}]}, "remarks": "", "signatureFrom": "Hareesh", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '7504', '8867', 'report', 'Weekly report', 'rejected', 'admin',
  'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'sabir',
  '2026-10-26T04:18:30.920Z'::timestamptz, '2026-10-26T04:34:19.914Z'::timestamptz, '{"createdByRole": "employee", "createdByDesignation": "PCB Fabrication Engineer", "createdByEmployeeId": "MIB04", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "9626272076", "payload": {"description": "WEEKLY WORK REPORT\nEmployee Name: Sabir Mohamed\nReporting Period: 23 October 2026 \u2013 24 October 2026\n1. TEQTIS INFO Project \u2013 PDB Design Workflow and Analysis\nPrepared the project workflow for the Dual-Battery Power Distribution Board (PDB) design.\nConducted an initial analysis of the project requirements, engineering activities, and development procedures.\nReviewed the proposed work sequence and identified key tasks required for project execution.\nParticipated in a technical discussion with Advisor Surya and Managing Partner Hareesh regarding project requirements, development approaches, work allocation, and engineering resources.\nAnalysed the scope of work for the upcoming TEQTIS project to support planning and execution.\n2. Four-Layer PCB Design \u2013 Altium Designer\nContinued development of the four-layer PCB design using Altium Designer.\nWorked on component footprint modifications and customization.\nPerformed schematic debugging and validation to identify circuit connection errors and design inconsistencies.\nCarried out design corrections and verification to improve schematic accuracy and prepare the design for further PCB development.\n3. Student Communication and Project Coordination\nCommunicated with students regarding their project requirements and progress.\nExplained the company brochure and provided information about the company''s services and project offerings.\nClarified student queries related to projects and available services.\nDiscussed project confirmation and pricing with a student.\nFollowed up on the student''s pricing concerns and documented the difficulty in proceeding at the quoted price.\n4. Engineering College Data Collection\nContinued collecting information related to engineering colleges.\nOrganized the collected data for company records and future reference.\nMaintained progress on data collection activities to support future company outreach and project-related initiatives.\n5. Company Project Activities\nContinued working on ongoing company projects.\nFollowed up on project-related tasks and reviewed upcoming development requirements.\nAnalysed project scope and activities to support work planning and execution.\nWeekly Work Summary\nDuring the reporting period, work focused on technical project development, PCB design and schematic validation, TEQTIS INFO project planning, student communication, project pricing discussions, and engineering college data collection.\nProgress was made in reviewing engineering requirements, identifying design corrections, planning upcoming project activities, and supporting company outreach initiatives.\nOverall Status\nStatus: Ongoing project activities and assigned tasks progressed during the reporting period.\nPlan for the Next Week\nContinue the four-layer PCB design, including schematic validation, footprint corrections, and layout development.\nProceed with TEQTIS INFO project planning and detailed analysis of the Dual-Battery PDB design requirements.\nFollow up on project discussions and coordinate the next engineering activities with the relevant team members.\nContinue engineering college data collection and organize the information for company use.\nFollow up with students regarding project requirements, confirmations, and pricing wherever applicable.\nReport Prepared By: Sabir Mohamed", "reportFrequency": "weekly", "reportPeriodMode": "period", "reportPeriodYear": 2026, "reportPeriodMonth": 10, "reportPeriodWeek": 44, "periodStartDate": "2026-10-26", "periodEndDate": "2026-11-01", "periodLabel": "2026-10-26", "reportDate": "2026-10-26", "attachments": [], "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "gkbharath", "comment": "1,2,4 are others work.", "decision": "reject", "stageIndex": 2, "at": "2026-10-26T04:34:19.912Z"}, {"by": "santhanakumarv", "comment": "Subject to Review.", "decision": "approve", "stageIndex": 1, "at": "2026-10-26T04:31:48.899Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 0, "at": "2026-10-26T04:26:18.590Z"}]}, "remarks": "", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '4148', '6611', 'ta', 'Allowance Claim Request', 'approved', 'admin',
  'HAREESH V', 'user-002', 'hareeshv',
  '2026-10-26T04:14:01.832Z'::timestamptz, '2026-10-26T04:34:36.872Z'::timestamptz, '{"createdByRole": "managing-partner", "createdByDesignation": "Managing Partner - Projects & Administration", "createdByEmployeeId": "MIB02", "createdByDepartment": "Executive Management Team", "createdByPhone": "6383014533", "payload": {"name": "HAREESH V", "id": "MIB02", "designation": "Managing Partner - Projects & Administration", "department": "Executive Management Team", "email": "hareeshv@suryas.in", "phone": "6383014533", "claimType": "expenses", "amount": "1500", "description": "Petrol allowance ", "remarks": "Petrol allowance", "filledFormFileName": "DocScanner 26 Oct 2026 9-42 am.pdf", "billFileName": "DocScanner 26 Oct 2026 9-42 am.pdf", "filledFormFile": {"name": "DocScanner 26 Oct 2026 9-42 am.pdf", "size": 35993, "type": "application/pdf", "base64": "[FILE_STRIPPED]", "uploadedAt": "2026-10-26T04:14:00.799Z"}, "submittedAt": "2026-10-26T04:14:00.799Z", "approvalChain": ["santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-26T04:34:36.871Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 0, "at": "2026-10-26T04:15:34.925Z"}]}, "remarks": "Petrol allowance", "uploadedFile": {"name": "DocScanner 26 Oct 2026 9-42 am.pdf", "size": 35993, "type": "application/pdf", "base64": "[FILE_STRIPPED]", "uploadedAt": "2026-10-26T04:14:00.776Z"}, "signatureFrom": "Admin", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '4205', '2851', 'report', 'Weekly Work Report – Student Project Coordination and Engineering College Data Collection (19–24 October 2026)', 'approved', 'admin',
  'MATHIYAZHAGAN D', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', 'mathi',
  '2026-10-26T04:08:08.362Z'::timestamptz, '2026-10-26T05:32:33.536Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB Design Intern", "createdByEmployeeId": "MIB06", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "8056197704", "payload": {"description": "During the reporting period from 19 October to 24 October 2026, I worked on student project coordination, project collection follow-ups, company brochure explanation, and engineering college data collection across four states.\n\nI contacted students regarding project collection and discussed their project requirements. I explained the company brochure and services to students and followed up on project confirmation. During one confirmation discussion, a student raised a concern that the quoted project price was too high, and the project was not confirmed at the proposed price.\n\nAlongside student communication, I continued project-related activities for the company and collected and organized engineering college data to support future college outreach, training proposals, and institutional business development.\n\nThe same ongoing work activities were carried out on 19, 20, and 21 October, followed by the above activities during 22\u201324 October.", "reportFrequency": "weekly", "reportPeriodMode": "period", "reportPeriodYear": 2026, "reportPeriodMonth": 10, "reportPeriodWeek": 43, "periodStartDate": "2026-10-19", "periodEndDate": "2026-10-25", "periodLabel": "2026-10-24", "reportDate": "2026-10-24", "attachments": [{"name": "Report.pdf", "size": 35591, "type": "application/pdf", "base64": "[FILE_STRIPPED]"}], "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 3, "at": "2026-10-26T05:32:33.535Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-10-26T05:29:33.207Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-26T05:28:29.874Z"}, {"by": "sabir", "comment": "", "decision": "recommend", "stageIndex": 0, "at": "2026-10-26T05:15:40.197Z"}]}, "remarks": "This report summarizes the work completed and ongoing activities during the week. The main objectives were to coordinate with students regarding projects, explain the company\u2019s services, follow up on project confirmation, and continue engineering college data collection across four states.", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '6023', '6131', 'leave', 'Casual Leave Request', 'approved', 'admin',
  'VISHNU VARSHINI M', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'vishnuu',
  '2026-10-26T03:55:28.637Z'::timestamptz, '2026-10-26T05:31:27.734Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB & EMS/IoT Designer-T", "createdByEmployeeId": "MIB05", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "6380551370", "payload": {"name": "VISHNU VARSHINI M", "id": "MIB05", "designation": "PCB & EMS/IoT Designer-T", "department": "PCB Designs & Fabrication Team", "email": "pcb.designers@suryas.in", "phone": "6380551370", "leaveType": "casual", "fromDate": "2026-10-31", "toDate": "2026-10-31", "reason": "Degree certificate photo is to be taken at college on the mentioned date.", "remarks": "", "isPastDateRequest": false, "filledFormFileName": "", "submittedAt": "2026-10-26T03:55:28.768Z", "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 3, "at": "2026-10-26T05:31:27.733Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-10-26T05:26:15.434Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-26T05:25:50.327Z"}, {"by": "sabir", "comment": "", "decision": "recommend", "stageIndex": 0, "at": "2026-10-26T04:49:35.133Z"}]}, "remarks": "", "signatureFrom": "Admin", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '4212', '7736', 'report', 'weekly report (Reporting Period: 08 October 2026, 10 October 2026)', 'approved', 'admin',
  'VISHNU VARSHINI M', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'vishnuu',
  '2026-10-26T03:45:56.043Z'::timestamptz, '2026-10-26T05:31:40.701Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB & EMS/IoT Designer-T", "createdByEmployeeId": "MIB05", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "6380551370", "payload": {"description": "1. Introduction\nThis report summarizes the joining formalities, initial work orientation, and technical workshop activities carried out on 08 October 2026 and 10 October 2026 as part of my professional responsibilities at SURYA\u2019S MiB ENTERPRISES.\n2. Activities on 08 October 2026 \u2013 Joining and Induction\nVenue: Mudhalvar Padaipagam\nTime: 10:00 AM onwards\nI formally joined SURYA\u2019S MiB ENTERPRISES on 08 October 2026 as a PCB & EMS / IoT Engineer / Designer \u2013 T.\nThe day''s activities included:\nSubmission of the required documents and completion of document verification.\nReceipt of the joining letter from Advisor Surya and Managing Partner Hareesh V.\nAn initial discussion regarding the organization''s work nature, technical responsibilities, and upcoming assignments.\nThe induction process provided an initial understanding of the organization''s expectations and the responsibilities associated with my position.\n3. Activities on 10 October 2026 \u2013 Hands-on Technical Workshop\nVenue: AMS College of Engineering, Avadi\nTeam Members: Vishnu Varshini M, Sabir Mohamed, and Managing Partner Hareesh V\nOn 10 October 2026, I participated in conducting a practical technical workshop at AMS College of Engineering, Avadi, along with team member Sabir Mohamed and Managing Partner Hareesh V.\nThe workshop focused on providing students with practical exposure to electronics and IoT-based project development.\nKey activities conducted\nWorkshop Setup and Coordination: Took over and coordinated the workshop activities at the college along with the team.\nHands-on Project Training: Guided students through the implementation of three mini projects, providing practical demonstrations and hands-on learning opportunities.\nProject Testing and Verification: Tested the completed mini projects to verify their functionality and demonstrate the working principles to the students.\nStudent Interaction: Supported practical learning by explaining project implementation and helping students understand the functioning of the developed systems.\nCertificate Distribution: Concluded the workshop activities with the distribution of certificates to the participating students.\nThe workshop provided students with practical experience in project implementation and testing while supporting their understanding of applied electronics and IoT concepts.", "reportFrequency": "weekly", "reportPeriodMode": "period", "reportPeriodYear": 2026, "reportPeriodMonth": 10, "reportPeriodWeek": 41, "periodStartDate": "2026-10-05", "periodEndDate": "2026-10-11", "periodLabel": "2026-10-08", "reportDate": "2026-10-08", "attachments": [], "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 3, "at": "2026-10-26T05:31:40.701Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-10-26T05:27:46.469Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-26T05:25:57.515Z"}, {"by": "sabir", "comment": "", "decision": "recommend", "stageIndex": 0, "at": "2026-10-26T05:15:44.360Z"}]}, "remarks": "", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '7789', '4107', 'report', 'weekly report (Reporting Period: 14 October 2026 – 17 October 2026)', 'approved', 'admin',
  'VISHNU VARSHINI M', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'vishnuu',
  '2026-10-26T03:43:20.098Z'::timestamptz, '2026-10-26T05:31:53.106Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB & EMS/IoT Designer-T", "createdByEmployeeId": "MIB05", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "6380551370", "payload": {"description": "1. Introduction\nThis report summarizes the technical, quotation-preparation, marketing research, and business-development activities carried out from 14 October 2026 to 17 October 2026 as part of my responsibilities at SURYA\u2019S MiB ENTERPRISES.\n2. Activities on 14 October 2026 \u2013 Marketing Research, Quotations and Design File Analysis\nThe day''s activities focused on CMRL marketing research, preparation of project quotations, and initial analysis of a four-layer PCB design file.\n\uf0b7CMRL Marketing Research: Worked on gathering marketing-related details and reviewing potential opportunities for promoting the organization''s products.\n\uf0b7Quotation Preparation for JSON Design Files: Prepared a quotation based on the provided JSON design files.\n\uf0b7Induction Motor Control PCB Quotation: Worked on a quotation for a 230 VAC, single-phase induction motor control PCB project.\n\uf0b7Four-Layer PCB File Analysis: Analysed the provided four-layer PCB JSON file in EasyEDA to review the design and identify items requiring further checking.\n3. Activities on 15 October 2026 \u2013 Four-Layer PCB Debugging and DRC Analysis\nThe day''s work concentrated on debugging and checking the four-layer PCB project using KiCad.\n\uf0b7Design Debugging: Examined the four-layer project in KiCad and investigated design errors requiring correction.\n\uf0b7Error Analysis: Reviewed the identified issues to support further PCB design corrections.\n\uf0b7DRC Report: Generated and reviewed the Design Rule Check (DRC) report to identify reported PCB design-rule violations and guide the correction process.\n4. Activities on 16 October 2026 \u2013 Company Database and Quotation Preparation\nThe day''s activities focused on business development and preparation of a quotation for a controller project.\n\uf0b7Company Database Creation: Continued building a structured database of companies associated with electronics, embedded systems, IoT, firmware, and PCB-related services.\n\uf0b7Company Outreach: Contacted companies to explore potential business opportunities and orders for the organization.\n\uf0b7Hybrid Urinal Controller Quotation: Prepared a quotation for the hybrid urinal controller project based on the available project requirements.\n5. Activities on 17 October 2026 \u2013 Altium PCB Design and Database Development\nThe day''s work involved continuing the four-layer PCB design in Altium Designer alongside company database activities.\n\uf0b7Four-Layer PCB Design: Worked on developing the four-layer PCB layout in Altium Designer.\n\uf0b7Design Review and Progress: Continued the design workflow and reviewed the layout as part of the ongoing PCB design task.\n\uf0b7Company Database Work: Continued organizing and updating company information to support business development and outreach.\n6. Conclusion\nDuring the reporting period, I worked on CMRL marketing research, multiple PCB-related quotations, and the analysis and debugging of a four-layer PCB project using EasyEDA and KiCad. I also prepared a DRC report, continued the four-layer design in Altium Designer, and contributed to company database development and outreach for potential orders. These activities supported both the organization''s technical design work and its business-development efforts.", "reportFrequency": "weekly", "reportPeriodMode": "period", "reportPeriodYear": 2026, "reportPeriodMonth": 10, "reportPeriodWeek": 42, "periodStartDate": "2026-10-12", "periodEndDate": "2026-10-18", "periodLabel": "2026-10-14", "reportDate": "2026-10-14", "attachments": [], "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 3, "at": "2026-10-26T05:31:53.106Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-10-26T05:29:36.273Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-26T05:28:48.162Z"}, {"by": "sabir", "comment": "", "decision": "recommend", "stageIndex": 0, "at": "2026-10-26T05:15:48.126Z"}]}, "remarks": "", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '4601', '8676', 'report', 'weekly report (Reporting Period: 19–24 October 2026)', 'approved', 'admin',
  'VISHNU VARSHINI M', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'vishnuu',
  '2026-10-26T03:40:30.066Z'::timestamptz, '2026-10-26T10:49:11.445Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB & EMS/IoT Designer-T", "createdByEmployeeId": "MIB05", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "6380551370", "payload": {"description": "19 October 2026 \u2013 Monday\nContinued electronics and PCB-related project activities and reviewed ongoing work requirements.\nReviewed project requirements and supported ongoing quotation preparation and PCB design activities.\n21 October 2026 \u2013 Wednesday\nPrepared project quotations based on the specified technical requirements.\nDeveloped and updated the company database for business development and potential customer outreach.\nWorked on debugging errors and schematic development for the four-layer PCB project in Altium Designer.\n22 October 2026 \u2013 Thursday\nPrepared a quotation for the Dual-Battery Power Distribution Board (PDB) Design Project.\nModified and customized component footprints in Altium Designer to improve design consistency and resolve schematic/PCB-related issues.\n23 October 2026 \u2013 Friday\nPrepared the workflow and technical analysis for the upcoming TEQTIS INFO PDB Design Project.\nAttended a project discussion with Advisor Surya and Managing Partner Hareesh regarding the TEQTIS INFO project requirements and scope.\nContinued working on the four-layer PCB project in Altium Designer.\n24 October 2026 \u2013 Saturday\nDebugged and validated the schematic of the four-layer PCB project in Altium Designer.\nAnalysed the scope of work, technical requirements, and proposed activities for the upcoming TEQTIS INFO project.", "reportFrequency": "weekly", "reportPeriodMode": "period", "reportPeriodYear": 2026, "reportPeriodMonth": 10, "reportPeriodWeek": 44, "periodStartDate": "2026-10-26", "periodEndDate": "2026-11-01", "periodLabel": "2026-10-26", "reportDate": "2026-10-26", "attachments": [], "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "comments": [{"by": "gkbharath", "comment": "Subject to Check the Schematic Files Made By She.", "decision": "approve", "stageIndex": 3, "at": "2026-10-26T10:49:11.445Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-10-26T05:21:36.124Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-26T05:20:32.343Z"}, {"by": "sabir", "comment": "", "decision": "recommend", "stageIndex": 0, "at": "2026-10-26T05:15:52.981Z"}]}, "remarks": "", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '3403', '5761', 'internal-service', 'Internal Service Request from SANTHANA KUMAR V', 'conversation', 'admin',
  'SANTHANA KUMAR V', 'user-003', '',
  '2026-10-26T03:17:41.384Z'::timestamptz, '2026-10-26T03:17:41.384Z'::timestamptz, '{"createdByRole": "managing-partner", "createdByDesignation": "Managing Partner - Operations & Business Development", "createdByEmployeeId": "MIB03", "createdByDepartment": "Executive Management Team", "createdByPhone": "7010353723", "payload": {"description": "Hi Smrithi, Welcome to your 1at day of Intern.", "id": "MIB03", "designation": "Managing Partner - Operations & Business Development", "department": "Executive Management Team", "phone": "7010353723", "remarks": "", "files": [], "assignedHeadId": "SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13", "replies": []}}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '1665', '6323', 'internal-service', 'Internal Service Request from SANTHANA KUMAR V', 'conversation', 'admin',
  'SANTHANA KUMAR V', 'user-003', '',
  '2026-10-26T03:14:18.798Z'::timestamptz, '2026-10-26T03:14:18.798Z'::timestamptz, '{"createdByRole": "managing-partner", "createdByDesignation": "Managing Partner - Operations & Business Development", "createdByEmployeeId": "MIB03", "createdByDepartment": "Executive Management Team", "createdByPhone": "7010353723", "payload": {"description": "Hi Bharath,", "id": "MIB03", "designation": "Managing Partner - Operations & Business Development", "department": "Executive Management Team", "phone": "7010353723", "remarks": "", "files": [], "assignedHeadId": "founder-001", "replies": []}}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '6064', '4238', 'internal-service', 'Internal Service Request from GOLLA KUMAR BHARATH', 'conversation', 'admin',
  'GOLLA KUMAR BHARATH', 'founder-001', '',
  '2026-10-26T02:51:54.338Z'::timestamptz, '2026-10-26T02:51:54.338Z'::timestamptz, '{"createdByRole": "founder", "createdByDesignation": "Founder & Chief Executive Partner", "createdByEmployeeId": "MIB01", "createdByDepartment": "Executive Management Team", "createdByPhone": "8124227370", "payload": {"description": "Hi Rithanya, Welcome Your 1st Day of Intern. ", "id": "MIB01", "designation": "Founder & Chief Executive Partner", "department": "Executive Management Team", "phone": "8124227370", "remarks": "", "files": [], "assignedHeadId": "SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb", "replies": []}}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '6442', '6989', 'internal-service', 'Internal Service Request from GOLLA KUMAR BHARATH', 'conversation', 'admin',
  'GOLLA KUMAR BHARATH', 'founder-001', '',
  '2026-10-26T02:51:05.501Z'::timestamptz, '2026-10-26T02:51:05.501Z'::timestamptz, '{"createdByRole": "founder", "createdByDesignation": "Founder & Chief Executive Partner", "createdByEmployeeId": "MIB01", "createdByDepartment": "Executive Management Team", "createdByPhone": "8124227370", "payload": {"description": "1. Rajkumar Schule (this week before oct 2026)\n2. Sri City Company List  \n3. Mathiaglaan & you follow up get 30 mini projects", "id": "MIB01", "designation": "Founder & Chief Executive Partner", "department": "Executive Management Team", "phone": "8124227370", "remarks": "", "files": [], "assignedHeadId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "replies": []}}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '6505', '4799', 'internal-service', 'Internal Service Request from GOLLA KUMAR BHARATH', 'conversation', 'admin',
  'GOLLA KUMAR BHARATH', 'founder-001', '',
  '2026-10-26T02:34:03.608Z'::timestamptz, '2026-10-26T02:34:03.608Z'::timestamptz, '{"createdByRole": "founder", "createdByDesignation": "Founder & Chief Executive Partner", "createdByEmployeeId": "MIB01", "createdByDepartment": "Executive Management Team", "createdByPhone": "8124227370", "payload": {"description": "1. Share the source file of previous circuit\n2. TEQTIS Project with team circuit (circuit required on 29-10-2026)\n3. Check office official website all intern and course required marketing agency upto registration (intern minim 50/course minim 30) give a quote will be check. \n4. previous quote final review and give the final quote. PDB", "id": "MIB01", "designation": "Founder & Chief Executive Partner", "department": "Executive Management Team", "phone": "8124227370", "remarks": "", "files": [], "assignedHeadId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3", "replies": []}}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '8600', '6932', 'leave', 'Casual Leave Request', 'rejected', 'admin',
  'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'sabir',
  '2026-10-22T11:43:52.614Z'::timestamptz, '2026-10-22T11:48:26.746Z'::timestamptz, '{"createdByRole": "employee", "createdByDesignation": "PCB Fabrication Engineer", "createdByEmployeeId": "MIB04", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "9626272076", "payload": {"name": "SABIR MOHAMMED S", "id": "MIB04", "designation": "PCB Fabrication Engineer", "department": "PCB Designs & Fabrication Team", "email": "sabirmohammeds@suryas.in", "phone": "9626272076", "leaveType": "casual", "fromDate": "2026-10-25", "toDate": "2026-10-25", "reason": "Casual Leave", "remarks": "", "isPastDateRequest": false, "filledFormFileName": "", "submittedAt": "2026-10-22T11:43:52.540Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "gkbharath", "comment": "rejected due already taken a casual leave.", "decision": "reject", "stageIndex": 2, "at": "2026-10-22T11:48:26.746Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-22T11:47:35.823Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 0, "at": "2026-10-22T11:46:18.139Z"}]}, "remarks": "", "signatureFrom": "Admin", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '3432', '8982', 'ta', 'Allowance Claim Request', 'approved', 'admin',
  'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'sabir',
  '2026-10-19T11:53:12.032Z'::timestamptz, '2026-10-19T11:54:54.550Z'::timestamptz, '{"createdByRole": "employee", "createdByDesignation": "PCB Fabrication Engineer", "createdByEmployeeId": "MIB04", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "9626272076", "payload": {"name": "SABIR MOHAMMED S", "id": "MIB04", "designation": "PCB Fabrication Engineer", "department": "PCB Designs & Fabrication Team", "email": "sabirmohammeds@suryas.in", "phone": "9626272076", "claimType": "bill", "amount": "200", "description": "AMS Petrol Allowance ", "remarks": "", "filledFormFileName": "", "billFileName": "", "submittedAt": "2026-10-19T11:53:11.977Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-10-19T11:54:54.549Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-19T11:54:27.861Z"}, {"by": "hareeshv", "comment": "Subject to Summit Bill.", "decision": "approve", "stageIndex": 0, "at": "2026-10-19T11:53:59.651Z"}]}, "remarks": "", "signatureFrom": "Admin", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '9375', '4069', 'proposal', 'Project Proposal', 'approved', 'admin',
  'GOLLA KUMAR BHARATH', 'founder-001', 'gkbharath',
  '2026-10-19T10:50:17.109Z'::timestamptz, '2026-10-19T10:55:09.412Z'::timestamptz, '{"createdByRole": "founder", "createdByDesignation": "Founder & Chief Executive Partner", "createdByEmployeeId": "MIB01", "createdByDepartment": "Executive Management Team", "createdByPhone": "8124227370", "payload": {"projectTitle": "HYBRID CONTROLLER ", "projectStatus": "review", "createdBy": "GOLLA KUMAR BHARATH", "phone": "8124227370", "abstractFileName": "Hybrid_Urinal_Controller_FINAL_Manufacturer_Spec.pdf", "clientName": "TEQTIS INFO PVT LTD", "clientOrganization": "", "clientDesignation": "", "clientAddress": "", "clientPhone": "", "clientEmail": "", "projectAmount": "75000", "forwardedBy": "", "submittedAt": "2026-10-19T10:50:16.452Z", "remarks": "", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-10-19T10:55:09.412Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-19T10:54:30.934Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 0, "at": "2026-10-19T10:51:20.045Z"}]}, "remarks": "", "uploadedFile": {"name": "Hybrid_Urinal_Controller_FINAL_Manufacturer_Spec.pdf", "size": 41245, "type": "application/pdf", "base64": "[FILE_STRIPPED]", "uploadedAt": "2026-10-19T10:50:16.452Z"}, "signatureFrom": "Admin", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '4692', '7636', 'internal-service', 'Internal Service Request from SABIR MOHAMMED S', 'conversation', 'admin',
  'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', '',
  '2026-10-19T10:30:29.190Z'::timestamptz, '2026-10-19T10:30:29.190Z'::timestamptz, '{"createdByRole": "employee", "createdByDesignation": "PCB Fabrication Engineer", "createdByEmployeeId": "MIB04", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "9626272076", "payload": {"description": "Update the Past Week Report.", "id": "MIB04", "designation": "PCB Fabrication Engineer", "department": "PCB Designs & Fabrication Team", "phone": "9626272076", "remarks": "", "files": [], "assignedHeadId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3", "replies": []}}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '8704', '2809', 'report', 'PCB Fabrication and Assembly Training Report – RSR Engineering College, Nellore', 'approved', 'admin',
  'MATHIYAZHAGAN D', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', 'mathi',
  '2026-10-19T09:57:51.141Z'::timestamptz, '2026-10-19T10:00:08.382Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB Design Intern", "createdByEmployeeId": "MIB06", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "8056197704", "payload": {"description": "Successfully completed PCB Fabrication and Assembly Training for 120 students across two batches, with 60 students in each batch. The training provided practical exposure to PCB fabrication techniques, component assembly, and hands-on electronics skills.", "reportFrequency": "weekly", "reportPeriodMode": "period", "reportPeriodYear": 2026, "reportPeriodMonth": 10, "reportPeriodWeek": 41, "periodStartDate": "2026-10-05", "periodEndDate": "2026-10-11", "periodLabel": "2026-10-10", "reportDate": "2026-10-10", "attachments": [], "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 3, "at": "2026-10-19T10:00:08.382Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-10-19T09:59:38.560Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-19T09:58:59.269Z"}, {"by": "sabir", "comment": "", "decision": "recommend", "stageIndex": 0, "at": "2026-10-19T09:58:27.275Z"}]}, "remarks": "", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '5320', '9077', 'leave', 'Past-Date Casual Leave Request', 'approved', 'admin',
  'MATHIYAZHAGAN D', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', 'mathi',
  '2026-10-19T09:56:26.263Z'::timestamptz, '2026-10-19T10:00:10.267Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB Design Intern", "createdByEmployeeId": "MIB06", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "8056197704", "payload": {"name": "MATHIYAZHAGAN D", "id": "MIB06", "designation": "PCB Design Intern", "department": "PCB Designs & Fabrication Team", "email": "mathiyazhagandhanapalmathiyazh@gmail.com", "phone": "8056197704", "leaveType": "casual", "fromDate": "2026-10-17", "toDate": "2026-10-17", "reason": "Casual Leave", "remarks": "", "isPastDateRequest": true, "filledFormFileName": "", "submittedAt": "2026-10-19T09:56:26.206Z", "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 3, "at": "2026-10-19T10:00:10.266Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-10-19T09:59:40.153Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-19T09:59:01.444Z"}, {"by": "sabir", "comment": "", "decision": "recommend", "stageIndex": 0, "at": "2026-10-19T09:58:29.458Z"}]}, "remarks": "", "signatureFrom": "Hareesh", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '3507', '7108', 'leave', 'Casual Leave Request', 'approved', 'admin',
  'GOLLA KUMAR BHARATH', 'founder-001', 'gkbharath',
  '2026-10-19T09:49:32.330Z'::timestamptz, '2026-10-19T09:51:10.802Z'::timestamptz, '{"createdByRole": "founder", "createdByDesignation": "Founder & Chief Executive Partner", "createdByEmployeeId": "MIB01", "createdByDepartment": "Executive Management Team", "createdByPhone": "8124227370", "payload": {"name": "GOLLA KUMAR BHARATH", "id": "MIB01", "designation": "Founder & Chief Executive Partner", "department": "Executive Management Team", "email": "gollakumarbharath@suryas.in", "phone": "8124227370", "leaveType": "casual", "fromDate": "2026-10-31", "toDate": "2026-10-31", "reason": "Next Mouth Casual Leave Carry Forward This Mounth.", "remarks": "", "isPastDateRequest": false, "filledFormFileName": "", "submittedAt": "2026-10-19T09:49:32.291Z", "approvalChain": ["hareeshv", "santhanakumarv"], "currentApproverIndex": 1, "comments": [{"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-19T09:51:10.801Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 0, "at": "2026-10-19T09:50:26.655Z"}]}, "remarks": "", "signatureFrom": "Admin", "forwardedTo": "santhanakumarv"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '1329', '8580', 'leave', 'Past-Date Casual Leave Request', 'approved', 'admin',
  'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'sabir',
  '2026-10-19T09:19:16.942Z'::timestamptz, '2026-10-19T09:40:36.733Z'::timestamptz, '{"createdByRole": "employee", "createdByDesignation": "PCB Fabrication Engineer", "createdByEmployeeId": "MIB04", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "123456789", "payload": {"name": "SABIR MOHAMMED S", "id": "MIB04", "designation": "PCB Fabrication Engineer", "department": "PCB Designs & Fabrication Team", "email": "sabirmohammeds@suryas.in", "phone": "8124227370", "leaveType": "casual", "fromDate": "2026-10-12", "toDate": "2026-10-12", "reason": "Casual Leave", "remarks": "", "isPastDateRequest": true, "filledFormFileName": "", "submittedAt": "2026-10-19T09:19:16.855Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-10-19T09:40:36.732Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-19T09:39:06.816Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 0, "at": "2026-10-19T09:21:15.949Z"}]}, "remarks": "", "signatureFrom": "Admin", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '7057', '2780', 'leave', 'Past-Date Casual Leave Request', 'approved', 'admin',
  'GOLLA KUMAR BHARATH', 'founder-001', 'gkbharath',
  '2026-10-19T09:16:43.235Z'::timestamptz, '2026-10-19T09:39:00.922Z'::timestamptz, '{"createdByRole": "founder", "createdByDesignation": "Founder & Chief Executive Partner", "createdByEmployeeId": "MIB01", "createdByDepartment": "Executive Management Team", "createdByPhone": "8124227370", "payload": {"name": "GOLLA KUMAR BHARATH", "id": "MIB01", "designation": "Founder & Chief Executive Partner", "department": "Executive Management Team", "email": "gollakumarbharath@suryas.in", "phone": "8124227370", "leaveType": "casual", "fromDate": "2026-10-17", "toDate": "2026-10-17", "reason": "Casual Leave Carry Forward from Past Mounth.", "remarks": "", "isPastDateRequest": true, "filledFormFileName": "", "submittedAt": "2026-10-19T09:16:43.107Z", "approvalChain": ["hareeshv", "santhanakumarv"], "currentApproverIndex": 1, "comments": [{"by": "santhanakumarv", "comment": "Approved.", "decision": "approve", "stageIndex": 1, "at": "2026-10-19T09:39:00.921Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 0, "at": "2026-10-19T09:21:43.135Z"}]}, "remarks": "", "signatureFrom": "Admin", "forwardedTo": "santhanakumarv"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '7185', '1339', 'report', 'PCB Fabrication and Assembly Training Report – RSR Engineering College, Nellore', 'approved', 'admin',
  'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'sabir',
  '2026-10-19T08:31:45.647Z'::timestamptz, '2026-10-19T08:50:42.454Z'::timestamptz, '{"createdByRole": "employee", "createdByDesignation": "PCB Fabrication Engineer", "createdByEmployeeId": "MIB04", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "123456789", "payload": {"description": "Successfully completed PCB Fabrication and Assembly Training for 120 students across two batches, with 60 students in each batch. The training provided practical exposure to PCB fabrication techniques, component assembly, and hands-on electronics skills.", "reportFrequency": "weekly", "reportPeriodMode": "period", "reportPeriodYear": 2026, "reportPeriodMonth": 10, "reportPeriodWeek": 42, "periodStartDate": "2026-10-12", "periodEndDate": "2026-10-18", "periodLabel": "Week 42, 2026", "attachments": [], "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 2, "comments": [{"by": "gkbharath", "comment": "", "decision": "approve", "stageIndex": 2, "at": "2026-10-19T08:50:42.194Z"}, {"by": "santhanakumarv", "comment": "", "decision": "approve", "stageIndex": 1, "at": "2026-10-19T08:41:08.402Z"}, {"by": "hareeshv", "comment": "Approved.", "decision": "approve", "stageIndex": 0, "at": "2026-10-19T08:32:35.911Z"}]}, "remarks": "", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '9237', '3657', 'leave', 'Past-Date Medical Leave Request', 'approved', 'admin',
  'VISHNU VARSHINI M', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'vishnuu',
  '2026-10-19T04:53:07.540Z'::timestamptz, '2026-10-19T05:38:14.952Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB & EMS/IoT Designer-T", "createdByEmployeeId": "MIB05", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "6380551370", "payload": {"name": "VISHNU VARSHINI M", "id": "MIB05", "designation": "PCB & EMS/IoT Designer-T", "department": "PCB Designs & Fabrication Team", "email": "pcb.designers@suryas.in", "phone": "6380551370", "leaveType": "medical", "fromDate": "2026-10-12", "toDate": "2026-10-13", "reason": "As I am diagnosed with dengue, doctors have advised 3 days bed test and blood test on daily basis to monitor platelets count and I have been prescribed with heavy doses of tablets for recovery. On account of this I am applying medical leave on 12.10.2026 and 13.10.2026(Monday & Tuesday).\n", "remarks": "", "isPastDateRequest": true, "filledFormFileName": "IMG_20261011_203454.jpg", "medicalDocument": {"name": "IMG_20261011_203401.jpg", "size": 5625470, "type": "image/jpeg", "base64": "[FILE_STRIPPED]", "uploadedAt": "2026-10-19T04:51:51.610Z"}, "submittedAt": "2026-10-19T04:51:51.610Z", "guideId": "user-002", "guideUsername": "hareeshv", "approvalChain": ["hareeshv", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "comments": [{"by": "gkbharath", "comment": "Approved.", "decision": "approve", "stageIndex": 3, "at": "2026-10-19T05:38:14.263Z"}, {"by": "santhanakumarv", "comment": "Approved.", "decision": "approve", "stageIndex": 2, "at": "2026-10-19T05:21:44.183Z"}, {"by": "hareeshv", "comment": "Approved.", "decision": "approve", "stageIndex": 1, "at": "2026-10-19T05:06:15.615Z"}, {"by": "hareeshv", "comment": "Approved.", "decision": "recommend", "stageIndex": 0, "at": "2026-10-19T05:04:54.798Z"}]}, "remarks": "", "uploadedFile": {"name": "IMG_20261011_203454.jpg", "size": 3755546, "type": "image/jpeg", "base64": "[FILE_STRIPPED]", "uploadedAt": "2026-10-19T04:51:51.610Z"}, "signatureFrom": "Admin", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '2810', '2017', 'leave', 'Past-Date Medical Leave Request', 'approved', 'admin',
  'VISHNU VARSHINI M', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'vishnuu',
  '2026-10-19T03:52:53.727Z'::timestamptz, '2026-10-19T04:28:31.722Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB & EMS/IoT Designer-T", "createdByEmployeeId": "MIB05", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "6380551370", "payload": {"name": "VISHNU VARSHINI M", "id": "MIB05", "designation": "PCB & EMS/IoT Designer-T", "department": "PCB Designs & Fabrication Team", "email": "pcb.designers@suryas.in", "phone": "6380551370", "leaveType": "medical", "fromDate": "2026-10-09", "toDate": "2026-10-09", "reason": "Dengue fever ", "remarks": "As I was suffering from severe fever and got two dosage of trips, I''m applying medical leave on 09.10.2026(Friday)", "isPastDateRequest": true, "filledFormFileName": "IMG20261008233537.jpg", "medicalDocument": {"name": "IMG_20261008_233743.jpg", "size": 5717953, "type": "image/jpeg", "base64": "[FILE_STRIPPED]", "uploadedAt": "2026-10-19T03:52:34.227Z"}, "submittedAt": "2026-10-19T03:52:34.227Z", "guideId": "user-002", "guideUsername": "hareeshv", "approvalChain": ["hareeshv", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 3, "comments": [{"by": "gkbharath", "comment": "Approved.", "decision": "approve", "stageIndex": 3, "at": "2026-10-19T04:28:31.569Z"}, {"by": "santhanakumarv", "comment": "Approve", "decision": "approve", "stageIndex": 2, "at": "2026-10-19T04:26:30.671Z"}, {"by": "hareeshv", "comment": "Approved.", "decision": "approve", "stageIndex": 1, "at": "2026-10-19T04:22:43.932Z"}, {"by": "hareeshv", "comment": "Approved.", "decision": "recommend", "stageIndex": 0, "at": "2026-10-19T04:22:37.126Z"}]}, "remarks": "As I was suffering from severe fever and got two dosage of trips, I''m applying medical leave on 09.10.2026(Friday)", "uploadedFile": {"name": "IMG20261008233537.jpg", "size": 6297545, "type": "image/jpeg", "base64": "[FILE_STRIPPED]", "uploadedAt": "2026-10-19T03:52:34.227Z"}, "signatureFrom": "Admin", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '4008', '8738', 'proposal', 'Project Proposal', 'approved', 'admin',
  'SANTHANA KUMAR V', 'user-003', 'santhanakumarv',
  '2026-10-19T02:31:33.211Z'::timestamptz, '2026-10-19T03:48:09.241Z'::timestamptz, '{"createdByRole": "managing-partner", "createdByDesignation": "Managing Partner - Operations & Business Development", "createdByEmployeeId": "MIB03", "createdByDepartment": "Executive Management Team", "createdByPhone": "7010353723", "payload": {"projectTitle": "PCB & Networking Engineer Drive 2026 ", "projectStatus": "in-progress", "createdBy": "SANTHANA KUMAR V", "abstractFileName": "Loyola-ICAM College of Engineering and Technology (LICET) (Autonomous).pdf", "clientName": "-NA-", "clientOrganization": "", "clientDesignation": "", "clientAddress": "", "clientPhone": "", "clientEmail": "", "projectAmount": "", "forwardedBy": "", "submittedAt": "2026-10-19T02:31:31.395Z", "remarks": "26-10-2026 - Loyola-ICAM College of Engineering and Technology (LICET) (Autonomous)", "approvalChain": ["hareeshv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "gkbharath", "comment": "Approved.", "decision": "approve", "stageIndex": 1, "at": "2026-10-19T03:48:09.233Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 0, "at": "2026-10-19T03:47:36.864Z"}]}, "remarks": "26-10-2026 - Loyola-ICAM College of Engineering and Technology (LICET) (Autonomous)", "uploadedFile": {"name": "Loyola-ICAM College of Engineering and Technology (LICET) (Autonomous).pdf", "size": 1200860, "type": "application/pdf", "base64": "[FILE_STRIPPED]", "uploadedAt": "2026-10-19T02:31:31.395Z"}, "signatureFrom": "Admin", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '1454', '1980', 'leave', 'Past-Date Casual Leave Request', 'approved', 'admin',
  'SANTHANA KUMAR V', 'user-003', 'santhanakumarv',
  '2026-10-19T02:13:40.311Z'::timestamptz, '2026-10-19T03:49:22.751Z'::timestamptz, '{"createdByRole": "managing-partner", "createdByDesignation": "Managing Partner - Operations & Business Development", "createdByEmployeeId": "MIB03", "createdByDepartment": "Executive Management Team", "createdByPhone": "7010353723", "payload": {"name": "SANTHANA KUMAR V", "id": "MIB03", "designation": "Managing Partner - Operations & Business Development", "department": "Executive Management Team", "email": "santhanakumarv@suryas.in", "phone": "", "leaveType": "casual", "fromDate": "2026-10-17", "toDate": "2026-10-17", "reason": "Casual Leave", "remarks": "Casual Leave", "isPastDateRequest": true, "filledFormFileName": "", "submittedAt": "2026-10-19T02:13:40.133Z", "approvalChain": ["hareeshv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "gkbharath", "comment": "Approved.", "decision": "approve", "stageIndex": 1, "at": "2026-10-19T03:49:22.735Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 0, "at": "2026-10-19T03:47:58.089Z"}]}, "remarks": "Casual Leave", "signatureFrom": "Admin", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '1489', '5866', 'internal-service', 'Internal Service Request from SANTHANA KUMAR V', 'conversation', 'admin',
  'SANTHANA KUMAR V', 'user-003', '',
  '2026-10-19T02:12:18.048Z'::timestamptz, '2026-10-19T02:12:18.048Z'::timestamptz, '{"createdByRole": "managing-partner", "createdByDesignation": "Managing Partner - Operations & Business Development", "createdByEmployeeId": "MIB03", "createdByDepartment": "Executive Management Team", "createdByPhone": "7010353723", "payload": {"description": "What is the Present Status of R&D Interns?", "id": "MIB03", "designation": "Managing Partner - Operations & Business Development", "department": "Executive Management Team", "phone": "7010353723", "remarks": "", "files": [], "assignedHeadId": "user-002", "replies": []}}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '6312', '4229', 'ta', 'Allowance Claim Request', 'approved', 'admin',
  'GOLLA KUMAR BHARATH', 'founder-001', 'gkbharath',
  '2026-10-19T02:09:20.449Z'::timestamptz, '2026-10-19T04:11:54.889Z'::timestamptz, '{"createdByRole": "founder", "createdByDesignation": "Founder & Chief Executive Partner", "createdByEmployeeId": "MIB01", "createdByDepartment": "Executive Management Team", "createdByPhone": "8124227370", "payload": {"name": "GOLLA KUMAR BHARATH", "id": "MIB01", "designation": "Founder & Chief Executive Partner", "department": "Executive Management Team", "email": "gollakumarbharath@suryas.in", "claimType": "bill", "amount": "500", "description": "Auditor Visit Petrol and Food.", "remarks": "Add Salary.", "filledFormFileName": "", "billFileName": "", "submittedAt": "2026-10-19T02:09:20.195Z", "approvalChain": ["hareeshv", "santhanakumarv"], "currentApproverIndex": 1, "comments": [{"by": "santhanakumarv", "comment": "Approved.", "decision": "approve", "stageIndex": 1, "at": "2026-10-19T04:11:54.662Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 0, "at": "2026-10-19T03:48:15.624Z"}]}, "remarks": "Add Salary.", "signatureFrom": "Admin", "forwardedTo": "santhanakumarv"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '3579', '2914', 'internal-service', 'Internal Service Request from GOLLA KUMAR BHARATH', 'conversation', 'admin',
  'GOLLA KUMAR BHARATH', 'founder-001', '',
  '2026-10-19T02:07:23.829Z'::timestamptz, '2026-10-19T03:52:33.634Z'::timestamptz, '{"createdByRole": "founder", "createdByDesignation": "Founder & Chief Executive Partner", "createdByEmployeeId": "MIB01", "createdByDepartment": "Executive Management Team", "createdByPhone": "8124227370", "payload": {"description": "Present Status of PCB Circuit 4 Layer? DRC/ERC 83 Errors Clear?", "id": "MIB01", "designation": "Founder & Chief Executive Partner", "department": "Executive Management Team", "phone": "8124227370", "remarks": "", "files": [], "assignedHeadId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3", "replies": [{"repliedBy": "gkbharath", "repliedById": "founder-001", "repliedAt": "2026-10-19T03:52:33.624Z", "message": "Update As Possible Soon."}]}}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '1312', '4754', 'leave', 'Past-Date Casual Leave Request', 'approved', 'admin',
  'GOLLA KUMAR BHARATH', 'founder-001', 'gkbharath',
  '2026-10-18T16:53:08.997Z'::timestamptz, '2026-10-19T04:12:09.165Z'::timestamptz, '{"createdByRole": "founder", "createdByDesignation": "Founder & Chief Executive Partner", "createdByEmployeeId": "MIB01", "createdByDepartment": "Executive Management Team", "createdByPhone": "8124227370", "payload": {"name": "GOLLA KUMAR BHARATH", "id": "MIB01", "designation": "Founder & Chief Executive Partner", "department": "Executive Management Team", "email": "gollakumarbharath@suryas.in", "phone": "8124227370", "leaveType": "casual", "fromDate": "2026-10-10", "toDate": "2026-10-10", "reason": "Casual Leave.", "remarks": "Request to Approve.", "isPastDateRequest": true, "filledFormFileName": "", "submittedAt": "2026-10-18T16:53:08.927Z", "approvalChain": ["hareeshv", "santhanakumarv"], "currentApproverIndex": 1, "comments": [{"by": "santhanakumarv", "comment": "Approved.", "decision": "approve", "stageIndex": 1, "at": "2026-10-19T04:12:08.966Z"}, {"by": "hareeshv", "comment": "", "decision": "approve", "stageIndex": 0, "at": "2026-10-19T03:48:47.255Z"}]}, "remarks": "Request to Approve.", "signatureFrom": "Admin", "forwardedTo": "santhanakumarv"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;


-- ==================== TASKS (17 records) ====================
INSERT INTO public.tasks (
  id, title, description, deadline, status, progress,
  assigned_to_id, assigned_to_name, assigned_to_username,
  assigned_by_id, assigned_by_name, created_at, updated_at, comments
) VALUES (
  'a2c08e64-b6c0-47e1-9d98-5f9394608259', 'Team', 'I will give some task for vishnu varshini please follow and ensure them', '2026-11-04', 'completed', 100,
  'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'SABIR MOHAMMED S', 'sabir',
  'user-002', 'HAREESH V', '2026-11-04T03:11:43.806Z'::timestamptz, '2026-11-05T11:31:57.433Z'::timestamptz, '[{"by": "sabir", "byId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "comment": "Today work schedule completed", "at": "2026-11-05T11:31:57.433Z"}]'::jsonb
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
  '62e75196-66a6-4524-94a6-a8d3aee91c05', 'College workshop and internship', 'I will send the college database and u talk to them and confirm it some workshops and internships', '2026-11-04', 'not_started', 0,
  'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'VISHNU VARSHINI M', 'vishnuu',
  'user-002', 'HAREESH V', '2026-11-04T03:10:38.942Z'::timestamptz, '2026-11-04T03:10:38.942Z'::timestamptz, '[]'::jsonb
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
  '89ad3622-e326-4f6c-89ae-46f7a39f2788', 'Task', 'Share the source file of previous circuit
Check office official website all intern and course required marketing agency upto registration (intern minim 50/course minim 30) give a quote will be check. 
previous quote final review and give the final quote. PDB', '2026-10-26', 'completed', 100,
  'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'VISHNU VARSHINI M', 'vishnuu',
  'founder-001', 'GOLLA KUMAR BHARATH', '2026-10-26T02:34:36.707Z'::timestamptz, '2026-10-26T11:41:50.561Z'::timestamptz, '[]'::jsonb
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
  '61b497cf-e290-40f4-abf9-1a1647ca90ca', 'Task', '1. Rajkumar Schule (this week before oct 2026)
2. Sri City Company List  
3. Mathiaglaan & you follow up get 30 mini projects', '2026-10-31', 'in_progress', 55,
  'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'SABIR MOHAMMED S', 'sabir',
  'founder-001', 'GOLLA KUMAR BHARATH', '2026-10-26T02:33:37.734Z'::timestamptz, '2026-10-26T13:09:42.213Z'::timestamptz, '[]'::jsonb
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
  '3d587f76-a5ff-47ac-bb7b-5af11a08aa5d', 'Task', '1. You and Sabir Sir, 30 Mini Projects required conformed state (try other college and all departments we do okay)
2. College Data Base Done?
3. Company Data Base Similarly give by PCB Team progress that also...,', '2026-10-31', 'in_progress', 25,
  'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', 'MATHIYAZHAGAN D', 'mathi',
  'founder-001', 'GOLLA KUMAR BHARATH', '2026-10-26T02:33:18.094Z'::timestamptz, '2026-10-26T09:23:40.588Z'::timestamptz, '[]'::jsonb
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
  '11bd0881-555c-419e-8fec-2364cff4c27d', 'Call Back Clients', 'Call 
PGP HOD
PAVAI MAM
LOYAL 
OCEAN FOR QUOTE', '2026-10-26', 'not_started', 0,
  'user-002', 'HAREESH V', 'hareeshv',
  'founder-001', 'GOLLA KUMAR BHARATH', '2026-10-26T02:32:51.233Z'::timestamptz, '2026-10-26T04:29:04.728Z'::timestamptz, '[]'::jsonb
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
  '600eff19-08c0-4368-985b-19978e06f3ba', 'Official Project Assignment, Technical Requirements & Strict NDA – Electronic Motor Starter with SSR-Based Protection | Final Deadline: 14 December 2026', 'Dear Team,

This email serves as the official project assignment, technical problem statement, execution plan, team allocation, confidentiality requirements, and delivery schedule for the development of a complete programmable Electronic Motor Starter with SSR-Based Motor Protection for SURYA’S MiB ENTERPRISES.

The project covers complete hardware and software development, circuit design, PCB design, external PCB fabrication and assembly, firmware development, two prototypes, testing, and calibration.

Project Start Date: 26 October 2026
Circuit Design Submission Deadline: 29 October 2026
Final Project Completion Deadline: 14 December 2026
1. Project Problem Statement and Objective
SURYA’S MiB ENTERPRISES intends to develop a customizable electronic motor starter using Solid-State Relay (SSR) technology for single-phase and three-phase submersible motor applications.

The engineering challenge is to integrate motor starting and power switching with comprehensive electrical protection, dry-run detection, fault monitoring, programmable protection parameters, and automatic restart control into a complete hardware and firmware solution.

The developed system must monitor the applicable electrical and operating conditions, detect abnormal supply or motor conditions, disconnect the motor through the appropriate power-switching arrangement when a fault occurs, and provide clear fault indications.

The system must support the following operating configurations:

Single-phase: 170–240 VAC, motors up to 3 HP.

Three-phase: 360–440 VAC, motors from 3 HP to 25 HP.

All applicable protection parameters must be configurable through a keypad. The solution must include the protection control circuit, sensing circuits, SSR interface, complete power-switching stage, associated components, PCB, firmware, and user interface.

The team must evaluate whether the single-phase and three-phase applications can share a common control platform with different power stages or require separate hardware configurations. This decision must be documented during circuit design.

The objective is to deliver two functional prototypes with integrated hardware and firmware, validated protection functions, calibration, and complete technical documentation.

2. Electrical Specifications
Single-Phase Application

Operating voltage: 170–240 VAC.

Motor capacity: Up to 3 HP.

Appropriate voltage and current sensing and motor protection.

Three-Phase Application

Operating voltage: 360–440 VAC.

Motor capacity: 3 HP to 25 HP.

Three-phase monitoring, phase-failure detection, and single-phasing prevention.

The design must account for motor starting current, switching characteristics, component ratings, heat dissipation, electrical isolation, short-circuit protection, and the applicable safety requirements.

3. Mandatory Protection and Functional Requirements
The system must include the following functions:

Under-Voltage (UV) Protection: Detect low supply voltage and trip the motor according to the configured threshold.

Over-Voltage (OV) Protection: Protect the motor against excessive supply voltage.

Overload (OL) Protection: Detect excessive motor current using a suitable sensing and protection mechanism.

Dry-Run Protection: Prevent motor operation when sufficient water is unavailable. The team must evaluate and select a suitable detection method, such as current-based detection or an appropriate external sensor, based on the application.

Phase-Failure Protection: Detect a missing phase in three-phase applications.

Single-Phasing Prevention: Prevent unsafe operation when one phase is lost.

Automatic Restart: Support restart after power restoration, preferably with an adjustable restart delay and configurable restart behaviour.

Fault Detection and Indication: Identify applicable fault conditions, provide individual fault indications, and ensure appropriate motor trip behaviour.

Keypad-Based Parameter Programming: All applicable protection parameters must be configurable through the keypad, including voltage thresholds, overload settings, restart delays, and other supported settings.

Complete SSR-Based Starter Integration: Include the protection control circuit, SSR interface, complete power-switching stage, and associated components required for the prototype.

The team must define the protection thresholds, time delays, sensing methods, restart logic, fault-reset behaviour, and other unresolved technical parameters during circuit design. All assumptions and limitations must be documented for approval.

4. Complete Scope of Work and Deliverables
The project includes the following:

Circuit design and complete schematic preparation.

Component selection, calculations, and ratings verification.

PCB design and layout.

Gerber files, drill files, and manufacturing documentation.

Bill of Materials (BOM) and component specifications.

External PCB fabrication and assembly.

Firmware development and keypad-based parameter configuration.

Integration of the protection circuit with the complete SSR-based power-switching stage.

Development and assembly of two prototypes.

Integration of all required protection functions and fault indications.

Testing under applicable single-phase and three-phase operating conditions.

Calibration of voltage, current, overload, and other applicable protection thresholds.

Validation of dry-run detection, phase-failure protection, motor trips, and automatic restart behaviour.

Testing of keypad operation and parameter retention, wherever applicable.

Preparation of circuit files, PCB design files, firmware, technical documentation, test reports, and calibration records.

All final deliverables must be reviewed before project closure.

5. Team Allocation and Responsibilities
Team Head – Project Coordination

Hareesh V
Managing Partner – Projects & Administration
Executive Management Team
Mobile: 81242 27370
Email: hareeshv@suryas.in
The team head shall coordinate project execution, monitor progress, review deliverables, and ensure compliance with the project schedule and approved workflow.

PCB Designs & Fabrication Team

Ms. Vishnu Varshini M – PCB & EMS/IoT Designer-T

Smrithi K – Intern, PCB Designs & Fabrication Team

Rithanya D – Intern, PCB Designs & Fabrication Team

The assigned team shall coordinate circuit documentation, PCB design preparation, component information, fabrication documentation, assembly planning, and associated technical records according to the finalized allocation of responsibilities.

All team members must coordinate with the team head and provide progress updates at the required milestones.

6. Circuit Design Submission and Mandatory Approval
The complete circuit design must be submitted to me on or before 29 October 2026 for review and approval.

The submission must include:

Complete circuit schematic and protection logic.

Proposed component list with ratings and specifications.

Voltage and current sensing arrangements.

SSR and power-switching stage design.

Protection thresholds, time delays, and restart logic.

Keypad interface and firmware control approach.

Preliminary PCB architecture and relevant safety considerations.

Technical calculations, assumptions, limitations, and unresolved design decisions.

The team must incorporate the corrections or modifications required during the review.

PCB fabrication and assembly may proceed only after I have reviewed and explicitly approved the circuit design.

No fabrication order, external production commitment, or related expenditure may be initiated before approval. This is a mandatory project-control requirement.

7. External PCB Fabrication and Assembly
PCB fabrication must be coordinated through the designated partner company via me.

After circuit approval, the team must prepare the complete fabrication package, including:

Approved schematic and PCB design files.

Gerber and drill files.

BOM with component specifications and ratings.

PCB dimensions, layer count, copper thickness, and fabrication specifications.

Assembly drawings and component placement files, wherever applicable.

Relevant high-voltage isolation, creepage and clearance, and thermal-management requirements.

The initial requirement is two prototype units, subject to final design confirmation.

The team must coordinate the fabrication schedule to ensure sufficient time remains for assembly, firmware integration, testing, calibration, and final validation.

No team member may independently finalize external fabrication arrangements without the required coordination and authorization.

8. Project Schedule and Milestones
Activity
Deadline
Project commencement and technical review
26 October 2026
Complete circuit design submission
29 October 2026
Circuit review and approval
After submission and review
PCB fabrication and assembly
Only after explicit circuit approval
Firmware development and integration
During project execution
Prototype development – 2 units
As per the approved schedule
Functional testing and calibration
Before final submission
Final documentation and validation
Before project completion
Final project completion and delivery
14 December 2026
The complete project, including hardware, software, PCB fabrication and assembly, two prototypes, testing, calibration, and technical documentation, must be completed and delivered on or before 14 December 2026.

Any anticipated delay, component availability issue, technical difficulty, or fabrication constraint must be reported immediately to the team head, together with a corrective action plan.

9. Technical and Safety Requirements
Since the design involves AC mains and three-phase motor loads up to 25 HP, the following requirements must receive particular attention:

Appropriate SSR ratings for motor starting and operating currents.

Heat sinks, thermal management, and overheating protection.

Electrical isolation between control and power sections.

Suitable fuses, circuit breakers, short-circuit protection, and protective earthing.

Adequate PCB creepage and clearance distances.

Reliable fault detection and fail-safe motor shutdown.

Safe restart behaviour following power restoration or fault clearance.

Appropriate testing procedures for high-voltage and high-current equipment.

The SSR must not be treated as the sole means of short-circuit protection or safe electrical isolation. Suitable independent protective devices and safety arrangements must be evaluated and incorporated as required by the design.

Testing and calibration must be conducted using appropriate equipment and safe procedures.

10. Progress Reporting and Communication
All team members must coordinate through the designated team head and provide timely progress updates.

Technical queries, component-selection concerns, design changes, procurement requirements, and fabrication issues must be communicated promptly.

No changes affecting the approved circuit, component ratings, protection logic, or project scope may be implemented without authorization.

For further technical or project-related queries, contact:

Er. SANTHANA KUMAR V
Managing Partner – Operations & Business Development
Executive Management Team
Email: santhanakumarv@suryas.in
All external PCB fabrication coordination must be routed through me.

11. Strict Confidentiality, NDA and Intellectual Property Protection
Mandatory Confidentiality and Non-Disclosure Agreement (NDA) Compliance

All team members, interns, consultants, external PCB fabrication partners, vendors, and other individuals or organizations involved in this project must maintain strict confidentiality regarding all project-related information.

The confidentiality requirements are as follows:

Mandatory NDA: Every relevant individual and external partner must execute the applicable NDA or confidentiality agreement before receiving confidential project information or accessing project files.

No Unauthorized Disclosure: Circuit diagrams, schematics, PCB layouts, Gerber files, firmware, source code, technical specifications, BOMs, testing results, commercial details, and other project materials must not be disclosed, forwarded, published, or shared with unauthorized persons.

No Unauthorized Use: Project information must be used exclusively for the authorized work. Independent commercial use, reproduction, resale, or exploitation of confidential materials without written authorization is prohibited.

External Partner Confidentiality: The designated PCB fabrication and assembly partner must be bound by appropriate confidentiality obligations before project files are shared. Only information necessary for the authorized work may be disclosed.

Data Security: Project files must be stored and transferred securely. Uploading confidential materials to public repositories, personal cloud storage, public forums, or third-party AI tools is prohibited unless expressly authorized in writing.

Intellectual Property Ownership: Ownership and usage rights relating to project deliverables, circuit designs, PCB layouts, firmware, documentation, and other intellectual property shall be governed by the applicable written agreements and law. No individual or partner may commercially exploit such deliverables contrary to those agreements.

Return or Deletion of Materials: Upon project completion or termination, confidential materials must be returned or securely deleted as required by the applicable agreement, subject to lawful retention obligations.

Continuing Confidentiality: Confidentiality obligations shall continue for the period specified in the applicable NDA and, where permitted by law, for as long as the information remains a trade secret.

Breach Reporting: Any suspected or actual disclosure, loss, unauthorized access, or misuse of confidential information must be reported immediately to management. Appropriate legal remedies may be pursued under the signed agreements and applicable law.

Management Requirement: No project-related confidential information may be shared externally until the applicable NDA and authorization procedures have been completed.

All parties must acknowledge and comply with these requirements before commencing their respective project activities. The relevant signed agreements must clearly define confidentiality obligations, permitted use, intellectual property rights, and applicable remedies.

These requirements are intended to ensure strict confidentiality throughout the project and after its completion, subject to the applicable agreements and law.

12. Final Instructions
The project officially commences on 26 October 2026. The complete circuit design must be submitted by 29 October 2026, and PCB fabrication may proceed only after my explicit approval.

The complete project must be delivered on or before 14 December 2026, including all required hardware, firmware, two functional prototypes, testing, calibration, and technical documentation.

All assigned team members are expected to follow the approved workflow, maintain proper technical documentation, protect confidential information, coordinate effectively, and meet the finalized deadlines.

Please review the complete requirements carefully and prepare for project commencement.', '2026-10-29', 'not_started', 0,
  'user-002', 'HAREESH V', 'hareeshv',
  'user-003', 'SANTHANA KUMAR V', '2026-10-26T02:27:12.163Z'::timestamptz, '2026-10-26T02:27:12.163Z'::timestamptz, '[]'::jsonb
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
  'a2147721-2ae3-4aad-88d9-de84c2e74ec5', 'Official Project Assignment, Technical Requirements & Strict NDA – Electronic Motor Starter with SSR-Based Protection | Final Deadline: 14 December 2026', 'Dear Team,

This email serves as the official project assignment, technical problem statement, execution plan, team allocation, confidentiality requirements, and delivery schedule for the development of a complete programmable Electronic Motor Starter with SSR-Based Motor Protection for SURYA’S MiB ENTERPRISES.

The project covers complete hardware and software development, circuit design, PCB design, external PCB fabrication and assembly, firmware development, two prototypes, testing, and calibration.

Project Start Date: 26 October 2026
Circuit Design Submission Deadline: 29 October 2026
Final Project Completion Deadline: 14 December 2026
1. Project Problem Statement and Objective
SURYA’S MiB ENTERPRISES intends to develop a customizable electronic motor starter using Solid-State Relay (SSR) technology for single-phase and three-phase submersible motor applications.

The engineering challenge is to integrate motor starting and power switching with comprehensive electrical protection, dry-run detection, fault monitoring, programmable protection parameters, and automatic restart control into a complete hardware and firmware solution.

The developed system must monitor the applicable electrical and operating conditions, detect abnormal supply or motor conditions, disconnect the motor through the appropriate power-switching arrangement when a fault occurs, and provide clear fault indications.

The system must support the following operating configurations:

Single-phase: 170–240 VAC, motors up to 3 HP.

Three-phase: 360–440 VAC, motors from 3 HP to 25 HP.

All applicable protection parameters must be configurable through a keypad. The solution must include the protection control circuit, sensing circuits, SSR interface, complete power-switching stage, associated components, PCB, firmware, and user interface.

The team must evaluate whether the single-phase and three-phase applications can share a common control platform with different power stages or require separate hardware configurations. This decision must be documented during circuit design.

The objective is to deliver two functional prototypes with integrated hardware and firmware, validated protection functions, calibration, and complete technical documentation.

2. Electrical Specifications
Single-Phase Application

Operating voltage: 170–240 VAC.

Motor capacity: Up to 3 HP.

Appropriate voltage and current sensing and motor protection.

Three-Phase Application

Operating voltage: 360–440 VAC.

Motor capacity: 3 HP to 25 HP.

Three-phase monitoring, phase-failure detection, and single-phasing prevention.

The design must account for motor starting current, switching characteristics, component ratings, heat dissipation, electrical isolation, short-circuit protection, and the applicable safety requirements.

3. Mandatory Protection and Functional Requirements
The system must include the following functions:

Under-Voltage (UV) Protection: Detect low supply voltage and trip the motor according to the configured threshold.

Over-Voltage (OV) Protection: Protect the motor against excessive supply voltage.

Overload (OL) Protection: Detect excessive motor current using a suitable sensing and protection mechanism.

Dry-Run Protection: Prevent motor operation when sufficient water is unavailable. The team must evaluate and select a suitable detection method, such as current-based detection or an appropriate external sensor, based on the application.

Phase-Failure Protection: Detect a missing phase in three-phase applications.

Single-Phasing Prevention: Prevent unsafe operation when one phase is lost.

Automatic Restart: Support restart after power restoration, preferably with an adjustable restart delay and configurable restart behaviour.

Fault Detection and Indication: Identify applicable fault conditions, provide individual fault indications, and ensure appropriate motor trip behaviour.

Keypad-Based Parameter Programming: All applicable protection parameters must be configurable through the keypad, including voltage thresholds, overload settings, restart delays, and other supported settings.

Complete SSR-Based Starter Integration: Include the protection control circuit, SSR interface, complete power-switching stage, and associated components required for the prototype.

The team must define the protection thresholds, time delays, sensing methods, restart logic, fault-reset behaviour, and other unresolved technical parameters during circuit design. All assumptions and limitations must be documented for approval.

4. Complete Scope of Work and Deliverables
The project includes the following:

Circuit design and complete schematic preparation.

Component selection, calculations, and ratings verification.

PCB design and layout.

Gerber files, drill files, and manufacturing documentation.

Bill of Materials (BOM) and component specifications.

External PCB fabrication and assembly.

Firmware development and keypad-based parameter configuration.

Integration of the protection circuit with the complete SSR-based power-switching stage.

Development and assembly of two prototypes.

Integration of all required protection functions and fault indications.

Testing under applicable single-phase and three-phase operating conditions.

Calibration of voltage, current, overload, and other applicable protection thresholds.

Validation of dry-run detection, phase-failure protection, motor trips, and automatic restart behaviour.

Testing of keypad operation and parameter retention, wherever applicable.

Preparation of circuit files, PCB design files, firmware, technical documentation, test reports, and calibration records.

All final deliverables must be reviewed before project closure.

5. Team Allocation and Responsibilities
Team Head – Project Coordination

Hareesh V
Managing Partner – Projects & Administration
Executive Management Team
Mobile: 81242 27370
Email: hareeshv@suryas.in
The team head shall coordinate project execution, monitor progress, review deliverables, and ensure compliance with the project schedule and approved workflow.

PCB Designs & Fabrication Team

Ms. Vishnu Varshini M – PCB & EMS/IoT Designer-T

Smrithi K – Intern, PCB Designs & Fabrication Team

Rithanya D – Intern, PCB Designs & Fabrication Team

The assigned team shall coordinate circuit documentation, PCB design preparation, component information, fabrication documentation, assembly planning, and associated technical records according to the finalized allocation of responsibilities.

All team members must coordinate with the team head and provide progress updates at the required milestones.

6. Circuit Design Submission and Mandatory Approval
The complete circuit design must be submitted to me on or before 29 October 2026 for review and approval.

The submission must include:

Complete circuit schematic and protection logic.

Proposed component list with ratings and specifications.

Voltage and current sensing arrangements.

SSR and power-switching stage design.

Protection thresholds, time delays, and restart logic.

Keypad interface and firmware control approach.

Preliminary PCB architecture and relevant safety considerations.

Technical calculations, assumptions, limitations, and unresolved design decisions.

The team must incorporate the corrections or modifications required during the review.

PCB fabrication and assembly may proceed only after I have reviewed and explicitly approved the circuit design.

No fabrication order, external production commitment, or related expenditure may be initiated before approval. This is a mandatory project-control requirement.

7. External PCB Fabrication and Assembly
PCB fabrication must be coordinated through the designated partner company via me.

After circuit approval, the team must prepare the complete fabrication package, including:

Approved schematic and PCB design files.

Gerber and drill files.

BOM with component specifications and ratings.

PCB dimensions, layer count, copper thickness, and fabrication specifications.

Assembly drawings and component placement files, wherever applicable.

Relevant high-voltage isolation, creepage and clearance, and thermal-management requirements.

The initial requirement is two prototype units, subject to final design confirmation.

The team must coordinate the fabrication schedule to ensure sufficient time remains for assembly, firmware integration, testing, calibration, and final validation.

No team member may independently finalize external fabrication arrangements without the required coordination and authorization.

8. Project Schedule and Milestones
Activity
Deadline
Project commencement and technical review
26 October 2026
Complete circuit design submission
29 October 2026
Circuit review and approval
After submission and review
PCB fabrication and assembly
Only after explicit circuit approval
Firmware development and integration
During project execution
Prototype development – 2 units
As per the approved schedule
Functional testing and calibration
Before final submission
Final documentation and validation
Before project completion
Final project completion and delivery
14 December 2026
The complete project, including hardware, software, PCB fabrication and assembly, two prototypes, testing, calibration, and technical documentation, must be completed and delivered on or before 14 December 2026.

Any anticipated delay, component availability issue, technical difficulty, or fabrication constraint must be reported immediately to the team head, together with a corrective action plan.

9. Technical and Safety Requirements
Since the design involves AC mains and three-phase motor loads up to 25 HP, the following requirements must receive particular attention:

Appropriate SSR ratings for motor starting and operating currents.

Heat sinks, thermal management, and overheating protection.

Electrical isolation between control and power sections.

Suitable fuses, circuit breakers, short-circuit protection, and protective earthing.

Adequate PCB creepage and clearance distances.

Reliable fault detection and fail-safe motor shutdown.

Safe restart behaviour following power restoration or fault clearance.

Appropriate testing procedures for high-voltage and high-current equipment.

The SSR must not be treated as the sole means of short-circuit protection or safe electrical isolation. Suitable independent protective devices and safety arrangements must be evaluated and incorporated as required by the design.

Testing and calibration must be conducted using appropriate equipment and safe procedures.

10. Progress Reporting and Communication
All team members must coordinate through the designated team head and provide timely progress updates.

Technical queries, component-selection concerns, design changes, procurement requirements, and fabrication issues must be communicated promptly.

No changes affecting the approved circuit, component ratings, protection logic, or project scope may be implemented without authorization.

For further technical or project-related queries, contact:

Er. SANTHANA KUMAR V
Managing Partner – Operations & Business Development
Executive Management Team
Email: santhanakumarv@suryas.in
All external PCB fabrication coordination must be routed through me.

11. Strict Confidentiality, NDA and Intellectual Property Protection
Mandatory Confidentiality and Non-Disclosure Agreement (NDA) Compliance

All team members, interns, consultants, external PCB fabrication partners, vendors, and other individuals or organizations involved in this project must maintain strict confidentiality regarding all project-related information.

The confidentiality requirements are as follows:

Mandatory NDA: Every relevant individual and external partner must execute the applicable NDA or confidentiality agreement before receiving confidential project information or accessing project files.

No Unauthorized Disclosure: Circuit diagrams, schematics, PCB layouts, Gerber files, firmware, source code, technical specifications, BOMs, testing results, commercial details, and other project materials must not be disclosed, forwarded, published, or shared with unauthorized persons.

No Unauthorized Use: Project information must be used exclusively for the authorized work. Independent commercial use, reproduction, resale, or exploitation of confidential materials without written authorization is prohibited.

External Partner Confidentiality: The designated PCB fabrication and assembly partner must be bound by appropriate confidentiality obligations before project files are shared. Only information necessary for the authorized work may be disclosed.

Data Security: Project files must be stored and transferred securely. Uploading confidential materials to public repositories, personal cloud storage, public forums, or third-party AI tools is prohibited unless expressly authorized in writing.

Intellectual Property Ownership: Ownership and usage rights relating to project deliverables, circuit designs, PCB layouts, firmware, documentation, and other intellectual property shall be governed by the applicable written agreements and law. No individual or partner may commercially exploit such deliverables contrary to those agreements.

Return or Deletion of Materials: Upon project completion or termination, confidential materials must be returned or securely deleted as required by the applicable agreement, subject to lawful retention obligations.

Continuing Confidentiality: Confidentiality obligations shall continue for the period specified in the applicable NDA and, where permitted by law, for as long as the information remains a trade secret.

Breach Reporting: Any suspected or actual disclosure, loss, unauthorized access, or misuse of confidential information must be reported immediately to management. Appropriate legal remedies may be pursued under the signed agreements and applicable law.

Management Requirement: No project-related confidential information may be shared externally until the applicable NDA and authorization procedures have been completed.

All parties must acknowledge and comply with these requirements before commencing their respective project activities. The relevant signed agreements must clearly define confidentiality obligations, permitted use, intellectual property rights, and applicable remedies.

These requirements are intended to ensure strict confidentiality throughout the project and after its completion, subject to the applicable agreements and law.

12. Final Instructions
The project officially commences on 26 October 2026. The complete circuit design must be submitted by 29 October 2026, and PCB fabrication may proceed only after my explicit approval.

The complete project must be delivered on or before 14 December 2026, including all required hardware, firmware, two functional prototypes, testing, calibration, and technical documentation.

All assigned team members are expected to follow the approved workflow, maintain proper technical documentation, protect confidential information, coordinate effectively, and meet the finalized deadlines.

Please review the complete requirements carefully and prepare for project commencement.', '2026-10-29', 'in_progress', 0,
  'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'VISHNU VARSHINI M', 'vishnuu',
  'user-003', 'SANTHANA KUMAR V', '2026-10-26T02:27:12.163Z'::timestamptz, '2026-10-26T11:42:00.884Z'::timestamptz, '[]'::jsonb
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
  '0d72d440-3c16-4d6f-a8d4-f841e3279b64', 'Official Project Assignment, Technical Requirements & Strict NDA – Electronic Motor Starter with SSR-Based Protection | Final Deadline: 14 December 2026', 'Dear Team,

This email serves as the official project assignment, technical problem statement, execution plan, team allocation, confidentiality requirements, and delivery schedule for the development of a complete programmable Electronic Motor Starter with SSR-Based Motor Protection for SURYA’S MiB ENTERPRISES.

The project covers complete hardware and software development, circuit design, PCB design, external PCB fabrication and assembly, firmware development, two prototypes, testing, and calibration.

Project Start Date: 26 October 2026
Circuit Design Submission Deadline: 29 October 2026
Final Project Completion Deadline: 14 December 2026
1. Project Problem Statement and Objective
SURYA’S MiB ENTERPRISES intends to develop a customizable electronic motor starter using Solid-State Relay (SSR) technology for single-phase and three-phase submersible motor applications.

The engineering challenge is to integrate motor starting and power switching with comprehensive electrical protection, dry-run detection, fault monitoring, programmable protection parameters, and automatic restart control into a complete hardware and firmware solution.

The developed system must monitor the applicable electrical and operating conditions, detect abnormal supply or motor conditions, disconnect the motor through the appropriate power-switching arrangement when a fault occurs, and provide clear fault indications.

The system must support the following operating configurations:

Single-phase: 170–240 VAC, motors up to 3 HP.

Three-phase: 360–440 VAC, motors from 3 HP to 25 HP.

All applicable protection parameters must be configurable through a keypad. The solution must include the protection control circuit, sensing circuits, SSR interface, complete power-switching stage, associated components, PCB, firmware, and user interface.

The team must evaluate whether the single-phase and three-phase applications can share a common control platform with different power stages or require separate hardware configurations. This decision must be documented during circuit design.

The objective is to deliver two functional prototypes with integrated hardware and firmware, validated protection functions, calibration, and complete technical documentation.

2. Electrical Specifications
Single-Phase Application

Operating voltage: 170–240 VAC.

Motor capacity: Up to 3 HP.

Appropriate voltage and current sensing and motor protection.

Three-Phase Application

Operating voltage: 360–440 VAC.

Motor capacity: 3 HP to 25 HP.

Three-phase monitoring, phase-failure detection, and single-phasing prevention.

The design must account for motor starting current, switching characteristics, component ratings, heat dissipation, electrical isolation, short-circuit protection, and the applicable safety requirements.

3. Mandatory Protection and Functional Requirements
The system must include the following functions:

Under-Voltage (UV) Protection: Detect low supply voltage and trip the motor according to the configured threshold.

Over-Voltage (OV) Protection: Protect the motor against excessive supply voltage.

Overload (OL) Protection: Detect excessive motor current using a suitable sensing and protection mechanism.

Dry-Run Protection: Prevent motor operation when sufficient water is unavailable. The team must evaluate and select a suitable detection method, such as current-based detection or an appropriate external sensor, based on the application.

Phase-Failure Protection: Detect a missing phase in three-phase applications.

Single-Phasing Prevention: Prevent unsafe operation when one phase is lost.

Automatic Restart: Support restart after power restoration, preferably with an adjustable restart delay and configurable restart behaviour.

Fault Detection and Indication: Identify applicable fault conditions, provide individual fault indications, and ensure appropriate motor trip behaviour.

Keypad-Based Parameter Programming: All applicable protection parameters must be configurable through the keypad, including voltage thresholds, overload settings, restart delays, and other supported settings.

Complete SSR-Based Starter Integration: Include the protection control circuit, SSR interface, complete power-switching stage, and associated components required for the prototype.

The team must define the protection thresholds, time delays, sensing methods, restart logic, fault-reset behaviour, and other unresolved technical parameters during circuit design. All assumptions and limitations must be documented for approval.

4. Complete Scope of Work and Deliverables
The project includes the following:

Circuit design and complete schematic preparation.

Component selection, calculations, and ratings verification.

PCB design and layout.

Gerber files, drill files, and manufacturing documentation.

Bill of Materials (BOM) and component specifications.

External PCB fabrication and assembly.

Firmware development and keypad-based parameter configuration.

Integration of the protection circuit with the complete SSR-based power-switching stage.

Development and assembly of two prototypes.

Integration of all required protection functions and fault indications.

Testing under applicable single-phase and three-phase operating conditions.

Calibration of voltage, current, overload, and other applicable protection thresholds.

Validation of dry-run detection, phase-failure protection, motor trips, and automatic restart behaviour.

Testing of keypad operation and parameter retention, wherever applicable.

Preparation of circuit files, PCB design files, firmware, technical documentation, test reports, and calibration records.

All final deliverables must be reviewed before project closure.

5. Team Allocation and Responsibilities
Team Head – Project Coordination

Hareesh V
Managing Partner – Projects & Administration
Executive Management Team
Mobile: 81242 27370
Email: hareeshv@suryas.in
The team head shall coordinate project execution, monitor progress, review deliverables, and ensure compliance with the project schedule and approved workflow.

PCB Designs & Fabrication Team

Ms. Vishnu Varshini M – PCB & EMS/IoT Designer-T

Smrithi K – Intern, PCB Designs & Fabrication Team

Rithanya D – Intern, PCB Designs & Fabrication Team

The assigned team shall coordinate circuit documentation, PCB design preparation, component information, fabrication documentation, assembly planning, and associated technical records according to the finalized allocation of responsibilities.

All team members must coordinate with the team head and provide progress updates at the required milestones.

6. Circuit Design Submission and Mandatory Approval
The complete circuit design must be submitted to me on or before 29 October 2026 for review and approval.

The submission must include:

Complete circuit schematic and protection logic.

Proposed component list with ratings and specifications.

Voltage and current sensing arrangements.

SSR and power-switching stage design.

Protection thresholds, time delays, and restart logic.

Keypad interface and firmware control approach.

Preliminary PCB architecture and relevant safety considerations.

Technical calculations, assumptions, limitations, and unresolved design decisions.

The team must incorporate the corrections or modifications required during the review.

PCB fabrication and assembly may proceed only after I have reviewed and explicitly approved the circuit design.

No fabrication order, external production commitment, or related expenditure may be initiated before approval. This is a mandatory project-control requirement.

7. External PCB Fabrication and Assembly
PCB fabrication must be coordinated through the designated partner company via me.

After circuit approval, the team must prepare the complete fabrication package, including:

Approved schematic and PCB design files.

Gerber and drill files.

BOM with component specifications and ratings.

PCB dimensions, layer count, copper thickness, and fabrication specifications.

Assembly drawings and component placement files, wherever applicable.

Relevant high-voltage isolation, creepage and clearance, and thermal-management requirements.

The initial requirement is two prototype units, subject to final design confirmation.

The team must coordinate the fabrication schedule to ensure sufficient time remains for assembly, firmware integration, testing, calibration, and final validation.

No team member may independently finalize external fabrication arrangements without the required coordination and authorization.

8. Project Schedule and Milestones
Activity
Deadline
Project commencement and technical review
26 October 2026
Complete circuit design submission
29 October 2026
Circuit review and approval
After submission and review
PCB fabrication and assembly
Only after explicit circuit approval
Firmware development and integration
During project execution
Prototype development – 2 units
As per the approved schedule
Functional testing and calibration
Before final submission
Final documentation and validation
Before project completion
Final project completion and delivery
14 December 2026
The complete project, including hardware, software, PCB fabrication and assembly, two prototypes, testing, calibration, and technical documentation, must be completed and delivered on or before 14 December 2026.

Any anticipated delay, component availability issue, technical difficulty, or fabrication constraint must be reported immediately to the team head, together with a corrective action plan.

9. Technical and Safety Requirements
Since the design involves AC mains and three-phase motor loads up to 25 HP, the following requirements must receive particular attention:

Appropriate SSR ratings for motor starting and operating currents.

Heat sinks, thermal management, and overheating protection.

Electrical isolation between control and power sections.

Suitable fuses, circuit breakers, short-circuit protection, and protective earthing.

Adequate PCB creepage and clearance distances.

Reliable fault detection and fail-safe motor shutdown.

Safe restart behaviour following power restoration or fault clearance.

Appropriate testing procedures for high-voltage and high-current equipment.

The SSR must not be treated as the sole means of short-circuit protection or safe electrical isolation. Suitable independent protective devices and safety arrangements must be evaluated and incorporated as required by the design.

Testing and calibration must be conducted using appropriate equipment and safe procedures.

10. Progress Reporting and Communication
All team members must coordinate through the designated team head and provide timely progress updates.

Technical queries, component-selection concerns, design changes, procurement requirements, and fabrication issues must be communicated promptly.

No changes affecting the approved circuit, component ratings, protection logic, or project scope may be implemented without authorization.

For further technical or project-related queries, contact:

Er. SANTHANA KUMAR V
Managing Partner – Operations & Business Development
Executive Management Team
Email: santhanakumarv@suryas.in
All external PCB fabrication coordination must be routed through me.

11. Strict Confidentiality, NDA and Intellectual Property Protection
Mandatory Confidentiality and Non-Disclosure Agreement (NDA) Compliance

All team members, interns, consultants, external PCB fabrication partners, vendors, and other individuals or organizations involved in this project must maintain strict confidentiality regarding all project-related information.

The confidentiality requirements are as follows:

Mandatory NDA: Every relevant individual and external partner must execute the applicable NDA or confidentiality agreement before receiving confidential project information or accessing project files.

No Unauthorized Disclosure: Circuit diagrams, schematics, PCB layouts, Gerber files, firmware, source code, technical specifications, BOMs, testing results, commercial details, and other project materials must not be disclosed, forwarded, published, or shared with unauthorized persons.

No Unauthorized Use: Project information must be used exclusively for the authorized work. Independent commercial use, reproduction, resale, or exploitation of confidential materials without written authorization is prohibited.

External Partner Confidentiality: The designated PCB fabrication and assembly partner must be bound by appropriate confidentiality obligations before project files are shared. Only information necessary for the authorized work may be disclosed.

Data Security: Project files must be stored and transferred securely. Uploading confidential materials to public repositories, personal cloud storage, public forums, or third-party AI tools is prohibited unless expressly authorized in writing.

Intellectual Property Ownership: Ownership and usage rights relating to project deliverables, circuit designs, PCB layouts, firmware, documentation, and other intellectual property shall be governed by the applicable written agreements and law. No individual or partner may commercially exploit such deliverables contrary to those agreements.

Return or Deletion of Materials: Upon project completion or termination, confidential materials must be returned or securely deleted as required by the applicable agreement, subject to lawful retention obligations.

Continuing Confidentiality: Confidentiality obligations shall continue for the period specified in the applicable NDA and, where permitted by law, for as long as the information remains a trade secret.

Breach Reporting: Any suspected or actual disclosure, loss, unauthorized access, or misuse of confidential information must be reported immediately to management. Appropriate legal remedies may be pursued under the signed agreements and applicable law.

Management Requirement: No project-related confidential information may be shared externally until the applicable NDA and authorization procedures have been completed.

All parties must acknowledge and comply with these requirements before commencing their respective project activities. The relevant signed agreements must clearly define confidentiality obligations, permitted use, intellectual property rights, and applicable remedies.

These requirements are intended to ensure strict confidentiality throughout the project and after its completion, subject to the applicable agreements and law.

12. Final Instructions
The project officially commences on 26 October 2026. The complete circuit design must be submitted by 29 October 2026, and PCB fabrication may proceed only after my explicit approval.

The complete project must be delivered on or before 14 December 2026, including all required hardware, firmware, two functional prototypes, testing, calibration, and technical documentation.

All assigned team members are expected to follow the approved workflow, maintain proper technical documentation, protect confidential information, coordinate effectively, and meet the finalized deadlines.

Please review the complete requirements carefully and prepare for project commencement.', '2026-10-29', 'in_progress', 0,
  'SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13', 'SMRITHI K', 'smrithik',
  'user-003', 'SANTHANA KUMAR V', '2026-10-26T02:27:12.163Z'::timestamptz, '2026-10-26T02:58:21.512Z'::timestamptz, '[]'::jsonb
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
  'd4cbb315-acb5-4f61-9a7d-f9664442acf0', 'Official Project Assignment, Technical Requirements & Strict NDA – Electronic Motor Starter with SSR-Based Protection | Final Deadline: 14 December 2026', 'Dear Team,

This email serves as the official project assignment, technical problem statement, execution plan, team allocation, confidentiality requirements, and delivery schedule for the development of a complete programmable Electronic Motor Starter with SSR-Based Motor Protection for SURYA’S MiB ENTERPRISES.

The project covers complete hardware and software development, circuit design, PCB design, external PCB fabrication and assembly, firmware development, two prototypes, testing, and calibration.

Project Start Date: 26 October 2026
Circuit Design Submission Deadline: 29 October 2026
Final Project Completion Deadline: 14 December 2026
1. Project Problem Statement and Objective
SURYA’S MiB ENTERPRISES intends to develop a customizable electronic motor starter using Solid-State Relay (SSR) technology for single-phase and three-phase submersible motor applications.

The engineering challenge is to integrate motor starting and power switching with comprehensive electrical protection, dry-run detection, fault monitoring, programmable protection parameters, and automatic restart control into a complete hardware and firmware solution.

The developed system must monitor the applicable electrical and operating conditions, detect abnormal supply or motor conditions, disconnect the motor through the appropriate power-switching arrangement when a fault occurs, and provide clear fault indications.

The system must support the following operating configurations:

Single-phase: 170–240 VAC, motors up to 3 HP.

Three-phase: 360–440 VAC, motors from 3 HP to 25 HP.

All applicable protection parameters must be configurable through a keypad. The solution must include the protection control circuit, sensing circuits, SSR interface, complete power-switching stage, associated components, PCB, firmware, and user interface.

The team must evaluate whether the single-phase and three-phase applications can share a common control platform with different power stages or require separate hardware configurations. This decision must be documented during circuit design.

The objective is to deliver two functional prototypes with integrated hardware and firmware, validated protection functions, calibration, and complete technical documentation.

2. Electrical Specifications
Single-Phase Application

Operating voltage: 170–240 VAC.

Motor capacity: Up to 3 HP.

Appropriate voltage and current sensing and motor protection.

Three-Phase Application

Operating voltage: 360–440 VAC.

Motor capacity: 3 HP to 25 HP.

Three-phase monitoring, phase-failure detection, and single-phasing prevention.

The design must account for motor starting current, switching characteristics, component ratings, heat dissipation, electrical isolation, short-circuit protection, and the applicable safety requirements.

3. Mandatory Protection and Functional Requirements
The system must include the following functions:

Under-Voltage (UV) Protection: Detect low supply voltage and trip the motor according to the configured threshold.

Over-Voltage (OV) Protection: Protect the motor against excessive supply voltage.

Overload (OL) Protection: Detect excessive motor current using a suitable sensing and protection mechanism.

Dry-Run Protection: Prevent motor operation when sufficient water is unavailable. The team must evaluate and select a suitable detection method, such as current-based detection or an appropriate external sensor, based on the application.

Phase-Failure Protection: Detect a missing phase in three-phase applications.

Single-Phasing Prevention: Prevent unsafe operation when one phase is lost.

Automatic Restart: Support restart after power restoration, preferably with an adjustable restart delay and configurable restart behaviour.

Fault Detection and Indication: Identify applicable fault conditions, provide individual fault indications, and ensure appropriate motor trip behaviour.

Keypad-Based Parameter Programming: All applicable protection parameters must be configurable through the keypad, including voltage thresholds, overload settings, restart delays, and other supported settings.

Complete SSR-Based Starter Integration: Include the protection control circuit, SSR interface, complete power-switching stage, and associated components required for the prototype.

The team must define the protection thresholds, time delays, sensing methods, restart logic, fault-reset behaviour, and other unresolved technical parameters during circuit design. All assumptions and limitations must be documented for approval.

4. Complete Scope of Work and Deliverables
The project includes the following:

Circuit design and complete schematic preparation.

Component selection, calculations, and ratings verification.

PCB design and layout.

Gerber files, drill files, and manufacturing documentation.

Bill of Materials (BOM) and component specifications.

External PCB fabrication and assembly.

Firmware development and keypad-based parameter configuration.

Integration of the protection circuit with the complete SSR-based power-switching stage.

Development and assembly of two prototypes.

Integration of all required protection functions and fault indications.

Testing under applicable single-phase and three-phase operating conditions.

Calibration of voltage, current, overload, and other applicable protection thresholds.

Validation of dry-run detection, phase-failure protection, motor trips, and automatic restart behaviour.

Testing of keypad operation and parameter retention, wherever applicable.

Preparation of circuit files, PCB design files, firmware, technical documentation, test reports, and calibration records.

All final deliverables must be reviewed before project closure.

5. Team Allocation and Responsibilities
Team Head – Project Coordination

Hareesh V
Managing Partner – Projects & Administration
Executive Management Team
Mobile: 81242 27370
Email: hareeshv@suryas.in
The team head shall coordinate project execution, monitor progress, review deliverables, and ensure compliance with the project schedule and approved workflow.

PCB Designs & Fabrication Team

Ms. Vishnu Varshini M – PCB & EMS/IoT Designer-T

Smrithi K – Intern, PCB Designs & Fabrication Team

Rithanya D – Intern, PCB Designs & Fabrication Team

The assigned team shall coordinate circuit documentation, PCB design preparation, component information, fabrication documentation, assembly planning, and associated technical records according to the finalized allocation of responsibilities.

All team members must coordinate with the team head and provide progress updates at the required milestones.

6. Circuit Design Submission and Mandatory Approval
The complete circuit design must be submitted to me on or before 29 October 2026 for review and approval.

The submission must include:

Complete circuit schematic and protection logic.

Proposed component list with ratings and specifications.

Voltage and current sensing arrangements.

SSR and power-switching stage design.

Protection thresholds, time delays, and restart logic.

Keypad interface and firmware control approach.

Preliminary PCB architecture and relevant safety considerations.

Technical calculations, assumptions, limitations, and unresolved design decisions.

The team must incorporate the corrections or modifications required during the review.

PCB fabrication and assembly may proceed only after I have reviewed and explicitly approved the circuit design.

No fabrication order, external production commitment, or related expenditure may be initiated before approval. This is a mandatory project-control requirement.

7. External PCB Fabrication and Assembly
PCB fabrication must be coordinated through the designated partner company via me.

After circuit approval, the team must prepare the complete fabrication package, including:

Approved schematic and PCB design files.

Gerber and drill files.

BOM with component specifications and ratings.

PCB dimensions, layer count, copper thickness, and fabrication specifications.

Assembly drawings and component placement files, wherever applicable.

Relevant high-voltage isolation, creepage and clearance, and thermal-management requirements.

The initial requirement is two prototype units, subject to final design confirmation.

The team must coordinate the fabrication schedule to ensure sufficient time remains for assembly, firmware integration, testing, calibration, and final validation.

No team member may independently finalize external fabrication arrangements without the required coordination and authorization.

8. Project Schedule and Milestones
Activity
Deadline
Project commencement and technical review
26 October 2026
Complete circuit design submission
29 October 2026
Circuit review and approval
After submission and review
PCB fabrication and assembly
Only after explicit circuit approval
Firmware development and integration
During project execution
Prototype development – 2 units
As per the approved schedule
Functional testing and calibration
Before final submission
Final documentation and validation
Before project completion
Final project completion and delivery
14 December 2026
The complete project, including hardware, software, PCB fabrication and assembly, two prototypes, testing, calibration, and technical documentation, must be completed and delivered on or before 14 December 2026.

Any anticipated delay, component availability issue, technical difficulty, or fabrication constraint must be reported immediately to the team head, together with a corrective action plan.

9. Technical and Safety Requirements
Since the design involves AC mains and three-phase motor loads up to 25 HP, the following requirements must receive particular attention:

Appropriate SSR ratings for motor starting and operating currents.

Heat sinks, thermal management, and overheating protection.

Electrical isolation between control and power sections.

Suitable fuses, circuit breakers, short-circuit protection, and protective earthing.

Adequate PCB creepage and clearance distances.

Reliable fault detection and fail-safe motor shutdown.

Safe restart behaviour following power restoration or fault clearance.

Appropriate testing procedures for high-voltage and high-current equipment.

The SSR must not be treated as the sole means of short-circuit protection or safe electrical isolation. Suitable independent protective devices and safety arrangements must be evaluated and incorporated as required by the design.

Testing and calibration must be conducted using appropriate equipment and safe procedures.

10. Progress Reporting and Communication
All team members must coordinate through the designated team head and provide timely progress updates.

Technical queries, component-selection concerns, design changes, procurement requirements, and fabrication issues must be communicated promptly.

No changes affecting the approved circuit, component ratings, protection logic, or project scope may be implemented without authorization.

For further technical or project-related queries, contact:

Er. SANTHANA KUMAR V
Managing Partner – Operations & Business Development
Executive Management Team
Email: santhanakumarv@suryas.in
All external PCB fabrication coordination must be routed through me.

11. Strict Confidentiality, NDA and Intellectual Property Protection
Mandatory Confidentiality and Non-Disclosure Agreement (NDA) Compliance

All team members, interns, consultants, external PCB fabrication partners, vendors, and other individuals or organizations involved in this project must maintain strict confidentiality regarding all project-related information.

The confidentiality requirements are as follows:

Mandatory NDA: Every relevant individual and external partner must execute the applicable NDA or confidentiality agreement before receiving confidential project information or accessing project files.

No Unauthorized Disclosure: Circuit diagrams, schematics, PCB layouts, Gerber files, firmware, source code, technical specifications, BOMs, testing results, commercial details, and other project materials must not be disclosed, forwarded, published, or shared with unauthorized persons.

No Unauthorized Use: Project information must be used exclusively for the authorized work. Independent commercial use, reproduction, resale, or exploitation of confidential materials without written authorization is prohibited.

External Partner Confidentiality: The designated PCB fabrication and assembly partner must be bound by appropriate confidentiality obligations before project files are shared. Only information necessary for the authorized work may be disclosed.

Data Security: Project files must be stored and transferred securely. Uploading confidential materials to public repositories, personal cloud storage, public forums, or third-party AI tools is prohibited unless expressly authorized in writing.

Intellectual Property Ownership: Ownership and usage rights relating to project deliverables, circuit designs, PCB layouts, firmware, documentation, and other intellectual property shall be governed by the applicable written agreements and law. No individual or partner may commercially exploit such deliverables contrary to those agreements.

Return or Deletion of Materials: Upon project completion or termination, confidential materials must be returned or securely deleted as required by the applicable agreement, subject to lawful retention obligations.

Continuing Confidentiality: Confidentiality obligations shall continue for the period specified in the applicable NDA and, where permitted by law, for as long as the information remains a trade secret.

Breach Reporting: Any suspected or actual disclosure, loss, unauthorized access, or misuse of confidential information must be reported immediately to management. Appropriate legal remedies may be pursued under the signed agreements and applicable law.

Management Requirement: No project-related confidential information may be shared externally until the applicable NDA and authorization procedures have been completed.

All parties must acknowledge and comply with these requirements before commencing their respective project activities. The relevant signed agreements must clearly define confidentiality obligations, permitted use, intellectual property rights, and applicable remedies.

These requirements are intended to ensure strict confidentiality throughout the project and after its completion, subject to the applicable agreements and law.

12. Final Instructions
The project officially commences on 26 October 2026. The complete circuit design must be submitted by 29 October 2026, and PCB fabrication may proceed only after my explicit approval.

The complete project must be delivered on or before 14 December 2026, including all required hardware, firmware, two functional prototypes, testing, calibration, and technical documentation.

All assigned team members are expected to follow the approved workflow, maintain proper technical documentation, protect confidential information, coordinate effectively, and meet the finalized deadlines.

Please review the complete requirements carefully and prepare for project commencement.', '2026-10-29', 'in_progress', 0,
  'SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb', 'RITHANYA D', 'rithanyad',
  'user-003', 'SANTHANA KUMAR V', '2026-10-26T02:27:12.163Z'::timestamptz, '2026-10-26T02:48:57.887Z'::timestamptz, '[]'::jsonb
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
  '14df5d33-1231-49b6-aa97-527a09295f9c', 'Projects Marketing', 'Get 30-50 Mini/Major Projects to be follow up Sabir.', '2026-10-31', 'in_progress', 15,
  'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'SABIR MOHAMMED S', 'sabir',
  'founder-001', 'GOLLA KUMAR BHARATH', '2026-10-19T10:40:05.131Z'::timestamptz, '2026-10-26T13:09:43.894Z'::timestamptz, '[]'::jsonb
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
  '4fbb5d01-0b19-4eb6-b5f1-e98828351871', 'Projects Marketing', 'Get 30-50 Mini/Major Projects to be follow up Sabir.', '2026-10-31', 'in_progress', 20,
  'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', 'MATHIYAZHAGAN D', 'mathi',
  'founder-001', 'GOLLA KUMAR BHARATH', '2026-10-19T10:40:05.131Z'::timestamptz, '2026-10-27T11:26:34.583Z'::timestamptz, '[]'::jsonb
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
  'd00c2281-15e9-4dfe-9fbf-8df7e7e0c07c', 'PCB & N/W ENGINEER', 'DRIVE PCB & N/W ENGINEER - LOYAL', '2026-10-26', 'in_progress', 0,
  'user-002', 'HAREESH V', 'hareeshv',
  'founder-001', 'GOLLA KUMAR BHARATH', '2026-10-19T07:39:29.989Z'::timestamptz, '2026-10-26T04:24:49.338Z'::timestamptz, '[]'::jsonb
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
  '2174ec64-00bf-44f2-99e1-dfff99fd2e43', 'PCB & N/W ENGINEER', 'DRIVE PCB & N/W ENGINEER - LOYAL', '2026-10-26', 'not_started', 0,
  'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'VISHNU VARSHINI M', 'vishnuu',
  'founder-001', 'GOLLA KUMAR BHARATH', '2026-10-19T07:39:29.989Z'::timestamptz, '2026-10-19T07:39:29.989Z'::timestamptz, '[]'::jsonb
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
  '8a93fc6e-ca96-4ec6-97ac-8248954e736f', 'PCB & N/W ENGINEER', 'DRIVE PCB & N/W ENGINEER - LOYAL', '2026-10-26', 'in_progress', 0,
  'SMIB-EMP-8cc825a5-7d82-43b1-accf-684074846929', 'NIDHI TIWARI', 'nidhi',
  'founder-001', 'GOLLA KUMAR BHARATH', '2026-10-19T07:39:29.989Z'::timestamptz, '2026-10-26T13:09:30.128Z'::timestamptz, '[]'::jsonb
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
  '30a3df9c-0d58-460c-84fc-148908e8b96d', 'PCB & N/W ENGINEER', 'DRIVE PCB & N/W ENGINEER - LOYAL', '2026-10-26', 'completed', 100,
  'founder-001', 'GOLLA KUMAR BHARATH', 'gkbharath',
  'founder-001', 'GOLLA KUMAR BHARATH', '2026-10-19T07:39:29.989Z'::timestamptz, '2026-10-26T13:09:16.380Z'::timestamptz, '[]'::jsonb
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
  '0a988148-d8c4-4738-b9c2-899a017a5126', 'Colleges Database', 'What is the present status colleges database?', '2026-10-24', 'completed', 100,
  'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', 'MATHIYAZHAGAN D', 'mathi',
  'user-003', 'SANTHANA KUMAR V', '2026-10-19T02:15:13.277Z'::timestamptz, '2026-10-26T03:39:38.168Z'::timestamptz, '[{"by": "mathi", "byId": "SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01", "comment": "Completed the given work assigned 16.10.2026 to 24.10.2026", "at": "2026-10-26T03:21:21.321Z"}]'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  progress = EXCLUDED.progress,
  updated_at = EXCLUDED.updated_at,
  comments = EXCLUDED.comments;


-- ==================== COMPANY LEDGER ====================
INSERT INTO public.company_ledger (
  id, balance, transactions, updated_at
) VALUES (
  'primary', 72800, '[{"id": "txn-1792989276868", "date": "2026-10-26T04:34:36.868Z", "amount": 1500, "purpose": "Petrol allowance ", "remarks": "", "type": "debited", "balanceAfter": 72800, "requestId": "4148", "requestType": "ta", "amountBy": "HAREESH V", "modeOfPayment": ""}, {"id": "txn-1792410894545", "date": "2026-10-19T11:54:54.546Z", "amount": 200, "purpose": "AMS Petrol Allowance ", "remarks": "", "type": "debited", "balanceAfter": 74300, "requestId": "3432", "requestType": "ta", "amountBy": "SABIR MOHAMMED S", "modeOfPayment": ""}, {"id": "txn-1792407309409", "date": "2026-10-19T10:55:09.409Z", "amount": 75000, "purpose": "HYBRID CONTROLLER ", "remarks": "", "type": "credited", "balanceAfter": 74500, "requestId": "9375", "requestType": "proposal", "amountBy": "GOLLA KUMAR BHARATH", "modeOfPayment": ""}, {"id": "txn-1792383114651", "date": "2026-10-19T04:11:54.651Z", "amount": 500, "purpose": "Auditor Visit Petrol and Food.", "remarks": "Approved.", "type": "debited", "balanceAfter": -500, "requestId": "6312", "requestType": "ta", "amountBy": "GOLLA KUMAR BHARATH", "modeOfPayment": ""}]'::jsonb, NOW()
) ON CONFLICT (id) DO UPDATE SET
  balance = EXCLUDED.balance,
  transactions = EXCLUDED.transactions,
  updated_at = NOW();


-- ==================== CIRCULARS ====================
INSERT INTO public.circulars (
  id, title, content, posted_by, posted_by_role, posted_at, recipients, priority, meta
) VALUES (
  'circular-9dd24afa-e673-4666-947d-bb8e598b36ed', 'Hi', 'Hi', 'gkbharath', 'founder', '2026-10-18T06:47:00.907Z'::timestamptz, '["all"]'::jsonb, 'medium', '{"date": "2026-10-18", "time": "", "category": "Notice"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  priority = EXCLUDED.priority,
  meta = EXCLUDED.meta;


-- ==================== NOTIFICATIONS ====================
INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1794835728594-3l92era1a', 'user_access_request', 'New User Access Request - Nagaraj K', 'Nagaraj K (nagarajkaids0410@gmail.com) has requested access. Review the request and add remarks.', 'hareeshv', 'SMIB-EMP-17517443-03e8-4cee-b678-8d5c3caf66f1', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793938213386-dobgtkpu7', 'request_approved', 'Request approved - Attendance report: 2026-11-04 to 2026-11-05', 'Your request Attendance report: 2026-11-04 to 2026-11-05 received final approval.', 'smrithik', '5557', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793938208329-ndkos1wgb', 'request_approved', 'Request approved - Attendance report: 2026-11-05 to 2026-11-05', 'Your request Attendance report: 2026-11-05 to 2026-11-05 received final approval.', 'rithanyad', '8521', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793938205894-dy7slmykg', 'request_approved', 'Request approved - Attendance report: 2026-11-05 to 2026-11-05', 'Your request Attendance report: 2026-11-05 to 2026-11-05 received final approval.', 'vishnuu', '4831', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793938157913-zki2o0ua4', 'request_forwarded', 'Request forwarded - Attendance report: 2026-11-04 to 2026-11-05', 'Request Attendance report: 2026-11-04 to 2026-11-05 has been forwarded to you for approval.', 'gkbharath', '5557', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793938157914-uhsy46itl', 'request_status_changed', 'Request advanced - Attendance report: 2026-11-04 to 2026-11-05', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'smrithik', '5557', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793938154737-kun3vk8a3', 'request_forwarded', 'Request forwarded - Attendance report: 2026-11-05 to 2026-11-05', 'Request Attendance report: 2026-11-05 to 2026-11-05 has been forwarded to you for approval.', 'gkbharath', '8521', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793938154737-oe8msxnp4', 'request_status_changed', 'Request advanced - Attendance report: 2026-11-05 to 2026-11-05', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'rithanyad', '8521', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793938151174-s89vhefqk', 'request_forwarded', 'Request forwarded - Attendance report: 2026-11-05 to 2026-11-05', 'Request Attendance report: 2026-11-05 to 2026-11-05 has been forwarded to you for approval.', 'gkbharath', '4831', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793938151174-00etkerr5', 'request_status_changed', 'Request advanced - Attendance report: 2026-11-05 to 2026-11-05', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'vishnuu', '4831', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793937579393-xo7e8y4a9', 'request_forwarded', 'Request forwarded - Attendance report: 2026-11-04 to 2026-11-05', 'Request Attendance report: 2026-11-04 to 2026-11-05 has been forwarded to you for approval.', 'santhanakumarv', '5557', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793937579393-jus6br17w', 'request_status_changed', 'Request advanced - Attendance report: 2026-11-04 to 2026-11-05', 'Your request was approved by hareeshv and forwarded to the next approver.', 'smrithik', '5557', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793937577738-s08pr9k1n', 'request_forwarded', 'Request forwarded - Attendance report: 2026-11-05 to 2026-11-05', 'Request Attendance report: 2026-11-05 to 2026-11-05 has been forwarded to you for approval.', 'santhanakumarv', '8521', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793937577739-330lbymt3', 'request_status_changed', 'Request advanced - Attendance report: 2026-11-05 to 2026-11-05', 'Your request was approved by hareeshv and forwarded to the next approver.', 'rithanyad', '8521', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793937575384-ie0z0dt4g', 'request_forwarded', 'Request forwarded - Attendance report: 2026-11-05 to 2026-11-05', 'Request Attendance report: 2026-11-05 to 2026-11-05 has been forwarded to you for approval.', 'santhanakumarv', '4831', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793937575384-qrscc89nl', 'request_status_changed', 'Request advanced - Attendance report: 2026-11-05 to 2026-11-05', 'Your request was approved by hareeshv and forwarded to the next approver.', 'vishnuu', '4831', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793878153238-rgp0qqw2m', 'request_forwarded', 'Guide recommendation submitted - Attendance report: 2026-11-04 to 2026-11-05', 'The guide has recommended this request for authorized approval.', 'hareeshv', '5557', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793877811651-z4ewcssdr', 'request_submitted', 'Attendance report submitted', 'VISHNU VARSHINI M submitted an attendance report for 2026-11-05 to 2026-11-05.', 'hareeshv', '4831', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793877794874-g5pve9ac6', 'request_forwarded', 'Guide recommendation submitted - Attendance report: 2026-11-05 to 2026-11-05', 'The guide has recommended this request for authorized approval.', 'hareeshv', '8521', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793877751829-v08ymnm3q', 'request_submitted', 'Attendance report submitted', 'RITHANYA D submitted an attendance report for 2026-11-05 to 2026-11-05.', 'vishnuu', '8521', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793877554693-1k7gez89l', 'request_submitted', 'Attendance report submitted', 'SMRITHI K submitted an attendance report for 2026-11-04 to 2026-11-05.', 'sabir', '5557', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793848999225-ixoy9ycy1', 'request_approved', 'Request approved - Attendance report: 2026-11-03 to 2026-11-03', 'Your request Attendance report: 2026-11-03 to 2026-11-03 received final approval.', 'smrithik', '8054', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793848994656-i1smy0zir', 'request_approved', 'Request approved - Attendance report: 2026-11-03 to 2026-11-03', 'Your request Attendance report: 2026-11-03 to 2026-11-03 received final approval.', 'rithanyad', '1000', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793848989719-rkl8dhixn', 'request_approved', 'Request approved - Attendance report: 2026-11-04 to 2026-11-04', 'Your request Attendance report: 2026-11-04 to 2026-11-04 received final approval.', 'vishnuu', '2745', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793848974703-gzw876ych', 'request_approved', 'Request approved - Attendance report: 2026-11-04 to 2026-11-04', 'Your request Attendance report: 2026-11-04 to 2026-11-04 received final approval.', 'rithanyad', '1663', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793848636212-xbjybydfr', 'request_forwarded', 'Request forwarded - Attendance report: 2026-11-03 to 2026-11-03', 'Request Attendance report: 2026-11-03 to 2026-11-03 has been forwarded to you for approval.', 'gkbharath', '8054', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793848636212-s2ztvcawa', 'request_status_changed', 'Request advanced - Attendance report: 2026-11-03 to 2026-11-03', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'smrithik', '8054', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793848635106-egq3ohlig', 'request_forwarded', 'Request forwarded - Attendance report: 2026-11-03 to 2026-11-03', 'Request Attendance report: 2026-11-03 to 2026-11-03 has been forwarded to you for approval.', 'gkbharath', '1000', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793848635106-7pen7d6gs', 'request_status_changed', 'Request advanced - Attendance report: 2026-11-03 to 2026-11-03', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'rithanyad', '1000', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793848633332-1974bg7io', 'request_forwarded', 'Request forwarded - Attendance report: 2026-11-04 to 2026-11-04', 'Request Attendance report: 2026-11-04 to 2026-11-04 has been forwarded to you for approval.', 'gkbharath', '2745', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793848633332-9zlezxu3o', 'request_status_changed', 'Request advanced - Attendance report: 2026-11-04 to 2026-11-04', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'vishnuu', '2745', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793848626604-obdqwwmzq', 'request_forwarded', 'Request forwarded - Attendance report: 2026-11-04 to 2026-11-04', 'Request Attendance report: 2026-11-04 to 2026-11-04 has been forwarded to you for approval.', 'gkbharath', '1663', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793848626604-jwerh1opd', 'request_status_changed', 'Request advanced - Attendance report: 2026-11-04 to 2026-11-04', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'rithanyad', '1663', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793847412298-j674rg5hp', 'request_forwarded', 'Request forwarded - Attendance report: 2026-11-03 to 2026-11-03', 'Request Attendance report: 2026-11-03 to 2026-11-03 has been forwarded to you for approval.', 'santhanakumarv', '8054', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793847412298-odavk9ocr', 'request_status_changed', 'Request advanced - Attendance report: 2026-11-03 to 2026-11-03', 'Your request was approved by hareeshv and forwarded to the next approver.', 'smrithik', '8054', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793847409885-ws0kz3k4u', 'request_forwarded', 'Request forwarded - Attendance report: 2026-11-03 to 2026-11-03', 'Request Attendance report: 2026-11-03 to 2026-11-03 has been forwarded to you for approval.', 'santhanakumarv', '1000', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793847409885-zd0q1iv8j', 'request_status_changed', 'Request advanced - Attendance report: 2026-11-03 to 2026-11-03', 'Your request was approved by hareeshv and forwarded to the next approver.', 'rithanyad', '1000', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793847407279-jrrolfjj2', 'request_forwarded', 'Request forwarded - Attendance report: 2026-11-04 to 2026-11-04', 'Request Attendance report: 2026-11-04 to 2026-11-04 has been forwarded to you for approval.', 'santhanakumarv', '2745', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793847407279-r52g4d1yy', 'request_status_changed', 'Request advanced - Attendance report: 2026-11-04 to 2026-11-04', 'Your request was approved by hareeshv and forwarded to the next approver.', 'vishnuu', '2745', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793847404037-sytwqbl1b', 'request_forwarded', 'Request forwarded - Attendance report: 2026-11-04 to 2026-11-04', 'Request Attendance report: 2026-11-04 to 2026-11-04 has been forwarded to you for approval.', 'santhanakumarv', '1663', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793847404037-eq1dsqxlp', 'request_status_changed', 'Request advanced - Attendance report: 2026-11-04 to 2026-11-04', 'Your request was approved by hareeshv and forwarded to the next approver.', 'rithanyad', '1663', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793791979023-48q9ahykm', 'request_forwarded', 'Guide recommendation submitted - Attendance report: 2026-11-04 to 2026-11-04', 'The guide has recommended this request for authorized approval.', 'hareeshv', '1663', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793791184225-2wbs88oyx', 'request_submitted', 'Attendance report submitted', 'RITHANYA D submitted an attendance report for 2026-11-04 to 2026-11-04.', 'vishnuu', '1663', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793790889072-ykopglxm9', 'request_submitted', 'Attendance report submitted', 'VISHNU VARSHINI M submitted an attendance report for 2026-11-04 to 2026-11-04.', 'hareeshv', '2745', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793763895752-8zexefkv4', 'request_forwarded', 'Guide recommendation submitted - Attendance report: 2026-11-03 to 2026-11-03', 'The guide has recommended this request for authorized approval.', 'hareeshv', '8054', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793762510200-b2wp3xpl3', 'request_approved', 'Request approved - Past-Date Casual Leave Request', 'Your request Past-Date Casual Leave Request received final approval.', 'rithanyad', '2663', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793762492052-jr03b3gc9', 'request_approved', 'Request approved - Attendance report: 2026-11-03 to 2026-11-03', 'Your request Attendance report: 2026-11-03 to 2026-11-03 received final approval.', 'vishnuu', '9601', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793762303067-418nilrcc', 'request_forwarded', 'Request forwarded - Past-Date Casual Leave Request', 'Request Past-Date Casual Leave Request has been forwarded to you for approval.', 'gkbharath', '2663', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793762303068-4cau7c1i2', 'request_status_changed', 'Request advanced - Past-Date Casual Leave Request', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'rithanyad', '2663', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793762300874-o9ue7tbat', 'request_forwarded', 'Guide recommendation submitted - Attendance report: 2026-11-03 to 2026-11-03', 'The guide has recommended this request for authorized approval.', 'hareeshv', '1000', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793762284654-foylpyd7z', 'request_forwarded', 'Request forwarded - Attendance report: 2026-11-03 to 2026-11-03', 'Request Attendance report: 2026-11-03 to 2026-11-03 has been forwarded to you for approval.', 'gkbharath', '9601', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793762284654-tipxuz83i', 'request_status_changed', 'Request advanced - Attendance report: 2026-11-03 to 2026-11-03', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'vishnuu', '9601', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793761717533-ag5a39y2n', 'request_forwarded', 'Request forwarded - Past-Date Casual Leave Request', 'Request Past-Date Casual Leave Request has been forwarded to you for approval.', 'santhanakumarv', '2663', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793761717533-aj11ir3ig', 'request_status_changed', 'Request advanced - Past-Date Casual Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'rithanyad', '2663', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793761710171-51kg3soty', 'request_forwarded', 'Request forwarded - Attendance report: 2026-11-03 to 2026-11-03', 'Request Attendance report: 2026-11-03 to 2026-11-03 has been forwarded to you for approval.', 'santhanakumarv', '9601', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793761710172-bg5xozq4c', 'request_status_changed', 'Request advanced - Attendance report: 2026-11-03 to 2026-11-03', 'Your request was approved by hareeshv and forwarded to the next approver.', 'vishnuu', '9601', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793706945018-5u5dlzwvu', 'request_submitted', 'Attendance report submitted', 'RITHANYA D submitted an attendance report for 2026-11-03 to 2026-11-03.', 'vishnuu', '1000', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793705989294-di5jp4c9h', 'request_submitted', 'Attendance report submitted', 'VISHNU VARSHINI M submitted an attendance report for 2026-11-03 to 2026-11-03.', 'hareeshv', '9601', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793705897275-dx4tmcq0i', 'request_submitted', 'Attendance report submitted', 'SMRITHI K submitted an attendance report for 2026-11-03 to 2026-11-03.', 'sabir', '8054', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793705692187-hfw7c8mfx', 'request_forwarded', 'Guide recommendation submitted - Past-Date Casual Leave Request', 'The guide has recommended this request for authorized approval.', 'hareeshv', '2663', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793677236936-vv9eqh7ud', 'request_submitted', 'Request submitted - Past-Date Casual Leave Request', 'RITHANYA D submitted Past-Date Casual Leave Request; it is awaiting your review.', 'vishnuu', '2663', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793677236936-25vtc326i', 'request_submitted', 'Submission received - Past-Date Casual Leave Request', 'Your request Past-Date Casual Leave Request was submitted for approval.', 'rithanyad', '2663', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793366381687-v6oplhuzo', 'request_submitted', 'Attendance report submitted', 'RITHANYA D submitted an attendance report for 2026-10-29 to 2026-10-30.', 'vishnuu', '1131', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793366347222-ybsbaw1a7', 'request_submitted', 'Attendance report submitted', 'RITHANYA D submitted an attendance report for 2026-10-28 to 2026-10-28.', 'vishnuu', '2056', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793364534820-y8ktip2y8', 'request_submitted', 'Attendance report submitted', 'SMRITHI K submitted an attendance report for 2026-10-30 to 2026-10-30.', 'sabir', '1303', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793359057179-g9rk47y08', 'request_submitted', 'Attendance report submitted', 'VISHNU VARSHINI M submitted an attendance report for 2026-10-30 to 2026-10-30.', 'hareeshv', '9752', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793351627471-fk98o6vzj', 'request_approved', 'Request approved - Attendance report: 2026-10-26 to 2026-10-26', 'Your request Attendance report: 2026-10-26 to 2026-10-26 received final approval.', 'mathi', '6732', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793351624980-q7gox3ol9', 'request_approved', 'Request approved - Attendance report: 2026-10-27 to 2026-10-27', 'Your request Attendance report: 2026-10-27 to 2026-10-27 received final approval.', 'mathi', '1292', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793351622970-jjq5jx3av', 'request_approved', 'Request approved - Attendance report: 2026-10-26 to 2026-10-27', 'Your request Attendance report: 2026-10-26 to 2026-10-27 received final approval.', 'smrithik', '4894', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793351620021-yw24z2yr5', 'request_approved', 'Request approved - Attendance report: 2026-10-28 to 2026-10-28', 'Your request Attendance report: 2026-10-28 to 2026-10-28 received final approval.', 'mathi', '3079', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793351585852-wpinccwq4', 'request_forwarded', 'Request forwarded - Attendance report: 2026-10-26 to 2026-10-26', 'Request Attendance report: 2026-10-26 to 2026-10-26 has been forwarded to you for approval.', 'gkbharath', '6732', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793351585852-87zonj4l3', 'request_status_changed', 'Request advanced - Attendance report: 2026-10-26 to 2026-10-26', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'mathi', '6732', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793351580304-z3og24qhz', 'request_forwarded', 'Request forwarded - Attendance report: 2026-10-27 to 2026-10-27', 'Request Attendance report: 2026-10-27 to 2026-10-27 has been forwarded to you for approval.', 'gkbharath', '1292', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793351580304-iyjijqvf0', 'request_status_changed', 'Request advanced - Attendance report: 2026-10-27 to 2026-10-27', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'mathi', '1292', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793351574287-f5ynr8gfs', 'request_forwarded', 'Request forwarded - Attendance report: 2026-10-26 to 2026-10-27', 'Request Attendance report: 2026-10-26 to 2026-10-27 has been forwarded to you for approval.', 'gkbharath', '4894', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793351574287-8il0wt3rx', 'request_status_changed', 'Request advanced - Attendance report: 2026-10-26 to 2026-10-27', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'smrithik', '4894', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793351566993-v6bz4vmvk', 'request_forwarded', 'Request forwarded - Attendance report: 2026-10-28 to 2026-10-28', 'Request Attendance report: 2026-10-28 to 2026-10-28 has been forwarded to you for approval.', 'gkbharath', '3079', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793351566993-bv0fqxgsa', 'request_status_changed', 'Request advanced - Attendance report: 2026-10-28 to 2026-10-28', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'mathi', '3079', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793344932722-1fv2qmnar', 'request_submitted', 'Request submitted - Casual Leave Request', 'GOLLA KUMAR BHARATH submitted Casual Leave Request; it is awaiting your review.', 'hareeshv', '2423', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793344932722-8sycxuyf0', 'request_submitted', 'Submission received - Casual Leave Request', 'Your request Casual Leave Request was submitted for approval.', 'gkbharath', '2423', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793344911917-41xunyhg9', 'request_submitted', 'Request submitted - Casual Leave Request', 'GOLLA KUMAR BHARATH submitted Casual Leave Request; it is awaiting your review.', 'hareeshv', '8844', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793344911917-o0m4hl7rg', 'request_submitted', 'Submission received - Casual Leave Request', 'Your request Casual Leave Request was submitted for approval.', 'gkbharath', '8844', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793340375805-g0lf6qccn', 'request_forwarded', 'Request forwarded - Attendance report: 2026-10-26 to 2026-10-26', 'Request Attendance report: 2026-10-26 to 2026-10-26 has been forwarded to you for approval.', 'santhanakumarv', '6732', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793340375805-atxhif1lv', 'request_status_changed', 'Request advanced - Attendance report: 2026-10-26 to 2026-10-26', 'Your request was approved by hareeshv and forwarded to the next approver.', 'mathi', '6732', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793340371063-12i95savh', 'request_forwarded', 'Request forwarded - Attendance report: 2026-10-27 to 2026-10-27', 'Request Attendance report: 2026-10-27 to 2026-10-27 has been forwarded to you for approval.', 'santhanakumarv', '1292', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793340371063-iw9rhnyfo', 'request_status_changed', 'Request advanced - Attendance report: 2026-10-27 to 2026-10-27', 'Your request was approved by hareeshv and forwarded to the next approver.', 'mathi', '1292', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793340363400-mxosti54u', 'request_forwarded', 'Request forwarded - Attendance report: 2026-10-26 to 2026-10-27', 'Request Attendance report: 2026-10-26 to 2026-10-27 has been forwarded to you for approval.', 'santhanakumarv', '4894', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793340363400-c7jj7optr', 'request_status_changed', 'Request advanced - Attendance report: 2026-10-26 to 2026-10-27', 'Your request was approved by hareeshv and forwarded to the next approver.', 'smrithik', '4894', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793340358658-aa5jbgznj', 'request_forwarded', 'Request forwarded - Attendance report: 2026-10-28 to 2026-10-28', 'Request Attendance report: 2026-10-28 to 2026-10-28 has been forwarded to you for approval.', 'santhanakumarv', '3079', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793340358659-v9beuqd01', 'request_status_changed', 'Request advanced - Attendance report: 2026-10-28 to 2026-10-28', 'Your request was approved by hareeshv and forwarded to the next approver.', 'mathi', '3079', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793340016588-if3bbijsw', 'request_approved', 'Request approved - Casual Leave Request', 'Your request Casual Leave Request received final approval.', 'smrithik', '1516', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793339998747-pd3lezn1d', 'request_approved', 'Request approved - Attendance report: 2026-10-28 to 2026-10-28', 'Your request Attendance report: 2026-10-28 to 2026-10-28 received final approval.', 'vishnuu', '3261', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793339983775-atnve857t', 'request_approved', 'Request approved - Attendance report: 2026-10-28 to 2026-10-28', 'Your request Attendance report: 2026-10-28 to 2026-10-28 received final approval.', 'smrithik', '4273', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793339921592-eajdthszz', 'request_forwarded', 'Request forwarded - Casual Leave Request', 'Request Casual Leave Request has been forwarded to you for approval.', 'gkbharath', '1516', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793339921592-17levo51q', 'request_status_changed', 'Request advanced - Casual Leave Request', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'smrithik', '1516', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793339911016-f0wqedxbm', 'request_forwarded', 'Request forwarded - Attendance report: 2026-10-28 to 2026-10-28', 'Request Attendance report: 2026-10-28 to 2026-10-28 has been forwarded to you for approval.', 'gkbharath', '4273', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793339911016-tp9eduk61', 'request_status_changed', 'Request advanced - Attendance report: 2026-10-28 to 2026-10-28', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'smrithik', '4273', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793339832942-t7ul7bp6k', 'request_forwarded', 'Request forwarded - Casual Leave Request', 'Request Casual Leave Request has been forwarded to you for approval.', 'santhanakumarv', '1516', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793339832943-6qglpyops', 'request_status_changed', 'Request advanced - Casual Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'smrithik', '1516', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793339824320-iziqzvxts', 'request_forwarded', 'Request forwarded - Attendance report: 2026-10-28 to 2026-10-28', 'Request Attendance report: 2026-10-28 to 2026-10-28 has been forwarded to you for approval.', 'santhanakumarv', '4273', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793339824321-rt1ipiidz', 'request_status_changed', 'Request advanced - Attendance report: 2026-10-28 to 2026-10-28', 'Your request was approved by hareeshv and forwarded to the next approver.', 'smrithik', '4273', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793339815589-uvse2d8ds', 'request_rejected', 'Request rejected - Attendance report: 2026-10-29 to 2026-10-29', 'Your request Attendance report: 2026-10-29 to 2026-10-29 was rejected by hareeshv. Remarks: ', 'mathi', '5073', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793338300481-bv4c1ujzd', 'request_forwarded', 'Guide recommendation submitted - Attendance report: 2026-10-29 to 2026-10-29', 'The guide has recommended this request for authorized approval.', 'hareeshv', '5073', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793338285352-73cau72mj', 'request_forwarded', 'Guide recommendation submitted - Casual Leave Request', 'The guide has recommended this request for authorized approval.', 'hareeshv', '1516', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793332009495-39tpc8za5', 'request_submitted', 'Attendance report submitted', 'MATHIYAZHAGAN D submitted an attendance report for 2026-10-29 to 2026-10-29.', 'sabir', '5073', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793331217566-xkiz1xgou', 'request_forwarded', 'Guide recommendation submitted - Attendance report: 2026-10-28 to 2026-10-28', 'The guide has recommended this request for authorized approval.', 'hareeshv', '4273', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793331203757-5onj5y34g', 'request_forwarded', 'Guide recommendation submitted - Attendance report: 2026-10-28 to 2026-10-28', 'The guide has recommended this request for authorized approval.', 'hareeshv', '3079', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793331167497-nyo99tco6', 'request_forwarded', 'Guide recommendation submitted - Attendance report: 2026-10-26 to 2026-10-27', 'The guide has recommended this request for authorized approval.', 'hareeshv', '4894', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793331142285-qak3d7tm4', 'request_forwarded', 'Guide recommendation submitted - Attendance report: 2026-10-27 to 2026-10-27', 'The guide has recommended this request for authorized approval.', 'hareeshv', '1292', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793331132237-yok941s0g', 'request_forwarded', 'Guide recommendation submitted - Attendance report: 2026-10-26 to 2026-10-26', 'The guide has recommended this request for authorized approval.', 'hareeshv', '6732', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793189116568-a3k5t5uxa', 'request_submitted', 'Attendance report submitted', 'SMRITHI K submitted an attendance report for 2026-10-28 to 2026-10-28.', 'sabir', '4273', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793188136079-q1w4vjtq4', 'request_forwarded', 'Request forwarded - Attendance report: 2026-10-28 to 2026-10-28', 'Request Attendance report: 2026-10-28 to 2026-10-28 has been forwarded to you for approval.', 'gkbharath', '3261', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793188136079-0ldfqe7ke', 'request_status_changed', 'Request advanced - Attendance report: 2026-10-28 to 2026-10-28', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'vishnuu', '3261', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793188126297-sbaxe2v33', 'request_submitted', 'Request submitted - Allowance Claim Request', 'MATHIYAZHAGAN D submitted Allowance Claim Request; it is awaiting your review.', 'sabir', '6887', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793188126297-xth2v3xg1', 'request_submitted', 'Submission received - Allowance Claim Request', 'Your request Allowance Claim Request was submitted for approval.', 'mathi', '6887', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793187690612-id0uj4iaw', 'request_forwarded', 'Request forwarded - Attendance report: 2026-10-28 to 2026-10-28', 'Request Attendance report: 2026-10-28 to 2026-10-28 has been forwarded to you for approval.', 'santhanakumarv', '3261', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793187690612-mu1cvykwa', 'request_status_changed', 'Request advanced - Attendance report: 2026-10-28 to 2026-10-28', 'Your request was approved by hareeshv and forwarded to the next approver.', 'vishnuu', '3261', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793187679440-rmfv92cmn', 'request_submitted', 'Attendance report submitted', 'MATHIYAZHAGAN D submitted an attendance report for 2026-10-28 to 2026-10-28.', 'sabir', '3079', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793186788283-8ot14xnne', 'request_submitted', 'Attendance report submitted', 'VISHNU VARSHINI M submitted an attendance report for 2026-10-28 to 2026-10-28.', 'hareeshv', '3261', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793159577308-snml0bjrt', 'request_approved', 'Request approved - Casual Leave Request', 'Your request Casual Leave Request received final approval.', 'santhanakumarv', '6911', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793159204698-u9yi5lku6', 'request_forwarded', 'Request forwarded - Casual Leave Request', 'Request Casual Leave Request has been forwarded to you for approval.', 'gkbharath', '6911', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793159204698-uqmn12n0j', 'request_status_changed', 'Request advanced - Casual Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'santhanakumarv', '6911', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793158489101-sm4izvfc6', 'request_submitted', 'Request submitted - Casual Leave Request', 'SANTHANA KUMAR V submitted Casual Leave Request; it is awaiting your review.', 'hareeshv', '6911', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793158489101-ebgesx6ri', 'request_submitted', 'Submission received - Casual Leave Request', 'Your request Casual Leave Request was submitted for approval.', 'santhanakumarv', '6911', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793157601363-lzsw2r7bv', 'request_submitted', 'Request submitted - Casual Leave Request', 'SMRITHI K submitted Casual Leave Request; it is awaiting your review.', 'sabir', '1516', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793157601363-zd5uuekc7', 'request_submitted', 'Submission received - Casual Leave Request', 'Your request Casual Leave Request was submitted for approval.', 'smrithik', '1516', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793157060492-0dbcik9lg', 'request_rejected', 'Request rejected - Casual Leave Request', 'Your request Casual Leave Request was rejected by gkbharath. Remarks: ', 'mathi', '4973', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793157054162-pnjljjc92', 'request_approved', 'Request approved - Attendance report: 2026-10-27 to 2026-10-27', 'Your request Attendance report: 2026-10-27 to 2026-10-27 received final approval.', 'vishnuu', '3955', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793157050941-lklmhn2ar', 'request_approved', 'Request approved - Attendance report: 2026-10-27 to 2026-10-27', 'Your request Attendance report: 2026-10-27 to 2026-10-27 received final approval.', 'rithanyad', '5124', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793157007551-rm31cru8n', 'request_forwarded', 'Request forwarded - Attendance report: 2026-10-27 to 2026-10-27', 'Request Attendance report: 2026-10-27 to 2026-10-27 has been forwarded to you for approval.', 'gkbharath', '3955', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793157007551-m73w6w3gr', 'request_status_changed', 'Request advanced - Attendance report: 2026-10-27 to 2026-10-27', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'vishnuu', '3955', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793157005664-11iydzo2e', 'request_forwarded', 'Request forwarded - Attendance report: 2026-10-27 to 2026-10-27', 'Request Attendance report: 2026-10-27 to 2026-10-27 has been forwarded to you for approval.', 'gkbharath', '5124', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793157005664-td9ls8tp0', 'request_status_changed', 'Request advanced - Attendance report: 2026-10-27 to 2026-10-27', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'rithanyad', '5124', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793104359457-0u6kc88of', 'request_forwarded', 'Request forwarded - Attendance report: 2026-10-27 to 2026-10-27', 'Request Attendance report: 2026-10-27 to 2026-10-27 has been forwarded to you for approval.', 'santhanakumarv', '5124', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793104359457-7ejs1xplg', 'request_status_changed', 'Request advanced - Attendance report: 2026-10-27 to 2026-10-27', 'Your request was approved by hareeshv and forwarded to the next approver.', 'rithanyad', '5124', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793104340899-sp251j1nq', 'request_forwarded', 'Guide recommendation submitted - Attendance report: 2026-10-27 to 2026-10-27', 'The guide has recommended this request for authorized approval.', 'hareeshv', '5124', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793103717531-82hm25das', 'request_submitted', 'Attendance report submitted', 'SMRITHI K submitted an attendance report for 2026-10-26 to 2026-10-27.', 'sabir', '4894', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793103072095-4cbjsbjt4', 'request_submitted', 'Attendance report submitted', 'RITHANYA D submitted an attendance report for 2026-10-27 to 2026-10-27.', 'vishnuu', '5124', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793102482333-q88xs1bqg', 'request_forwarded', 'Request forwarded - Attendance report: 2026-10-27 to 2026-10-27', 'Request Attendance report: 2026-10-27 to 2026-10-27 has been forwarded to you for approval.', 'santhanakumarv', '3955', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793102482333-ayd43xkeo', 'request_status_changed', 'Request advanced - Attendance report: 2026-10-27 to 2026-10-27', 'Your request was approved by hareeshv and forwarded to the next approver.', 'vishnuu', '3955', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793101545285-z3pyww3i6', 'request_approved', 'Request approved - Casual Leave Request', 'Your request Casual Leave Request received final approval.', 'hareeshv', '2609', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793100729124-9cq3vhu0o', 'request_submitted', 'Attendance report submitted', 'MATHIYAZHAGAN D submitted an attendance report for 2026-10-27 to 2026-10-27.', 'sabir', '1292', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793099551941-4k0atw3ty', 'request_submitted', 'Attendance report submitted', 'VISHNU VARSHINI M submitted an attendance report for 2026-10-27 to 2026-10-27.', 'hareeshv', '3955', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793094378242-w0he40doy', 'request_forwarded', 'Request forwarded - Casual Leave Request', 'Request Casual Leave Request has been forwarded to you for approval.', 'gkbharath', '2609', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793094378242-2eso52o68', 'request_status_changed', 'Request advanced - Casual Leave Request', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'hareeshv', '2609', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793094334190-gep47yntc', 'request_submitted', 'Request submitted - Casual Leave Request', 'HAREESH V submitted Casual Leave Request; it is awaiting your review.', 'santhanakumarv', '2609', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793094334190-zlicvj4v6', 'request_submitted', 'Submission received - Casual Leave Request', 'Your request Casual Leave Request was submitted for approval.', 'hareeshv', '2609', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793071514084-1p8qov368', 'request_approved', 'Request approved - Attendance report: 2026-10-26 to 2026-10-26', 'Your request Attendance report: 2026-10-26 to 2026-10-26 received final approval.', 'rithanyad', '6548', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793071473604-fc5uur6nz', 'request_forwarded', 'Request forwarded - Attendance report: 2026-10-26 to 2026-10-26', 'Request Attendance report: 2026-10-26 to 2026-10-26 has been forwarded to you for approval.', 'gkbharath', '6548', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793071473605-0qe27l73i', 'request_status_changed', 'Request advanced - Attendance report: 2026-10-26 to 2026-10-26', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'rithanyad', '6548', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793071107233-bfzs45wnq', 'request_forwarded', 'Request forwarded - Attendance report: 2026-10-26 to 2026-10-26', 'Request Attendance report: 2026-10-26 to 2026-10-26 has been forwarded to you for approval.', 'santhanakumarv', '6548', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793071107233-gi52cas87', 'request_status_changed', 'Request advanced - Attendance report: 2026-10-26 to 2026-10-26', 'Your request was approved by hareeshv and forwarded to the next approver.', 'rithanyad', '6548', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793020177562-i3sfuym3a', 'request_submitted', 'Attendance report submitted', 'MATHIYAZHAGAN D submitted an attendance report for 2026-10-26 to 2026-10-26.', 'sabir', '6732', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793020063192-a8ym8nt50', 'request_approved', 'Request approved - Attendance report: 2026-10-26 to 2026-10-26', 'Your request Attendance report: 2026-10-26 to 2026-10-26 received final approval.', 'vishnuu', '6072', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793019778360-sh6o5zftb', 'request_forwarded', 'Guide recommendation submitted - Attendance report: 2026-10-26 to 2026-10-26', 'The guide has recommended this request for authorized approval.', 'hareeshv', '6548', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793019776795-hp7nckxq0', 'request_forwarded', 'Request forwarded - Attendance report: 2026-10-26 to 2026-10-26', 'Request Attendance report: 2026-10-26 to 2026-10-26 has been forwarded to you for approval.', 'gkbharath', '6072', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793019776795-7p42jivyo', 'request_status_changed', 'Request advanced - Attendance report: 2026-10-26 to 2026-10-26', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'vishnuu', '6072', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793019770310-dmd5mlm7p', 'request_forwarded', 'Request forwarded - Casual Leave Request', 'Request Casual Leave Request has been forwarded to you for approval.', 'gkbharath', '4973', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793019770310-hqesa8wf8', 'request_status_changed', 'Request advanced - Casual Leave Request', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'mathi', '4973', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793019763085-acdnly8vm', 'request_rejected', 'Request rejected - Daily Work Report – Company Website Research', 'Your request Daily Work Report – Company Website Research was rejected by santhanakumarv. Remarks: Summited Under Weekly. Summit to Attdance Page.', 'mathi', '8625', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793019704461-l5kwlepbp', 'request_rejected', 'Request rejected - Daily report', 'Your request Daily report was rejected by santhanakumarv. Remarks: Two Time Summited.', 'vishnuu', '3137', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793019523828-lln5gknh1', 'request_submitted', 'Attendance report submitted', 'RITHANYA D submitted an attendance report for 2026-10-26 to 2026-10-26.', 'vishnuu', '6548', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793019250711-g2o15eckz', 'request_forwarded', 'Request forwarded - Casual Leave Request', 'Request Casual Leave Request has been forwarded to you for approval.', 'santhanakumarv', '4973', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793019250711-sk0jgijo4', 'request_status_changed', 'Request advanced - Casual Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'mathi', '4973', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793019176961-p61zinp3d', 'request_forwarded', 'Request forwarded - Daily report', 'Request Daily report has been forwarded to you for approval.', 'santhanakumarv', '3137', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793019176961-wp8396onk', 'request_status_changed', 'Request advanced - Daily report', 'Your request was approved by hareeshv and forwarded to the next approver.', 'vishnuu', '3137', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793019167334-r7dabl85f', 'request_forwarded', 'Request forwarded - Daily Work Report – Company Website Research', 'Request Daily Work Report – Company Website Research has been forwarded to you for approval.', 'santhanakumarv', '8625', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793019167334-pi2omrebu', 'request_status_changed', 'Request advanced - Daily Work Report – Company Website Research', 'Your request was approved by hareeshv and forwarded to the next approver.', 'mathi', '8625', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793019160588-4tlt0mrhz', 'request_forwarded', 'Request forwarded - Attendance report: 2026-10-26 to 2026-10-26', 'Request Attendance report: 2026-10-26 to 2026-10-26 has been forwarded to you for approval.', 'santhanakumarv', '6072', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793019160588-74z5xbmjk', 'request_status_changed', 'Request advanced - Attendance report: 2026-10-26 to 2026-10-26', 'Your request was approved by hareeshv and forwarded to the next approver.', 'vishnuu', '6072', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793016472334-34hmsfz72', 'request_forwarded', 'Guide recommendation submitted - Daily Work Report – Company Website Research', 'The guide has recommended this request for authorized approval.', 'hareeshv', '8625', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793016001051-21rc7zkil', 'request_submitted', 'Attendance report submitted', 'VISHNU VARSHINI M submitted an attendance report for 2026-10-26 to 2026-10-26.', 'hareeshv', '6072', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793015996321-ymwtd1jpy', 'report-submitted', 'Weekly Report Submitted', 'mathi submitted "Daily Work Report – Company Website Research" for Week 44, 2026.', 'sabir', '8625', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793015996321-e9ei27hc6', 'report-submitted', 'Weekly Report Received', 'Your report "Daily Work Report – Company Website Research" was submitted for approval.', 'mathi', '8625', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793015499268-sklugsar0', 'report-submitted', 'Weekly Report Submitted', 'vishnuu submitted "Daily report" for Week 43, 2026.', 'hareeshv', '3137', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793015499268-hvi3qitbl', 'report-submitted', 'Weekly Report Received', 'Your report "Daily report" was submitted for approval.', 'vishnuu', '3137', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1793011752118-wugmpzbme', 'request_approved', 'Request approved - weekly report (Reporting Period: 19–24 October 2026)', 'Your request weekly report (Reporting Period: 19–24 October 2026) received final approval.', 'vishnuu', '4601', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792993546170-qozgh6l18', 'request_approved', 'Request approved - Casual Leave Request', 'Your request Casual Leave Request received final approval.', 'gkbharath', '4591', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792993465439-aqzv17cwa', 'request_forwarded', 'Request forwarded - Casual Leave Request', 'Request Casual Leave Request has been forwarded to you for approval.', 'santhanakumarv', '4591', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792993465439-8rjmkoxqp', 'request_status_changed', 'Request advanced - Casual Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'gkbharath', '4591', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992795336-zvaizve7q', 'request_submitted', 'Request submitted - Casual Leave Request', 'GOLLA KUMAR BHARATH submitted Casual Leave Request; it is awaiting your review.', 'hareeshv', '4591', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992795336-a09iihdom', 'request_submitted', 'Submission received - Casual Leave Request', 'Your request Casual Leave Request was submitted for approval.', 'gkbharath', '4591', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992753881-mtk6ntbx9', 'request_approved', 'Request approved - Weekly Work Report – Student Project Coordination and Engineering College Data Collection (19–24 October 2026)', 'Your request Weekly Work Report – Student Project Coordination and Engineering College Data Collection (19–24 October 2026) received final approval.', 'mathi', '4205', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992713428-nqk8mky3g', 'request_approved', 'Request approved - weekly report (Reporting Period: 14 October 2026 – 17 October 2026)', 'Your request weekly report (Reporting Period: 14 October 2026 – 17 October 2026) received final approval.', 'vishnuu', '7789', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992701030-l7f2k5zzw', 'request_approved', 'Request approved - weekly report (Reporting Period: 08 October 2026, 10 October 2026)', 'Your request weekly report (Reporting Period: 08 October 2026, 10 October 2026) received final approval.', 'vishnuu', '4212', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992688082-gay3z7qhg', 'request_approved', 'Request approved - Casual Leave Request', 'Your request Casual Leave Request received final approval.', 'vishnuu', '6023', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992576621-odr6jesxu', 'request_forwarded', 'Request forwarded - weekly report (Reporting Period: 14 October 2026 – 17 October 2026)', 'Request weekly report (Reporting Period: 14 October 2026 – 17 October 2026) has been forwarded to you for approval.', 'gkbharath', '7789', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992576621-mq2kzaico', 'request_status_changed', 'Request advanced - weekly report (Reporting Period: 14 October 2026 – 17 October 2026)', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'vishnuu', '7789', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992573585-ds2jfl252', 'request_forwarded', 'Request forwarded - Weekly Work Report – Student Project Coordination and Engineering College Data Collection (19–24 October 2026)', 'Request Weekly Work Report – Student Project Coordination and Engineering College Data Collection (19–24 October 2026) has been forwarded to you for approval.', 'gkbharath', '4205', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992573585-crydiploa', 'request_status_changed', 'Request advanced - Weekly Work Report – Student Project Coordination and Engineering College Data Collection (19–24 October 2026)', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'mathi', '4205', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992528495-e8be5epvq', 'request_forwarded', 'Request forwarded - weekly report (Reporting Period: 14 October 2026 – 17 October 2026)', 'Request weekly report (Reporting Period: 14 October 2026 – 17 October 2026) has been forwarded to you for approval.', 'santhanakumarv', '7789', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992528495-av3cdgb9e', 'request_status_changed', 'Request advanced - weekly report (Reporting Period: 14 October 2026 – 17 October 2026)', 'Your request was approved by hareeshv and forwarded to the next approver.', 'vishnuu', '7789', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992510211-cu982h25f', 'request_forwarded', 'Request forwarded - Weekly Work Report – Student Project Coordination and Engineering College Data Collection (19–24 October 2026)', 'Request Weekly Work Report – Student Project Coordination and Engineering College Data Collection (19–24 October 2026) has been forwarded to you for approval.', 'santhanakumarv', '4205', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992510211-6lj2o8tdb', 'request_status_changed', 'Request advanced - Weekly Work Report – Student Project Coordination and Engineering College Data Collection (19–24 October 2026)', 'Your request was approved by hareeshv and forwarded to the next approver.', 'mathi', '4205', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992466825-wi9usgpwf', 'request_forwarded', 'Request forwarded - weekly report (Reporting Period: 08 October 2026, 10 October 2026)', 'Request weekly report (Reporting Period: 08 October 2026, 10 October 2026) has been forwarded to you for approval.', 'gkbharath', '4212', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992466825-c0g2tzaqq', 'request_status_changed', 'Request advanced - weekly report (Reporting Period: 08 October 2026, 10 October 2026)', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'vishnuu', '4212', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992375650-4zmk5nqlm', 'request_forwarded', 'Request forwarded - Casual Leave Request', 'Request Casual Leave Request has been forwarded to you for approval.', 'gkbharath', '6023', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992375651-u6qcu2sxb', 'request_status_changed', 'Request advanced - Casual Leave Request', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'vishnuu', '6023', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992357729-27krea1xi', 'request_forwarded', 'Request forwarded - weekly report (Reporting Period: 08 October 2026, 10 October 2026)', 'Request weekly report (Reporting Period: 08 October 2026, 10 October 2026) has been forwarded to you for approval.', 'santhanakumarv', '4212', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992357730-4qunwkcik', 'request_status_changed', 'Request advanced - weekly report (Reporting Period: 08 October 2026, 10 October 2026)', 'Your request was approved by hareeshv and forwarded to the next approver.', 'vishnuu', '4212', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992350582-8q46k0tlq', 'request_forwarded', 'Request forwarded - Casual Leave Request', 'Request Casual Leave Request has been forwarded to you for approval.', 'santhanakumarv', '6023', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992350583-ub3u34oz7', 'request_status_changed', 'Request advanced - Casual Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'vishnuu', '6023', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992096376-8302w02ea', 'request_forwarded', 'Request forwarded - weekly report (Reporting Period: 19–24 October 2026)', 'Request weekly report (Reporting Period: 19–24 October 2026) has been forwarded to you for approval.', 'gkbharath', '4601', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992096376-1fdw9ubu7', 'request_status_changed', 'Request advanced - weekly report (Reporting Period: 19–24 October 2026)', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'vishnuu', '4601', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992032887-gpjued3by', 'request_forwarded', 'Request forwarded - weekly report (Reporting Period: 19–24 October 2026)', 'Request weekly report (Reporting Period: 19–24 October 2026) has been forwarded to you for approval.', 'santhanakumarv', '4601', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792992032887-m39htsrp9', 'request_status_changed', 'Request advanced - weekly report (Reporting Period: 19–24 October 2026)', 'Your request was approved by hareeshv and forwarded to the next approver.', 'vishnuu', '4601', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792991753302-8vrgew0qq', 'request_forwarded', 'Guide recommendation submitted - weekly report (Reporting Period: 19–24 October 2026)', 'The guide has recommended this request for authorized approval.', 'hareeshv', '4601', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792991748448-34h89ydby', 'request_forwarded', 'Guide recommendation submitted - weekly report (Reporting Period: 14 October 2026 – 17 October 2026)', 'The guide has recommended this request for authorized approval.', 'hareeshv', '7789', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792991744739-1hq7abt7c', 'request_forwarded', 'Guide recommendation submitted - weekly report (Reporting Period: 08 October 2026, 10 October 2026)', 'The guide has recommended this request for authorized approval.', 'hareeshv', '4212', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792991740642-a0r2b0aes', 'request_forwarded', 'Guide recommendation submitted - Weekly Work Report – Student Project Coordination and Engineering College Data Collection (19–24 October 2026)', 'The guide has recommended this request for authorized approval.', 'hareeshv', '4205', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792990175445-2b4vsmenm', 'request_forwarded', 'Guide recommendation submitted - Casual Leave Request', 'The guide has recommended this request for authorized approval.', 'hareeshv', '6023', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792990164858-0exmp4ncw', 'request_forwarded', 'Guide recommendation submitted - Casual Leave Request', 'The guide has recommended this request for authorized approval.', 'hareeshv', '4973', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792989958113-jxwz3eeqp', 'request_submitted', 'Request submitted - Casual Leave Request', 'MATHIYAZHAGAN D submitted Casual Leave Request; it is awaiting your review.', 'sabir', '4973', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792989958113-yvam6vfw5', 'request_submitted', 'Submission received - Casual Leave Request', 'Your request Casual Leave Request was submitted for approval.', 'mathi', '4973', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792989277229-ordtknt08', 'request_approved', 'Request approved - Allowance Claim Request', 'Your request Allowance Claim Request received final approval.', 'hareeshv', '4148', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792989260288-tmn8rclax', 'request_rejected', 'Request rejected - Weekly report', 'Your request Weekly report was rejected by gkbharath. Remarks: 1,2,4 are others work.', 'sabir', '7504', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792989109310-rbqc47hmf', 'request_forwarded', 'Request forwarded - Weekly report', 'Request Weekly report has been forwarded to you for approval.', 'gkbharath', '7504', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792989109310-bgbzv5dsq', 'request_status_changed', 'Request advanced - Weekly report', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'sabir', '7504', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792988778982-xeoegw2pr', 'request_forwarded', 'Request forwarded - Weekly report', 'Request Weekly report has been forwarded to you for approval.', 'santhanakumarv', '7504', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792988778982-81cuximwh', 'request_status_changed', 'Request advanced - Weekly report', 'Your request was approved by hareeshv and forwarded to the next approver.', 'sabir', '7504', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792988311301-c5a5ynpam', 'report-submitted', 'Weekly Report Submitted', 'sabir submitted "Weekly report" for Week 44, 2026.', 'hareeshv', '7504', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792988311301-jwmh70j7g', 'report-submitted', 'Weekly Report Received', 'Your report "Weekly report" was submitted for approval.', 'sabir', '7504', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792988135316-p4p1xpbmi', 'request_forwarded', 'Request forwarded - Allowance Claim Request', 'Request Allowance Claim Request has been forwarded to you for approval.', 'gkbharath', '4148', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792988135316-8r8g5010x', 'request_status_changed', 'Request advanced - Allowance Claim Request', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'hareeshv', '4148', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792988042354-y08jae9ip', 'request_submitted', 'Request submitted - Allowance Claim Request', 'HAREESH V submitted Allowance Claim Request; it is awaiting your review.', 'santhanakumarv', '4148', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792988042354-jhb30ybhb', 'request_submitted', 'Submission received - Allowance Claim Request', 'Your request Allowance Claim Request was submitted for approval.', 'hareeshv', '4148', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792987688830-3nmtkz8be', 'report-submitted', 'Weekly Report Submitted', 'mathi submitted "Weekly Work Report – Student Project Coordination and Engineering College Data Collection (19–24 October 2026)" for Week 43, 2026.', 'sabir', '4205', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792987688830-etlcygwwd', 'report-submitted', 'Weekly Report Received', 'Your report "Weekly Work Report – Student Project Coordination and Engineering College Data Collection (19–24 October 2026)" was submitted for approval.', 'mathi', '4205', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792986928985-o3xdhz0ox', 'request_submitted', 'Request submitted - Casual Leave Request', 'VISHNU VARSHINI M submitted Casual Leave Request; it is awaiting your review.', 'sabir', '6023', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792986928986-98gjluwzs', 'request_submitted', 'Submission received - Casual Leave Request', 'Your request Casual Leave Request was submitted for approval.', 'vishnuu', '6023', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792986356434-d6wdutoem', 'report-submitted', 'Weekly Report Submitted', 'vishnuu submitted "weekly report (Reporting Period: 08 October 2026, 10 October 2026)" for Week 41, 2026.', 'sabir', '4212', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792986356434-e0256y86d', 'report-submitted', 'Weekly Report Received', 'Your report "weekly report (Reporting Period: 08 October 2026, 10 October 2026)" was submitted for approval.', 'vishnuu', '4212', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792986200510-74ryt6cea', 'report-submitted', 'Weekly Report Submitted', 'vishnuu submitted "weekly report (Reporting Period: 14 October 2026 – 17 October 2026)" for Week 42, 2026.', 'sabir', '7789', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792986200510-iv6y6aosi', 'report-submitted', 'Weekly Report Received', 'Your report "weekly report (Reporting Period: 14 October 2026 – 17 October 2026)" was submitted for approval.', 'vishnuu', '7789', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792986030742-lx7qmtlfl', 'report-submitted', 'Weekly Report Submitted', 'vishnuu submitted "weekly report (Reporting Period: 19–24 October 2026)" for Week 44, 2026.', 'sabir', '4601', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792986030743-bve6rjp1l', 'report-submitted', 'Weekly Report Received', 'Your report "weekly report (Reporting Period: 19–24 October 2026)" was submitted for approval.', 'vishnuu', '4601', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792984661778-hk5oll0x9', 'internal-service-request', 'Internal request assigned to you', 'SANTHANA KUMAR V sent you a request: "Hi Smrithi, Welcome to your 1at day of Intern...."', 'smrithik', '3403', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792984459205-9ghcavb7m', 'internal-service-request', 'Internal request assigned to you', 'SANTHANA KUMAR V sent you a request: "Hi Bharath,..."', 'gkbharath', '1665', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792983114696-zls34a29q', 'internal-service-request', 'Internal request assigned to you', 'GOLLA KUMAR BHARATH sent you a request: "Hi Rithanya, Welcome Your 1st Day of Intern. ..."', 'rithanyad', '6064', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792983066188-ss6s6d3g0', 'internal-service-request', 'Internal request assigned to you', 'GOLLA KUMAR BHARATH sent you a request: "1. Rajkumar Schule (this week before oct 2026)
2. ..."', 'sabir', '6442', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792982043898-ibsdo03hi', 'internal-service-request', 'Internal request assigned to you', 'GOLLA KUMAR BHARATH sent you a request: "1. Share the source file of previous circuit
2. TE..."', 'vishnuu', '6505', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792669707134-xmfr9ijni', 'request_rejected', 'Request rejected - Casual Leave Request', 'Your request Casual Leave Request was rejected by gkbharath. Remarks: rejected due already taken a casual leave.', 'sabir', '8600', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792669656226-heorz9umz', 'request_forwarded', 'Request forwarded - Casual Leave Request', 'Request Casual Leave Request has been forwarded to you for approval.', 'gkbharath', '8600', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792669656226-5a32tb3s6', 'request_status_changed', 'Request advanced - Casual Leave Request', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'sabir', '8600', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792669578627-xuixytp2z', 'request_forwarded', 'Request forwarded - Casual Leave Request', 'Request Casual Leave Request has been forwarded to you for approval.', 'santhanakumarv', '8600', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792669578627-1rd4ssvhl', 'request_status_changed', 'Request advanced - Casual Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'sabir', '8600', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792669433095-vlp17xvo8', 'request_submitted', 'Request submitted - Casual Leave Request', 'SABIR MOHAMMED S submitted Casual Leave Request; it is awaiting your review.', 'hareeshv', '8600', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792669433095-ozm3esa5l', 'request_submitted', 'Submission received - Casual Leave Request', 'Your request Casual Leave Request was submitted for approval.', 'sabir', '8600', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792410894939-ahrnwwtl6', 'request_approved', 'Request approved - Allowance Claim Request', 'Your request Allowance Claim Request received final approval.', 'sabir', '3432', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792410868203-d2nfk8c6s', 'request_forwarded', 'Request forwarded - Allowance Claim Request', 'Request Allowance Claim Request has been forwarded to you for approval.', 'gkbharath', '3432', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792410868203-sv0lrfzb0', 'request_status_changed', 'Request advanced - Allowance Claim Request', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'sabir', '3432', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792410840094-vjg08227x', 'request_forwarded', 'Request forwarded - Allowance Claim Request', 'Request Allowance Claim Request has been forwarded to you for approval.', 'santhanakumarv', '3432', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792410840095-2gwpsgt3y', 'request_status_changed', 'Request advanced - Allowance Claim Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'sabir', '3432', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792410792633-lrlxg47ja', 'request_submitted', 'Request submitted - Allowance Claim Request', 'SABIR MOHAMMED S submitted Allowance Claim Request; it is awaiting your review.', 'hareeshv', '3432', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792410792633-i7pdlr8jn', 'request_submitted', 'Submission received - Allowance Claim Request', 'Your request Allowance Claim Request was submitted for approval.', 'sabir', '3432', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792407309963-yjjhwazh0', 'request_approved', 'Request approved - Project Proposal', 'Your request Project Proposal received final approval.', 'gkbharath', '9375', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792407271535-wdzd03pbw', 'request_forwarded', 'Request forwarded - Project Proposal', 'Request Project Proposal has been forwarded to you for approval.', 'gkbharath', '9375', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792407271535-2tmo70md5', 'request_status_changed', 'Request advanced - Project Proposal', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'gkbharath', '9375', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792407080440-y0xx79x6v', 'request_forwarded', 'Request forwarded - Project Proposal', 'Request Project Proposal has been forwarded to you for approval.', 'santhanakumarv', '9375', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792407080440-bw9l3sfll', 'request_status_changed', 'Request advanced - Project Proposal', 'Your request was approved by hareeshv and forwarded to the next approver.', 'gkbharath', '9375', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792407017523-7rsn92dim', 'request_submitted', 'Request submitted - Project Proposal', 'GOLLA KUMAR BHARATH submitted Project Proposal; it is awaiting your review.', 'hareeshv', '9375', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792407017523-z9bkl8h5t', 'request_submitted', 'Submission received - Project Proposal', 'Your request Project Proposal was submitted for approval.', 'gkbharath', '9375', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792405829538-w2o0p0acn', 'internal-service-request', 'Internal request assigned to you', 'SABIR MOHAMMED S sent you a request: "Update the Past Week Report...."', 'vishnuu', '4692', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792404010657-qbwuqe6jb', 'request_approved', 'Request approved - Past-Date Casual Leave Request', 'Your request Past-Date Casual Leave Request received final approval.', 'mathi', '5320', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792404008747-geov4b5ei', 'request_approved', 'Request approved - PCB Fabrication and Assembly Training Report – RSR Engineering College, Nellore', 'Your request PCB Fabrication and Assembly Training Report – RSR Engineering College, Nellore received final approval.', 'mathi', '8704', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792403980472-a1eqvqibt', 'request_forwarded', 'Request forwarded - Past-Date Casual Leave Request', 'Request Past-Date Casual Leave Request has been forwarded to you for approval.', 'gkbharath', '5320', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792403980472-drg5vfd2a', 'request_status_changed', 'Request advanced - Past-Date Casual Leave Request', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'mathi', '5320', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792403978884-o62a08ii2', 'request_forwarded', 'Request forwarded - PCB Fabrication and Assembly Training Report – RSR Engineering College, Nellore', 'Request PCB Fabrication and Assembly Training Report – RSR Engineering College, Nellore has been forwarded to you for approval.', 'gkbharath', '8704', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792403978884-jkaggyu3q', 'request_status_changed', 'Request advanced - PCB Fabrication and Assembly Training Report – RSR Engineering College, Nellore', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'mathi', '8704', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792403941767-s0kjvn4vp', 'request_forwarded', 'Request forwarded - Past-Date Casual Leave Request', 'Request Past-Date Casual Leave Request has been forwarded to you for approval.', 'santhanakumarv', '5320', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792403941767-w6io1bkmp', 'request_status_changed', 'Request advanced - Past-Date Casual Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'mathi', '5320', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792403939602-onfqoktrj', 'request_forwarded', 'Request forwarded - PCB Fabrication and Assembly Training Report – RSR Engineering College, Nellore', 'Request PCB Fabrication and Assembly Training Report – RSR Engineering College, Nellore has been forwarded to you for approval.', 'santhanakumarv', '8704', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792403939602-oj4z039u5', 'request_status_changed', 'Request advanced - PCB Fabrication and Assembly Training Report – RSR Engineering College, Nellore', 'Your request was approved by hareeshv and forwarded to the next approver.', 'mathi', '8704', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792403909812-7wpee9h7a', 'request_forwarded', 'Guide recommendation submitted - Past-Date Casual Leave Request', 'The guide has recommended this request for authorized approval.', 'hareeshv', '5320', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792403907601-ps6o824oz', 'request_forwarded', 'Guide recommendation submitted - PCB Fabrication and Assembly Training Report – RSR Engineering College, Nellore', 'The guide has recommended this request for authorized approval.', 'hareeshv', '8704', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792403871474-2ijo8u6cz', 'report-submitted', 'Weekly Report Submitted', 'mathi submitted "PCB Fabrication and Assembly Training Report – RSR Engineering College, Nellore" for Week 41, 2026.', 'sabir', '8704', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792403871474-vzis4q4sb', 'report-submitted', 'Weekly Report Received', 'Your report "PCB Fabrication and Assembly Training Report – RSR Engineering College, Nellore" was submitted for approval.', 'mathi', '8704', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792403786661-yqxg693lk', 'request_submitted', 'Request submitted - Past-Date Casual Leave Request', 'MATHIYAZHAGAN D submitted Past-Date Casual Leave Request; it is awaiting your review.', 'sabir', '5320', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792403786661-25y9ppw19', 'request_submitted', 'Submission received - Past-Date Casual Leave Request', 'Your request Past-Date Casual Leave Request was submitted for approval.', 'mathi', '5320', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792403471135-lb2zso9t8', 'request_approved', 'Request approved - Casual Leave Request', 'Your request Casual Leave Request received final approval.', 'gkbharath', '3507', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792403427161-gclw98ujv', 'request_forwarded', 'Request forwarded - Casual Leave Request', 'Request Casual Leave Request has been forwarded to you for approval.', 'santhanakumarv', '3507', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792403427161-m43gz5t8o', 'request_status_changed', 'Request advanced - Casual Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'gkbharath', '3507', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792403372683-r4cmqjm1z', 'request_submitted', 'Request submitted - Casual Leave Request', 'GOLLA KUMAR BHARATH submitted Casual Leave Request; it is awaiting your review.', 'hareeshv', '3507', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792403372683-2eeq36nou', 'request_submitted', 'Submission received - Casual Leave Request', 'Your request Casual Leave Request was submitted for approval.', 'gkbharath', '3507', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792402837072-ziq0m3h9x', 'request_approved', 'Request approved - Past-Date Casual Leave Request', 'Your request Past-Date Casual Leave Request received final approval.', 'sabir', '1329', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792402747144-rd2ll8jjp', 'request_forwarded', 'Request forwarded - Past-Date Casual Leave Request', 'Request Past-Date Casual Leave Request has been forwarded to you for approval.', 'gkbharath', '1329', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792402747144-p5jkvsdge', 'request_status_changed', 'Request advanced - Past-Date Casual Leave Request', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'sabir', '1329', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792402741393-kd9ewqgju', 'request_approved', 'Request approved - Past-Date Casual Leave Request', 'Your request Past-Date Casual Leave Request received final approval.', 'gkbharath', '7057', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792401716173-8ys5t8myg', 'request_status_changed', 'Request advanced - Past-Date Casual Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'gkbharath', '7057', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792401716162-rds8thpzj', 'request_forwarded', 'Request forwarded - Past-Date Casual Leave Request', 'Request Past-Date Casual Leave Request has been forwarded to you for approval.', 'santhanakumarv', '7057', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792401690232-2d1qqkgcr', 'request_status_changed', 'Request advanced - Past-Date Casual Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'sabir', '1329', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792401690219-cxc5slsbc', 'request_forwarded', 'Request forwarded - Past-Date Casual Leave Request', 'Request Past-Date Casual Leave Request has been forwarded to you for approval.', 'santhanakumarv', '1329', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792401562834-cp3rdza45', 'request_submitted', 'Submission received - Past-Date Casual Leave Request', 'Your request Past-Date Casual Leave Request was submitted for approval.', 'sabir', '1329', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792401562824-4gkr7pfbh', 'request_submitted', 'Request submitted - Past-Date Casual Leave Request', 'SABIR MOHAMMED S submitted Past-Date Casual Leave Request; it is awaiting your review.', 'hareeshv', '1329', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792401410570-0k0gvoqxc', 'request_submitted', 'Submission received - Past-Date Casual Leave Request', 'Your request Past-Date Casual Leave Request was submitted for approval.', 'gkbharath', '7057', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792401410560-4j82eb0em', 'request_submitted', 'Request submitted - Past-Date Casual Leave Request', 'GOLLA KUMAR BHARATH submitted Past-Date Casual Leave Request; it is awaiting your review.', 'hareeshv', '7057', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792399856634-mqkel8lju', 'request_approved', 'Request approved - PCB Fabrication and Assembly Training Report – RSR Engineering College, Nellore', 'Your request PCB Fabrication and Assembly Training Report – RSR Engineering College, Nellore received final approval.', 'sabir', '7185', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792399278926-x18f8wvil', 'request_status_changed', 'Request advanced - PCB Fabrication and Assembly Training Report – RSR Engineering College, Nellore', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'sabir', '7185', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792399278919-i4evq05h9', 'request_forwarded', 'Request forwarded - PCB Fabrication and Assembly Training Report – RSR Engineering College, Nellore', 'Request PCB Fabrication and Assembly Training Report – RSR Engineering College, Nellore has been forwarded to you for approval.', 'gkbharath', '7185', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792398765242-5d06d376h', 'request_status_changed', 'Request advanced - PCB Fabrication and Assembly Training Report – RSR Engineering College, Nellore', 'Your request was approved by hareeshv and forwarded to the next approver.', 'sabir', '7185', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792398765229-lpojgtb5p', 'request_forwarded', 'Request forwarded - PCB Fabrication and Assembly Training Report – RSR Engineering College, Nellore', 'Request PCB Fabrication and Assembly Training Report – RSR Engineering College, Nellore has been forwarded to you for approval.', 'santhanakumarv', '7185', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792398710530-0zr4zl79e', 'report-submitted', 'Weekly Report Received', 'Your report "PCB Fabrication and Assembly Training Report – RSR Engineering College, Nellore" was submitted for approval.', 'sabir', '7185', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792398710524-7rcfdjsw4', 'report-submitted', 'Weekly Report Submitted', 'sabir submitted "PCB Fabrication and Assembly Training Report – RSR Engineering College, Nellore" for Week 42, 2026.', 'hareeshv', '7185', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792397248100-lio5gqrrn', 'request_rejected', 'Request rejected - Weekly Report – Nellore PCB Design, Fabrication and Engineering College Data Collection', 'Your request Weekly Report – Nellore PCB Design, Fabrication and Engineering College Data Collection was rejected by santhanakumarv. Remarks: Already Approved. Duplicate Report.', 'mathi', '9109', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792389914785-gjb983nqs', 'request_approved', 'Request approved - weekly report', 'Your request weekly report received final approval.', 'vishnuu', '9122', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792388987390-yic3d0hwh', 'request_status_changed', 'Request advanced - Weekly Report – Nellore PCB Design, Fabrication and Engineering College Data Collection', 'Your request was approved by hareeshv and forwarded to the next approver.', 'mathi', '9109', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792388987385-sz2xbthl5', 'request_forwarded', 'Request forwarded - Weekly Report – Nellore PCB Design, Fabrication and Engineering College Data Collection', 'Request Weekly Report – Nellore PCB Design, Fabrication and Engineering College Data Collection has been forwarded to you for approval.', 'santhanakumarv', '9109', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792388945726-n1emrztp9', 'request_rejected', 'Request rejected - Past-Date Casual Leave Request', 'Your request Past-Date Casual Leave Request was rejected by hareeshv. Remarks: Approved.', 'mathi', '3407', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792388922564-z9reyq29q', 'request_rejected', 'Request rejected - Weekly Report – Nellore PCB Design, Fabrication and Engineering College Data Collection', 'Your request Weekly Report – Nellore PCB Design, Fabrication and Engineering College Data Collection was rejected by hareeshv. Remarks: ', 'mathi', '5750', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792388857369-kcd8mlq1i', 'request_forwarded', 'Guide recommendation submitted - Weekly Report – Nellore PCB Design, Fabrication and Engineering College Data Collection', 'The guide has recommended this request for authorized approval.', 'hareeshv', '5750', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792388814619-7lz9o5wsk', 'request_forwarded', 'Guide recommendation submitted - Weekly Report – Nellore PCB Design, Fabrication and Engineering College Data Collection', 'The guide has recommended this request for authorized approval.', 'hareeshv', '9109', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792388791010-ff8j66824', 'request_forwarded', 'Guide recommendation submitted - Past-Date Casual Leave Request', 'The guide has recommended this request for authorized approval.', 'hareeshv', '3407', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792388702663-kuy75nf4i', 'request_status_changed', 'Request advanced - weekly report', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'vishnuu', '9122', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792388702659-9g0vamo4p', 'request_forwarded', 'Request forwarded - weekly report', 'Request weekly report has been forwarded to you for approval.', 'gkbharath', '9122', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792388688985-3w8f6o8dq', 'request_rejected', 'Request rejected - weekly report', 'Your request weekly report was rejected by santhanakumarv. Remarks: ', 'vishnuu', '8987', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792388662973-icwvsjx9v', 'request_rejected', 'Request rejected - working days : 08.10.2026(Thursday) and 10.10.2026(Saturday)', 'Your request working days : 08.10.2026(Thursday) and 10.10.2026(Saturday) was rejected by santhanakumarv. Remarks: Rejected.', 'vishnuu', '7302', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792388303365-cmz7e32jd', 'request_approved', 'Request approved - Past-Date Medical Leave Request', 'Your request Past-Date Medical Leave Request received final approval.', 'vishnuu', '9237', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792387739742-iv5t5r536', 'request_rejected', 'Request rejected - Past-Date Medical Leave Request', 'Your request Past-Date Medical Leave Request was rejected by santhanakumarv. Remarks: ', 'vishnuu', '1651', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792387600264-scbnzlef8', 'request_rejected', 'Request rejected - Past-Date Medical Leave Request', 'Your request Past-Date Medical Leave Request was rejected by santhanakumarv. Remarks: ', 'vishnuu', '1596', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792387520347-m784kryv9', 'request_rejected', 'Request rejected - Past-Date Medical Leave Request', 'Your request Past-Date Medical Leave Request was rejected by santhanakumarv. Remarks: ', 'vishnuu', '2380', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792387472023-36iq47fsp', 'request_rejected', 'Request rejected - Past-Date Medical Leave Request', 'Your request Past-Date Medical Leave Request was rejected by santhanakumarv. Remarks: ', 'vishnuu', '4252', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792387430606-319p7b3ij', 'request_rejected', 'Request rejected - Past-Date Medical Leave Request', 'Your request Past-Date Medical Leave Request was rejected by santhanakumarv. Remarks: ', 'vishnuu', '8724', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792387413767-2gkxwbdhk', 'request_rejected', 'Request rejected - Past-Date Medical Leave Request', 'Your request Past-Date Medical Leave Request was rejected by santhanakumarv. Remarks: ', 'vishnuu', '7822', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792387389351-721a27sxp', 'request_rejected', 'Request rejected - Past-Date Medical Leave Request', 'Your request Past-Date Medical Leave Request was rejected by santhanakumarv. Remarks: ', 'vishnuu', '2025', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792387369289-4dyt49amj', 'request_rejected', 'Request rejected - Past-Date Medical Leave Request', 'Your request Past-Date Medical Leave Request was rejected by santhanakumarv. Remarks: ', 'vishnuu', '1568', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792387316765-j15jllwj9', 'request_status_changed', 'Request advanced - Past-Date Medical Leave Request', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'vishnuu', '9237', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792387316749-a1b5r8u0g', 'request_forwarded', 'Request forwarded - Past-Date Medical Leave Request', 'Request Past-Date Medical Leave Request has been forwarded to you for approval.', 'gkbharath', '9237', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792387137613-oevqwtk1g', 'request_status_changed', 'Request advanced - Past-Date Medical Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'vishnuu', '2380', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792387137603-6mnny69y7', 'request_forwarded', 'Request forwarded - Past-Date Medical Leave Request', 'Request Past-Date Medical Leave Request has been forwarded to you for approval.', 'santhanakumarv', '2380', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792387090327-4hpn4w3k7', 'request_status_changed', 'Request advanced - Past-Date Medical Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'vishnuu', '1651', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792387090314-12ibjtvp8', 'request_forwarded', 'Request forwarded - Past-Date Medical Leave Request', 'Request Past-Date Medical Leave Request has been forwarded to you for approval.', 'santhanakumarv', '1651', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792387077655-mxnv77wxh', 'request_status_changed', 'Request advanced - Past-Date Medical Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'vishnuu', '1568', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792387077647-vjkp8igqf', 'request_forwarded', 'Request forwarded - Past-Date Medical Leave Request', 'Request Past-Date Medical Leave Request has been forwarded to you for approval.', 'santhanakumarv', '1568', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792387037128-hvz8a4baq', 'request_status_changed', 'Request advanced - Past-Date Medical Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'vishnuu', '2025', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792387037117-99xlbx2r5', 'request_forwarded', 'Request forwarded - Past-Date Medical Leave Request', 'Request Past-Date Medical Leave Request has been forwarded to you for approval.', 'santhanakumarv', '2025', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386843308-c668ch74a', 'request_forwarded', 'Guide recommendation submitted - Past-Date Medical Leave Request', 'The guide has recommended this request for authorized approval.', 'hareeshv', '1651', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386801123-smtljp8sx', 'request_forwarded', 'Guide recommendation submitted - Past-Date Medical Leave Request', 'The guide has recommended this request for authorized approval.', 'hareeshv', '2380', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386787132-r3t3jcre7', 'request_forwarded', 'Guide recommendation submitted - Past-Date Medical Leave Request', 'The guide has recommended this request for authorized approval.', 'hareeshv', '1568', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386773222-8jv1puuxq', 'request_forwarded', 'Guide recommendation submitted - Past-Date Medical Leave Request', 'The guide has recommended this request for authorized approval.', 'hareeshv', '2025', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386746519-jui26ajcv', 'request_status_changed', 'Request advanced - Past-Date Medical Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'vishnuu', '8724', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386746513-36rrvc0qk', 'request_forwarded', 'Request forwarded - Past-Date Medical Leave Request', 'Request Past-Date Medical Leave Request has been forwarded to you for approval.', 'santhanakumarv', '8724', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386697421-0d0zrtk2m', 'request_forwarded', 'Guide recommendation submitted - Past-Date Medical Leave Request', 'The guide has recommended this request for authorized approval.', 'hareeshv', '8724', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386681229-r9wr3o2ny', 'request_status_changed', 'Request advanced - Past-Date Medical Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'vishnuu', '7822', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386681224-nhfmbbd75', 'request_forwarded', 'Request forwarded - Past-Date Medical Leave Request', 'Request Past-Date Medical Leave Request has been forwarded to you for approval.', 'santhanakumarv', '7822', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386665653-tz7xhl45n', 'request_forwarded', 'Guide recommendation submitted - Past-Date Medical Leave Request', 'The guide has recommended this request for authorized approval.', 'hareeshv', '7822', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386641082-ao5t6cm6d', 'request_status_changed', 'Request advanced - Past-Date Medical Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'vishnuu', '1596', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386641076-zkihqngf3', 'request_forwarded', 'Request forwarded - Past-Date Medical Leave Request', 'Request Past-Date Medical Leave Request has been forwarded to you for approval.', 'santhanakumarv', '1596', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386624323-evrenywuu', 'request_forwarded', 'Guide recommendation submitted - Past-Date Medical Leave Request', 'The guide has recommended this request for authorized approval.', 'hareeshv', '1596', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386607620-x4yz5x6s7', 'request_status_changed', 'Request advanced - Past-Date Medical Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'vishnuu', '4252', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386607616-ldjeiaeo3', 'request_forwarded', 'Request forwarded - Past-Date Medical Leave Request', 'Request Past-Date Medical Leave Request has been forwarded to you for approval.', 'santhanakumarv', '4252', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386584796-6712mnuxw', 'request_forwarded', 'Guide recommendation submitted - Past-Date Medical Leave Request', 'The guide has recommended this request for authorized approval.', 'hareeshv', '4252', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386569817-z3u3quhhr', 'request_status_changed', 'Request advanced - working days : 08.10.2026(Thursday) and 10.10.2026(Saturday)', 'Your request was approved by hareeshv and forwarded to the next approver.', 'vishnuu', '7302', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386569812-kypfg03yo', 'request_forwarded', 'Request forwarded - working days : 08.10.2026(Thursday) and 10.10.2026(Saturday)', 'Request working days : 08.10.2026(Thursday) and 10.10.2026(Saturday) has been forwarded to you for approval.', 'santhanakumarv', '7302', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386556099-xmtd874n1', 'request_forwarded', 'Guide recommendation submitted - working days : 08.10.2026(Thursday) and 10.10.2026(Saturday)', 'The guide has recommended this request for authorized approval.', 'hareeshv', '7302', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386542318-o5qrqjrc7', 'request_status_changed', 'Request advanced - weekly report', 'Your request was approved by hareeshv and forwarded to the next approver.', 'vishnuu', '8987', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386542313-ogoff2hnj', 'request_forwarded', 'Request forwarded - weekly report', 'Request weekly report has been forwarded to you for approval.', 'santhanakumarv', '8987', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386524617-g968guiwe', 'request_forwarded', 'Guide recommendation submitted - weekly report', 'The guide has recommended this request for authorized approval.', 'hareeshv', '8987', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386456081-uik40xgrw', 'request_status_changed', 'Request advanced - weekly report', 'Your request was approved by hareeshv and forwarded to the next approver.', 'vishnuu', '9122', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386456072-jhg0ce9kg', 'request_forwarded', 'Request forwarded - weekly report', 'Request weekly report has been forwarded to you for approval.', 'santhanakumarv', '9122', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386430210-b1tm7q85n', 'request_forwarded', 'Guide recommendation submitted - weekly report', 'The guide has recommended this request for authorized approval.', 'hareeshv', '9122', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386381663-kcl4wi0j9', 'request_status_changed', 'Request advanced - Past-Date Medical Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'vishnuu', '9237', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386381656-vq3yqn2zx', 'request_forwarded', 'Request forwarded - Past-Date Medical Leave Request', 'Request Past-Date Medical Leave Request has been forwarded to you for approval.', 'santhanakumarv', '9237', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792386300739-i8x6po1yq', 'request_forwarded', 'Guide recommendation submitted - Past-Date Medical Leave Request', 'The guide has recommended this request for authorized approval.', 'hareeshv', '9237', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792385591570-d5srnl5uj', 'request_submitted', 'Submission received - Past-Date Medical Leave Request', 'Your request Past-Date Medical Leave Request was submitted for approval.', 'vishnuu', '9237', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792385591564-ppyldpmu8', 'request_submitted', 'Request submitted - Past-Date Medical Leave Request', 'VISHNU VARSHINI M submitted Past-Date Medical Leave Request; it is awaiting your review.', 'hareeshv', '9237', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792385586255-ap6vtm1xi', 'request_submitted', 'Submission received - Past-Date Medical Leave Request', 'Your request Past-Date Medical Leave Request was submitted for approval.', 'vishnuu', '2025', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792385586247-e80dj64cw', 'request_submitted', 'Request submitted - Past-Date Medical Leave Request', 'VISHNU VARSHINI M submitted Past-Date Medical Leave Request; it is awaiting your review.', 'hareeshv', '2025', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792385581007-4muev9hnf', 'request_submitted', 'Submission received - Past-Date Medical Leave Request', 'Your request Past-Date Medical Leave Request was submitted for approval.', 'vishnuu', '1568', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792385580999-vzq4o3ldv', 'request_submitted', 'Request submitted - Past-Date Medical Leave Request', 'VISHNU VARSHINI M submitted Past-Date Medical Leave Request; it is awaiting your review.', 'hareeshv', '1568', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792385576405-0sxijofk5', 'request_submitted', 'Submission received - Past-Date Medical Leave Request', 'Your request Past-Date Medical Leave Request was submitted for approval.', 'vishnuu', '2380', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792385576400-x4crtz2h0', 'request_submitted', 'Request submitted - Past-Date Medical Leave Request', 'VISHNU VARSHINI M submitted Past-Date Medical Leave Request; it is awaiting your review.', 'hareeshv', '2380', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792385572107-wlxgcdl1z', 'request_submitted', 'Submission received - Past-Date Medical Leave Request', 'Your request Past-Date Medical Leave Request was submitted for approval.', 'vishnuu', '1651', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792385572100-cmcib82wh', 'request_submitted', 'Request submitted - Past-Date Medical Leave Request', 'VISHNU VARSHINI M submitted Past-Date Medical Leave Request; it is awaiting your review.', 'hareeshv', '1651', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792385557401-vp7056bez', 'request_submitted', 'Submission received - Past-Date Medical Leave Request', 'Your request Past-Date Medical Leave Request was submitted for approval.', 'vishnuu', '8724', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792385557395-8bhhf2zjf', 'request_submitted', 'Request submitted - Past-Date Medical Leave Request', 'VISHNU VARSHINI M submitted Past-Date Medical Leave Request; it is awaiting your review.', 'hareeshv', '8724', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792385551579-i74z7znkq', 'request_submitted', 'Submission received - Past-Date Medical Leave Request', 'Your request Past-Date Medical Leave Request was submitted for approval.', 'vishnuu', '7822', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792385551574-u5a038i6f', 'request_submitted', 'Request submitted - Past-Date Medical Leave Request', 'VISHNU VARSHINI M submitted Past-Date Medical Leave Request; it is awaiting your review.', 'hareeshv', '7822', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792385517971-zfqdiwd62', 'request_submitted', 'Submission received - Past-Date Medical Leave Request', 'Your request Past-Date Medical Leave Request was submitted for approval.', 'vishnuu', '1596', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792385517966-8ak4a7b8o', 'request_submitted', 'Request submitted - Past-Date Medical Leave Request', 'VISHNU VARSHINI M submitted Past-Date Medical Leave Request; it is awaiting your review.', 'hareeshv', '1596', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792385514803-dmfiyd1w2', 'request_submitted', 'Submission received - Past-Date Medical Leave Request', 'Your request Past-Date Medical Leave Request was submitted for approval.', 'vishnuu', '4252', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792385514796-hgqfqlwcl', 'request_submitted', 'Request submitted - Past-Date Medical Leave Request', 'VISHNU VARSHINI M submitted Past-Date Medical Leave Request; it is awaiting your review.', 'hareeshv', '4252', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792384626213-bc4p0vfdf', 'report-submitted', 'Weekly Report Received', 'Your report "working days : 08.10.2026(Thursday) and 10.10.2026(Saturday)" was submitted for approval.', 'vishnuu', '7302', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792384626209-32q7y14dp', 'report-submitted', 'Weekly Report Submitted', 'vishnuu submitted: "working days : 08.10.2026(Thursday) and 10.10.2026(Saturday)"', 'hareeshv', '7302', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792384307945-f5w5fz7ey', 'report-submitted', 'Weekly Report Received', 'Your report "Weekly Report – Nellore PCB Design, Fabrication and Engineering College Data Collection" was submitted for approval.', 'mathi', '5750', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792384307939-l9udryerz', 'report-submitted', 'Weekly Report Submitted', 'mathi submitted: "Weekly Report – Nellore PCB Design, Fabrication and Engineering College Data Collection"', 'sabir', '5750', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792384299321-lmurlxi8e', 'report-submitted', 'Weekly Report Received', 'Your report "Weekly Report – Nellore PCB Design, Fabrication and Engineering College Data Collection" was submitted for approval.', 'mathi', '9109', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792384299316-nu00sz60e', 'report-submitted', 'Weekly Report Submitted', 'mathi submitted: "Weekly Report – Nellore PCB Design, Fabrication and Engineering College Data Collection"', 'sabir', '9109', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792384171594-dmrlj078i', 'report-submitted', 'Weekly Report Received', 'Your report "weekly report" was submitted for approval.', 'vishnuu', '8987', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792384171588-n7fmi5qp8', 'report-submitted', 'Weekly Report Submitted', 'vishnuu submitted: "weekly report"', 'hareeshv', '8987', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792384113000-28g5ws5wz', 'request_approved', 'Request approved - Past-Date Medical Leave Request', 'Your request Past-Date Medical Leave Request received final approval.', 'vishnuu', '2810', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792384072513-pe9xqza44', 'report-submitted', 'Weekly Report Received', 'Your report "weekly report" was submitted for approval.', 'vishnuu', '9122', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792384072504-bzubdeylq', 'report-submitted', 'Weekly Report Submitted', 'vishnuu submitted: "weekly report"', 'hareeshv', '9122', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792383992135-q5uyklt24', 'request_status_changed', 'Request advanced - Past-Date Medical Leave Request', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'vishnuu', '2810', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792383992125-am4846pmj', 'request_forwarded', 'Request forwarded - Past-Date Medical Leave Request', 'Request Past-Date Medical Leave Request has been forwarded to you for approval.', 'gkbharath', '2810', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792383801877-ybqx75u7t', 'request_rejected', 'Request rejected - Past-Date Medical Leave Request', 'Your request Past-Date Medical Leave Request was rejected by hareeshv. Remarks: 2 Times Applied Same Date.', 'vishnuu', '3796', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792383792027-f2x2ct433', 'request_forwarded', 'Guide recommendation submitted - Past-Date Medical Leave Request', 'The guide has recommended this request for authorized approval.', 'hareeshv', '3796', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792383764485-c64hs7n1j', 'request_status_changed', 'Request advanced - Past-Date Medical Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'vishnuu', '2810', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792383764479-1k36g4add', 'request_forwarded', 'Request forwarded - Past-Date Medical Leave Request', 'Request Past-Date Medical Leave Request has been forwarded to you for approval.', 'santhanakumarv', '2810', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792383757570-w6pd9t84h', 'request_forwarded', 'Guide recommendation submitted - Past-Date Medical Leave Request', 'The guide has recommended this request for authorized approval.', 'hareeshv', '2810', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792383129442-h8txleh6j', 'request_approved', 'Request approved - Past-Date Casual Leave Request', 'Your request Past-Date Casual Leave Request received final approval.', 'gkbharath', '1312', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792383115273-nc7uyxjrd', 'request_approved', 'Request approved - Allowance Claim Request', 'Your request Allowance Claim Request received final approval.', 'gkbharath', '6312', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792381973957-fbeivb5bk', 'request_submitted', 'Submission received - Past-Date Medical Leave Request', 'Your request Past-Date Medical Leave Request was submitted for approval.', 'vishnuu', '2810', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792381973954-9hus23d5z', 'request_submitted', 'Request submitted - Past-Date Medical Leave Request', 'VISHNU VARSHINI M submitted Past-Date Medical Leave Request; it is awaiting your review.', 'hareeshv', '2810', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792381969493-y0vw7jmhc', 'request_submitted', 'Submission received - Past-Date Medical Leave Request', 'Your request Past-Date Medical Leave Request was submitted for approval.', 'vishnuu', '3796', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792381969488-pocc3cqc4', 'request_submitted', 'Request submitted - Past-Date Medical Leave Request', 'VISHNU VARSHINI M submitted Past-Date Medical Leave Request; it is awaiting your review.', 'hareeshv', '3796', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792381954159-zjnbfhjnk', 'request_submitted', 'Submission received - Past-Date Casual Leave Request', 'Your request Past-Date Casual Leave Request was submitted for approval.', 'mathi', '3407', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792381954157-3fx9xzv66', 'request_submitted', 'Request submitted - Past-Date Casual Leave Request', 'MATHIYAZHAGAN D submitted Past-Date Casual Leave Request; it is awaiting your review.', 'sabir', '3407', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792381953662-c3mmyjuwt', 'internal-service-reply', 'Reply on Internal Request', 'gkbharath: "Update As Possible Soon...."', 'vishnuu', '3579', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792381762765-seuvnjvin', 'request_approved', 'Request approved - Past-Date Casual Leave Request', 'Your request Past-Date Casual Leave Request received final approval.', 'santhanakumarv', '1454', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792381727277-9guh4q480', 'request_status_changed', 'Request advanced - Past-Date Casual Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'gkbharath', '1312', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792381727274-8an0t4ifr', 'request_forwarded', 'Request forwarded - Past-Date Casual Leave Request', 'Request Past-Date Casual Leave Request has been forwarded to you for approval.', 'santhanakumarv', '1312', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792381695647-qu71yqc9t', 'request_status_changed', 'Request advanced - Allowance Claim Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'gkbharath', '6312', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792381695645-4w8qeqa14', 'request_forwarded', 'Request forwarded - Allowance Claim Request', 'Request Allowance Claim Request has been forwarded to you for approval.', 'santhanakumarv', '6312', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792381689255-9bgbkppp2', 'request_approved', 'Request approved - Project Proposal', 'Your request Project Proposal received final approval.', 'santhanakumarv', '4008', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792381678112-y6wzikbm9', 'request_status_changed', 'Request advanced - Past-Date Casual Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'santhanakumarv', '1454', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792381678109-kornmyzr5', 'request_forwarded', 'Request forwarded - Past-Date Casual Leave Request', 'Request Past-Date Casual Leave Request has been forwarded to you for approval.', 'gkbharath', '1454', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792381656897-rb8buphl9', 'request_status_changed', 'Request advanced - Project Proposal', 'Your request was approved by hareeshv and forwarded to the next approver.', 'santhanakumarv', '4008', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792381656893-hgkjc7c7a', 'request_forwarded', 'Request forwarded - Project Proposal', 'Request Project Proposal has been forwarded to you for approval.', 'gkbharath', '4008', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792377093243-n78z5s0uo', 'request_submitted', 'Submission received - Project Proposal', 'Your request Project Proposal was submitted for approval.', 'santhanakumarv', '4008', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792377093235-whbimc4dm', 'request_submitted', 'Request submitted - Project Proposal', 'SANTHANA KUMAR V submitted Project Proposal; it is awaiting your review.', 'hareeshv', '4008', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792376020336-2wip4zfa9', 'request_submitted', 'Submission received - Past-Date Casual Leave Request', 'Your request Past-Date Casual Leave Request was submitted for approval.', 'santhanakumarv', '1454', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792376020329-fv6mqwn7c', 'request_submitted', 'Request submitted - Past-Date Casual Leave Request', 'SANTHANA KUMAR V submitted Past-Date Casual Leave Request; it is awaiting your review.', 'hareeshv', '1454', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792375938064-p7keqapha', 'internal-service-request', 'Internal request assigned to you', 'SANTHANA KUMAR V sent you a request: "What is the Present Status of R&D Interns?..."', 'hareeshv', '1489', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792375798634-wksgbngh2', 'circular', 'New Circular Posted', 'All the Employee Check in correct time.  (Notice)', 'all', NULL, TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792375760464-5c4uohfyr', 'request_submitted', 'Submission received - Allowance Claim Request', 'Your request Allowance Claim Request was submitted for approval.', 'gkbharath', '6312', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792375760459-8xcc3fcbv', 'request_submitted', 'Request submitted - Allowance Claim Request', 'GOLLA KUMAR BHARATH submitted Allowance Claim Request; it is awaiting your review.', 'hareeshv', '6312', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792375643841-l3pld6ep8', 'internal-service-request', 'Internal request assigned to you', 'GOLLA KUMAR BHARATH sent you a request: "Present Status of PCB Circuit 4 Layer? DRC/ERC 83 ..."', 'vishnuu', '3579', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792342389005-vwrnaadad', 'request_submitted', 'Submission received - Past-Date Casual Leave Request', 'Your request Past-Date Casual Leave Request was submitted for approval.', 'gkbharath', '1312', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792342389002-pocv9u79s', 'request_submitted', 'Request submitted - Past-Date Casual Leave Request', 'GOLLA KUMAR BHARATH submitted Past-Date Casual Leave Request; it is awaiting your review.', 'hareeshv', '1312', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792342277316-1xxaz0pgr', 'data_retention_completed', '90-day data archive and reset completed', 'Operational data was archived to operational-data-2026-10-18T16-51-15-083Z.xlsx and reset after final approval.', 'all', 'c5a55f99-f587-4cad-b622-3b5907b19f7c', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792342237469-b9y3n0lfx', 'data_retention_approval', '90-day data archive approval required', 'Review the operational data archive and approve or reject the scheduled reset in Request Approvals.', 'gkbharath', 'c5a55f99-f587-4cad-b622-3b5907b19f7c', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792342180611-w95wv9s6f', 'data_retention_approval', '90-day data archive approval required', 'Review the operational data archive and approve or reject the scheduled reset in Request Approvals.', 'santhanakumarv', 'c5a55f99-f587-4cad-b622-3b5907b19f7c', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792341852761-v1hzad89l', 'data_retention_approval', '90-day data archive approval required', 'Review the operational data archive and approve or reject the scheduled reset in Request Approvals.', 'hareeshv', 'c5a55f99-f587-4cad-b622-3b5907b19f7c', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;


-- ==================== GUEST INQUIRIES ====================
INSERT INTO public.guest_inquiries (
  id, name, email, phone, purpose, message, status, created_at, meta
) VALUES (
  'inquiry-1770793715313', 'Manigandan C', 'manigandanc@gmail.com', '', 'HI', 'HI', 'new', '2026-02-11T07:08:35.313Z'::timestamptz, '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status;


-- ==================== VERIFICATION ====================
SELECT 'users' as table_name, count(*) as record_count FROM public.users
UNION ALL SELECT 'attendance', count(*) FROM public.attendance
UNION ALL SELECT 'requests', count(*) FROM public.requests
UNION ALL SELECT 'tasks', count(*) FROM public.tasks
UNION ALL SELECT 'notifications', count(*) FROM public.notifications
UNION ALL SELECT 'circulars', count(*) FROM public.circulars
UNION ALL SELECT 'company_ledger', count(*) FROM public.company_ledger
UNION ALL SELECT 'guest_inquiries', count(*) FROM public.guest_inquiries;
