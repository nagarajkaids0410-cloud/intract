-- ====================================================================
-- SURYAS MiB ENTERPRISES - DAILY ATTENDANCE FOLDER MIGRATION
-- 64 Attendance records from 9 daily files (2026-10-19 to 2026-11-06)
-- ====================================================================

-- Date: attendance-2026-10-19.json (6 records)
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

-- Date: attendance-2026-10-26.json (8 records)
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

-- Date: attendance-2026-10-27.json (8 records)
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

-- Date: attendance-2026-10-28.json (7 records)
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

-- Date: attendance-2026-10-30.json (8 records)
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

-- Date: attendance-2026-11-03.json (6 records)
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

-- Date: attendance-2026-11-04.json (7 records)
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

-- Date: attendance-2026-11-05.json (7 records)
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

-- Date: attendance-2026-11-06.json (7 records)
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


-- ==================== VERIFICATION ====================
SELECT 'Total attendance records in Supabase' as check, count(*) as count FROM public.attendance;
