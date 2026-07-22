import React, { useState, useEffect } from 'react';
import {
  Box, Typography, Paper, Table, TableBody, TableCell, TableContainer,
  TableHead, TableRow, Chip, IconButton, Tooltip, FormControl,
  InputLabel, Select, MenuItem
} from '@mui/material';
import { Refresh, Visibility } from '@mui/icons-material';
import axiosInstance from '../api/axios.config';

const Jobs = () => {
  const [jobs, setJobs] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [statusFilter, setStatusFilter] = useState('');

  useEffect(() => {
    fetchJobs();
  }, [statusFilter]);

  const fetchJobs = async () => {
    setLoading(true);
    try {
      const params: any = {};
      if (statusFilter) params.status = statusFilter;
      const response = await axiosInstance.get('/admin/jobs', { params });
      setJobs(response.data.data);
    } catch (error) {
      console.error('Failed to fetch jobs:', error);
    } finally {
      setLoading(false);
    }
  };

  const getStatusChip = (status: string) => {
    const colors: Record<string, any> = {
      on_the_way: { color: 'info', label: 'On The Way' },
      in_progress: { color: 'warning', label: 'In Progress' },
      completed: { color: 'success', label: 'Completed' },
      cancelled: { color: 'error', label: 'Cancelled' },
    };
    const config = colors[status] || { color: 'default', label: status };
    return <Chip color={config.color} label={config.label} size="small" />;
  };

  return (
    <Box>
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
        <Typography variant="h4">Jobs</Typography>
        <Box display="flex" gap={2}>
          <FormControl size="small" sx={{ minWidth: 150 }}>
            <InputLabel>Status</InputLabel>
            <Select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value)}
              label="Status"
            >
              <MenuItem value="">All</MenuItem>
              <MenuItem value="on_the_way">On The Way</MenuItem>
              <MenuItem value="in_progress">In Progress</MenuItem>
              <MenuItem value="completed">Completed</MenuItem>
              <MenuItem value="cancelled">Cancelled</MenuItem>
            </Select>
          </FormControl>
          <IconButton onClick={fetchJobs}>
            <Refresh />
          </IconButton>
        </Box>
      </Box>

      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>ID</TableCell>
              <TableCell>Customer</TableCell>
              <TableCell>Professional</TableCell>
              <TableCell>Category</TableCell>
              <TableCell>Profession</TableCell>
              <TableCell>Status</TableCell>
              <TableCell>Started</TableCell>
              <TableCell>Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {jobs.map((job) => (
              <TableRow key={job.id}>
                <TableCell>{job.id.slice(0, 8)}</TableCell>
                <TableCell>
                  {job.customer?.first_name} {job.customer?.last_name}
                </TableCell>
                <TableCell>
                  {job.professional?.user?.first_name} {job.professional?.user?.last_name}
                </TableCell>
                <TableCell>{job.request?.category?.name || 'N/A'}</TableCell>
                <TableCell>{job.request?.profession?.name || 'N/A'}</TableCell>
                <TableCell>{getStatusChip(job.status)}</TableCell>
                <TableCell>{new Date(job.started_at).toLocaleDateString()}</TableCell>
                <TableCell>
                  <Tooltip title="View Details">
                    <IconButton size="small">
                      <Visibility />
                    </IconButton>
                  </Tooltip>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </Box>
  );
};

export default Jobs;