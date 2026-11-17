import fs from 'node:fs';
import path from 'node:path';
import { randomUUID } from 'node:crypto';
import { getPool, initDatabase } from './db';

const DB_FILE = path.join(process.cwd(), '.data', 'attendance.json');

export interface AttendanceRecord {
  id: string;
  userId: string;
  username: string;
  fullName: string;
  date: string;
  checkIn: string;
  checkOut?: string;
}

const defaultAttendance: AttendanceRecord[] = [
  {
    "id": "83ca9e31-4880-434a-ba8b-f8827670aa1f",
    "userId": "user-002",
    "username": "hareeshv",
    "fullName": "HAREESH V",
    "date": "2026-11-06",
    "checkIn": "2026-11-06T03:58:57.514Z",
    "checkOut": null
  },
  {
    "id": "75407615-b1bb-4784-b93b-49a922526f91",
    "userId": "SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13",
    "username": "smrithik",
    "fullName": "SMRITHI K",
    "date": "2026-11-06",
    "checkIn": "2026-11-06T03:45:33.025Z",
    "checkOut": null
  },
  {
    "id": "8512249b-b67f-4ede-99f4-be64db31deb1",
    "userId": "founder-001",
    "username": "gkbharath",
    "fullName": "GOLLA KUMAR BHARATH",
    "date": "2026-11-06",
    "checkIn": "2026-11-06T03:39:25.930Z",
    "checkOut": null
  },
  {
    "id": "543a9e61-d2e2-4ba1-93c4-c52677b1e306",
    "userId": "user-003",
    "username": "santhanakumarv",
    "fullName": "SANTHANA KUMAR V",
    "date": "2026-11-06",
    "checkIn": "2026-11-06T03:39:00.300Z",
    "checkOut": null
  },
  {
    "id": "87eb9add-6c92-440a-b599-bd368de8c61d",
    "userId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69",
    "username": "sabir",
    "fullName": "SABIR MOHAMMED S",
    "date": "2026-11-06",
    "checkIn": "2026-11-06T03:38:29.852Z",
    "checkOut": null
  },
  {
    "id": "d0f8bff8-7ec0-4e6d-8efe-7e3be0d5dba6",
    "userId": "SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb",
    "username": "rithanyad",
    "fullName": "RITHANYA D",
    "date": "2026-11-06",
    "checkIn": "2026-11-06T03:29:42.357Z",
    "checkOut": null
  },
  {
    "id": "ac299800-7ef4-42c9-8cfb-610f643308e0",
    "userId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3",
    "username": "vishnuu",
    "fullName": "VISHNU VARSHINI M",
    "date": "2026-11-06",
    "checkIn": "2026-11-06T03:25:35.003Z",
    "checkOut": null
  },
  {
    "id": "dcf50e58-11d8-4275-8221-56576dc05a5e",
    "userId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3",
    "username": "vishnuu",
    "fullName": "VISHNU VARSHINI M",
    "date": "2026-11-05",
    "checkIn": "2026-11-05T03:28:29.738Z",
    "checkOut": "2026-11-05T11:23:39.150Z"
  },
  {
    "id": "63262d90-4941-4238-ab79-84abba7a3691",
    "userId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69",
    "username": "sabir",
    "fullName": "SABIR MOHAMMED S",
    "date": "2026-11-05",
    "checkIn": "2026-11-05T03:22:00.471Z",
    "checkOut": "2026-11-05T11:27:40.333Z"
  },
  {
    "id": "a25b0988-1583-4fde-85e2-e5d4da43c0bb",
    "userId": "SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13",
    "username": "smrithik",
    "fullName": "SMRITHI K",
    "date": "2026-11-05",
    "checkIn": "2026-11-05T03:07:36.987Z",
    "checkOut": "2026-11-05T11:18:37.117Z"
  },
  {
    "id": "682fae0e-cd6e-410b-b566-c62d4cb0dcf7",
    "userId": "user-002",
    "username": "hareeshv",
    "fullName": "HAREESH V",
    "date": "2026-11-05",
    "checkIn": "2026-11-05T02:56:02.610Z",
    "checkOut": null
  },
  {
    "id": "03d1dda7-5ca4-4121-9ea2-8cd42435920d",
    "userId": "SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb",
    "username": "rithanyad",
    "fullName": "RITHANYA D",
    "date": "2026-11-05",
    "checkIn": "2026-11-05T02:55:02.032Z",
    "checkOut": "2026-11-05T11:22:33.775Z"
  },
  {
    "id": "38be8e8c-4aeb-4518-a663-52b7f3bf1648",
    "userId": "founder-001",
    "username": "gkbharath",
    "fullName": "GOLLA KUMAR BHARATH",
    "date": "2026-11-05",
    "checkIn": "2026-11-05T02:47:44.099Z",
    "checkOut": "2026-11-05T11:29:38.985Z"
  },
  {
    "id": "99787047-d215-4341-b19f-471678a0a685",
    "userId": "user-003",
    "username": "santhanakumarv",
    "fullName": "SANTHANA KUMAR V",
    "date": "2026-11-05",
    "checkIn": "2026-11-05T02:40:25.758Z",
    "checkOut": "2026-11-05T11:30:47.913Z"
  },
  {
    "id": "89abc3b9-7bf5-48f5-94a2-8ed4373efdb7",
    "userId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69",
    "username": "sabir",
    "fullName": "SABIR MOHAMMED S",
    "date": "2026-11-04",
    "checkIn": "2026-11-04T03:44:28.189Z",
    "checkOut": "2026-11-04T11:26:03.481Z"
  },
  {
    "id": "d885bfe7-e745-4f5e-91e0-ee5d4f780ac2",
    "userId": "SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13",
    "username": "smrithik",
    "fullName": "SMRITHI K",
    "date": "2026-11-04",
    "checkIn": "2026-11-04T03:40:28.310Z",
    "checkOut": null
  },
  {
    "id": "8c65215c-1c0d-4b27-9b26-19c79e28887b",
    "userId": "founder-001",
    "username": "gkbharath",
    "fullName": "GOLLA KUMAR BHARATH",
    "date": "2026-11-04",
    "checkIn": "2026-11-04T03:20:47.869Z",
    "checkOut": "2026-11-04T11:38:28.054Z"
  },
  {
    "id": "8eca8808-1d8d-4957-bdc8-563d8b4699bb",
    "userId": "user-003",
    "username": "santhanakumarv",
    "fullName": "SANTHANA KUMAR V",
    "date": "2026-11-04",
    "checkIn": "2026-11-04T03:17:27.622Z",
    "checkOut": null
  },
  {
    "id": "b8c299ab-86df-484c-9cfd-b55ab4c1b399",
    "userId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3",
    "username": "vishnuu",
    "fullName": "VISHNU VARSHINI M",
    "date": "2026-11-04",
    "checkIn": "2026-11-04T03:17:25.518Z",
    "checkOut": "2026-11-04T11:27:32.652Z"
  },
  {
    "id": "78b416b4-0437-4afa-b995-28ff388cb442",
    "userId": "SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb",
    "username": "rithanyad",
    "fullName": "RITHANYA D",
    "date": "2026-11-04",
    "checkIn": "2026-11-04T03:10:32.302Z",
    "checkOut": "2026-11-04T11:19:45.983Z"
  },
  {
    "id": "bbb448d2-fd78-4ecb-a73c-e9e7417a1500",
    "userId": "user-002",
    "username": "hareeshv",
    "fullName": "HAREESH V",
    "date": "2026-11-04",
    "checkIn": "2026-11-04T03:08:08.800Z",
    "checkOut": null
  },
  {
    "id": "bf31b7d8-164e-4468-89bb-87a12a58fd41",
    "userId": "user-002",
    "username": "hareeshv",
    "fullName": "HAREESH V",
    "date": "2026-11-03",
    "checkIn": "2026-11-03T04:21:08.177Z",
    "checkOut": "2026-11-03T11:25:12.844Z"
  },
  {
    "id": "935b72d3-b93e-432b-ac20-d3e768fb14a0",
    "userId": "SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb",
    "username": "rithanyad",
    "fullName": "RITHANYA D",
    "date": "2026-11-03",
    "checkIn": "2026-11-03T03:31:12.076Z",
    "checkOut": "2026-11-03T11:30:16.819Z"
  },
  {
    "id": "7177cdb8-45ad-4345-b9fc-b8db2ed471d5",
    "userId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3",
    "username": "vishnuu",
    "fullName": "VISHNU VARSHINI M",
    "date": "2026-11-03",
    "checkIn": "2026-11-03T03:25:53.912Z",
    "checkOut": "2026-11-03T11:35:25.547Z"
  },
  {
    "id": "eb0ff3b3-da3b-452e-98ed-474dc471b1a7",
    "userId": "SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13",
    "username": "smrithik",
    "fullName": "SMRITHI K",
    "date": "2026-11-03",
    "checkIn": "2026-11-03T03:24:32.553Z",
    "checkOut": "2026-11-03T11:37:08.230Z"
  },
  {
    "id": "3324650e-2f43-4497-bd64-e185f42bc7cb",
    "userId": "founder-001",
    "username": "gkbharath",
    "fullName": "GOLLA KUMAR BHARATH",
    "date": "2026-11-03",
    "checkIn": "2026-11-03T03:13:53.281Z",
    "checkOut": "2026-11-03T11:49:25.076Z"
  },
  {
    "id": "27ace3e8-0806-4ea9-9a64-c0d75bc4201c",
    "userId": "user-003",
    "username": "santhanakumarv",
    "fullName": "SANTHANA KUMAR V",
    "date": "2026-11-03",
    "checkIn": "2026-11-03T02:52:05.814Z",
    "checkOut": "2026-11-03T11:50:12.620Z"
  },
  {
    "id": "dc361e35-2899-4e40-9098-b8ec8fc65c21",
    "userId": "founder-001",
    "username": "gkbharath",
    "fullName": "GOLLA KUMAR BHARATH",
    "date": "2026-10-30",
    "checkIn": "2026-10-30T03:39:03.622Z",
    "checkOut": null
  },
  {
    "id": "7ba6be4c-e1d3-49e8-b69e-1463fa77743d",
    "userId": "SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01",
    "username": "mathi",
    "fullName": "MATHIYAZHAGAN D",
    "date": "2026-10-30",
    "checkIn": "2026-10-30T03:30:05.430Z",
    "checkOut": null
  },
  {
    "id": "f0e14014-5ffa-4983-961a-09c714ededf5",
    "userId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69",
    "username": "sabir",
    "fullName": "SABIR MOHAMMED S",
    "date": "2026-10-30",
    "checkIn": "2026-10-30T03:30:04.654Z",
    "checkOut": "2026-10-30T11:30:03.813Z"
  },
  {
    "id": "a5a3a10d-5a7b-4901-b247-6caf3f51c5c0",
    "userId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3",
    "username": "vishnuu",
    "fullName": "VISHNU VARSHINI M",
    "date": "2026-10-30",
    "checkIn": "2026-10-30T03:27:27.566Z",
    "checkOut": "2026-10-30T11:40:50.613Z"
  },
  {
    "id": "028b96c9-270f-4dc3-bb28-184ffccd989e",
    "userId": "SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb",
    "username": "rithanyad",
    "fullName": "RITHANYA D",
    "date": "2026-10-30",
    "checkIn": "2026-10-30T03:17:02.207Z",
    "checkOut": "2026-10-30T12:37:02.256Z"
  },
  {
    "id": "92d42d1b-2aa7-4b91-9a83-904528106efd",
    "userId": "user-003",
    "username": "santhanakumarv",
    "fullName": "SANTHANA KUMAR V",
    "date": "2026-10-30",
    "checkIn": "2026-10-30T03:15:05.872Z",
    "checkOut": null
  },
  {
    "id": "a4953458-998c-48e9-818b-f779ac9bfe26",
    "userId": "user-002",
    "username": "hareeshv",
    "fullName": "HAREESH V",
    "date": "2026-10-30",
    "checkIn": "2026-10-30T03:14:18.256Z",
    "checkOut": null
  },
  {
    "id": "7d71f70e-3c6d-4de6-bdae-2b438012b3ef",
    "userId": "SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13",
    "username": "smrithik",
    "fullName": "SMRITHI K",
    "date": "2026-10-30",
    "checkIn": "2026-10-30T03:12:58.782Z",
    "checkOut": "2026-10-30T12:47:08.982Z"
  },
  {
    "id": "f5a48999-73ec-4f2e-b622-ae67f78209fc",
    "userId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69",
    "username": "sabir",
    "fullName": "SABIR MOHAMMED S",
    "date": "2026-10-28",
    "checkIn": "2026-10-28T03:47:32.805Z",
    "checkOut": "2026-10-28T11:34:32.321Z"
  },
  {
    "id": "fa570b7b-4697-4b0f-915a-29e918f629e1",
    "userId": "SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01",
    "username": "mathi",
    "fullName": "MATHIYAZHAGAN D",
    "date": "2026-10-28",
    "checkIn": "2026-10-28T03:32:12.608Z",
    "checkOut": "2026-10-28T11:41:26.092Z"
  },
  {
    "id": "5868bc16-156c-42c9-b966-ca6eabd1a911",
    "userId": "SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb",
    "username": "rithanyad",
    "fullName": "RITHANYA D",
    "date": "2026-10-28",
    "checkIn": "2026-10-28T03:31:43.857Z",
    "checkOut": null
  },
  {
    "id": "34d4d901-1f12-4c35-a7d9-775fcb37e57d",
    "userId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3",
    "username": "vishnuu",
    "fullName": "VISHNU VARSHINI M",
    "date": "2026-10-28",
    "checkIn": "2026-10-28T03:26:25.755Z",
    "checkOut": "2026-10-28T11:32:03.354Z"
  },
  {
    "id": "a49f1095-72f3-40bd-b55a-9ccbe92174bc",
    "userId": "user-002",
    "username": "hareeshv",
    "fullName": "HAREESH V",
    "date": "2026-10-28",
    "checkIn": "2026-10-28T03:22:45.127Z",
    "checkOut": "2026-10-28T11:42:01.642Z"
  },
  {
    "id": "838304b2-2a45-46a2-82c9-908f84216a52",
    "userId": "founder-001",
    "username": "gkbharath",
    "fullName": "GOLLA KUMAR BHARATH",
    "date": "2026-10-28",
    "checkIn": "2026-10-28T03:21:04.081Z",
    "checkOut": "2026-10-28T11:33:36.346Z"
  },
  {
    "id": "466098a1-988b-445c-9be4-5331c8b9e823",
    "userId": "SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13",
    "username": "smrithik",
    "fullName": "SMRITHI K",
    "date": "2026-10-28",
    "checkIn": "2026-10-28T03:12:44.352Z",
    "checkOut": "2026-10-28T12:00:43.304Z"
  },
  {
    "id": "bd0c1c85-11c9-47cc-9bdd-2d6f33500c4b",
    "userId": "SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01",
    "username": "mathi",
    "fullName": "MATHIYAZHAGAN D",
    "date": "2026-10-27",
    "checkIn": "2026-10-27T03:31:05.220Z",
    "checkOut": "2026-10-27T11:34:53.528Z"
  },
  {
    "id": "66e7a27c-2a23-4bb4-888f-f06831f39fd5",
    "userId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69",
    "username": "sabir",
    "fullName": "SABIR MOHAMMED S",
    "date": "2026-10-27",
    "checkIn": "2026-10-27T03:30:38.983Z",
    "checkOut": "2026-10-27T12:58:57.048Z"
  },
  {
    "id": "ac72454a-6f65-4963-8370-290bd823b22a",
    "userId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3",
    "username": "vishnuu",
    "fullName": "VISHNU VARSHINI M",
    "date": "2026-10-27",
    "checkIn": "2026-10-27T03:21:40.243Z",
    "checkOut": "2026-10-27T11:31:49.902Z"
  },
  {
    "id": "92def774-92a1-4168-a73a-b3b15364a4a0",
    "userId": "user-002",
    "username": "hareeshv",
    "fullName": "HAREESH V",
    "date": "2026-10-27",
    "checkIn": "2026-10-27T03:18:45.078Z",
    "checkOut": null
  },
  {
    "id": "978dd5df-fcf5-461a-909c-636d99660ac0",
    "userId": "SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb",
    "username": "rithanyad",
    "fullName": "RITHANYA D",
    "date": "2026-10-27",
    "checkIn": "2026-10-27T03:16:18.362Z",
    "checkOut": "2026-10-27T12:10:04.089Z"
  },
  {
    "id": "f2d02a84-c177-4447-8ffe-3186543ad241",
    "userId": "founder-001",
    "username": "gkbharath",
    "fullName": "GOLLA KUMAR BHARATH",
    "date": "2026-10-27",
    "checkIn": "2026-10-27T03:15:35.732Z",
    "checkOut": null
  },
  {
    "id": "01b5ec32-4811-40cb-a11b-32b4530c5631",
    "userId": "SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13",
    "username": "smrithik",
    "fullName": "SMRITHI K",
    "date": "2026-10-27",
    "checkIn": "2026-10-27T03:14:46.993Z",
    "checkOut": "2026-10-27T12:21:41.361Z"
  },
  {
    "id": "add9484d-70c0-4f6f-ac07-c8970d2e2e4b",
    "userId": "user-003",
    "username": "santhanakumarv",
    "fullName": "SANTHANA KUMAR V",
    "date": "2026-10-27",
    "checkIn": "2026-10-27T03:14:34.859Z",
    "checkOut": null
  },
  {
    "id": "33fef29c-df11-4af2-849b-8c66f37ef777",
    "userId": "SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01",
    "username": "mathi",
    "fullName": "MATHIYAZHAGAN D",
    "date": "2026-10-26",
    "checkIn": "2026-10-26T03:36:59.493Z",
    "checkOut": "2026-10-26T12:00:47.980Z"
  },
  {
    "id": "0ec1430f-ca51-4212-8691-1050f32eed46",
    "userId": "user-002",
    "username": "hareeshv",
    "fullName": "HAREESH V",
    "date": "2026-10-26",
    "checkIn": "2026-10-26T03:36:47.541Z",
    "checkOut": "2026-10-26T03:47:27.046Z"
  },
  {
    "id": "959473d4-3e76-40de-a3a4-fea57e5ed55b",
    "userId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69",
    "username": "sabir",
    "fullName": "SABIR MOHAMMED S",
    "date": "2026-10-26",
    "checkIn": "2026-10-26T03:33:37.075Z",
    "checkOut": "2026-10-26T12:04:10.539Z"
  },
  {
    "id": "37537ff1-dfeb-4a35-97ec-607e1cedba91",
    "userId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3",
    "username": "vishnuu",
    "fullName": "VISHNU VARSHINI M",
    "date": "2026-10-26",
    "checkIn": "2026-10-26T03:26:38.358Z",
    "checkOut": "2026-10-26T11:52:33.577Z"
  },
  {
    "id": "a2a6b5c9-6e69-4501-9ef2-cc416641012d",
    "userId": "SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13",
    "username": "smrithik",
    "fullName": "SMRITHI K",
    "date": "2026-10-26",
    "checkIn": "2026-10-26T02:57:54.171Z",
    "checkOut": null
  },
  {
    "id": "68b176a6-2aed-4ab9-860f-4ee4c66d5503",
    "userId": "SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb",
    "username": "rithanyad",
    "fullName": "RITHANYA D",
    "date": "2026-10-26",
    "checkIn": "2026-10-26T02:52:46.332Z",
    "checkOut": "2026-10-26T11:57:02.048Z"
  },
  {
    "id": "4edda6db-9985-4f71-b63a-dc4373012091",
    "userId": "founder-001",
    "username": "gkbharath",
    "fullName": "GOLLA KUMAR BHARATH",
    "date": "2026-10-26",
    "checkIn": "2026-10-26T02:49:32.924Z",
    "checkOut": "2026-10-26T12:01:42.970Z"
  },
  {
    "id": "d66298c5-4265-4952-96ec-3baa52c8ad6b",
    "userId": "user-003",
    "username": "santhanakumarv",
    "fullName": "SANTHANA KUMAR V",
    "date": "2026-10-26",
    "checkIn": "2026-10-26T02:27:58.495Z",
    "checkOut": "2026-10-26T11:59:30.799Z"
  },
  {
    "id": "083fa447-7f56-4d22-a256-32e59af7506d",
    "userId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69",
    "username": "sabir",
    "fullName": "SABIR MOHAMMED S",
    "date": "2026-10-19",
    "checkIn": "2026-10-19T03:59:09.529Z",
    "checkOut": "2026-10-19T11:49:37.533Z"
  },
  {
    "id": "c000a4fa-41ff-4297-a084-bb3d55b841fb",
    "userId": "SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01",
    "username": "mathi",
    "fullName": "MATHIYAZHAGAN D",
    "date": "2026-10-19",
    "checkIn": "2026-10-19T03:48:14.699Z",
    "checkOut": null
  },
  {
    "id": "36000a88-7cc0-424c-a9a7-2ff37cbf2f29",
    "userId": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3",
    "username": "vishnuu",
    "fullName": "VISHNU VARSHINI M",
    "date": "2026-10-19",
    "checkIn": "2026-10-19T03:46:45.319Z",
    "checkOut": "2026-10-19T11:37:04.927Z"
  },
  {
    "id": "59d0ecde-c5a0-467e-acd9-34f4f2f65fca",
    "userId": "user-002",
    "username": "hareeshv",
    "fullName": "HAREESH V",
    "date": "2026-10-19",
    "checkIn": "2026-10-19T03:44:52.669Z",
    "checkOut": null
  },
  {
    "id": "4e199962-19c9-45b2-93eb-52c0e3cb7cc7",
    "userId": "founder-001",
    "username": "gkbharath",
    "fullName": "GOLLA KUMAR BHARATH",
    "date": "2026-10-19",
    "checkIn": "2026-10-19T02:11:01.626Z",
    "checkOut": "2026-10-19T10:59:43.543Z"
  },
  {
    "id": "040ef418-56fb-421d-9f20-e12495b4affb",
    "userId": "user-003",
    "username": "santhanakumarv",
    "fullName": "SANTHANA KUMAR V",
    "date": "2026-10-19",
    "checkIn": "2026-10-19T02:01:44.423Z",
    "checkOut": null
  },
  {
    "id": "36038cff-e5a7-4986-bb1c-eb57a1e4c1af",
    "userId": "founder-001",
    "username": "gkbharath",
    "fullName": "GOLLA KUMAR BHARATH",
    "date": "2026-10-18",
    "checkIn": "2026-10-18T06:54:46.309Z",
    "checkOut": "2026-10-18T06:54:51.514Z"
  },
  {
    "id": "5927cd18-435a-487a-bfe2-30dfa3e4e441",
    "userId": "user-002",
    "username": "hareeshv",
    "fullName": "HAREESH V",
    "date": "2026-10-18",
    "checkIn": "2026-10-18T06:31:24.868Z",
    "checkOut": null
  },
  {
    "id": "ab21157d-3eb6-4637-8e44-2de4e89c713d",
    "userId": "user-003",
    "username": "santhanakumarv",
    "fullName": "SANTHANA KUMAR V",
    "date": "2026-10-18",
    "checkIn": "2026-10-18T04:00:25.834Z",
    "checkOut": null
  },
  {
    "id": "a2f65e0f-81b5-4486-9eb2-ddc99c602cca",
    "userId": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69",
    "username": "sabir",
    "fullName": "SABIR MOHAMMED S",
    "date": "2026-10-18",
    "checkIn": "2026-10-18T03:55:41.608Z",
    "checkOut": "2026-10-18T07:08:57.034Z"
  }
];

