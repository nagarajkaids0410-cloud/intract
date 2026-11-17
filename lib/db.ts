import { Pool } from 'pg';

let pool: Pool | null = null;
let initialized = false;

export function resolveConnectionString(rawUrl: string): string {
  // Direct Supabase connections (db.<project-ref>.supabase.co:5432) are IPv6-only on Free tier.
  // Serverless functions (Netlify / AWS Lambda) do not have IPv6 outbound routing.
  // Transform to the IPv4-compatible Supabase connection pooler host automatically:
  const match = rawUrl.match(/^(postgres(?:ql)?:\/\/)([^:]+):([^@]+)@db\.([a-z0-9]+)\.supabase\.co(?::\d+)?\/(.*)$/);
  if (match) {
    const [, protocol, user, password, projectRef, dbname] = match;
    const poolerUser = user.includes('.') ? user : `${user}.${projectRef}`;
    // If the old project was Tokyo (ap-northeast-1), keep it; otherwise default to Mumbai (ap-south-1)
    const region = projectRef === 'zzgyllrljjzvzpcxcalz' ? 'ap-northeast-1' : 'ap-south-1';
    const poolerHost = `aws-0-${region}.pooler.supabase.com`;
    return `${protocol}${poolerUser}:${password}@${poolerHost}:5432/${dbname}`;
  }
  return rawUrl;
}

export function getPool(): Pool | null {
  const rawUrl = process.env.DATABASE_URL;
  if (!rawUrl) return null;

  const connectionString = resolveConnectionString(rawUrl);

  if (!pool) {
    pool = new Pool({
      connectionString,
      ssl: {
        rejectUnauthorized: false,
      },
      max: 5,
      idleTimeoutMillis: 30000,
      connectionTimeoutMillis: 10000,
    });

    pool.on('error', (err) => {
      console.error('[DATABASE] Unexpected error on idle client:', err);
    });
  }

  return pool;
}

export async function query(text: string, params?: any[]) {
  const p = getPool();
  if (!p) return null;
  return p.query(text, params);
}

export async function initDatabase() {
  if (initialized) return;
  const p = getPool();
  if (!p) return;

  try {
    await p.query(`
      CREATE TABLE IF NOT EXISTS users (
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
    `);

    const columnMigrations = [
      'ALTER TABLE users ADD COLUMN IF NOT EXISTS requested_at TIMESTAMPTZ',
      'ALTER TABLE users ADD COLUMN IF NOT EXISTS email_verified BOOLEAN DEFAULT FALSE',
      'ALTER TABLE users ADD COLUMN IF NOT EXISTS verification_token TEXT',
      'ALTER TABLE users ADD COLUMN IF NOT EXISTS reset_token TEXT',
      'ALTER TABLE users ADD COLUMN IF NOT EXISTS reset_token_expires_at TIMESTAMPTZ',
      'ALTER TABLE users ADD COLUMN IF NOT EXISTS is_profile_completed BOOLEAN DEFAULT FALSE',
      "ALTER TABLE requests ADD COLUMN IF NOT EXISTS target TEXT DEFAULT 'admin'",
      'ALTER TABLE requests ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ',
    ];

    for (const stmt of columnMigrations) {
      try {
        await p.query(stmt);
      } catch {}
    }

    await p.query(`
      CREATE TABLE IF NOT EXISTS requests (
        id TEXT PRIMARY KEY,
        submission_id TEXT,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending',
        created_by TEXT NOT NULL,
        created_by_id TEXT NOT NULL,
        created_by_username TEXT NOT NULL,
        created_at TIMESTAMPTZ DEFAULT NOW(),
        payload JSONB DEFAULT '{}'::jsonb
      );

      CREATE TABLE IF NOT EXISTS attendance (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        username TEXT NOT NULL,
        full_name TEXT NOT NULL,
        date TEXT NOT NULL,
        check_in TIMESTAMPTZ NOT NULL,
        check_out TIMESTAMPTZ
      );

      CREATE TABLE IF NOT EXISTS notifications (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        target_user TEXT NOT NULL,
        related_id TEXT,
        read BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMPTZ DEFAULT NOW()
      );
    `);

    // Check if initial users exist, if not seed them
    const res = await p.query('SELECT COUNT(*) FROM users');
    if (res.rows[0]?.count === '0') {
      await p.query(`
        INSERT INTO users (id, employee_id, username, email, password_hash, role, full_name, designation, status, must_change_password, created_at)
        VALUES 
          ('founder-001', 'MIB01', 'gkbharath', 'gollakumarbharath@suryas.in', '$2b$10$Ba/u/FCErcSKaqGZ2KR0y.G1OijRFl5nugGPkz/HT4OHr97X6rOy6', 'founder', 'GOLLA KUMAR BHARATH', 'Founder & Chief Executive Partner', 'active', FALSE, NOW()),
          ('admin-002', 'MIB02', 'hareeshv', 'hareeshv@suryas.in', '$2b$10$Ba/u/FCErcSKaqGZ2KR0y.G1OijRFl5nugGPkz/HT4OHr97X6rOy6', 'managing-partner', 'HAREESH V', 'Managing Partner - Projects & Administration', 'active', FALSE, NOW()),
          ('admin-003', 'MIB03', 'santhanakumarv', 'santhanakumarv@suryas.in', '$2b$10$Ba/u/FCErcSKaqGZ2KR0y.G1OijRFl5nugGPkz/HT4OHr97X6rOy6', 'managing-partner', 'SANTHANA KUMAR V', 'Managing Partner - Operations & Business Development', 'active', FALSE, NOW()),
          ('admin-007', 'MIB07', 'nagarajkaids0410', 'nagarajkaids0410@gmail.com', '$2b$10$Ba/u/FCErcSKaqGZ2KR0y.G1OijRFl5nugGPkz/HT4OHr97X6rOy6', 'admin', 'Nagaraj K', 'Administrator', 'active', FALSE, NOW())
        ON CONFLICT (username) DO NOTHING;
      `);
      console.log('[DATABASE] Seeded initial permanent admin users in Supabase');
    }

    initialized = true;
    console.log('[DATABASE] Supabase tables verified and initialized');
  } catch (err) {
    console.error('[DATABASE] Failed to initialize Supabase tables:', err);
  }
}
