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

  const match = rawUrl.match(/^(postgres(?:ql)?:\/\/)([^:]+):([^@]+)@([^:/]+)(?::(\d+))?\/(.*)$/);
  if (!match) {
    return NextResponse.json({ error: 'Cannot parse DATABASE_URL' });
  }

  const [, protocol, user, password, host, port, dbname] = match;
  const projectRef = host.includes('supabase.co') 
    ? host.split('.')[1] 
    : (user.includes('.') ? user.split('.')[1] : 'lxzcyvhdaqoqmywfoqhl');
  
  const poolerUser = user.includes('.') ? user : `postgres.${projectRef}`;

  const candidates = [
    { name: 'ap-south-1:6543', host: 'aws-0-ap-south-1.pooler.supabase.com', port: 6543 },
    { name: 'ap-south-1:5432', host: 'aws-0-ap-south-1.pooler.supabase.com', port: 5432 },
    { name: 'ap-southeast-1:6543', host: 'aws-0-ap-southeast-1.pooler.supabase.com', port: 6543 },
  ];

  const results: any[] = [];
  let successfulCandidate: any = null;

  for (const c of candidates) {
    const testUrl = `${protocol}${poolerUser}:${password}@${c.host}:${c.port}/${dbname}`;
    const p = new Pool({
      connectionString: testUrl,
      ssl: { rejectUnauthorized: false },
      connectionTimeoutMillis: 2500,
    });

    try {
      const q = await p.query('SELECT count(*) as cnt FROM users');
      results.push({ name: c.name, connected: true, userCount: Number(q.rows[0]?.cnt || 0) });
      successfulCandidate = c;
      await p.end();
      break;
    } catch (err: any) {
      results.push({ name: c.name, connected: false, error: err.message });
      await p.end().catch(() => {});
    }
  }

  return NextResponse.json({
    activeConfigured: rawUrl.replace(/:([^:@]+)@/, ':****@'),
    successfulCandidate,
    candidateProbes: results,
  });
}