let inMemoryAttendance: AttendanceRecord[] = [...defaultAttendance];

export async function syncAttendanceWithDb(): Promise<AttendanceRecord[]> {
  const pool = getPool();
  if (!pool) return readDB();

  try {
    await initDatabase();
    const res = await pool.query('SELECT * FROM attendance ORDER BY date DESC, check_in DESC');
    if (res && res.rows && res.rows.length > 0) {
      const dbRecords: AttendanceRecord[] = res.rows.map((r: any) => ({
        id: r.id,
        userId: r.user_id,
        username: r.username,
        fullName: r.full_name,
        date: r.date,
        checkIn: r.check_in,
        checkOut: r.check_out,
      }));
      for (const rec of dbRecords) {
        const idx = inMemoryAttendance.findIndex((a) => a.id === rec.id);
        if (idx !== -1) {
          inMemoryAttendance[idx] = rec;
        } else {
          inMemoryAttendance.push(rec);
        }
      }
    } else {
      // Auto-seed file attendance if new database is empty
      const localAttendance = readDB();
      for (const rec of localAttendance) {
        await saveAttendanceToPostgres(rec);
      }
    }
  } catch (err) {
    console.warn('[ATTENDANCE-DB] Failed to sync attendance from Supabase:', err);
  }
  return inMemoryAttendance;
}

