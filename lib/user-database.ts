// Simple in-memory user storage with PostgreSQL / Supabase synchronization
import { getPool, initDatabase } from './db';

// Persist the current in-memory users array to the JSON file.
// Uses require() to avoid circular-import issues with user-db.ts.
function persistToDisk(): void {
  try {
    const { saveUsersToDB } = require('./user-db');
    saveUsersToDB(users);
  } catch (err) {
    console.error('[USER-DB] Failed to persist users to disk:', err);
  }
}

// Map database row (snake_case) to StoredUser (camelCase)
function mapRowToUser(row: any): StoredUser {
  return {
    id: row.id,
    employeeId: row.employee_id,
    username: row.username,
    email: row.email,
    passwordHash: row.password_hash,
    role: row.role,
    employmentType: row.employment_type,
    fullName: row.full_name,
    phone: row.phone,
    profilePhoto: row.profile_photo,
    profilePictureUploaded: !!row.profile_photo,
    designation: row.designation,
    department: row.department,
    guideId: row.guide_id,
    guideName: row.guide_name,
    status: row.status,
    mustChangePassword: row.must_change_password,
    sessionVersion: row.session_version,
    approvalStage: row.approval_stage,
    registrationApprovalVersion: row.registration_approval_version,
    approvalHistory: typeof row.approval_history === 'string' ? JSON.parse(row.approval_history) : (row.approval_history || []),
    approvalRemarks: row.approval_remarks,
    approvedAt: row.approved_at,
    requestedAt: row.requested_at,
    createdAt: row.created_at,
    emailVerified: row.email_verified,
    verificationToken: row.verification_token,
    resetToken: row.reset_token,
    resetTokenExpiresAt: row.reset_token_expires_at,
    isProfileCompleted: row.is_profile_completed,
  };
}

// Synchronize all users from Supabase into memory
export async function syncUsersWithDb(): Promise<StoredUser[]> {
  const pool = getPool();
  if (!pool) return users;

  try {
    await initDatabase();
    const res = await pool.query('SELECT * FROM users ORDER BY created_at ASC');
    if (res && res.rows && res.rows.length > 0) {
      const dbUsers = res.rows.map(mapRowToUser);
      // Merge with default/memory users to ensure no lost records
      for (const dUser of dbUsers) {
        const idx = users.findIndex((u) => u.id === dUser.id || u.username.toLowerCase() === dUser.username.toLowerCase());
        if (idx !== -1) {
          users[idx] = dUser;
        } else {
          users.push(dUser);
        }
      }
      console.log(`[USER-DB] Successfully synchronized ${users.length} users from Supabase`);
    } else {
      // Database is empty (e.g. brand new Supabase project) - auto-seed initial users
      for (const u of users) {
        await saveUserToPostgres(u);
      }
      console.log(`[USER-DB] Auto-seeded new Supabase database with ${users.length} users`);
    }
  } catch (err) {
    console.warn('[USER-DB] Failed to sync users from Supabase, using memory store:', err);
  }
  return users;
}

