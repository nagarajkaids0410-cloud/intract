-- ====================================================================
-- SURYAS MiB ENTERPRISES - COMPLETE DATA MIGRATION FROM JSON TO SUPABASE
-- Generated automatically. Run in Supabase SQL Editor.
-- ====================================================================

-- ==================== USERS (FULL UPSERT - 12 users) ====================
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


-- ==================== REQUESTS (10 records) ====================
ALTER TABLE public.requests ADD COLUMN IF NOT EXISTS target TEXT DEFAULT 'admin';
ALTER TABLE public.requests ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '6823', '5792', 'leave', 'Past-Date Medical Leave Request', 'forwarded', 'admin',
  'VISHNU VARSHINI M', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', 'vishnuu',
  '2026-10-18T07:11:55.369Z'::timestamptz, '2026-10-18T07:13:55.505Z'::timestamptz, '{"createdByRole": "intern", "createdByDesignation": "PCB & EMS/IoT Designer-T", "createdByEmployeeId": "MIB05", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "6380551370", "payload": {"name": "VISHNU VARSHINI M", "id": "MIB05", "designation": "PCB & EMS/IoT Designer-T", "department": "PCB Designs & Fabrication Team", "email": "pcb.designers@suryas.in", "phone": "6380551370", "leaveType": "medical", "fromDate": "2026-10-12", "toDate": "2026-10-13", "reason": "Medical leave", "remarks": "As I am diagnosed with dengue, doctors have advised 3 days bed test and blood test on daily basis to monitor platelets count and I have been prescribed with heavy doses of tablets for recovery. On account of this I am applying medical leave on 12.10.2026 and 13.10.2026(Monday & Tuesday).", "isPastDateRequest": true, "filledFormFileName": "IMG_20261011_203454.jpg", "medicalDocument": {"name": "IMG_20261011_203401.jpg", "size": 5625470, "type": "image/jpeg", "base64": "[FILE_STRIPPED]", "uploadedAt": "2026-10-18T07:11:30.811Z"}, "submittedAt": "2026-10-18T07:11:30.811Z", "guideId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69", "guideUsername": "sabir", "approvalChain": ["sabir", "hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "sabir", "comment": "Recommend", "decision": "recommend", "stageIndex": 0, "at": "2026-10-18T07:13:55.437Z"}]}, "remarks": "As I am diagnosed with dengue, doctors have advised 3 days bed test and blood test on daily basis to monitor platelets count and I have been prescribed with heavy doses of tablets for recovery. On account of this I am applying medical leave on 12.10.2026 and 13.10.2026(Monday & Tuesday).", "uploadedFile": {"name": "IMG_20261011_203454.jpg", "size": 3755546, "type": "image/jpeg", "base64": "[FILE_STRIPPED]", "uploadedAt": "2026-10-18T07:11:30.789Z"}, "signatureFrom": "Admin", "forwardedTo": "hareeshv"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '9475', '1105', 'attendance-report', 'Attendance report: 2026-10-17 to 2026-10-17', 'pending', 'admin',
  'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'sabir',
  '2026-10-18T07:09:50.851Z'::timestamptz, NULL::timestamptz, '{"createdByRole": "employee", "createdByDesignation": "PCB Fabrication Engineer", "createdByEmployeeId": "MIB04", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "123456789", "payload": {"fromDate": "2026-10-17", "toDate": "2026-10-17", "remarks": "Mathialgan Follow up done.", "daysRecorded": 0, "attendance": [], "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 0}, "remarks": "Mathialgan Follow up done."}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '4906', '6652', 'leave', 'Past-Date Casual Leave Request', 'pending', 'admin',
  'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'sabir',
  '2026-10-18T07:07:39.082Z'::timestamptz, NULL::timestamptz, '{"createdByRole": "employee", "createdByDesignation": "PCB Fabrication Engineer", "createdByEmployeeId": "MIB04", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "123456789", "payload": {"name": "SABIR MOHAMMED S", "id": "MIB04", "designation": "PCB Fabrication Engineer", "department": "PCB Designs & Fabrication Team", "email": "sabirmohammeds@suryas.in", "phone": "", "leaveType": "casual", "fromDate": "2026-10-12", "toDate": "2026-10-12", "reason": "Casual Leave", "remarks": "Request to Approve.", "isPastDateRequest": true, "filledFormFileName": "", "submittedAt": "2026-10-18T07:07:38.965Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 0}, "remarks": "Request to Approve.", "signatureFrom": "Admin"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '8222', '7700', 'ta', 'Allowance Claim Request', 'pending', 'admin',
  'SABIR MOHAMMED S', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', 'sabir',
  '2026-10-18T07:06:51.106Z'::timestamptz, NULL::timestamptz, '{"createdByRole": "employee", "createdByDesignation": "PCB Fabrication Engineer", "createdByEmployeeId": "MIB04", "createdByDepartment": "PCB Designs & Fabrication Team", "createdByPhone": "123456789", "payload": {"name": "SABIR MOHAMMED S", "id": "MIB04", "designation": "PCB Fabrication Engineer", "department": "PCB Designs & Fabrication Team", "email": "sabirmohammeds@suryas.in", "claimType": "bill", "amount": "300", "description": "RSR NELLORE FOOD ALLOWANCE", "remarks": "Request to Approve.", "filledFormFileName": "", "billFileName": "", "submittedAt": "2026-10-18T07:06:50.945Z", "approvalChain": ["hareeshv", "santhanakumarv", "gkbharath"], "currentApproverIndex": 0}, "remarks": "Request to Approve.", "signatureFrom": "Admin"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '2063', '1948', 'leave', 'Past-Date Casual Leave Request', 'pending', 'admin',
  'GOLLA KUMAR BHARATH', 'founder-001', 'gkbharath',
  '2026-10-18T06:56:09.487Z'::timestamptz, NULL::timestamptz, '{"createdByRole": "founder", "createdByDesignation": "Founder & Chief Executive Partner", "createdByEmployeeId": "MIB01", "createdByDepartment": "Executive Management Team", "createdByPhone": "8124227370", "payload": {"name": "GOLLA KUMAR BHARATH", "id": "MIB01", "designation": "Founder & Chief Executive Partner", "department": "Executive Management Team", "email": "gollakumarbharath@suryas.in", "phone": "8124227370", "leaveType": "casual", "fromDate": "2026-10-03", "toDate": "2026-10-03", "reason": "Casual Leave", "remarks": "Casual Leave", "isPastDateRequest": true, "filledFormFileName": "", "submittedAt": "2026-10-18T06:56:09.349Z", "approvalChain": ["hareeshv", "santhanakumarv"], "currentApproverIndex": 0}, "remarks": "Casual Leave", "signatureFrom": "Admin"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '1115', '1976', 'leave', 'Past-Date Casual Leave Request', 'approved', 'admin',
  'GOLLA KUMAR BHARATH', 'founder-001', 'gkbharath',
  '2026-10-18T06:41:04.625Z'::timestamptz, '2026-10-18T06:43:46.996Z'::timestamptz, '{"createdByRole": "founder", "createdByDesignation": "Founder & Chief Executive Partner", "createdByEmployeeId": "MIB01", "createdByDepartment": "Executive Management Team", "createdByPhone": "8124227370", "payload": {"name": "GOLLA KUMAR BHARATH", "id": "MIB01", "designation": "Founder & Chief Executive Partner", "department": "Executive Management Team", "email": "gollakumarbharath@suryas.in", "phone": "", "leaveType": "casual", "fromDate": "2026-10-10", "toDate": "2026-10-10", "reason": "Casual Leave", "remarks": "Casual Leave", "isPastDateRequest": true, "filledFormFileName": "", "submittedAt": "2026-10-18T06:41:04.465Z", "approvalChain": ["hareeshv", "santhanakumarv"], "currentApproverIndex": 1, "comments": [{"by": "santhanakumarv", "comment": "Approved", "decision": "approve", "stageIndex": 1, "at": "2026-10-18T06:43:46.993Z"}, {"by": "hareeshv", "comment": "Approve.", "decision": "approve", "stageIndex": 0, "at": "2026-10-18T06:41:55.452Z"}]}, "remarks": "Casual Leave", "signatureFrom": "Admin", "forwardedTo": "santhanakumarv"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '1539', '4077', 'leave', 'Casual Leave Request', 'rejected', 'admin',
  'SANTHANA KUMAR V', 'user-003', 'santhanakumarv',
  '2026-10-18T06:33:20.583Z'::timestamptz, '2026-10-18T06:40:28.133Z'::timestamptz, '{"createdByRole": "managing-partner", "createdByDesignation": "Managing Partner - Operations & Business Development", "createdByEmployeeId": "MIB03", "createdByDepartment": "Executive Management Team", "createdByPhone": "7010353723", "payload": {"name": "SANTHANA KUMAR V", "id": "MIB03", "designation": "Managing Partner - Operations & Business Development", "department": "Executive Management Team", "email": "santhanakumarv@suryas.in", "phone": "7010353723", "leaveType": "casual", "fromDate": "2026-10-19", "toDate": "2026-10-19", "reason": "Medical leave", "remarks": "Pooja holiday", "isPastDateRequest": false, "filledFormFileName": "", "submittedAt": "2026-10-18T06:33:18.853Z", "approvalChain": ["hareeshv", "gkbharath"], "currentApproverIndex": 1, "comments": [{"by": "gkbharath", "comment": "Due to No Medical Certificate.", "decision": "reject", "stageIndex": 1, "at": "2026-10-18T06:40:28.131Z"}, {"by": "hareeshv", "comment": "Approved.", "decision": "approve", "stageIndex": 0, "at": "2026-10-18T06:34:10.306Z"}]}, "remarks": "Pooja holiday", "signatureFrom": "Admin", "forwardedTo": "gkbharath"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '2894', '1469', 'internal-service', 'Internal Service Request from HAREESH V', 'conversation', 'admin',
  'HAREESH V', 'user-002', '',
  '2026-10-18T06:29:20.671Z'::timestamptz, NULL::timestamptz, '{"createdByRole": "managing-partner", "createdByDesignation": "Managing Partner - Projects & Administration", "createdByEmployeeId": "MIB02", "createdByDepartment": "Executive Management Team", "createdByPhone": "6383014533", "payload": {"description": "Hi Santhana Kumar V, ", "id": "MIB02", "designation": "Managing Partner - Projects & Administration", "department": "Executive Management Team", "phone": "6383014533", "remarks": "", "files": [], "assignedHeadId": "user-003", "replies": []}}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '8393', '2385', 'ta', 'Allowance Claim Request', 'rejected', 'admin',
  'HAREESH V', 'user-002', 'hareeshv',
  '2026-10-18T06:28:41.454Z'::timestamptz, '2026-10-18T06:29:18.089Z'::timestamptz, '{"createdByRole": "managing-partner", "createdByDesignation": "Managing Partner - Projects & Administration", "createdByEmployeeId": "MIB02", "createdByDepartment": "Executive Management Team", "createdByPhone": "6383014533", "payload": {"name": "HAREESH V", "id": "MIB02", "designation": "Managing Partner - Projects & Administration", "department": "Executive Management Team", "email": "hareeshv@suryas.in", "claimType": "expenses", "amount": "1500", "description": "RSR Gummdipoondi to Nellore, Petrol Bill Summited to Auditor. ", "remarks": "Request to Approve.", "filledFormFileName": "", "billFileName": "", "submittedAt": "2026-10-18T06:28:41.316Z", "approvalChain": ["santhanakumarv", "gkbharath"], "currentApproverIndex": 0, "comments": [{"by": "santhanakumarv", "comment": "Due to no bills rejected", "decision": "reject", "stageIndex": 0, "at": "2026-10-18T06:29:18.087Z"}]}, "remarks": "Request to Approve.", "signatureFrom": "Admin"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;

