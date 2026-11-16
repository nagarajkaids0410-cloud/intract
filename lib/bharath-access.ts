/**
 * Pure client-safe utility to check if a user is Golla Kumar Bharath (Founder).
 * Verified against role, employeeId, id, username, or email.
 * This file has NO server/database dependencies so it can be safely used in 'use client' components.
 */
export function isBharathUser(
  user?: {
    id?: string;
    role?: string;
    username?: string;
    employeeId?: string;
    email?: string;
  } | null
): boolean {
  if (!user) return false;

  const username = (user.username || '').toLowerCase().trim();
  const email = (user.email || '').toLowerCase().trim();
  const empId = (user.employeeId || '').toUpperCase().trim();
  const id = (user.id || '').toLowerCase().trim();
  const role = (user.role || '').toLowerCase().trim();

  return (
    role === 'founder' ||
    id === 'founder-001' ||
    empId === 'MIB01' ||
    username === 'gkbharath' ||
    username === 'gollakumarbharath' ||
    username === 'kumar' ||
    email === 'gollakumarbharath@suryas.in'
  );
}
