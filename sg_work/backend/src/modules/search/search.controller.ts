import { Request, Response, NextFunction } from 'express';
import { SearchService } from './search.service';

export class SearchController {
  private service: SearchService;

  constructor() {
    this.service = new SearchService();
  }

  search = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const {
        lat, lng, radius, category_id, profession_id,
        min_rating, availability, is_featured, search, limit, page,
      } = req.query;

      const results = await this.service.search({
        lat: lat ? parseFloat(lat as string) : undefined,
        lng: lng ? parseFloat(lng as string) : undefined,
        radiusKm: radius ? parseFloat(radius as string) : undefined,
        categoryId: category_id as string | undefined,
        professionId: profession_id as string | undefined,
        minRating: min_rating ? parseFloat(min_rating as string) : undefined,
        availability: availability as string | undefined,
        isFeatured: is_featured === 'true' ? true : undefined,
        search: search as string | undefined,
        limit: limit ? parseInt(limit as string) : undefined,
        page: page ? parseInt(page as string) : undefined,
      });

      res.status(200).json({
        success: true,
        data: results,
        message: 'Search results retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  getProfessionalProfile = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { professionalId } = req.params;
      const profile = await this.service.getProfessionalProfile(professionalId);
      if (!profile) {
        return res.status(404).json({
          success: false,
          data: null,
          message: 'Professional not found',
          errors: null,
          timestamp: new Date().toISOString(),
        });
      }
      res.status(200).json({
        success: true,
        data: profile,
        message: 'Professional profile retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  getProfessionalReviews = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { professionalId } = req.params;
      const { limit, page } = req.query;
      const reviews = await this.service.getProfessionalReviews(
        professionalId,
        limit ? parseInt(limit as string) : undefined,
        page ? parseInt(page as string) : undefined,
      );
      res.status(200).json({
        success: true,
        data: reviews,
        message: 'Reviews retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };
}
