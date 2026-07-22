import prisma from '../../config/database';
import { Profession } from '@prisma/client';

export class ProfessionsRepository {
  async findByCategory(categoryId: string): Promise<Profession[]> {
    return prisma.profession.findMany({
      where: { category_id: categoryId, is_active: true },
      orderBy: { name: 'asc' },
    });
  }

  async findById(id: string): Promise<Profession | null> {
    return prisma.profession.findUnique({
      where: { id },
    });
  }
}