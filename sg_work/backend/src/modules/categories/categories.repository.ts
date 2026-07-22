import prisma from '../../config/database';
import { Category } from '@prisma/client';

export class CategoriesRepository {
  async findAllActive(): Promise<Category[]> {
    return prisma.category.findMany({
      where: { is_active: true },
      orderBy: { name: 'asc' },
    });
  }

  async findById(id: string): Promise<Category | null> {
    return prisma.category.findUnique({
      where: { id },
    });
  }

  // Admin only
  async create(data: { name: string; icon?: string }): Promise<Category> {
    return prisma.category.create({ data });
  }

  async update(id: string, data: Partial<Category>): Promise<Category> {
    return prisma.category.update({ where: { id }, data });
  }

  async softDelete(id: string): Promise<Category> {
    return prisma.category.update({ where: { id }, data: { is_active: false } });
  }
}