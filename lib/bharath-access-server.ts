import { NextRequest, NextResponse } from 'next/server';
import { getSessionIdentity } from '@/lib/session';
import { findUserById, syncUsersWithDb } from '@/lib/user-database';
import { isBharathUser } from '@/lib/bharath-access';

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
