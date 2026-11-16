-- ====================================================================
-- SURYAS MiB ENTERPRISES - SUPABASE DATABASE INITIALIZATION SCRIPT
-- Open Supabase Dashboard -> SQL Editor -> New Query -> Paste & Click Run
-- ====================================================================

-- 1. Create USERS table
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

-- 2. Create REQUESTS table
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

-- 3. Create ATTENDANCE table
CREATE TABLE IF NOT EXISTS public.attendance (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  username TEXT NOT NULL,
  full_name TEXT NOT NULL,
  date TEXT NOT NULL,
  check_in TIMESTAMPTZ NOT NULL,
  check_out TIMESTAMPTZ
);

-- 4. Create NOTIFICATIONS table
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

-- 5. Indexes for fast search
CREATE INDEX IF NOT EXISTS idx_users_username ON public.users(username);
CREATE INDEX IF NOT EXISTS idx_users_email ON public.users(email);
CREATE INDEX IF NOT EXISTS idx_requests_created_by ON public.requests(created_by_id);
CREATE INDEX IF NOT EXISTS idx_attendance_user_date ON public.attendance(user_id, date);

-- 6. Seed Initial Users
INSERT INTO public.users (
  id, employee_id, username, email, password_hash, role, employment_type,
  full_name, phone, designation, department, status, must_change_password,
  session_version, email_verified, is_profile_completed, created_at, approved_at
) VALUES (
  'founder-001', 'MIB01', 'gkbharath', 'gollakumarbharath@suryas.in',
  '$2b$10$Ba/u/FCErcSKaqGZ2KR0y.G1OijRFl5nugGPkz/HT4OHr97X6rOy6', 'founder', 'full-time',
  'GOLLA KUMAR BHARATH', '8124227370', 'Founder & Chief Executive Partner', 'Executive Management Team',
  'active', FALSE, 0,
  TRUE, TRUE,
  '2026-10-17 09:31:53.102Z', '2026-10-17 09:31:53.102Z'
) ON CONFLICT (username) DO UPDATE SET
  status = EXCLUDED.status,
  role = EXCLUDED.role,
  employee_id = EXCLUDED.employee_id,
  full_name = EXCLUDED.full_name;

INSERT INTO public.users (
  id, employee_id, username, email, password_hash, role, employment_type,
  full_name, phone, designation, department, status, must_change_password,
  session_version, email_verified, is_profile_completed, created_at, approved_at
) VALUES (
  'admin-007', 'MIB10', 'nagarajkaids0410', 'nagarajkaids0410@gmail.com',
  '$2b$10$Ba/u/FCErcSKaqGZ2KR0y.G1OijRFl5nugGPkz/HT4OHr97X6rOy6', 'admin', 'full-time',
  'Nagaraj K', '', 'Administrator', 'Management',
  'active', FALSE, 0,
  TRUE, TRUE,
  '2026-11-13 13:40:00.000Z', '2026-11-13 13:40:00.000Z'
) ON CONFLICT (username) DO UPDATE SET
  status = EXCLUDED.status,
  role = EXCLUDED.role,
  employee_id = EXCLUDED.employee_id,
  full_name = EXCLUDED.full_name;

INSERT INTO public.users (
  id, employee_id, username, email, password_hash, role, employment_type,
  full_name, phone, designation, department, status, must_change_password,
  session_version, email_verified, is_profile_completed, created_at, approved_at
) VALUES (
  'admin-002', 'MIB02', 'hareeshv', 'hareeshv@suryas.in',
  '$2b$10$Ba/u/FCErcSKaqGZ2KR0y.G1OijRFl5nugGPkz/HT4OHr97X6rOy6', 'managing-partner', 'full-time',
  'HAREESH V', '6383014533', 'Managing Partner - Projects & Administration', 'Executive Management Team',
  'active', FALSE, 1,
  TRUE, TRUE,
  '2026-10-17 09:31:53.102Z', '2026-10-17 09:31:53.102Z'
) ON CONFLICT (username) DO UPDATE SET
  status = EXCLUDED.status,
  role = EXCLUDED.role,
  employee_id = EXCLUDED.employee_id,
  full_name = EXCLUDED.full_name;