// Save a single user to Supabase PostgreSQL
export async function saveUserToPostgres(user: StoredUser): Promise<void> {
  const pool = getPool();
  if (!pool) return;

  try {
    await initDatabase();
    await pool.query(`
      INSERT INTO users (
        id, employee_id, username, email, password_hash, role, employment_type,
        full_name, phone, profile_photo, designation, department, guide_id, guide_name,
        status, must_change_password, session_version, approval_stage,
        registration_approval_version, approval_history, approval_remarks, approved_at,
        requested_at, created_at, email_verified, verification_token,
        reset_token, reset_token_expires_at, is_profile_completed
      ) VALUES (
        $1, $2, $3, $4, $5, $6, $7,
        $8, $9, $10, $11, $12, $13, $14,
        $15, $16, $17, $18,
        $19, $20, $21, $22,
        $23, $24, $25, $26,
        $27, $28, $29
      )
      ON CONFLICT (id) DO UPDATE SET
        employee_id = EXCLUDED.employee_id,
        username = EXCLUDED.username,
        email = EXCLUDED.email,
        password_hash = EXCLUDED.password_hash,
        role = EXCLUDED.role,
        employment_type = EXCLUDED.employment_type,
        full_name = EXCLUDED.full_name,
        phone = EXCLUDED.phone,
        profile_photo = EXCLUDED.profile_photo,
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
        verification_token = EXCLUDED.verification_token,
        reset_token = EXCLUDED.reset_token,
        reset_token_expires_at = EXCLUDED.reset_token_expires_at,
        is_profile_completed = EXCLUDED.is_profile_completed;
    `, [
      user.id,
      user.employeeId || null,
      user.username,
      user.email,
      user.passwordHash,
      user.role,
      user.employmentType || 'full-time',
      user.fullName,
      user.phone || null,
      user.profilePhoto || null,
      user.designation || 'User',
      user.department || null,
      user.guideId || null,
      user.guideName || null,
      user.status || 'pending_approval',
      user.mustChangePassword || false,
      user.sessionVersion || 0,
      user.approvalStage || 0,
      user.registrationApprovalVersion || 3,
      JSON.stringify(user.approvalHistory || []),
      user.approvalRemarks || null,
      user.approvedAt || null,
      user.requestedAt || user.createdAt || new Date().toISOString(),
      user.createdAt || new Date().toISOString(),
      user.emailVerified || false,
      user.verificationToken || null,
      user.resetToken || null,
      user.resetTokenExpiresAt || null,
      user.isProfileCompleted || false,
    ]);
  } catch (err) {
    console.error('[USER-DB] Failed to persist user to Supabase:', err);
  }
}

// Delete user from Supabase PostgreSQL
export async function deleteUserFromPostgres(userId: string): Promise<void> {
  const pool = getPool();
  if (!pool) return;
  try {
    await initDatabase();
    await pool.query('DELETE FROM users WHERE id = $1', [userId]);
  } catch (err) {
    console.error('[USER-DB] Failed to delete user from Supabase:', err);
  }
}

export interface StoredUser {
  id: string;
  employeeId?: string;
  username: string;
  email: string;
  passwordHash: string;
  // Role is now the primary role; employmentType is optional for part/full-time
  role:
    | 'founder'
    | 'managing-partner'
    | 'admin'
    | 'employee'
    | 'freelancer'
    | 'senior-freelancer'
    | 'intern'
    | 'project-intern'
    | 'guest'
    | 'user';
  employmentType?: 'full-time' | 'part-time';
  fullName: string;
  phone?: string;
  profilePhoto?: string;
  profilePictureUploaded?: boolean;
  designation?: string;
  department?: string;
  guideId?: string;
  guideName?: string;
  status?: 'pending_approval' | 'active' | 'rejected' | 'suspended';
  mustChangePassword?: boolean;
  sessionVersion?: number;
  requestedAt?: string;
  approvalStage?: number;
  registrationApprovalVersion?: number;
  approvalHistory?: Array<{
    actorId: string;
    actorUsername: string;
    actorRole: string;
    decision: 'approve' | 'deny';
    remarks: string;
    createdAt: string;
  }>;
  approvalRemarks?: string;
  approvedAt?: string;
  rejectedAt?: string;
  emailVerified?: boolean;
  verificationToken?: string;
  verificationSentAt?: string;
  resetToken?: string;
  resetTokenExpiresAt?: string;
  createdAt: string;
  isProfileCompleted?: boolean;
  profileCompletedAt?: string;
  selectedRole?: string;
}

