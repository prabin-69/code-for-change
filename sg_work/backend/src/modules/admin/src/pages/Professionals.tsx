import React, { useState, useEffect } from 'react';
import {
  Box,
  Typography,
  Paper,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Chip,
  Button,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  IconButton,
  Tooltip,
} from '@mui/material';
import { Check, Close, Star } from '@mui/icons-material';
import axiosInstance from '../api/axios.config';

const Professionals = () => {
  const [professionals, setProfessionals] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedProfessional, setSelectedProfessional] = useState<any>(null);
  const [dialogOpen, setDialogOpen] = useState(false);
  const [dialogType, setDialogType] = useState<'verification' | 'featured'>('verification');
  const [verificationStatus, setVerificationStatus] = useState('approved');
  const [rejectionReason, setRejectionReason] = useState('');
  const [isFeatured, setIsFeatured] = useState(false);
  const [featuredDays, setFeaturedDays] = useState(30);

  useEffect(() => {
    fetchProfessionals();
  }, []);

  const fetchProfessionals = async () => {
    try {
      const response = await axiosInstance.get('/admin/professionals');
      setProfessionals(response.data.data);
    } catch (error) {
      console.error('Failed to fetch professionals:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleVerification = async () => {
    try {
      await axiosInstance.put(
        `/admin/professionals/${selectedProfessional.user_id}/verification`,
        {
          status: verificationStatus,
          rejection_reason: verificationStatus === 'rejected' ? rejectionReason : undefined,
        }
      );
      await fetchProfessionals();
      setDialogOpen(false);
    } catch (error) {
      console.error('Failed to update verification:', error);
    }
  };

  const handleFeatured = async () => {
    try {
      await axiosInstance.put(
        `/admin/professionals/${selectedProfessional.user_id}/featured`,
        {
          is_featured: isFeatured,
          duration_days: isFeatured ? featuredDays : 0,
        }
      );
      await fetchProfessionals();
      setDialogOpen(false);
    } catch (error) {
      console.error('Failed to update featured:', error);
    }
  };

  const getStatusChip = (status: string) => {
    const colors: Record<string, any> = {
      pending: { color: 'warning', label: 'Pending' },
      approved: { color: 'success', label: 'Approved' },
      rejected: { color: 'error', label: 'Rejected' },
    };
    const config = colors[status] || { color: 'default', label: status };
    return <Chip color={config.color} label={config.label} size="small" />;
  };

  const getAvailabilityChip = (availability: string) => {
    const colors: Record<string, any> = {
      available: { color: 'success', label: 'Available' },
      busy: { color: 'warning', label: 'Busy' },
      offline: { color: 'default', label: 'Offline' },
    };
    const config = colors[availability] || { color: 'default', label: availability };
    return <Chip color={config.color} label={config.label} size="small" />;
  };

  return (
    <Box>
      <Typography variant="h4" gutterBottom>Professionals</Typography>
      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Name</TableCell>
              <TableCell>Phone</TableCell>
              <TableCell>Category</TableCell>
              <TableCell>Profession</TableCell>
              <TableCell>Verification</TableCell>
              <TableCell>Featured</TableCell>
              <TableCell>Availability</TableCell>
              <TableCell>Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {professionals.map((prof) => (
              <TableRow key={prof.user_id}>
                <TableCell>
                  {prof.user.first_name} {prof.user.last_name}
                </TableCell>
                <TableCell>{prof.user.phone_number}</TableCell>
                <TableCell>{prof.category?.name || 'N/A'}</TableCell>
                <TableCell>{prof.profession?.name || 'N/A'}</TableCell>
                <TableCell>{getStatusChip(prof.verification_status)}</TableCell>
                <TableCell>
                  {prof.is_featured ? (
                    <Chip color="primary" label="Featured" size="small" />
                  ) : (
                    <Chip label="No" size="small" />
                  )}
                </TableCell>
                <TableCell>{getAvailabilityChip(prof.availability)}</TableCell>
                <TableCell>
                  <Tooltip title="Verify">
                    <IconButton
                      onClick={() => {
                        setSelectedProfessional(prof);
                        setDialogType('verification');
                        setDialogOpen(true);
                      }}
                    >
                      <Check />
                    </IconButton>
                  </Tooltip>
                  <Tooltip title="Toggle Featured">
                    <IconButton
                      onClick={() => {
                        setSelectedProfessional(prof);
                        setIsFeatured(!prof.is_featured);
                        setDialogType('featured');
                        setDialogOpen(true);
                      }}
                    >
                      <Star color={prof.is_featured ? 'primary' : 'action'} />
                    </IconButton>
                  </Tooltip>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>

      {/* Dialog */}
      <Dialog open={dialogOpen} onClose={() => setDialogOpen(false)} maxWidth="sm" fullWidth>
        <DialogTitle>
          {dialogType === 'verification'
            ? `Verify ${selectedProfessional?.user?.first_name || ''}`
            : 'Update Featured Status'}
        </DialogTitle>
        <DialogContent>
          {dialogType === 'verification' ? (
            <>
              <FormControl fullWidth margin="normal">
                <InputLabel>Status</InputLabel>
                <Select
                  value={verificationStatus}
                  onChange={(e) => setVerificationStatus(e.target.value)}
                >
                  <MenuItem value="approved">Approve</MenuItem>
                  <MenuItem value="rejected">Reject</MenuItem>
                </Select>
              </FormControl>
              {verificationStatus === 'rejected' && (
                <TextField
                  fullWidth
                  margin="normal"
                  label="Rejection Reason"
                  multiline
                  rows={3}
                  value={rejectionReason}
                  onChange={(e) => setRejectionReason(e.target.value)}
                />
              )}
            </>
          ) : (
            <>
              <FormControl fullWidth margin="normal">
                <InputLabel>Featured Status</InputLabel>
                <Select
                  value={isFeatured ? 'true' : 'false'}
                  onChange={(e) => setIsFeatured(e.target.value === 'true')}
                >
                  <MenuItem value="true">Enable Featured</MenuItem>
                  <MenuItem value="false">Disable Featured</MenuItem>
                </Select>
              </FormControl>
              {isFeatured && (
                <FormControl fullWidth margin="normal">
                  <InputLabel>Duration (days)</InputLabel>
                  <Select
                    value={featuredDays}
                    onChange={(e) => setFeaturedDays(Number(e.target.value))}
                  >
                    <MenuItem value={7}>7 Days</MenuItem>
                    <MenuItem value={30}>30 Days</MenuItem>
                    <MenuItem value={90}>90 Days</MenuItem>
                  </Select>
                </FormControl>
              )}
            </>
          )}
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setDialogOpen(false)}>Cancel</Button>
          <Button
            onClick={dialogType === 'verification' ? handleVerification : handleFeatured}
            variant="contained"
          >
            Save
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default Professionals;