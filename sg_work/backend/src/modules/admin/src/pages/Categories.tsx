import React, { useState, useEffect } from 'react';
import {
  Box, Typography, Paper, Table, TableBody, TableCell, TableContainer,
  TableHead, TableRow, IconButton, Tooltip, Button, Dialog, DialogTitle,
  DialogContent, DialogActions, TextField, Chip, Switch,
} from '@mui/material';
import { Add, Edit, Delete, Refresh } from '@mui/icons-material';
import axiosInstance from '../api/axios.config';

const Categories = () => {
  const [categories, setCategories] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editingCategory, setEditingCategory] = useState<any>(null);
  const [categoryName, setCategoryName] = useState('');
  const [categoryIcon, setCategoryIcon] = useState('');
  const [professions, setProfessions] = useState<any[]>([]);
  const [professionDialogOpen, setProfessionDialogOpen] = useState(false);
  const [selectedCategoryId, setSelectedCategoryId] = useState('');
  const [professionName, setProfessionName] = useState('');
  const [editingProfession, setEditingProfession] = useState<any>(null);

  useEffect(() => {
    fetchCategories();
  }, []);

  const fetchCategories = async () => {
    setLoading(true);
    try {
      const response = await axiosInstance.get('/categories');
      setCategories(response.data.data);
    } catch (error) {
      console.error('Failed to fetch categories:', error);
    } finally {
      setLoading(false);
    }
  };

  const fetchProfessions = async (categoryId: string) => {
    try {
      const response = await axiosInstance.get(`/professions/category/${categoryId}`);
      setProfessions(response.data.data);
    } catch (error) {
      console.error('Failed to fetch professions:', error);
    }
  };

  const handleSaveCategory = async () => {
    try {
      if (editingCategory) {
        await axiosInstance.put(`/admin/categories/${editingCategory.id}`, {
          name: categoryName,
          icon: categoryIcon,
        });
      } else {
        await axiosInstance.post('/admin/categories', {
          name: categoryName,
          icon: categoryIcon,
        });
      }
      await fetchCategories();
      setDialogOpen(false);
      resetCategoryForm();
    } catch (error) {
      console.error('Failed to save category:', error);
    }
  };

  const handleDeleteCategory = async (id: string) => {
    if (window.confirm('Are you sure? This will soft-delete the category.')) {
      try {
        await axiosInstance.delete(`/admin/categories/${id}`);
        await fetchCategories();
      } catch (error) {
        console.error('Failed to delete category:', error);
      }
    }
  };

  const resetCategoryForm = () => {
    setCategoryName('');
    setCategoryIcon('');
    setEditingCategory(null);
  };

  const handleSaveProfession = async () => {
    try {
      if (editingProfession) {
        await axiosInstance.put(`/admin/professions/${editingProfession.id}`, {
          name: professionName,
        });
      } else {
        await axiosInstance.post('/admin/professions', {
          name: professionName,
          category_id: selectedCategoryId,
        });
      }
      await fetchProfessions(selectedCategoryId);
      setProfessionDialogOpen(false);
      setProfessionName('');
      setEditingProfession(null);
    } catch (error) {
      console.error('Failed to save profession:', error);
    }
  };

  const handleDeleteProfession = async (id: string) => {
    if (window.confirm('Are you sure?')) {
      try {
        await axiosInstance.delete(`/admin/professions/${id}`);
        await fetchProfessions(selectedCategoryId);
      } catch (error) {
        console.error('Failed to delete profession:', error);
      }
    }
  };

  return (
    <Box>
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
        <Typography variant="h4">Categories & Professions</Typography>
        <Button
          variant="contained"
          startIcon={<Add />}
          onClick={() => {
            resetCategoryForm();
            setDialogOpen(true);
          }}
        >
          Add Category
        </Button>
      </Box>

      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Name</TableCell>
              <TableCell>Icon</TableCell>
              <TableCell>Active</TableCell>
              <TableCell>Professions</TableCell>
              <TableCell>Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {categories.map((category) => (
              <TableRow key={category.id}>
                <TableCell>{category.name}</TableCell>
                <TableCell>{category.icon || '—'}</TableCell>
                <TableCell>
                  <Chip
                    color={category.is_active ? 'success' : 'error'}
                    label={category.is_active ? 'Active' : 'Inactive'}
                    size="small"
                  />
                </TableCell>
                <TableCell>
                  <Button
                    size="small"
                    onClick={() => {
                      setSelectedCategoryId(category.id);
                      fetchProfessions(category.id);
                    }}
                  >
                    Manage
                  </Button>
                </TableCell>
                <TableCell>
                  <Tooltip title="Edit">
                    <IconButton
                      onClick={() => {
                        setEditingCategory(category);
                        setCategoryName(category.name);
                        setCategoryIcon(category.icon || '');
                        setDialogOpen(true);
                      }}
                    >
                      <Edit />
                    </IconButton>
                  </Tooltip>
                  <Tooltip title="Delete">
                    <IconButton onClick={() => handleDeleteCategory(category.id)}>
                      <Delete />
                    </IconButton>
                  </Tooltip>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>

      {/* Category Dialog */}
      <Dialog open={dialogOpen} onClose={() => setDialogOpen(false)} maxWidth="sm" fullWidth>
        <DialogTitle>{editingCategory ? 'Edit Category' : 'Add Category'}</DialogTitle>
        <DialogContent>
          <TextField
            fullWidth
            margin="normal"
            label="Category Name"
            value={categoryName}
            onChange={(e) => setCategoryName(e.target.value)}
          />
          <TextField
            fullWidth
            margin="normal"
            label="Icon (URL or emoji)"
            value={categoryIcon}
            onChange={(e) => setCategoryIcon(e.target.value)}
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setDialogOpen(false)}>Cancel</Button>
          <Button onClick={handleSaveCategory} variant="contained">Save</Button>
        </DialogActions>
      </Dialog>

      {/* Professions Dialog */}
      <Dialog
        open={professionDialogOpen}
        onClose={() => setProfessionDialogOpen(false)}
        maxWidth="sm"
        fullWidth
      >
        <DialogTitle>Manage Professions</DialogTitle>
        <DialogContent>
          <Box display="flex" gap={2} alignItems="center" mb={2}>
            <TextField
              fullWidth
              label="Profession Name"
              value={professionName}
              onChange={(e) => setProfessionName(e.target.value)}
            />
            <Button
              variant="contained"
              onClick={handleSaveProfession}
            >
              {editingProfession ? 'Update' : 'Add'}
            </Button>
          </Box>
          <TableContainer component={Paper} variant="outlined">
            <Table size="small">
              <TableHead>
                <TableRow>
                  <TableCell>Name</TableCell>
                  <TableCell>Status</TableCell>
                  <TableCell>Actions</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {professions.map((prof) => (
                  <TableRow key={prof.id}>
                    <TableCell>{prof.name}</TableCell>
                    <TableCell>
                      <Chip
                        color={prof.is_active ? 'success' : 'error'}
                        label={prof.is_active ? 'Active' : 'Inactive'}
                        size="small"
                      />
                    </TableCell>
                    <TableCell>
                      <IconButton
                        size="small"
                        onClick={() => {
                          setEditingProfession(prof);
                          setProfessionName(prof.name);
                        }}
                      >
                        <Edit />
                      </IconButton>
                      <IconButton
                        size="small"
                        onClick={() => handleDeleteProfession(prof.id)}
                      >
                        <Delete />
                      </IconButton>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </TableContainer>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setProfessionDialogOpen(false)}>Close</Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default Categories;