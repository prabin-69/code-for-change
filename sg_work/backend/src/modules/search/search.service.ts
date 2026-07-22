import { SearchRepository } from './search.repository';

export class SearchService {
  private repo: SearchRepository;

  constructor() {
    this.repo = new SearchRepository();
  }

  async search(params: {
    lat?: number;
    lng?: number;
    radiusKm?: number;
    categoryId?: string;
    professionId?: string;
    minRating?: number;
    availability?: string;
    isFeatured?: boolean;
    search?: string;
    limit?: number;
    page?: number;
  }) {
    const limit = Math.min(params.limit ?? 20, 100);
    const offset = ((params.page ?? 1) - 1) * limit;

    if (params.lat != null && params.lng != null) {
      return this.repo.searchProfessionalsNearby({
        lat: params.lat,
        lng: params.lng,
        radiusKm: params.radiusKm ?? 10,
        categoryId: params.categoryId,
        professionId: params.professionId,
        minRating: params.minRating,
        availability: params.availability,
        isFeatured: params.isFeatured,
        limit,
        offset,
      });
    }

    return this.repo.searchProfessionals({
      categoryId: params.categoryId,
      professionId: params.professionId,
      minRating: params.minRating,
      availability: params.availability,
      isFeatured: params.isFeatured,
      search: params.search,
      limit,
      offset,
    });
  }

  async getProfessionalProfile(professionalId: string) {
    return this.repo.getProfessionalPublicProfile(professionalId);
  }

  async getProfessionalReviews(professionalId: string, limit?: number, page?: number) {
    const lim = Math.min(limit ?? 20, 100);
    const offset = ((page ?? 1) - 1) * lim;
    return this.repo.getProfessionalReviews(professionalId, lim, offset);
  }
}
