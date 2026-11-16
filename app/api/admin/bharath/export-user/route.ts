import { NextRequest, NextResponse } from 'next/server';
import { assertBharathAccess } from '@/lib/bharath-access-server';
import { findUserById, syncUsersWithDb } from '@/lib/user-database';
import { syncAttendanceWithDb } from '@/lib/attendance-db';
import { syncRequestsWithDb } from '@/lib/request-db';
import fs from 'node:fs';
import path from 'node:path';

export async function GET(request: NextRequest) {
  const auth = await assertBharathAccess(request);
  if (!auth.success) {
    return auth.response;
  }

  const { searchParams } = new URL(request.url);
  const userId = searchParams.get('userId');

  if (!userId) {
    return NextResponse.json({ error: 'userId is required' }, { status: 400 });
  }

  await syncUsersWithDb();
  const targetUser = findUserById(userId);

  if (!targetUser) {
    return NextResponse.json({ error: 'User not found' }, { status: 404 });
  }

  // Fetch Attendance for this user
  const allAttendance = await syncAttendanceWithDb();
  const userAttendance = allAttendance.filter((rec) => {
    return (
      rec.userId === targetUser.id ||
      (targetUser.username && rec.username?.toLowerCase() === targetUser.username.toLowerCase()) ||
      (targetUser.fullName && rec.fullName?.toLowerCase() === targetUser.fullName.toLowerCase())
    );
  });

  // Fetch Requests submitted by this user
  const allRequests = await syncRequestsWithDb();
  const userRequests = allRequests.filter((req) => {
    const payload = req.payload || {};
    return (
      req.createdById === targetUser.id ||
      (targetUser.username && req.createdByUsername?.toLowerCase() === targetUser.username.toLowerCase()) ||
      (targetUser.fullName && req.createdBy?.toLowerCase() === targetUser.fullName.toLowerCase()) ||
      (targetUser.employeeId && payload.employeeId === targetUser.employeeId) ||
      (targetUser.employeeId && payload.id === targetUser.employeeId)
    );
  });

  // Fetch Tasks assigned to this user
  let userTasks: any[] = [];
  try {
    const tasksFile = path.join(process.cwd(), '.data', 'tasks.json');
    if (fs.existsSync(tasksFile)) {
      const tasksRaw = JSON.parse(fs.readFileSync(tasksFile, 'utf8'));
      if (Array.isArray(tasksRaw)) {
        userTasks = tasksRaw.filter(
          (t: any) =>
            t.assignedToId === targetUser.id ||
            (targetUser.username && t.assignedToUsername?.toLowerCase() === targetUser.username.toLowerCase())
        );
      }
    }
  } catch (err) {
    console.warn('[EXPORT-USER] Could not read tasks:', err);
  }

  // Strip password hash from exported profile
  const { passwordHash, verificationToken, resetToken, resetTokenExpiresAt, ...safeUser } = targetUser;

  return NextResponse.json({
    success: true,
    data: {
      user: safeUser,
      attendance: userAttendance,
      requests: userRequests,
      tasks: userTasks,
    },
  });
}