const defaultUsers: StoredUser[] = [
  {
    "id": "founder-001",
    "employeeId": "MIB01",
    "username": "gkbharath",
    "email": "gollakumarbharath@suryas.in",
    "passwordHash": "$2b$10$Ba/u/FCErcSKaqGZ2KR0y.G1OijRFl5nugGPkz/HT4OHr97X6rOy6",
    "role": "founder",
    "employmentType": "full-time",
    "fullName": "GOLLA KUMAR BHARATH",
    "phone": "8124227370",
    "designation": "Founder & Chief Executive Partner",
    "department": "Executive Management Team",
    "profilePictureUploaded": false,
    "status": "active",
    "mustChangePassword": false,
    "sessionVersion": 0,
    "emailVerified": true,
    "isProfileCompleted": true,
    "createdAt": "2026-11-16 06:12:10.866144+00:00",
    "approvedAt": "2026-11-16 06:12:10.866144+00:00"
  },
  {
    "id": "admin-002",
    "employeeId": "MIB02",
    "username": "hareeshv",
    "email": "hareeshv@suryas.in",
    "passwordHash": "$2b$10$Ba/u/FCErcSKaqGZ2KR0y.G1OijRFl5nugGPkz/HT4OHr97X6rOy6",
    "role": "managing-partner",
    "employmentType": "full-time",
    "fullName": "HAREESH V",
    "phone": "6383014533",
    "designation": "Managing Partner - Projects & Administration",
    "department": "Executive Management Team",
    "profilePictureUploaded": false,
    "status": "active",
    "mustChangePassword": false,
    "sessionVersion": 1,
    "emailVerified": true,
    "isProfileCompleted": true,
    "createdAt": "2026-11-16 06:12:10.866144+00:00",
    "approvedAt": "2026-11-16 06:12:10.866144+00:00"
  },
  {
    "id": "admin-003",
    "employeeId": "MIB03",
    "username": "santhanakumarv",
    "email": "santhanakumarv@suryas.in",
    "passwordHash": "$2b$10$Ba/u/FCErcSKaqGZ2KR0y.G1OijRFl5nugGPkz/HT4OHr97X6rOy6",
    "role": "managing-partner",
    "employmentType": "full-time",
    "fullName": "SANTHANA KUMAR V",
    "phone": "7010353723",
    "designation": "Managing Partner - Operations & Business Development",
    "department": "Executive Management Team",
    "profilePictureUploaded": false,
    "status": "active",
    "mustChangePassword": false,
    "sessionVersion": 0,
    "emailVerified": true,
    "isProfileCompleted": true,
    "createdAt": "2026-11-16 06:12:10.866144+00:00",
    "approvedAt": "2026-11-16 06:12:10.866144+00:00"
  },
  {
    "id": "admin-007",
    "employeeId": "MIB10",
    "username": "nagarajkaids0410",
    "email": "nagarajkaids0410@gmail.com",
    "passwordHash": "$2b$10$Ba/u/FCErcSKaqGZ2KR0y.G1OijRFl5nugGPkz/HT4OHr97X6rOy6",
    "role": "admin",
    "employmentType": "full-time",
    "fullName": "Nagaraj K",
    "phone": "",
    "designation": "Not Set",
    "department": "",
    "profilePictureUploaded": false,
    "status": "active",
    "mustChangePassword": false,
    "sessionVersion": 0,
    "emailVerified": true,
    "isProfileCompleted": true,
    "createdAt": "2026-11-16 06:12:10.866144+00:00",
    "approvedAt": "2026-11-16 06:12:10.866144+00:00"
  },
  {
    "id": "SMIB-EMP-cb29066e-397b-4d3d-bd88-04ee5d654d69",
    "employeeId": "MIB04",
    "username": "sabir",
    "email": "sabirmohammeds@suryas.in",
    "passwordHash": "$2b$12$5rSLrHKbwwhsWFyQfuJku.JMXUIKNwtk7iAu5Ge.edTLiMYeZDH3S",
    "role": "employee",
    "employmentType": "full-time",
    "fullName": "SABIR MOHAMMED S",
    "phone": "8754479660",
    "designation": "PCB Fabrication Engineer",
    "department": "PCB Designs & Fabrication Team",
    "profilePictureUploaded": false,
    "status": "active",
    "mustChangePassword": false,
    "sessionVersion": 36,
    "emailVerified": true,
    "isProfileCompleted": true,
    "createdAt": "2026-10-17 12:58:52.238000+00:00",
    "approvedAt": "2026-10-17 13:02:13.911000+00:00"
  },
  {
    "id": "SMIB-EMP-5c6151ea-f197-40ad-9eb4-69cc3e1cd5e3",
    "employeeId": "MIB05",
    "username": "vishnuu",
    "email": "pcb.designers@suryas.in",
    "passwordHash": "$2b$12$OOlRAOPfYz2S/rK6ti/CMe8.vEgndxBWy0ijDISF8Gz2mE1xnJ76S",
    "role": "employee",
    "employmentType": "full-time",
    "fullName": "VISHNU VARSHINI M",
    "phone": "6380551370",
    "designation": "PCB & EMS/IoT Designer-T",
    "department": "PCB Designs & Fabrication Team",
    "profilePictureUploaded": false,
    "status": "active",
    "mustChangePassword": false,
    "sessionVersion": 9,
    "emailVerified": true,
    "isProfileCompleted": true,
    "createdAt": "2026-10-17 16:48:15.424000+00:00",
    "approvedAt": "2026-10-17 16:50:21.073000+00:00"
  },
  {
    "id": "SMIB-EMP-ece437f0-46b4-4c26-acda-c6164dadef01",
    "employeeId": "MIB06",
    "username": "mathi",
    "email": "mathiyazhagandhanapalmathiyazh@gmail.com",
    "passwordHash": "$2b$10$SEhLmBDf7eUL.75GGMkBq.wljmE6L2Zw6piUB3Nrp36QKxFzEJtui",
    "role": "intern",
    "employmentType": "full-time",
    "fullName": "MATHIYAZHAGAN D",
    "phone": "8056197704",
    "designation": "PCB Design Intern",
    "department": "PCB Designs & Fabrication Team",
    "profilePictureUploaded": false,
    "status": "active",
    "mustChangePassword": false,
    "sessionVersion": 7,
    "emailVerified": true,
    "isProfileCompleted": true,
    "createdAt": "2026-10-18 04:04:57.266000+00:00",
    "approvedAt": "2026-10-18 04:07:32.294000+00:00"
  },
  {
    "id": "SMIB-EMP-8cc825a5-7d82-43b1-accf-684074846929",
    "employeeId": "MIB07",
    "username": "nidhi",
    "email": "admin@hearthaxor.in",
    "passwordHash": "$2b$12$BjUBn5Csm8X01AUfHjhOquBEhqYPvM1UWeKrBhTVCVfFk/g7D4bjO",
    "role": "user",
    "employmentType": "part-time",
    "fullName": "NIDHI TIWARI",
    "phone": "8148636158",
    "designation": "AI Engineer - C",
    "department": "Software Team",
    "profilePictureUploaded": false,
    "status": "active",
    "mustChangePassword": false,
    "sessionVersion": 0,
    "emailVerified": true,
    "isProfileCompleted": true,
    "createdAt": "2026-10-19 10:01:58.271000+00:00",
    "approvedAt": "2026-10-19 10:01:58.271000+00:00"
  },
  {
    "id": "SMIB-EMP-26f786a8-f668-447c-996c-b5e875867e13",
    "employeeId": "MIB08",
    "username": "smrithik",
    "email": "smrithik2005@gmail.com",
    "passwordHash": "$2b$12$89QW8XMKF4.VE24ohksrV.ErcyUTltZqNduOpa0S4jgowyQc8i27q",
    "role": "intern",
    "employmentType": "full-time",
    "fullName": "SMRITHI K",
    "phone": "8610492864",
    "designation": "PCB Design Intern",
    "department": "PCB Designs & Fabrication Team",
    "profilePictureUploaded": false,
    "status": "active",
    "mustChangePassword": false,
    "sessionVersion": 0,
    "emailVerified": true,
    "isProfileCompleted": true,
    "createdAt": "2026-10-19 10:14:47.293000+00:00",
    "approvedAt": "2026-10-19 10:14:47.293000+00:00"
  },
  {
    "id": "SMIB-EMP-e861d360-f148-4f68-afbc-c479ae09febb",
    "employeeId": "MIB09",
    "username": "rithanyad",
    "email": "rithanya07cbe@gmail.com",
    "passwordHash": "$2b$12$6kZ5J6s60NFa4AYSqj8SDea0qq3GqETMJjxMKYYDd9Rtp7igG8l5O",
    "role": "intern",
    "employmentType": "full-time",
    "fullName": "RITHANYA D",
    "phone": "9384304331",
    "designation": "PCB Design Intern",
    "department": "PCB Designs & Fabrication Team",
    "profilePictureUploaded": false,
    "status": "active",
    "mustChangePassword": false,
    "sessionVersion": 0,
    "emailVerified": true,
    "isProfileCompleted": true,
    "createdAt": "2026-10-19 10:17:39.102000+00:00",
    "approvedAt": "2026-10-19 10:17:39.102000+00:00"
  },
  {
    "id": "SMIB-EMP-ba45b474-f583-4802-af93-26555c8c6b72",
    "employeeId": "MIB04",
    "username": "kumar",
    "email": "nagarajmsdraj@gmail.com",
    "passwordHash": "$2b$10$Ba/u/FCErcSKaqGZ2KR0y.G1OijRFl5nugGPkz/HT4OHr97X6rOy6",
    "role": "intern",
    "employmentType": "full-time",
    "fullName": "Kumar",
    "phone": "",
    "designation": "Intern",
    "department": "",
    "profilePictureUploaded": false,
    "status": "active",
    "mustChangePassword": false,
    "sessionVersion": 2,
    "emailVerified": true,
    "isProfileCompleted": true,
    "createdAt": "2026-11-16 08:58:19.187347+00:00",
    "approvedAt": "2026-11-16 09:15:11.928000+00:00"
  },
  {
    "id": "SMIB-EMP-4dbc0097-2c05-42d3-b7c9-8a8530045d8a",
    "employeeId": "MIB05",
    "username": "kumar04",
    "email": "nagarajnk0413@gmail.com",
    "passwordHash": "$2b$10$qC0KNDf/191mu16A.5wPGuD1DFp5AxsI1ryfUdnlRSGwOH7YZQapO",
    "role": "intern",
    "employmentType": "part-time",
    "fullName": "Kumar",
    "phone": "",
    "designation": "Not Set",
    "department": "",
    "profilePictureUploaded": false,
    "status": "active",
    "mustChangePassword": false,
    "sessionVersion": 2,
    "emailVerified": true,
    "isProfileCompleted": true,
    "createdAt": "2026-11-16 09:14:44.469000+00:00",
    "approvedAt": "2026-11-16 09:15:17.181000+00:00"
  }
];

