import React, { useState, useEffect } from 'react';
import {
  Box, Typography, Paper, Grid, Card, CardContent, FormControl,
  InputLabel, Select, MenuItem, SelectChangeEvent
} from '@mui/material';
import {
  LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend,
  ResponsiveContainer, BarChart, Bar, PieChart, Pie, Cell
} from 'recharts';
import axiosInstance from '../api/axios.config';

const Analytics = () => {
  const [analytics, setAnalytics] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [timeframe, setTimeframe] = useState<'daily' | 'weekly' | 'monthly'>('monthly');

  useEffect(() => {
    fetchAnalytics();
  }, [timeframe]);

  const fetchAnalytics = async () => {
    setLoading(true);
    try {
      const response = await axiosInstance.get('/admin/analytics', {
        params: { timeframe },
      });
      setAnalytics(response.data.data);
    } catch (error) {
      console.error('Failed to fetch analytics:', error);
    } finally {
      setLoading(false);
    }
  };

  const COLORS = ['#0088FE', '#00C49F', '#FFBB28', '#FF8042', '#8884D8'];

  return (
    <Box>
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
        <Typography variant="h4">Analytics</Typography>
        <FormControl size="small" sx={{ minWidth: 150 }}>
          <InputLabel>Timeframe</InputLabel>
          <Select
            value={timeframe}
            onChange={(e) => setTimeframe(e.target.value as any)}
            label="Timeframe"
          >
            <MenuItem value="daily">Daily</MenuItem>
            <MenuItem value="weekly">Weekly</MenuItem>
            <MenuItem value="monthly">Monthly</MenuItem>
          </Select>
        </FormControl>
      </Box>

      {loading ? (
        <Typography>Loading...</Typography>
      ) : analytics ? (
        <Grid container spacing={3}>
          {/* Jobs Trend */}
          <Grid item xs={12} md={8}>
            <Paper sx={{ p: 2 }}>
              <Typography variant="h6" gutterBottom>Jobs Trend</Typography>
              <ResponsiveContainer width="100%" height={300}>
                <LineChart data={analytics.jobsByDate}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="date" />
                  <YAxis />
                  <Tooltip />
                  <Legend />
                  <Line type="monotone" dataKey="count" stroke="#8884d8" name="Total Jobs" />
                  <Line type="monotone" dataKey="completed" stroke="#82ca9d" name="Completed" />
                  <Line type="monotone" dataKey="cancelled" stroke="#ff7300" name="Cancelled" />
                </LineChart>
              </ResponsiveContainer>
            </Paper>
          </Grid>

          {/* Top Professionals */}
          <Grid item xs={12} md={4}>
            <Paper sx={{ p: 2 }}>
              <Typography variant="h6" gutterBottom>Top Professionals</Typography>
              <ResponsiveContainer width="100%" height={300}>
                <BarChart data={analytics.topProfessionals}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="first_name" />
                  <YAxis />
                  <Tooltip />
                  <Bar dataKey="job_count" fill="#8884d8" />
                </BarChart>
              </ResponsiveContainer>
            </Paper>
          </Grid>

          {/* Top Services */}
          <Grid item xs={12} md={6}>
            <Paper sx={{ p: 2 }}>
              <Typography variant="h6" gutterBottom>Most Requested Services</Typography>
              <ResponsiveContainer width="100%" height={300}>
                <BarChart data={analytics.topServices}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="profession_name" />
                  <YAxis />
                  <Tooltip />
                  <Bar dataKey="request_count" fill="#82ca9d" />
                </BarChart>
              </ResponsiveContainer>
            </Paper>
          </Grid>

          {/* Performance Summary */}
          <Grid item xs={12} md={6}>
            <Paper sx={{ p: 2 }}>
              <Typography variant="h6" gutterBottom>Performance Summary</Typography>
              <Grid container spacing={2}>
                <Grid item xs={6}>
                  <Card>
                    <CardContent>
                      <Typography color="textSecondary">Total Jobs</Typography>
                      <Typography variant="h4">
                        {analytics.jobsByDate?.reduce((sum: number, item: any) => sum + item.count, 0) || 0}
                      </Typography>
                    </CardContent>
                  </Card>
                </Grid>
                <Grid item xs={6}>
                  <Card>
                    <CardContent>
                      <Typography color="textSecondary">Avg. Completion</Typography>
                      <Typography variant="h4">
                        {analytics.jobsByDate?.length
                          ? Math.round(
                              (analytics.jobsByDate.reduce((sum: number, item: any) => sum + item.completed, 0) /
                                analytics.jobsByDate.reduce((sum: number, item: any) => sum + item.count, 0)) *
                                100
                            )
                          : 0}%
                      </Typography>
                    </CardContent>
                  </Card>
                </Grid>
              </Grid>
            </Paper>
          </Grid>
        </Grid>
      ) : (
        <Typography>No data available</Typography>
      )}
    </Box>
  );
};

export default Analytics;