export async function saveAttendanceToPostgres(rec: AttendanceRecord): Promise<void> {
  const pool = getPool();
  if (!pool) return;

  try {
    await initDatabase();
    await pool.query(`
      INSERT INTO attendance (id, user_id, username, full_name, date, check_in, check_out)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      ON CONFLICT (id) DO UPDATE SET
        check_out = EXCLUDED.check_out;
    `, [
      rec.id,
      rec.userId,
      rec.username,
      rec.fullName,
      rec.date,
      rec.checkIn,
      rec.checkOut || null,
    ]);
  } catch (err) {
    console.error('[ATTENDANCE-DB] Failed to persist attendance to Supabase:', err);
  }
}

function readDB(): AttendanceRecord[] {
  try {
    if (!fs.existsSync(DB_FILE)) return inMemoryAttendance;
    const records: unknown = JSON.parse(fs.readFileSync(DB_FILE, 'utf8'));
    if (!Array.isArray(records)) return inMemoryAttendance;
    if (inMemoryAttendance.length === 0 && records.length > 0) {
      inMemoryAttendance = records as AttendanceRecord[];
    }
    return records as AttendanceRecord[];
  } catch (err) {
    console.warn('Error reading attendance DB, using in-memory store:', err);
    return inMemoryAttendance;
  }
}

