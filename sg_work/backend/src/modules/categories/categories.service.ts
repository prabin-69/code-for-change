import { CategoriesRepository } from './categories.repository';
import { Category } from '@prisma/client';
import { NotFoundError } from '../../shared/utils/AppError';

export class CategoriesService {
  private repository: CategoriesRepository;

  constructor() {
    this.repository = new CategoriesRepository();
  }

  async getAllActive(): Promise<Category[]> {
    return this.repository.findAllActive();
  }

  async getById(id: string): Promise<Category> {
    const category = await this.repository.findById(id);
    if (!category) throw new NotFoundError('Category not found');
    return category;
  }
}