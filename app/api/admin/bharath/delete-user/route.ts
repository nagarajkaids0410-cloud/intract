import { NextRequest, NextResponse } from 'next/server';
import { assertBharathAccess, isBharathUser } from '@/lib/bharath-access';
import { findUserById, syncUsersWithDb, denyUser, deleteUserFromPostgres } from '@/lib/user-database';
import { addAuditEntry } from '@/lib/audit-log';

export async function POST(request: NextRequest) {
  return handleDelete(request);
}

export async function DELETE(request: NextRequest) {
  return handleDelete(request);
}

async function handleDelete(request: NextRequest) {
  const auth = await assertBharathAccess(request);
  if (!auth.success) {
    return auth.response;
  }

  let userId: string | null = null;

  try {
    const body = await request.json().catch(() => ({}));
    userId = body.userId;
  } catch {}

  if (!userId) {
    const { searchParams } = new URL(request.url);
    userId = searchParams.get('userId');
  }

  if (!userId || typeof userId !== 'string') {
    return NextResponse.json({ error: 'Valid userId is required' }, { status: 400 });
  }

  await syncUsersWithDb();
  const targetUser = findUserById(userId);

  if (!targetUser) {
    return NextResponse.json({ error: 'User not found in system' }, { status: 404 });
  }

  // Safety safeguard: Cannot delete Bharath's own account
  if (isBharathUser(targetUser) || targetUser.id === auth.bharath.id) {
    return NextResponse.json(
      { error: 'Cannot delete the Founder (Golla Kumar Bharath) account.' },
      { status: 400 }
    );
  }

  // 1. Delete from Supabase PostgreSQL
  await deleteUserFromPostgres(userId);

  // 2. Delete from in-memory and local database
  denyUser(userId);

  // 3. Write audit log entry
  try {
    addAuditEntry({
      action: 'user:deleted',
      actor: auth.bharath.username,
      actorId: auth.bharath.id,
      details: {
        deletedUserId: targetUser.id,
        deletedEmployeeId: targetUser.employeeId,
        deletedUsername: targetUser.username,
        deletedFullName: targetUser.fullName,
        deletedRole: targetUser.role,
      },
    });
  } catch (err) {
    console.error('[DELETE-USER] Failed to write audit log:', err);
  }

  return NextResponse.json({
    success: true,
    message: `Account for ${targetUser.fullName || targetUser.username} has been permanently deleted.`,
  });
}
