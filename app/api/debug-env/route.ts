import { NextResponse } from 'next/server';
import { getPool, resolveConnectionString } from '@/lib/db';

export async function GET() {
  const rawUrl = process.env.DATABASE_URL;

  if (!rawUrl) {
    return NextResponse.json({
      configured: false,
      message: 'DATABASE_URL environment variable is completely missing or empty on Netlify!',
    });
  }

  // Mask password for safety
  const maskedUrl = rawUrl.replace(/:([^:@]+)@/, ':****@');
  const resolved = resolveConnectionString(rawUrl);
  const maskedResolved = resolved.replace(/:([^:@]+)@/, ':****@');

  const pool = getPool();
  if (!pool) {
    return NextResponse.json({
      configured: true,
      maskedUrl,
      error: 'getPool() returned null',
    });
  }

  try {
    const res = await pool.query('SELECT id, username, full_name, role, status FROM users ORDER BY created_at ASC');
    return NextResponse.json({
      configured: true,
      maskedUrl,
      maskedResolved,
      connected: true,
      dbUserCount: res.rows.length,
      users: res.rows,
    });
  } catch (err: any) {
    return NextResponse.json({
      configured: true,
      maskedUrl,
      maskedResolved,
      connected: false,
      errorName: err.name,
      errorMessage: err.message,
      errorCode: err.code,
    });
  }
}
