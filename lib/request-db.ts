import fs from 'fs';
import path from 'path';
import { randomInt } from 'node:crypto';
import { RequestItem } from './request-store';
import { addAuditEntry } from './audit-log';
import { getPool, initDatabase } from './db';

const DB_FILE = path.join(process.cwd(), '.data', 'requests.json');
const LEGACY_FOUNDER_CHAIN = ['hareeshv', 'santhanakumarv', 'gkbharath'];
const FOUNDER_REQUEST_CHAIN = ['hareeshv', 'santhanakumarv'];

export async function syncRequestsWithDb(): Promise<RequestItem[]> {
  const pool = getPool();
  if (!pool) return readDB();

  try {
    await initDatabase();
    const res = await pool.query('SELECT * FROM requests ORDER BY created_at DESC');
    if (res && res.rows && res.rows.length > 0) {
      const dbRequests: RequestItem[] = res.rows.map((row: any) => ({
        id: row.id,
        submissionId: row.submission_id,
        type: row.type,
        title: row.title,
        status: row.status,
        target: row.target || 'admin',
        createdBy: row.created_by,
        createdById: row.created_by_id,
        createdByUsername: row.created_by_username,
        createdAt: row.created_at,
        updatedAt: row.updated_at,
        payload: typeof row.payload === 'string' ? JSON.parse(row.payload) : (row.payload || {}),
      }));
      for (const req of dbRequests) {
        const idx = inMemoryRequests.findIndex((r) => r.id === req.id);
        if (idx !== -1) {
          inMemoryRequests[idx] = req;
        } else {
          inMemoryRequests.push(req);
        }
      }
    } else {
      // Auto-seed file requests if new database is empty
      const localRequests = readDB();
      for (const req of localRequests) {
        await saveRequestToPostgres(req);
      }
    }
  } catch (err) {
    console.warn('[REQUEST-DB] Failed to sync requests from Supabase:', err);
  }
  return inMemoryRequests;
}

export async function saveRequestToPostgres(request: RequestItem): Promise<void> {
  const pool = getPool();
  if (!pool) return;

  try {
    await initDatabase();
    await pool.query(`
      INSERT INTO requests (
        id, submission_id, type, title, status, target, created_by,
        created_by_id, created_by_username, created_at, updated_at, payload
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
      ON CONFLICT (id) DO UPDATE SET
        status = EXCLUDED.status,
        target = EXCLUDED.target,
        updated_at = EXCLUDED.updated_at,
        payload = EXCLUDED.payload;
    `, [
      request.id,
      request.submissionId || null,
      request.type,
      request.title,
      request.status,
      request.target || 'admin',
      request.createdBy,
      request.createdById || '',
      request.createdByUsername || '',
      request.createdAt || new Date().toISOString(),
      request.updatedAt || new Date().toISOString(),
      JSON.stringify(request.payload || {}),
    ]);
  } catch (err) {
    console.error('[REQUEST-DB] Failed to persist request to Supabase:', err);
  }
}

export function generateRequestIdentifiers(): { id: string; submissionId: string } {
  const usedIds = new Set(
    readDB().flatMap((request) => [request.id, request.submissionId].filter(Boolean) as string[])
  );
  const generateId = () => {
    for (let attempt = 0; attempt < 10000; attempt += 1) {
      const id = String(randomInt(1000, 10000));
      if (!usedIds.has(id)) {
        usedIds.add(id);
        return id;
      }
    }
    throw new Error('No available four-digit request identifiers remain');
  };

  return { id: generateId(), submissionId: generateId() };
}

