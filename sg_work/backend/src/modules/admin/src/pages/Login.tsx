import React, { useState } from 'react';
import { Box, TextField, Button, Typography, Paper } from '@mui/material';
import axiosInstance from '../api/axios.config';
import { useNavigate } from 'react-router-dom';

const Login = () => {
  const navigate = useNavigate();
  const [phone, setPhone] = useState('');
  const [otp, setOtp] = useState('');
  const [step, setStep] = useState<'phone' | 'otp'>('phone');

  const sendOtp = async () => {
    try {
      await axiosInstance.post('/auth/send-otp', { phone });
      setStep('otp');
    } catch (error) {
      alert('Failed to send OTP');
    }
  };

  const verifyOtp = async () => {
    try {
      const response = await axiosInstance.post('/auth/verify-otp', { phone, otp });
      const { access_token, refresh_token } = response.data.data;
      localStorage.setItem('access_token', access_token);
      localStorage.setItem('refresh_token', refresh_token);
      navigate('/dashboard');
    } catch (error) {
      alert('Invalid OTP');
    }
  };

  return (
    <Box display="flex" justifyContent="center" alignItems="center" minHeight="100vh">
      <Paper sx={{ p: 4, maxWidth: 400, width: '100%' }}>
        <Typography variant="h5" gutterBottom>Admin Login</Typography>
        {step === 'phone' ? (
          <>
            <TextField
              fullWidth
              margin="normal"
              label="Phone Number"
              value={phone}
              onChange={(e) => setPhone(e.target.value)}
            />
            <Button fullWidth variant="contained" onClick={sendOtp}>Send OTP</Button>
          </>
        ) : (
          <>
            <Typography>OTP sent to {phone}</Typography>
            <TextField
              fullWidth
              margin="normal"
              label="OTP"
              value={otp}
              onChange={(e) => setOtp(e.target.value)}
            />
            <Button fullWidth variant="contained" onClick={verifyOtp}>Verify</Button>
          </>
        )}
      </Paper>
    </Box>
  );
};

export default Login;