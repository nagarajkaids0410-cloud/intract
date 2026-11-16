'use client';

import React, { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { Trash2, Download, AlertTriangle, FileSpreadsheet, X, ShieldAlert, CheckCircle2 } from 'lucide-react';
import { toast } from 'sonner';
import { isBharathUser } from '@/lib/bharath-access';
import { exportSingleUserDataToExcel } from '@/lib/bharath-export';

interface BharathUserActionsProps {
  targetUser: any;
  currentUser: any;
  onUserDeleted?: () => void;
}

export default function BharathUserActions({
  targetUser,
  currentUser,
  onUserDeleted,
}: BharathUserActionsProps) {
  const [showConfirmModal, setShowConfirmModal] = useState(false);
  const [downloading, setDownloading] = useState(false);
  const [deleting, setDeleting] = useState(false);
  const [confirmedSafeguard, setConfirmedSafeguard] = useState(false);
  const [hasDownloadedInModal, setHasDownloadedInModal] = useState(false);

  // ACCESS CONTROL: Exclusively for Bharath's login
  if (!isBharathUser(currentUser)) {
    return null;
  }

  // Prevent Bharath from deleting his own founder account
  if (isBharathUser(targetUser) || targetUser.id === currentUser?.id) {
    return null;
  }

  // Download user-specific data to .xlsx
  const handleDownloadUserData = async () => {
    setDownloading(true);
    try {
      const response = await fetch(`/api/admin/bharath/export-user?userId=${targetUser.id}`, {
        method: 'GET',
        headers: {
          'x-user-id': currentUser?.id || '',
        },
      });

      const result = await response.json();
      if (!response.ok) {
        throw new Error(result.error || 'Failed to fetch user data for export');
      }

      exportSingleUserDataToExcel(result.data);
      setHasDownloadedInModal(true);
      toast.success(`Exported complete data for ${targetUser.fullName || targetUser.username} (.xlsx)`);
    } catch (error: any) {
      console.error('Error exporting user data:', error);
      toast.error(error.message || 'Unable to download user data');
    } finally {
      setDownloading(false);
    }
  };

  // Permanently delete user account
  const handleDeleteUser = async () => {
    if (!confirmedSafeguard) {
      toast.error('Please confirm the safety declaration checkbox before deleting.');
      return;
    }

    setDeleting(true);
    try {
      const response = await fetch('/api/admin/bharath/delete-user', {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json',
          'x-user-id': currentUser?.id || '',
        },
        body: JSON.stringify({ userId: targetUser.id }),
      });

      const result = await response.json();
      if (!response.ok) {
        throw new Error(result.error || 'Failed to delete user account');
      }

      toast.success(result.message || `Account for ${targetUser.fullName || targetUser.username} has been deleted.`);
      setShowConfirmModal(false);
      setConfirmedSafeguard(false);

      if (onUserDeleted) {
        onUserDeleted();
      }
    } catch (error: any) {
      console.error('Error deleting user account:', error);
      toast.error(error.message || 'Failed to delete user account');
    } finally {
      setDeleting(false);
    }
  };

  return (
    <>
      {/* Bharath's Exclusive Action Buttons */}
      <div className="flex items-center gap-1.5 pt-1 border-t border-slate-100 mt-1">
        <Button
          size="sm"
          variant="outline"
          className="text-xs text-blue-700 hover:text-blue-800 hover:bg-blue-50 border-blue-200 h-7 px-2"
          onClick={handleDownloadUserData}
          disabled={downloading}
          title={`Download full data for ${targetUser.fullName || targetUser.username} in Excel (.xlsx)`}
        >
          <FileSpreadsheet size={13} className="mr-1 text-green-600" />
          {downloading ? 'Exporting...' : 'Export Excel'}
        </Button>

        <Button
          size="sm"
          variant="outline"
          className="text-xs text-red-600 hover:text-white hover:bg-red-600 border-red-200 h-7 px-2 transition-colors"
          onClick={() => {
            setShowConfirmModal(true);
            setConfirmedSafeguard(false);
            setHasDownloadedInModal(false);
          }}
          title={`Delete account for ${targetUser.fullName || targetUser.username}`}
        >
          <Trash2 size={13} className="mr-1" />
          Delete
        </Button>
      </div>

      {/* Confirmation Popup Modal */}
      {showConfirmModal && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 p-4 backdrop-blur-xs animate-in fade-in duration-150"
          role="dialog"
          aria-modal="true"
          aria-labelledby="bharath-delete-modal-title"
        >
          <Card className="w-full max-w-lg space-y-4 p-6 bg-white shadow-2xl border-slate-200 relative text-left">
            {/* Close Button */}
            <button
              onClick={() => setShowConfirmModal(false)}
              className="absolute right-4 top-4 text-slate-400 hover:text-slate-600 p-1 rounded-md"
              aria-label="Close"
            >
              <X size={18} />
            </button>

            {/* Header */}
            <div className="flex items-start gap-3">
              <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-red-100 text-red-600">
                <AlertTriangle size={20} />
              </div>
              <div>
                <h2 id="bharath-delete-modal-title" className="text-lg font-bold text-slate-900">
                  Delete User Account
                </h2>
                <p className="text-xs text-slate-500 font-medium">
                  Founder Action &bull; Golla Kumar Bharath
                </p>
              </div>
            </div>

            {/* Target User Summary Card */}
            <div className="rounded-lg border border-slate-200 bg-slate-50 p-3 space-y-1.5 text-xs text-slate-700">
              <div className="flex justify-between">
                <span className="font-semibold text-slate-500">Name:</span>
                <span className="font-bold text-slate-900">{targetUser.fullName || 'N/A'}</span>
              </div>
              <div className="flex justify-between">
                <span className="font-semibold text-slate-500">Employee ID:</span>
                <span className="font-mono text-slate-900">{targetUser.employeeId || 'Not Set'}</span>
              </div>
              <div className="flex justify-between">
                <span className="font-semibold text-slate-500">Username:</span>
                <span className="font-mono text-slate-900">{targetUser.username}</span>
              </div>
              <div className="flex justify-between">
                <span className="font-semibold text-slate-500">Email:</span>
                <span className="text-blue-600">{targetUser.email}</span>
              </div>
              <div className="flex justify-between">
                <span className="font-semibold text-slate-500">Role / Designation:</span>
                <span className="capitalize">{targetUser.designation || targetUser.role}</span>
              </div>
            </div>

            {/* Step 1: Pre-Deletion Data Download (Requirement 1 & 5) */}
            <div className="rounded-lg border border-blue-200 bg-blue-50/80 p-3.5 space-y-2">
              <div className="flex items-start gap-2">
                <FileSpreadsheet size={16} className="text-blue-600 shrink-0 mt-0.5" />
                <div className="text-xs text-blue-950">
                  <p className="font-semibold">Step 1: Download User Records (.xlsx)</p>
                  <p className="text-slate-600 mt-0.5">
                    Before permanently deleting, download all of this user's data (Profile, Attendance, Requests, and Tasks) as an Excel file for organizational records.
                  </p>
                </div>
              </div>

              <div className="pt-1 flex items-center justify-between">
                <Button
                  size="sm"
                  className="bg-emerald-600 hover:bg-emerald-700 text-white text-xs flex items-center gap-1.5 shadow-xs"
                  onClick={handleDownloadUserData}
                  disabled={downloading}
                >
                  <Download size={13} />
                  {downloading ? 'Generating Excel...' : 'Download User Data (.xlsx)'}
                </Button>

                {hasDownloadedInModal && (
                  <span className="inline-flex items-center text-xs text-emerald-700 font-medium gap-1">
                    <CheckCircle2 size={13} /> Downloaded
                  </span>
                )}
              </div>
            </div>

            {/* Step 2: Warning & Safeguard */}
            <div className="rounded-lg border border-red-200 bg-red-50/70 p-3 space-y-2">
              <div className="flex items-center gap-2 text-xs font-semibold text-red-800">
                <ShieldAlert size={15} />
                <span>Step 2: Permanent Deletion Safeguard</span>
              </div>
              <p className="text-xs text-red-700">
                This will permanently delete this account from Supabase PostgreSQL and terminate active sessions. This action cannot be reversed.
              </p>

              <label className="flex items-start gap-2 pt-1 text-xs text-slate-800 cursor-pointer select-none">
                <input
                  type="checkbox"
                  checked={confirmedSafeguard}
                  onChange={(e) => setConfirmedSafeguard(e.target.checked)}
                  className="mt-0.5 h-4 w-4 rounded border-slate-300 text-red-600 focus:ring-red-500 cursor-pointer"
                />
                <span>
                  I confirm that I want to permanently delete <strong>{targetUser.fullName || targetUser.username}</strong>'s account.
                </span>
              </label>
            </div>

            {/* Actions */}
            <div className="flex justify-end gap-2 pt-2 border-t border-slate-200">
              <Button
                variant="outline"
                size="sm"
                onClick={() => setShowConfirmModal(false)}
                disabled={deleting}
              >
                Cancel
              </Button>

              <Button
                size="sm"
                className="bg-red-600 hover:bg-red-700 text-white text-xs flex items-center gap-1.5"
                onClick={handleDeleteUser}
                disabled={!confirmedSafeguard || deleting}
              >
                <Trash2 size={13} />
                {deleting ? 'Deleting Account...' : 'Permanently Delete Account'}
              </Button>
            </div>
          </Card>
        </div>
      )}
    </>
  );
}
