import * as XLSX from 'xlsx';
import { getRequestTypeLabel, getStatusLabel } from '@/lib/excel-export';

export interface SingleUserDataPayload {
  user: any;
  attendance: any[];
  requests: any[];
  tasks: any[];
}

/**
 * Generates and downloads a comprehensive multi-sheet Excel (.xlsx) file
 * containing exclusively the target user's records.
 */
export function exportSingleUserDataToExcel(data: SingleUserDataPayload) {
  const { user, attendance = [], requests = [], tasks = [] } = data;

  const wb = XLSX.utils.book_new();

  // -------------------------------------------------------------
  // Sheet 1: User Profile
  // -------------------------------------------------------------
  const profileRows = [
    ['SURYAS MiB ENTERPRISES - INDIVIDUAL USER RECORD EXPORT'],
    ['Generated on:', new Date().toLocaleString('en-IN')],
    ['Confidentiality:', 'RESTRICTED / FOUNDER-LEVEL ACCESS ONLY'],
    [],
    ['FIELD', 'DETAILS'],
    ['Full Name', user.fullName || 'N/A'],
    ['Employee ID', user.employeeId || 'N/A'],
    ['Username', user.username || 'N/A'],
    ['Email Address', user.email || 'N/A'],
    ['Phone Number', user.phone || 'Not Set'],
    ['System Role', user.role || 'N/A'],
    ['Designation', user.designation || 'Not Set'],
    ['Department / Team', user.department || 'Not Set'],
    ['Employment Type', user.employmentType || 'full-time'],
    ['Account Status', (user.status || 'N/A').toUpperCase()],
    ['Assigned Guide', user.guideName || 'None'],
    ['Registration Date', user.createdAt ? new Date(user.createdAt).toLocaleString('en-IN') : 'N/A'],
    ['Approval Date', user.approvedAt ? new Date(user.approvedAt).toLocaleString('en-IN') : 'N/A'],
    ['Email Verified', user.emailVerified ? 'Yes' : 'No'],
    ['Profile Completed', user.isProfileCompleted ? 'Yes' : 'No'],
    [],
    ['SUMMARY METRICS', 'COUNT'],
    ['Total Attendance Logs', attendance.length],
    ['Total Requests / Claims', requests.length],
    ['Total Assigned Tasks', tasks.length],
  ];

  const wsProfile = XLSX.utils.aoa_to_sheet(profileRows);
  wsProfile['!cols'] = [{ wch: 28 }, { wch: 45 }];
  XLSX.utils.book_append_sheet(wb, wsProfile, 'User Profile');

  // -------------------------------------------------------------
  // Sheet 2: Attendance History
  // -------------------------------------------------------------
  const attendanceHeaders = [
    'Date',
    'Day',
    'Check In',
    'Check Out',
    'Duration (Hours)',
    'Status',
  ];

  const attendanceData = attendance.map((att) => {
    let checkInStr = 'N/A';
    let checkOutStr = 'N/A';
    let durationHours = 'N/A';

    if (att.checkIn) {
      const inDate = new Date(att.checkIn);
      checkInStr = inDate.toLocaleTimeString('en-IN', { hour: '2-digit', minute: '2-digit', second: '2-digit' });

      if (att.checkOut) {
        const outDate = new Date(att.checkOut);
        checkOutStr = outDate.toLocaleTimeString('en-IN', { hour: '2-digit', minute: '2-digit', second: '2-digit' });
        const diffMs = outDate.getTime() - inDate.getTime();
        if (diffMs > 0) {
          const hours = (diffMs / (1000 * 60 * 60)).toFixed(2);
          durationHours = `${hours} hrs`;
        }
      }
    }

    let dayName = 'N/A';
    if (att.date) {
      try {
        dayName = new Date(att.date).toLocaleDateString('en-IN', { weekday: 'long' });
      } catch {}
    }

    return [
      att.date || 'N/A',
      dayName,
      checkInStr,
      checkOutStr,
      durationHours,
      att.checkOut ? 'Completed' : 'Present (No Check-out)',
    ];
  });

  const wsAttendance = XLSX.utils.aoa_to_sheet([
    attendanceHeaders,
    ...(attendanceData.length > 0 ? attendanceData : [['No attendance records logged for this user.']]),
  ]);
  wsAttendance['!cols'] = [{ wch: 15 }, { wch: 15 }, { wch: 15 }, { wch: 15 }, { wch: 18 }, { wch: 22 }];
  XLSX.utils.book_append_sheet(wb, wsAttendance, 'Attendance History');

  // -------------------------------------------------------------
  // Sheet 3: Requests & Claims
  // -------------------------------------------------------------
  const requestHeaders = [
    'Submission ID',
    'Type',
    'Title / Subject',
    'Amount (INR)',
    'Status',
    'Submitted On',
    'Details',
    'Remarks / Feedback',
    'Approval Comments',
  ];

  const requestData = requests.map((req) => {
    const payload = req.payload || {};
    const amount = payload.amount || payload.projectAmount || '';
    const comments = Array.isArray(payload.comments)
      ? payload.comments.map((c: any) => `${c.by || 'Approver'}: ${c.decision || ''} (${c.comment || ''})`).join('; ')
      : '';

    let details = req.title || '';
    if (req.type === 'leave') {
      details = `Leave Type: ${payload.leaveType || ''} | Period: ${payload.fromDate || ''} to ${payload.toDate || ''} | Reason: ${payload.reason || ''}`;
    } else if (req.type === 'ta') {
      details = `Claim: ${payload.claimType || ''} | Description: ${payload.description || ''}`;
    } else if (req.type === 'proposal') {
      details = `Project: ${payload.projectTitle || ''} | Status: ${payload.projectStatus || ''}`;
    } else if (payload.description) {
      details = payload.description;
    }

    return [
      req.submissionId || req.id || 'N/A',
      getRequestTypeLabel(req.type || ''),
      req.title || 'N/A',
      amount ? Number(amount) : '',
      getStatusLabel(req.status || ''),
      req.createdAt ? new Date(req.createdAt).toLocaleString('en-IN') : 'N/A',
      details,
      req.remarks || payload.remarks || '',
      comments,
    ];
  });

  const wsRequests = XLSX.utils.aoa_to_sheet([
    requestHeaders,
    ...(requestData.length > 0 ? requestData : [['No requests or claims submitted by this user.']]),
  ]);
  wsRequests['!cols'] = [
    { wch: 18 },
    { wch: 20 },
    { wch: 30 },
    { wch: 15 },
    { wch: 15 },
    { wch: 22 },
    { wch: 45 },
    { wch: 30 },
    { wch: 40 },
  ];
  XLSX.utils.book_append_sheet(wb, wsRequests, 'Requests & Claims');

  // -------------------------------------------------------------
  // Sheet 4: Tasks
  // -------------------------------------------------------------
  const taskHeaders = [
    'Task ID',
    'Title',
    'Status',
    'Progress (%)',
    'Deadline',
    'Assigned By',
    'Created At',
    'Description',
  ];

  const taskData = tasks.map((t) => [
    t.id || 'N/A',
    t.title || 'N/A',
    (t.status || 'not_started').replace('_', ' ').toUpperCase(),
    `${t.progress ?? 0}%`,
    t.deadline || 'N/A',
    t.assignedByName || 'N/A',
    t.createdAt ? new Date(t.createdAt).toLocaleDateString('en-IN') : 'N/A',
    t.description || '',
  ]);

  const wsTasks = XLSX.utils.aoa_to_sheet([
    taskHeaders,
    ...(taskData.length > 0 ? taskData : [['No tasks assigned to this user.']]),
  ]);
  wsTasks['!cols'] = [
    { wch: 15 },
    { wch: 30 },
    { wch: 15 },
    { wch: 15 },
    { wch: 15 },
    { wch: 25 },
    { wch: 18 },
    { wch: 45 },
  ];
  XLSX.utils.book_append_sheet(wb, wsTasks, 'Tasks');

  // Trigger browser download
  const safeName = (user.fullName || user.username || 'User').replace(/[^a-zA-Z0-9_-]/g, '_');
  const empId = (user.employeeId || 'MIB').replace(/[^a-zA-Z0-9_-]/g, '_');
  const dateStamp = new Date().toISOString().slice(0, 10);
  const fileName = `UserData_${empId}_${safeName}_${dateStamp}.xlsx`;

  XLSX.writeFile(wb, fileName);
}