INSERT INTO public.users (
  id, employee_id, username, email, password_hash, role, employment_type,
  full_name, phone, designation, department, status, must_change_password,
  session_version, email_verified, is_profile_completed, created_at, approved_at
) VALUES (
  'admin-003', 'MIB03', 'santhanakumarv', 'santhanakumarv@suryas.in',
  '$2b$10$Ba/u/FCErcSKaqGZ2KR0y.G1OijRFl5nugGPkz/HT4OHr97X6rOy6', 'managing-partner', 'full-time',
  'SANTHANA KUMAR V', '7010353723', 'Managing Partner - Operations & Business Development', 'Executive Management Team',
  'active', FALSE, 0,
  TRUE, TRUE,
  '2026-10-17 09:31:53.102Z', '2026-10-17 09:31:53.102Z'
) ON CONFLICT (username) DO UPDATE SET
  status = EXCLUDED.status,
  role = EXCLUDED.role,
  employee_id = EXCLUDED.employee_id,
  full_name = EXCLUDED.full_name;

INSERT INTO public.users (
  id, employee_id, username, email, password_hash, role, employment_type,
  full_name, phone, designation, department, status, must_change_password,
  session_version, email_verified, is_profile_completed, created_at, approved_at
) VALUES (
  'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'MIB04', 'sabir', 'sabirmohammeds@suryas.in',
  '$2b$12$5rSLrHKbwwhsWFyQfuJku.JMXUIKNwtk7iAu5Ge.edTLiMYeZDH3S', 'employee', 'full-time',
  'SABIR MOHAMMED S', '8754479660', 'PCB Fabrication Engineer', 'PCB Designs & Fabrication Team',
  'active', FALSE, 36,
  TRUE, TRUE,
  '2026-10-17 12:58:52.238Z', '2026-10-17 13:02:13.911Z'
) ON CONFLICT (username) DO UPDATE SET
  status = EXCLUDED.status,
  role = EXCLUDED.role,
  employee_id = EXCLUDED.employee_id,
  full_name = EXCLUDED.full_name;

INSERT INTO public.users (
  id, employee_id, username, email, password_hash, role, employment_type,
  full_name, phone, designation, department, status, must_change_password,
  session_version, email_verified, is_profile_completed, created_at, approved_at
) VALUES (
  'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'MIB05', 'vishnuu', 'pcb.designers@suryas.in',
  '$2b$12$OOlRAOPfYz2S/rK6ti/CMe8.vEgndxBWy0ijDISF8Gz2mE1xnJ76S', 'employee', 'full-time',
  'VISHNU VARSHINI M', '6380551370', 'PCB & EMS/IoT Designer-T', 'PCB Designs & Fabrication Team',
  'active', FALSE, 9,
  TRUE, TRUE,
  '2026-10-17 16:48:15.424Z', '2026-10-17 16:50:21.073Z'
) ON CONFLICT (username) DO UPDATE SET
  status = EXCLUDED.status,
  role = EXCLUDED.role,
  employee_id = EXCLUDED.employee_id,
  full_name = EXCLUDED.full_name;

INSERT INTO public.users (
  id, employee_id, username, email, password_hash, role, employment_type,
  full_name, phone, designation, department, status, must_change_password,
  session_version, email_verified, is_profile_completed, created_at, approved_at
) VALUES (
  'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', 'MIB06', 'mathi', 'mathiyazhagandhanapalmathiyazh@gmail.com',
  '$2b$10$SEhLmBDf7eUL.75GGMkBq.wljmE6L2Zw6piUB3Nrp36QKxFzEJtui', 'intern', 'full-time',
  'MATHIYAZHAGAN D', '8056197704', 'PCB Design Intern', 'PCB Designs & Fabrication Team',
  'active', FALSE, 7,
  TRUE, TRUE,
  '2026-10-18 04:04:57.266Z', '2026-10-18 04:07:32.294Z'
) ON CONFLICT (username) DO UPDATE SET
  status = EXCLUDED.status,
  role = EXCLUDED.role,
  employee_id = EXCLUDED.employee_id,
  full_name = EXCLUDED.full_name;

INSERT INTO public.users (
  id, employee_id, username, email, password_hash, role, employment_type,
  full_name, phone, designation, department, status, must_change_password,
  session_version, email_verified, is_profile_completed, created_at, approved_at
) VALUES (
  'SMIB-EMP-8cc825a5-7d82-43b1-accf-684074846929', 'MIB07', 'nidhi', 'admin@hearthaxor.in',
  '$2b$12$BjUBn5Csm8X01AUfHjhOquBEhqYPvM1UWeKrBhTVCVfFk/g7D4bjO', 'user', 'part-time',
  'NIDHI TIWARI', '8148636158', 'AI Engineer - C', 'Software Team',
  'active', FALSE, 0,
  TRUE, TRUE,
  '2026-10-19 10:01:58.271Z', '2026-10-19 10:01:58.271Z'
) ON CONFLICT (username) DO UPDATE SET
  status = EXCLUDED.status,
  role = EXCLUDED.role,
  employee_id = EXCLUDED.employee_id,
  full_name = EXCLUDED.full_name;

