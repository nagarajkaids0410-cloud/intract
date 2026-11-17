import { NextRequest, NextResponse } from 'next/server';
import { requireRole } from '@/lib/rbac';
import { findUserById } from '@/lib/user-database';
import { getAttendanceForUser, recordAttendance, syncAttendanceWithDb, saveAttendanceToPostgres } from '@/lib/attendance-db';
import { addRequestDB, generateRequestIdentifiers } from '@/lib/request-db';
import { getApprovalChainForUser, RequestItem } from '@/lib/request-store';
import { addNotificationDB } from '@/lib/notification-db';
import { addAuditEntry } from '@/lib/audit-log';

const allowedRoles = [
  'founder', 'managing-partner', 'admin', 'employee', 'freelancer',
  'senior-freelancer', 'intern', 'project-intern', 'user',
] as const;

function indiaDate() {
  return new Intl.DateTimeFormat('en-CA', { timeZone: 'Asia/Kolkata' }).format(new Date());
}

export async function GET(request: NextRequest) {
  const auth = requireRole(request, [...allowedRoles]);
  if (auth instanceof NextResponse) return auth;
  try {
    await syncAttendanceWithDb();
    const records = getAttendanceForUser(auth.id, auth.username);
    return NextResponse.json({ success: true, today: indiaDate(), records });
  } catch (error) {
    console.error('Attendance fetch failed:', error);
    return NextResponse.json({ error: 'Unable to load attendance' }, { status: 500 });
  }
}

export async function POST(request: NextRequest) {
  const auth = requireRole(request, [...allowedRoles]);
  if (auth instanceof NextResponse) return auth;
  try {
    const body = await request.json();
    const user = findUserById(auth.id);
    if (!user || user.status !== 'active') {
      return NextResponse.json({ error: 'An active account is required' }, { status: 403 });
    }

    if (body.action === 'check-in' || body.action === 'check-out') {
      const attendance = recordAttendance(user, indiaDate(), body.action);
      await saveAttendanceToPostgres(attendance);
      return NextResponse.json({ success: true, attendance });
    }
    if (body.action !== 'submit-report') {
      return NextResponse.json({ error: 'Unknown attendance action' }, { status: 400 });
    }

    const { fromDate, toDate, remarks } = body as {
      fromDate?: string;
      toDate?: string;
      remarks?: string;
    };
    if (
      typeof fromDate !== 'string' || !/^\d{4}-\d{2}-\d{2}$/.test(fromDate) ||
      typeof toDate !== 'string' || !/^\d{4}-\d{2}-\d{2}$/.test(toDate) ||
      fromDate > toDate || typeof remarks !== 'string' || remarks.trim().length < 5
    ) {
      return NextResponse.json({ error: 'Choose a valid date range and provide remarks of at least five characters' }, { status: 400 });
    }

    const guide = user.guideId ? findUserById(user.guideId) : undefined;
    if ((auth.role === 'intern' || auth.role === 'project-intern') && (!guide || guide.status !== 'active')) {
      return NextResponse.json({ error: 'An authorized guide must be assigned before submitting attendance reports' }, { status: 409 });
    }
    const guideUsername = guide?.username.toLowerCase();
    const approvalChain = getApprovalChainForUser(auth.username, auth.role, 'attendance-report', guideUsername);
    const attendance = getAttendanceForUser(auth.id, auth.username)
      .filter((record) => record.date >= fromDate && record.date <= toDate);
    const identifiers = generateRequestIdentifiers();
    const report: RequestItem = {
      id: identifiers.id,
      submissionId: identifiers.submissionId,
      type: 'attendance-report',
      title: `Attendance report: ${fromDate} to ${toDate}`,
      createdBy: user.fullName,
      createdByUsername: user.username,
      createdById: user.id,
      createdByRole: user.role,
      createdByDesignation: user.designation,
      createdByEmployeeId: user.employeeId,
      createdByDepartment: user.department,
      createdByPhone: user.phone,
      payload: {
        fromDate,
        toDate,
        remarks: remarks.trim(),
        daysRecorded: attendance.length,
        attendance,
        approvalChain,
        currentApproverIndex: 0,
        ...(guideUsername ? { guideId: guide?.id, guideUsername } : {}),
      },
      remarks: remarks.trim(),
      target: 'admin',
      status: 'pending',
      createdAt: new Date().toISOString(),
    };
    addRequestDB(report);
    addNotificationDB({
      type: 'request_submitted',
      title: 'Attendance report submitted',
      message: `${user.fullName} submitted an attendance report for ${fromDate} to ${toDate}.`,
      targetUser: approvalChain[0],
      relatedId: report.id,
      read: false,
    });
    addAuditEntry({
      action: 'attendance:report-submitted',
      actor: user.username,
      actorId: user.id,
      details: { requestId: report.id, fromDate, toDate, daysRecorded: attendance.length },
    });
    return NextResponse.json({ success: true, request: report });
  } catch (error) {
    if (error instanceof Error && /already|check in/i.test(error.message)) {
      return NextResponse.json({ error: error.message }, { status: 409 });
    }
    console.error('Attendance action failed:', error);
    return NextResponse.json({ error: 'Unable to process attendance action' }, { status: 500 });
  }
}
