import { Request, Response, NextFunction } from 'express';
import { ProfessionsService } from './profession.service';

export class ProfessionsController {
  private service: ProfessionsService;

  constructor() {
    this.service = new ProfessionsService();
  }

  getByCategory = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { categoryId } = req.params;
      const professions = await this.service.getByCategory(categoryId);
      res.status(200).json({
        success: true,
        data: professions,
        message: 'Professions retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };
}