// Initialize from file DB or use defaults
function initializeUsers(): StoredUser[] {
  try {
    const { loadUsersFromDB } = require('./user-db');
    const loaded = loadUsersFromDB();
    if (loaded && loaded.length > 0) {
      console.log('[USER-DB-INIT] Loaded', loaded.length, 'users from file DB');
      return loaded;
    }
  } catch (err) {
    console.log('[USER-DB-INIT] Could not load from file, using defaults');
  }
  return defaultUsers;
}

let users: StoredUser[] = initializeUsers();

export function findUserByUsername(username: string): StoredUser | undefined {
  const normalizedUsername = username.trim().toLowerCase();
  // First check in-memory
  let user = users.find((u) =>
    u.username.toLowerCase() === normalizedUsername ||
    u.email.toLowerCase() === normalizedUsername ||
    u.employeeId?.toLowerCase() === normalizedUsername
  );
  
  // If not found or to ensure we have the latest version, also check file DB
  try {
    const { loadUsersFromDB } = require('./user-db');
    const fileUsers = loadUsersFromDB();
    if (fileUsers && fileUsers.length > 0) {
      const fileUser = fileUsers.find((u: StoredUser) =>
        u.username.toLowerCase() === normalizedUsername ||
        u.email.toLowerCase() === normalizedUsername ||
        u.employeeId?.toLowerCase() === normalizedUsername
      );
      if (fileUser) {
        // Update in-memory with latest from file
        const index = users.findIndex((u) => u.id === fileUser.id);
        if (index !== -1) {
          users[index] = fileUser;
        } else {
          users.push(fileUser);
        }
        return fileUser;
      }
    }
  } catch (err) {
    // Fallback to in-memory
  }
  
  return user;
}