function migrateFounderRequestChains(requests: RequestItem[]): boolean {
  let migrated = false;
  for (const request of requests) {
    const chain = request.payload?.approvalChain;
    const isFounderRequest = request.createdById === 'founder-001' ||
      request.createdByUsername?.toLowerCase() === 'gkbharath';
    if (
      !isFounderRequest ||
      !['leave', 'ta', 'report'].includes(request.type) ||
      !['pending', 'forwarded'].includes(request.status) ||
      !Array.isArray(chain) ||
      chain.length !== LEGACY_FOUNDER_CHAIN.length ||
      chain.some((approver, index) => approver !== LEGACY_FOUNDER_CHAIN[index])
    ) {
      continue;
    }

    const oldStage = request.status === 'pending' ? 0 : request.payload.currentApproverIndex;
    if (!Number.isInteger(oldStage) || oldStage < 0 || oldStage >= LEGACY_FOUNDER_CHAIN.length) {
      continue;
    }
    const currentStage = Math.min(oldStage, FOUNDER_REQUEST_CHAIN.length - 1);
    request.payload = {
      ...request.payload,
      approvalChain: FOUNDER_REQUEST_CHAIN,
      currentApproverIndex: currentStage,
    };
    if (request.status === 'forwarded') {
      request.forwardedTo = FOUNDER_REQUEST_CHAIN[currentStage];
    } else {
      delete request.forwardedTo;
    }
    migrated = true;
    try {
      addAuditEntry({
        action: 'request:approval-chain-migrated',
        actor: 'system',
        actorId: 'system',
        details: { requestId: request.id, oldChain: LEGACY_FOUNDER_CHAIN, newChain: FOUNDER_REQUEST_CHAIN, currentApprover: FOUNDER_REQUEST_CHAIN[currentStage] },
      });
    } catch (error) {
      console.error('Audit log failed for founder approval-chain migration', error);
    }
  }
  return migrated;
}

let inMemoryRequests: RequestItem[] = [];

function ensureDBDir() {
  try {
    const dir = path.dirname(DB_FILE);
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }
  } catch {
    // Read-only filesystem in serverless environments
  }
}

function readDB(): RequestItem[] {
  try {
    ensureDBDir();
    if (!fs.existsSync(DB_FILE)) {
      return inMemoryRequests;
    }
    const data = fs.readFileSync(DB_FILE, 'utf-8');
    const requests: RequestItem[] = JSON.parse(data) || [];
    if (inMemoryRequests.length === 0 && requests.length > 0) {
      inMemoryRequests = requests;
    }
    return requests;
  } catch (error) {
    console.warn('Error reading request DB, using in-memory store:', error);
    return inMemoryRequests;
  }
}

function writeDB(requests: RequestItem[]) {
  inMemoryRequests = requests;
  try {
    ensureDBDir();
    fs.writeFileSync(DB_FILE, JSON.stringify(requests, null, 2));
  } catch (error) {
    console.warn('Filesystem read-only, saved requests to in-memory store:', error);
  }
}

export function addRequestDB(request: RequestItem): RequestItem {
  const requests = readDB();
  requests.unshift(request);
  writeDB(requests);
  saveRequestToPostgres(request).catch(() => {});
  try {
    addAuditEntry({ action: 'request:created', actor: request.createdBy, actorId: request.createdById, details: { id: request.id, type: request.type, title: request.title } });
  } catch (e) {
    console.error('Audit log failed for addRequestDB', e);
  }
  return request;
}

export function getRequestsByTargetDB(target: 'admin' | 'founder' | 'all'): RequestItem[] {
  const requests = readDB();
  if (target === 'all') {
    return [...requests];
  }
  return requests.filter((req) => req.target === target);
}

export function getRequestByIdDB(id: string): RequestItem | undefined {
  const requests = readDB();
  return requests.find((req) => req.id === id);
}

export function updateRequestStatusDB(
  id: string,
  status: 'pending' | 'approved' | 'rejected' | 'signed' | 'forwarded',
  updates?: Partial<RequestItem>
): RequestItem | undefined {
  const requests = readDB();
  const index = requests.findIndex((req) => req.id === id);
  if (index !== -1) {
    requests[index] = {
      ...requests[index],
      status,
      updatedAt: new Date().toISOString(),
      ...updates,
    };
    writeDB(requests);
    saveRequestToPostgres(requests[index]).catch(() => {});
    try {
      addAuditEntry({ action: `request:${status}`, actor: updates?.forwardedTo || requests[index].createdBy, actorId: requests[index].createdById, details: { id, updates } });
    } catch (e) {
      console.error('Audit log failed for updateRequestStatusDB', e);
    }
    return requests[index];
  }
  return undefined;
}

export function updateRequestPayloadDB(
  id: string,
  payloadUpdates: Record<string, any>
): RequestItem | undefined {
  const requests = readDB();
  const index = requests.findIndex((req) => req.id === id);
  if (index !== -1) {
    requests[index] = {
      ...requests[index],
      payload: {
        ...requests[index].payload,
        ...payloadUpdates,
      },
      updatedAt: new Date().toISOString(),
    };
    writeDB(requests);
    saveRequestToPostgres(requests[index]).catch(() => {});
    return requests[index];
  }
  return undefined;
}