function writeDB(records: AttendanceRecord[]) {
  inMemoryAttendance = records;
  try {
    const dir = path.dirname(DB_FILE);
    if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
    fs.writeFileSync(DB_FILE, JSON.stringify(records, null, 2));
  } catch (err) {
    console.warn('Filesystem read-only, saved attendance to in-memory store:', err);
  }
}

export function getAttendanceForUser(userId: string, username?: string): AttendanceRecord[] {
  readDB();
  return inMemoryAttendance
    .filter((record) => record.userId === userId || (username && record.username?.toLowerCase() === username.toLowerCase()))
    .sort((a, b) => b.date.localeCompare(a.date));
}

export function recordAttendance(
  user: { id: string; username: string; fullName: string },
  date: string,
  action: 'check-in' | 'check-out'
): AttendanceRecord {
  const records = readDB();
  const existing = records.find((record) => record.userId === user.id && record.date === date);
  if (action === 'check-in') {
    if (existing) throw new Error('You have already checked in today');
    const record: AttendanceRecord = {
      id: randomUUID(),
      userId: user.id,
      username: user.username,
      fullName: user.fullName,
      date,
      checkIn: new Date().toISOString(),
    };
    records.unshift(record);
    writeDB(records);
    saveAttendanceToPostgres(record).catch(() => {});
    return record;
  }
  if (!existing) throw new Error('Check in before checking out');
  if (existing.checkOut) throw new Error('You have already checked out today');
  existing.checkOut = new Date().toISOString();
  writeDB(records);
  saveAttendanceToPostgres(existing).catch(() => {});
  return existing;
}