INSERT INTO public.users (
  id, employee_id, username, email, password_hash, role, employment_type,
  full_name, phone, designation, department, status, must_change_password,
  session_version, email_verified, is_profile_completed, created_at, approved_at
) VALUES (
  'SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13', 'MIB08', 'smrithik', 'smrithik2005@gmail.com',
  '$2b$12$89QW8XMKF4.VE24ohksrV.ErcyUTltZqNduOpa0S4jgowyQc8i27q', 'intern', 'full-time',
  'SMRITHI K', '8610492864', 'PCB Design Intern', 'PCB Designs & Fabrication Team',
  'active', FALSE, 0,
  TRUE, TRUE,
  '2026-10-19 10:14:47.293Z', '2026-10-19 10:14:47.293Z'
) ON CONFLICT (username) DO UPDATE SET
  status = EXCLUDED.status,
  role = EXCLUDED.role,
  employee_id = EXCLUDED.employee_id,
  full_name = EXCLUDED.full_name;

INSERT INTO public.users (
  id, employee_id, username, email, password_hash, role, employment_type,
  full_name, phone, designation, department, status, must_change_password,
  session_version, email_verified, is_profile_completed, created_at, approved_at
) VALUES (
  'SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb', 'MIB09', 'rithanyad', 'rithanya07cbe@gmail.com',
  '$2b$12$6kZ5J6s60NFa4AYSqj8SDea0qq3GqETMJjxMKYYDd9Rtp7igG8l5O', 'intern', 'full-time',
  'RITHANYA D', '9384304331', 'PCB Design Intern', 'PCB Designs & Fabrication Team',
  'active', FALSE, 0,
  TRUE, TRUE,
  '2026-10-19 10:17:39.102Z', '2026-10-19 10:17:39.102Z'
) ON CONFLICT (username) DO UPDATE SET
  status = EXCLUDED.status,
  role = EXCLUDED.role,
  employee_id = EXCLUDED.employee_id,
  full_name = EXCLUDED.full_name;

INSERT INTO public.users (
  id, employee_id, username, email, password_hash, role, employment_type,
  full_name, phone, designation, department, status, must_change_password,
  session_version, email_verified, is_profile_completed, created_at, approved_at
) VALUES (
  'SMIB-EMP-ba45b474-f583-4802-af93-26555c8c6b72', 'MIB04', 'kumar', 'nagarajmsdraj@gmail.com',
  '$2b$10$Ba/u/FCErcSKaqGZ2KR0y.G1OijRFl5nugGPkz/HT4OHr97X6rOy6', 'intern', 'full-time',
  'Kumar', '', 'Intern', '',
  'active', FALSE, 2,
  TRUE, TRUE,
  '2026-11-16 08:58:19.187Z', '2026-11-16 09:15:11.928Z'
) ON CONFLICT (username) DO UPDATE SET
  status = EXCLUDED.status,
  role = EXCLUDED.role,
  employee_id = EXCLUDED.employee_id,
  full_name = EXCLUDED.full_name;

INSERT INTO public.users (
  id, employee_id, username, email, password_hash, role, employment_type,
  full_name, phone, designation, department, status, must_change_password,
  session_version, email_verified, is_profile_completed, created_at, approved_at
) VALUES (
  'SMIB-EMP-4dbc0097-2c05-42d3-b7c9-8a8530045d8a', 'MIB05', 'kumar04', 'nagarajnk0413@gmail.com',
  '$2b$10$qC0KNDf/191mu16A.5wPGuD1DFp5AxsI1ryfUdnlRSGwOH7YZQapO', 'intern', 'part-time',
  'Kumar', '', 'Not Set', '',
  'active', FALSE, 2,
  TRUE, TRUE,
  '2026-11-16 09:14:44.469Z', '2026-11-16 09:15:17.181Z'
) ON CONFLICT (username) DO UPDATE SET
  status = EXCLUDED.status,
  role = EXCLUDED.role,
  employee_id = EXCLUDED.employee_id,
  full_name = EXCLUDED.full_name;