export function findUserById(id: string): StoredUser | undefined {
  // First check in-memory
  let user = users.find((u) => u.id === id);
  
  // If not found or to ensure we have the latest version, also check file DB
  try {
    const { loadUsersFromDB } = require('./user-db');
    const fileUsers = loadUsersFromDB();
    if (fileUsers && fileUsers.length > 0) {
      const fileUser = fileUsers.find((u: StoredUser) => u.id === id);
      if (fileUser) {
        // Update in-memory with latest from file
        const index = users.findIndex((u) => u.id === id);
        if (index !== -1) {
          users[index] = fileUser;
        } else {
          users.push(fileUser);
        }
        return fileUser;
      }
    }
  } catch (err) {
    // Fallback to in-memory
  }
  
  return user;
}

export function findUserByVerificationToken(token: string): StoredUser | undefined {
  // First check in-memory
  let user = users.find((u) => u.verificationToken === token);
  
  // Also check file DB
  try {
    const { loadUsersFromDB } = require('./user-db');
    const fileUsers = loadUsersFromDB();
    if (fileUsers && fileUsers.length > 0) {
      const fileUser = fileUsers.find((u: StoredUser) => u.verificationToken === token);
      if (fileUser) {
        const index = users.findIndex((u) => u.id === fileUser.id);
        if (index !== -1) {
          users[index] = fileUser;
        } else {
          users.push(fileUser);
        }
        return fileUser;
      }
    }
  } catch (err) {
    // Fallback to in-memory
  }
  
  return user;
}

