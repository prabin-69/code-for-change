import { Request, Response, NextFunction } from 'express';
import { CategoriesService } from './categories.service';

export class CategoriesController {
  private service: CategoriesService;

  constructor() {
    this.service = new CategoriesService();
  }

  getAll = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const categories = await this.service.getAllActive();
      res.status(200).json({
        success: true,
        data: categories,
        message: 'Categories retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };
}