INSERT INTO public.requests (
  id, submission_id, type, title, status, target,
  created_by, created_by_id, created_by_username,
  created_at, updated_at, payload
) VALUES (
  '7063', '8519', 'leave', 'Past-Date Casual Leave Request', 'rejected', 'admin',
  'HAREESH V', 'user-002', 'hareeshv',
  '2026-10-18T06:26:41.253Z'::timestamptz, '2026-10-18T06:29:41.999Z'::timestamptz, '{"createdByRole": "managing-partner", "createdByDesignation": "Managing Partner - Projects & Administration", "createdByEmployeeId": "MIB02", "createdByDepartment": "Executive Management Team", "createdByPhone": "6383014533", "payload": {"name": "HAREESH V", "id": "MIB02", "designation": "Managing Partner - Projects & Administration", "department": "Executive Management Team", "email": "hareeshv@suryas.in", "phone": "8124227370", "leaveType": "casual", "fromDate": "2026-10-10", "toDate": "2026-10-10", "reason": "Casual Leave", "remarks": "Request to Approve.", "isPastDateRequest": true, "filledFormFileName": "", "submittedAt": "2026-10-18T06:26:41.064Z", "approvalChain": ["santhanakumarv", "gkbharath"], "currentApproverIndex": 0, "comments": [{"by": "santhanakumarv", "comment": "Date?", "decision": "reject", "stageIndex": 0, "at": "2026-10-18T06:29:41.996Z"}]}, "remarks": "Request to Approve.", "signatureFrom": "Admin"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
  status = EXCLUDED.status,
  updated_at = EXCLUDED.updated_at,
  payload = EXCLUDED.payload;


-- ==================== ATTENDANCE (4 records) ====================
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


-- ==================== NOTIFICATIONS (101 records) ====================
INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1794557638188-yrhsq7t3r', 'user_access_request', 'New User Access Request - Nagaraj K', 'Nagaraj K (nagarajkaids0410@gmail.com) has requested access. Review the request and add remarks.', 'hareeshv', 'SMIB-EMP-584dce21-54bd-4ce5-8bbe-82ee5450111d', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792307635804-k9zw7jk5d', 'request_forwarded', 'Guide recommendation submitted - Past-Date Medical Leave Request', 'The guide has recommended this request for authorized approval.', 'hareeshv', '6823', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792307515444-dgvsyx6z0', 'request_submitted', 'Submission received - Past-Date Medical Leave Request', 'Your request Past-Date Medical Leave Request was submitted for approval.', 'vishnuu', '6823', FALSE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792307515440-hp97hhnu8', 'request_submitted', 'Request submitted - Past-Date Medical Leave Request', 'VISHNU VARSHINI M submitted Past-Date Medical Leave Request; it is awaiting your review.', 'sabir', '6823', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792307390869-tmk1ym121', 'request_submitted', 'Attendance report submitted', 'SABIR MOHAMMED S submitted an attendance report for 2026-10-17 to 2026-10-17.', 'hareeshv', '9475', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792307259103-w1s0qjdwf', 'request_submitted', 'Submission received - Past-Date Casual Leave Request', 'Your request Past-Date Casual Leave Request was submitted for approval.', 'sabir', '4906', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792307259098-lapwngw26', 'request_submitted', 'Request submitted - Past-Date Casual Leave Request', 'SABIR MOHAMMED S submitted Past-Date Casual Leave Request; it is awaiting your review.', 'hareeshv', '4906', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792307211131-c0ffemn55', 'request_submitted', 'Submission received - Allowance Claim Request', 'Your request Allowance Claim Request was submitted for approval.', 'sabir', '8222', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792307211125-5y4oqedbz', 'request_submitted', 'Request submitted - Allowance Claim Request', 'SABIR MOHAMMED S submitted Allowance Claim Request; it is awaiting your review.', 'hareeshv', '8222', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792306569510-031qrzkj8', 'request_submitted', 'Submission received - Past-Date Casual Leave Request', 'Your request Past-Date Casual Leave Request was submitted for approval.', 'gkbharath', '2063', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792306569504-pg12hocsp', 'request_submitted', 'Request submitted - Past-Date Casual Leave Request', 'GOLLA KUMAR BHARATH submitted Past-Date Casual Leave Request; it is awaiting your review.', 'hareeshv', '2063', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792306021148-tvoxwscd6', 'circular', 'New Circular Posted', 'Hi (Notice)', 'all', NULL, TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792305827016-6wlxi10dq', 'request_approved', 'Request approved - Past-Date Casual Leave Request', 'Your request Past-Date Casual Leave Request received final approval.', 'gkbharath', '1115', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792305715508-t7b1tvahb', 'request_status_changed', 'Request advanced - Past-Date Casual Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'gkbharath', '1115', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792305715500-wgicdyq7f', 'request_forwarded', 'Request forwarded - Past-Date Casual Leave Request', 'Request Past-Date Casual Leave Request has been forwarded to you for approval.', 'santhanakumarv', '1115', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792305664642-tgdiovq85', 'request_submitted', 'Submission received - Past-Date Casual Leave Request', 'Your request Past-Date Casual Leave Request was submitted for approval.', 'gkbharath', '1115', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792305664638-qhozcsss7', 'request_submitted', 'Request submitted - Past-Date Casual Leave Request', 'GOLLA KUMAR BHARATH submitted Past-Date Casual Leave Request; it is awaiting your review.', 'hareeshv', '1115', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792305628158-sr33q3usm', 'request_rejected', 'Request rejected - Casual Leave Request', 'Your request Casual Leave Request was rejected by gkbharath. Remarks: Due to No Medical Certificate.', 'santhanakumarv', '1539', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792305250364-2qlwd4ywa', 'request_status_changed', 'Request advanced - Casual Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'santhanakumarv', '1539', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792305250354-yk9uvzf3l', 'request_forwarded', 'Request forwarded - Casual Leave Request', 'Request Casual Leave Request has been forwarded to you for approval.', 'gkbharath', '1539', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792305200602-t2yw0z8sa', 'request_submitted', 'Submission received - Casual Leave Request', 'Your request Casual Leave Request was submitted for approval.', 'santhanakumarv', '1539', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792305200597-4h7k49h7j', 'request_submitted', 'Request submitted - Casual Leave Request', 'SANTHANA KUMAR V submitted Casual Leave Request; it is awaiting your review.', 'hareeshv', '1539', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792304982021-r315izwxd', 'request_rejected', 'Request rejected - Past-Date Casual Leave Request', 'Your request Past-Date Casual Leave Request was rejected by santhanakumarv. Remarks: Date?', 'hareeshv', '7063', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792304960688-qzrtt2i3o', 'internal-service-request', 'Internal request assigned to you', 'HAREESH V sent you a request: "Hi Santhana Kumar V, ..."', 'santhanakumarv', '2894', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792304958107-4jt4dlqzv', 'request_rejected', 'Request rejected - Allowance Claim Request', 'Your request Allowance Claim Request was rejected by santhanakumarv. Remarks: Due to no bills rejected', 'hareeshv', '8393', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792304921478-20ga9cchs', 'request_submitted', 'Submission received - Allowance Claim Request', 'Your request Allowance Claim Request was submitted for approval.', 'hareeshv', '8393', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792304921472-omeuaodut', 'request_submitted', 'Request submitted - Allowance Claim Request', 'HAREESH V submitted Allowance Claim Request; it is awaiting your review.', 'santhanakumarv', '8393', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792304801286-ssd08f7o8', 'request_submitted', 'Submission received - Past-Date Casual Leave Request', 'Your request Past-Date Casual Leave Request was submitted for approval.', 'hareeshv', '7063', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792304801280-p0ahkmt8k', 'request_submitted', 'Request submitted - Past-Date Casual Leave Request', 'HAREESH V submitted Past-Date Casual Leave Request; it is awaiting your review.', 'santhanakumarv', '7063', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792297978632-p7rqx34q9', 'request_approved', 'Request approved - Past-Date Casual Leave Request', 'Your request Past-Date Casual Leave Request received final approval.', 'mathi', '5018', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792297951017-x0fcn8k30', 'request_status_changed', 'Request advanced - Past-Date Casual Leave Request', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'mathi', '5018', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792297951015-uv1yrtwoj', 'request_forwarded', 'Request forwarded - Past-Date Casual Leave Request', 'Request Past-Date Casual Leave Request has been forwarded to you for approval.', 'gkbharath', '5018', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792297862339-gt6a8qq75', 'request_status_changed', 'Request advanced - Past-Date Casual Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'mathi', '5018', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792297862336-jfwx3v5hb', 'request_forwarded', 'Request forwarded - Past-Date Casual Leave Request', 'Request Past-Date Casual Leave Request has been forwarded to you for approval.', 'santhanakumarv', '5018', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792297856946-i3s91sfeo', 'request_rejected', 'Request rejected - Past-Date Casual Leave Request', 'Your request Past-Date Casual Leave Request was rejected by hareeshv. Remarks: 2 Time Application.', 'mathi', '3203', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792297801288-td5f2zuw0', 'request_forwarded', 'Guide recommendation submitted - Past-Date Casual Leave Request', 'The guide has recommended this request for authorized approval.', 'hareeshv', '5018', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792297787379-vh0cnnzwb', 'request_forwarded', 'Guide recommendation submitted - Past-Date Casual Leave Request', 'The guide has recommended this request for authorized approval.', 'hareeshv', '3203', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792297592131-b05ueocd8', 'request_submitted', 'Submission received - Past-Date Casual Leave Request', 'Your request Past-Date Casual Leave Request was submitted for approval.', 'mathi', '3203', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792297592129-y9aajy5x8', 'request_submitted', 'Request submitted - Past-Date Casual Leave Request', 'MATHIYAZHAGAN D submitted Past-Date Casual Leave Request; it is awaiting your review.', 'sabir', '3203', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792296592196-luur6f1ss', 'request_submitted', 'Submission received - Past-Date Casual Leave Request', 'Your request Past-Date Casual Leave Request was submitted for approval.', 'mathi', '5018', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792296592191-xu03nknpq', 'request_submitted', 'Request submitted - Past-Date Casual Leave Request', 'MATHIYAZHAGAN D submitted Past-Date Casual Leave Request; it is awaiting your review.', 'sabir', '5018', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792296452702-qqc8w688e', 'user_approved', 'User Approved: MATHIYAZHAGAN D', 'Access approved for mathiyazhagandhanapalmathiyazh@gmail.com.', 'founder', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792296452565-zgeagwygr', 'user_approved', 'User Approved: MATHIYAZHAGAN D', 'Access approved for mathiyazhagandhanapalmathiyazh@gmail.com.', 'admin', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792296452457-brxnopc5m', 'user_approved', 'Registration request approved', 'Your account is active. Sign in and change your temporary password if prompted.', 'mathi', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792296381543-pd1bchxmo', 'registration_approval', 'Registration review required - MATHIYAZHAGAN D', 'MATHIYAZHAGAN D''s registration is ready for your review.', 'gkbharath', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792296343240-jc61qoo39', 'registration_approval', 'Registration review required - MATHIYAZHAGAN D', 'MATHIYAZHAGAN D''s registration is ready for your review.', 'santhanakumarv', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792296297310-hl56hdt7k', 'user_access_request', 'New User Access Request - MATHIYAZHAGAN D', 'MATHIYAZHAGAN D (mathiyazhagandhanapalmathiyazh@gmail.com) has requested access. Review the request and add remarks.', 'hareeshv', 'SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792296172332-7b48vkduf', 'request_approved', 'Request approved - Attendance report: 2026-10-17 to 2026-10-17', 'Your request Attendance report: 2026-10-17 to 2026-10-17 received final approval.', 'sabir', '7985', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792296019688-8gm8dnxml', 'request_status_changed', 'Request advanced - Attendance report: 2026-10-17 to 2026-10-17', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'sabir', '7985', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792296019683-mflsgquqv', 'request_forwarded', 'Request forwarded - Attendance report: 2026-10-17 to 2026-10-17', 'Request Attendance report: 2026-10-17 to 2026-10-17 has been forwarded to you for approval.', 'gkbharath', '7985', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792296014374-r3ltnrua4', 'request_status_changed', 'Request advanced - Relieving letter request', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'sabir', '5264', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792296014370-v9gfceubg', 'request_forwarded', 'Request forwarded - Relieving letter request', 'Request Relieving letter request has been forwarded to you for approval.', 'gkbharath', '5264', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792295943605-1ixb3jgpk', 'request_status_changed', 'Request advanced - Attendance report: 2026-10-17 to 2026-10-17', 'Your request was approved by hareeshv and forwarded to the next approver.', 'sabir', '7985', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792295943598-he4ygm6o6', 'request_forwarded', 'Request forwarded - Attendance report: 2026-10-17 to 2026-10-17', 'Request Attendance report: 2026-10-17 to 2026-10-17 has been forwarded to you for approval.', 'santhanakumarv', '7985', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792295937085-bfa08owj1', 'request_status_changed', 'Request advanced - Relieving letter request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'sabir', '5264', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792295937079-9p4yrrvtu', 'request_forwarded', 'Request forwarded - Relieving letter request', 'Request Relieving letter request has been forwarded to you for approval.', 'santhanakumarv', '5264', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792295864537-8q388ly0x', 'request_submitted', 'Submission received - Relieving letter request', 'Your request Relieving letter request was submitted for approval.', 'sabir', '5264', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792295864529-d9bge1aa5', 'request_submitted', 'Request submitted - Relieving letter request', 'SABIR MOHAMMED S submitted Relieving letter request; it is awaiting your review.', 'hareeshv', '5264', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792295762291-lo0mk4seu', 'request_submitted', 'Attendance report submitted', 'SABIR MOHAMMED S submitted an attendance report for 2026-10-17 to 2026-10-17.', 'hareeshv', '7985', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792256168485-ifs9x9haq', 'request_rejected', 'Request rejected - Allowance Claim Request', 'Your request Allowance Claim Request was rejected by gkbharath. Remarks: Bill Required.', 'sabir', '2032', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792256131859-4uhyloz27', 'request_status_changed', 'Request advanced - Allowance Claim Request', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'sabir', '2032', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792256131852-oc7n938qs', 'request_forwarded', 'Request forwarded - Allowance Claim Request', 'Request Allowance Claim Request has been forwarded to you for approval.', 'gkbharath', '2032', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792256107710-1d6wpw8ax', 'request_status_changed', 'Request advanced - Allowance Claim Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'sabir', '2032', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792256107704-4oakpxm3b', 'request_forwarded', 'Request forwarded - Allowance Claim Request', 'Request Allowance Claim Request has been forwarded to you for approval.', 'santhanakumarv', '2032', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792256039152-5bohdgx9p', 'request_submitted', 'Submission received - Allowance Claim Request', 'Your request Allowance Claim Request was submitted for approval.', 'sabir', '2032', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792256039138-a97d4lgrx', 'request_submitted', 'Request submitted - Allowance Claim Request', 'SABIR MOHAMMED S submitted Allowance Claim Request; it is awaiting your review.', 'hareeshv', '2032', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792255821141-lcvkxr7sl', 'user_approved', 'User Approved: VISHNU VARSHINI M', 'Access approved for pcb.designers@suryas.in.', 'founder', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792255821137-kdub9vrbq', 'user_approved', 'User Approved: VISHNU VARSHINI M', 'Access approved for pcb.designers@suryas.in.', 'admin', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792255821128-876s7vj0o', 'user_approved', 'Registration request approved', 'Your account is active. Sign in and change your temporary password if prompted.', 'vishnuu', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792255799180-r9m6vyrhr', 'registration_approval', 'Registration review required - VISHNU VARSHINI M', 'VISHNU VARSHINI M''s registration is ready for your review.', 'gkbharath', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792255781603-r5ssr9g9c', 'registration_approval', 'Registration review required - VISHNU VARSHINI M', 'VISHNU VARSHINI M''s registration is ready for your review.', 'santhanakumarv', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792255695492-mzi98p4hp', 'user_access_request', 'New User Access Request - VISHNU VARSHINI M', 'VISHNU VARSHINI M (pcb.designers@suryas.in) has requested access. Review the request and add remarks.', 'hareeshv', 'SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792255306120-k216i7iq1', 'request_approved', 'Request approved - Project Proposal', 'Your request Project Proposal received final approval.', 'sabir', '8238', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792255292743-jw58kgvjf', 'request_status_changed', 'Request advanced - Project Proposal', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'sabir', '8238', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792255292727-ro6k5pe26', 'request_forwarded', 'Request forwarded - Project Proposal', 'Request Project Proposal has been forwarded to you for approval.', 'gkbharath', '8238', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792255273479-ws554fdub', 'request_status_changed', 'Request advanced - Project Proposal', 'Your request was approved by hareeshv and forwarded to the next approver.', 'sabir', '8238', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792255273470-s3ur9qdc2', 'request_forwarded', 'Request forwarded - Project Proposal', 'Request Project Proposal has been forwarded to you for approval.', 'santhanakumarv', '8238', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792255255954-bj2twpmnz', 'request_submitted', 'Submission received - Project Proposal', 'Your request Project Proposal was submitted for approval.', 'sabir', '8238', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792255255942-eye6877pj', 'request_submitted', 'Request submitted - Project Proposal', 'SABIR MOHAMMED S submitted Project Proposal; it is awaiting your review.', 'hareeshv', '8238', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792254306424-iwqs2jjgv', 'request_approved', 'Request approved - Past-Date PERSONAL Leave Request', 'Your request Past-Date PERSONAL Leave Request received final approval.', 'hareeshv', '3662', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792254290848-z8vspnogm', 'request_status_changed', 'Request advanced - Past-Date PERSONAL Leave Request', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'hareeshv', '3662', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792254290840-682si4jxg', 'request_forwarded', 'Request forwarded - Past-Date PERSONAL Leave Request', 'Request Past-Date PERSONAL Leave Request has been forwarded to you for approval.', 'gkbharath', '3662', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792254056789-vscfukmgj', 'request_submitted', 'Submission received - Past-Date PERSONAL Leave Request', 'Your request Past-Date PERSONAL Leave Request was submitted for approval.', 'hareeshv', '3662', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792254056782-sp8qo6oww', 'request_submitted', 'Request submitted - Past-Date PERSONAL Leave Request', 'HAREESH V submitted Past-Date PERSONAL Leave Request; it is awaiting your review.', 'santhanakumarv', '3662', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792253821861-i8jl58ilk', 'internal-service-reply', 'Reply on Your Internal Request', 'hareeshv: "Hi..."', 'sabir', '5388', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792253803025-f2qgaplfc', 'internal-service-request', 'Internal request assigned to you', 'SABIR MOHAMMED S sent you a request: "Hi..."', 'hareeshv', '5388', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792253460923-c75kgxxws', 'request_approved', 'Request approved - Past-Date PERSONAL Leave Request', 'Your request Past-Date PERSONAL Leave Request received final approval.', 'sabir', '4718', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792253440111-nz8cnbj37', 'request_status_changed', 'Request advanced - Past-Date PERSONAL Leave Request', 'Your request was approved by santhanakumarv and forwarded to the next approver.', 'sabir', '4718', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792253440107-0ifrtsnci', 'request_forwarded', 'Request forwarded - Past-Date PERSONAL Leave Request', 'Request Past-Date PERSONAL Leave Request has been forwarded to you for approval.', 'gkbharath', '4718', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792253425966-v9z8bhryn', 'request_status_changed', 'Request advanced - Past-Date PERSONAL Leave Request', 'Your request was approved by hareeshv and forwarded to the next approver.', 'sabir', '4718', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792253425958-ubaalbmiq', 'request_forwarded', 'Request forwarded - Past-Date PERSONAL Leave Request', 'Request Past-Date PERSONAL Leave Request has been forwarded to you for approval.', 'santhanakumarv', '4718', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792253367440-3fd4qtige', 'request_submitted', 'Submission received - Past-Date PERSONAL Leave Request', 'Your request Past-Date PERSONAL Leave Request was submitted for approval.', 'sabir', '4718', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792253367429-n0skbirg6', 'request_submitted', 'Request submitted - Past-Date PERSONAL Leave Request', 'SABIR MOHAMMED S submitted Past-Date PERSONAL Leave Request; it is awaiting your review.', 'hareeshv', '4718', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792250302698-5oap7qi2b', 'circular', 'New Circular Posted', 'Hi Guys (Notice)', 'all', NULL, TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792242944288-67ljjpd6o', 'circular', 'New Circular Posted', 'Hi (Notice)', 'all', NULL, TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792242133971-mbkprvjh2', 'user_approved', 'User Approved: SABIR MOHAMMED S', 'Access approved for sabirmohammeds@suryas.in.', 'founder', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792242133966-qx99wpgwj', 'user_approved', 'User Approved: SABIR MOHAMMED S', 'Access approved for sabirmohammeds@suryas.in.', 'admin', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792242133956-y2za4s0fl', 'user_approved', 'Registration request approved', 'Your account is active. Sign in and change your temporary password if prompted.', 'sabir', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792242117032-6ysdi4hno', 'registration_approval', 'Registration review required - SABIR MOHAMMED S', 'SABIR MOHAMMED S''s registration is ready for your review.', 'gkbharath', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792242012954-u46coigdc', 'registration_approval', 'Registration review required - SABIR MOHAMMED S', 'SABIR MOHAMMED S''s registration is ready for your review.', 'santhanakumarv', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;

INSERT INTO public.notifications (
  id, type, title, message, target_user, related_id, read, created_at
) VALUES (
  'notif-1792241932262-ya74gbtwd', 'user_access_request', 'New User Access Request - SABIR MOHAMMED S', 'SABIR MOHAMMED S (sabirmohammeds@suryas.in) has requested access. Review the request and add remarks.', 'hareeshv', 'SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69', TRUE, NULL::timestamptz
) ON CONFLICT (id) DO UPDATE SET
  read = EXCLUDED.read;


-- ==================== VERIFICATION ====================
SELECT 'users' as table_name, count(*) as record_count FROM public.users
UNION ALL SELECT 'requests', count(*) FROM public.requests
UNION ALL SELECT 'attendance', count(*) FROM public.attendance
UNION ALL SELECT 'notifications', count(*) FROM public.notifications;