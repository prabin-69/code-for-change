import { ProfessionsRepository } from './professions.repository';
import { Profession } from '@prisma/client';
import { NotFoundError } from '../../shared/utils/AppError';

export class ProfessionsService {
  private repository: ProfessionsRepository;

  constructor() {
    this.repository = new ProfessionsRepository();
  }

  async getByCategory(categoryId: string): Promise<Profession[]> {
    return this.repository.findByCategory(categoryId);
  }

  async getById(id: string): Promise<Profession> {
    const profession = await this.repository.findById(id);
    if (!profession) throw new NotFoundError('Profession not found');
    return profession;
  }
}