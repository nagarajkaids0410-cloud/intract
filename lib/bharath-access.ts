import { NextRequest, NextResponse } from 'next/server';
import { getSessionIdentity } from '@/lib/session';
import { findUserById, syncUsersWithDb } from '@/lib/user-database';

/**
 * Checks if a given user object represents Golla Kumar Bharath (Founder).
 * Verified against role, employeeId, id, username, or email.
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

/**
 * Server-side guard to verify that the incoming request is authenticated
 * and belongs specifically to Bharath.
 */
export async function assertBharathAccess(
  request: NextRequest
): Promise<{ success: true; bharath: { id: string; username: string; role: string } } | { success: false; response: NextResponse }> {
  const identity = getSessionIdentity(request);

  if (!identity) {
    // If running in development or custom auth header fallback:
    const authHeader = request.headers.get('x-user-id');
    if (authHeader) {
      await syncUsersWithDb();
      const fallbackUser = findUserById(authHeader);
      if (fallbackUser && isBharathUser(fallbackUser)) {
        return {
          success: true,
          bharath: { id: fallbackUser.id, username: fallbackUser.username, role: fallbackUser.role },
        };
      }
    }
    return {
      success: false,
      response: NextResponse.json(
        { error: 'Authentication required. Please sign in.' },
        { status: 401 }
      ),
    };
  }

  await syncUsersWithDb();
  const liveUser = findUserById(identity.userId);

  if (!isBharathUser(identity) && !isBharathUser(liveUser)) {
    return {
      success: false,
      response: NextResponse.json(
        { error: 'Access denied: This feature is exclusively available for Bharath (Founder).' },
        { status: 403 }
      ),
    };
  }

  return {
    success: true,
    bharath: {
      id: identity.userId,
      username: identity.username,
      role: identity.role,
    },
  };
}
