import React, { useState, useEffect } from 'react';
import {
  Box, Typography, Paper, Table, TableBody, TableCell, TableContainer,
  TableHead, TableRow, Chip, Button, Dialog, DialogTitle,
  DialogContent, DialogActions, TextField, IconButton, Tooltip,
} from '@mui/material';
import { Refresh, CheckCircle } from '@mui/icons-material';
import axiosInstance from '../api/axios.config';

const Reports = () => {
  const [reports, setReports] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [dialogOpen, setDialogOpen] = useState(false);
  const [selectedReport, setSelectedReport] = useState<any>(null);
  const [adminNote, setAdminNote] = useState('');

  useEffect(() => {
    fetchReports();
  }, []);

  const fetchReports = async () => {
    setLoading(true);
    try {
      const response = await axiosInstance.get('/admin/reports');
      setReports(response.data.data);
    } catch (error) {
      console.error('Failed to fetch reports:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleResolve = async () => {
    try {
      await axiosInstance.put(`/admin/reports/${selectedReport.id}/resolve`, {
        admin_note: adminNote,
      });
      await fetchReports();
      setDialogOpen(false);
    } catch (error) {
      console.error('Failed to resolve report:', error);
    }
  };

  const getStatusChip = (status: string) => {
    const colors: Record<string, any> = {
      pending: { color: 'warning', label: 'Pending' },
      reviewed: { color: 'info', label: 'Reviewed' },
      resolved: { color: 'success', label: 'Resolved' },
    };
    const config = colors[status] || { color: 'default', label: status };
    return <Chip color={config.color} label={config.label} size="small" />;
  };

  return (
    <Box>
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
        <Typography variant="h4">Reports</Typography>
        <IconButton onClick={fetchReports}>
          <Refresh />
        </IconButton>
      </Box>

      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Reporter</TableCell>
              <TableCell>Reported User</TableCell>
              <TableCell>Reason</TableCell>
              <TableCell>Status</TableCell>
              <TableCell>Reported</TableCell>
              <TableCell>Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {reports.map((report) => (
              <TableRow key={report.id}>
                <TableCell>
                  {report.reporter?.first_name} {report.reporter?.last_name}
                </TableCell>
                <TableCell>
                  {report.reported?.first_name} {report.reported?.last_name}
                </TableCell>
                <TableCell>{report.reason}</TableCell>
                <TableCell>{getStatusChip(report.status)}</TableCell>
                <TableCell>{new Date(report.created_at).toLocaleDateString()}</TableCell>
                <TableCell>
                  {report.status === 'pending' && (
                    <Tooltip title="Resolve">
                      <IconButton
                        onClick={() => {
                          setSelectedReport(report);
                          setDialogOpen(true);
                        }}
                      >
                        <CheckCircle color="primary" />
                      </IconButton>
                    </Tooltip>
                  )}
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>

      <Dialog open={dialogOpen} onClose={() => setDialogOpen(false)} maxWidth="sm" fullWidth>
        <DialogTitle>Resolve Report</DialogTitle>
        <DialogContent>
          <TextField
            fullWidth
            margin="normal"
            label="Admin Note"
            multiline
            rows={3}
            value={adminNote}
            onChange={(e) => setAdminNote(e.target.value)}
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setDialogOpen(false)}>Cancel</Button>
          <Button onClick={handleResolve} variant="contained">Resolve</Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default Reports;