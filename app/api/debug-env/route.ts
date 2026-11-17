import { NextResponse } from 'next/server';
import { Pool } from 'pg';

export async function GET() {
  const rawUrl = process.env.DATABASE_URL;

  if (!rawUrl) {
    return NextResponse.json({
      configured: false,
      message: 'DATABASE_URL is not set on Netlify!',
    });
  }

  // Extract credentials from rawUrl
  const match = rawUrl.match(/^(postgres(?:ql)?:\/\/)([^:]+):([^@]+)@([^:/]+)(?::(\d+))?\/(.*)$/);
  if (!match) {
    return NextResponse.json({
      configured: true,
      error: 'Cannot parse DATABASE_URL format',
    });
  }

  const [, protocol, user, password, host, port, dbname] = match;
  const projectRef = host.includes('supabase.co') 
    ? host.split('.')[1] 
    : (user.includes('.') ? user.split('.')[1] : 'lxzcyvhdaqoqmywfoqhl');
  
  const poolerUser = user.includes('.') ? user : `postgres.${projectRef}`;

  // Test candidates
  const candidates = [
    { name: 'ap-south-1:6543 (Mumbai Pooler)', host: 'aws-0-ap-south-1.pooler.supabase.com', port: 6543 },
    { name: 'ap-south-1:5432 (Mumbai Session)', host: 'aws-0-ap-south-1.pooler.supabase.com', port: 5432 },
    { name: 'ap-southeast-1:6543 (Singapore Pooler)', host: 'aws-0-ap-southeast-1.pooler.supabase.com', port: 6543 },
    { name: 'ap-southeast-1:5432 (Singapore Session)', host: 'aws-0-ap-southeast-1.pooler.supabase.com', port: 5432 },
    { name: 'ap-northeast-1:6543 (Tokyo Pooler)', host: 'aws-0-ap-northeast-1.pooler.supabase.com', port: 6543 },
    { name: 'us-east-1:6543 (US East Pooler)', host: 'aws-0-us-east-1.pooler.supabase.com', port: 6543 },
    { name: 'eu-central-1:6543 (Frankfurt Pooler)', host: 'aws-0-eu-central-1.pooler.supabase.com', port: 6543 },
  ];

  const results: any[] = [];
  let successfulCandidate: any = null;
  let sampleUsers: any[] = [];

  for (const c of candidates) {
    const testUrl = `${protocol}${poolerUser}:${password}@${c.host}:${c.port}/${dbname}`;
    const p = new Pool({
      connectionString: testUrl,
      ssl: { rejectUnauthorized: false },
      connectionTimeoutMillis: 5000,
    });

    try {
      const q = await p.query('SELECT count(*) as cnt FROM users');
      const count = Number(q.rows[0]?.cnt || 0);
      const userList = await p.query('SELECT id, username, full_name, role FROM users ORDER BY created_at ASC');
      results.push({ name: c.name, connected: true, userCount: count });
      successfulCandidate = c;
      sampleUsers = userList.rows;
      await p.end();
      break; // Found the working one!
    } catch (err: any) {
      results.push({ name: c.name, connected: false, error: err.message });
      await p.end().catch(() => {});
    }
  }

  return NextResponse.json({
    projectRef,
    poolerUser,
    activeUrlConfigured: rawUrl.replace(/:([^:@]+)@/, ':****@'),
    successfulCandidate,
    sampleUsers,
    candidateProbes: results,
  });
}
