import fs from 'node:fs';
import path from 'node:path';
import { randomUUID } from 'node:crypto';
import { getPool, initDatabase } from './db';

const DB_FILE = path.join(process.cwd(), '.data', 'attendance.json');

export interface AttendanceRecord {
  id: string;
  userId: string;
  username: string;
  fullName: string;
  date: string;
  checkIn: string;
  checkOut?: string;
}

let inMemoryAttendance: AttendanceRecord[] = [];

export async function syncAttendanceWithDb(): Promise<AttendanceRecord[]> {
  const pool = getPool();
  if (!pool) return readDB();

  try {
    await initDatabase();
    const res = await pool.query('SELECT * FROM attendance ORDER BY date DESC, check_in DESC');
    if (res && res.rows && res.rows.length > 0) {
      const dbRecords: AttendanceRecord[] = res.rows.map((r: any) => ({
        id: r.id,
        userId: r.user_id,
        username: r.username,
        fullName: r.full_name,
        date: r.date,
        checkIn: r.check_in,
        checkOut: r.check_out,
      }));
      for (const rec of dbRecords) {
        const idx = inMemoryAttendance.findIndex((a) => a.id === rec.id);
        if (idx !== -1) {
          inMemoryAttendance[idx] = rec;
        } else {
          inMemoryAttendance.push(rec);
        }
      }
    } else {
      // Auto-seed file attendance if new database is empty
      const localAttendance = readDB();
      for (const rec of localAttendance) {
        await saveAttendanceToPostgres(rec);
      }
    }
  } catch (err) {
    console.warn('[ATTENDANCE-DB] Failed to sync attendance from Supabase:', err);
  }
  return inMemoryAttendance;
}

export async function saveAttendanceToPostgres(rec: AttendanceRecord): Promise<void> {
  const pool = getPool();
  if (!pool) return;

  try {
    await initDatabase();
    await pool.query(`
      INSERT INTO attendance (id, user_id, username, full_name, date, check_in, check_out)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      ON CONFLICT (id) DO UPDATE SET
        check_out = EXCLUDED.check_out;
    `, [
      rec.id,
      rec.userId,
      rec.username,
      rec.fullName,
      rec.date,
      rec.checkIn,
      rec.checkOut || null,
    ]);
  } catch (err) {
    console.error('[ATTENDANCE-DB] Failed to persist attendance to Supabase:', err);
  }
}

function readDB(): AttendanceRecord[] {
  try {
    if (!fs.existsSync(DB_FILE)) return inMemoryAttendance;
    const records: unknown = JSON.parse(fs.readFileSync(DB_FILE, 'utf8'));
    if (!Array.isArray(records)) return inMemoryAttendance;
    if (inMemoryAttendance.length === 0 && records.length > 0) {
      inMemoryAttendance = records as AttendanceRecord[];
    }
    return records as AttendanceRecord[];
  } catch (err) {
    console.warn('Error reading attendance DB, using in-memory store:', err);
    return inMemoryAttendance;
  }
}

function writeDB(records: AttendanceRecord[]) {
  inMemoryAttendance = records;
  try {
    const dir = path.dirname(DB_FILE);
    if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
    fs.writeFileSync(DB_FILE, JSON.stringify(records, null, 2));
  } catch (err) {
    console.warn('Filesystem read-only, saved attendance to in-memory store:', err);
  }
}

export function getAttendanceForUser(userId: string): AttendanceRecord[] {
  return readDB()
    .filter((record) => record.userId === userId)
    .sort((a, b) => b.date.localeCompare(a.date));
}

export function recordAttendance(
  user: { id: string; username: string; fullName: string },
  date: string,
  action: 'check-in' | 'check-out'
): AttendanceRecord {
  const records = readDB();
  const existing = records.find((record) => record.userId === user.id && record.date === date);
  if (action === 'check-in') {
    if (existing) throw new Error('You have already checked in today');
    const record: AttendanceRecord = {
      id: randomUUID(),
      userId: user.id,
      username: user.username,
      fullName: user.fullName,
      date,
      checkIn: new Date().toISOString(),
    };
    records.unshift(record);
    writeDB(records);
    saveAttendanceToPostgres(record).catch(() => {});
    return record;
  }
  if (!existing) throw new Error('Check in before checking out');
  if (existing.checkOut) throw new Error('You have already checked out today');
  existing.checkOut = new Date().toISOString();
  writeDB(records);
  saveAttendanceToPostgres(existing).catch(() => {});
  return existing;
}