export function findUserByResetToken(token: string): StoredUser | undefined {
  // First check in-memory
  let user = users.find((u) => u.resetToken === token && !!u.resetTokenExpiresAt);
  
  // Also check file DB
  try {
    const { loadUsersFromDB } = require('./user-db');
    const fileUsers = loadUsersFromDB();
    if (fileUsers && fileUsers.length > 0) {
      const fileUser = fileUsers.find((u: StoredUser) => u.resetToken === token && !!u.resetTokenExpiresAt);
      if (fileUser) {
        const index = users.findIndex((u) => u.id === fileUser.id);
        if (index !== -1) {
          users[index] = fileUser;
        } else {
          users.push(fileUser);
        }
        return fileUser;
      }
    }
  } catch (err) {
    // Fallback to in-memory
  }
  
  return user;
}

export function addUser(user: StoredUser): StoredUser {
  users.push(user);
  persistToDisk();
  saveUserToPostgres(user).catch(() => {});
  return user;
}

export function getAllUsers(): StoredUser[] {
  return users;
}

export function getPendingUsers(): StoredUser[] {
  console.log('[getPendingUsers] Total users in DB:', users.length);
  users.forEach(u => console.log('  - User:', u.username, 'Status:', u.status));
  const pending = users.filter((u) => u.status === 'pending_approval');
  console.log('[getPendingUsers] Pending users found:', pending.length);
  return pending;
}

export function isUsernameTaken(username: string): boolean {
  return !!findUserByUsername(username);
}

export function approveUser(userId: string, username?: string, passwordHash?: string, updates?: Partial<StoredUser>): StoredUser | undefined {
  const index = users.findIndex((u) => u.id === userId);
  if (index !== -1) {
    users[index] = {
      ...users[index],
      username: username || users[index].username,
      passwordHash: passwordHash || users[index].passwordHash,
      status: 'active',
      approvedAt: new Date().toISOString(),
      ...updates,
    };
    persistToDisk();
    saveUserToPostgres(users[index]).catch(() => {});
    return users[index];
  }
  return undefined;
}

export function denyUser(userId: string): boolean {
  const initial = users.length;
  users = users.filter((u) => u.id !== userId);
  if (users.length !== initial) {
    persistToDisk();
    const pool = getPool();
    if (pool) {
      pool.query('DELETE FROM users WHERE id = $1', [userId]).catch(() => {});
    }
    return true;
  }
  return false;
}

export function updateUser(username: string, updates: Partial<StoredUser>): StoredUser | undefined {
  const index = users.findIndex((u) => u.username === username);
  if (index !== -1) {
    users[index] = { ...users[index], ...updates };
    persistToDisk();
    saveUserToPostgres(users[index]).catch(() => {});
    return users[index];
  }
  return undefined;
}

export function updateUserById(userId: string, updates: Partial<StoredUser>): StoredUser | undefined {
  const index = users.findIndex((u) => u.id === userId);
  if (index !== -1) {
    users[index] = { ...users[index], ...updates };
    persistToDisk();
    saveUserToPostgres(users[index]).catch(() => {});
    return users[index];
  }
  return undefined;
}
