import { CustomersRepository } from './customers.repository';
import { CategoriesService } from '../categories/categories.service';
import { ProfessionsService } from '../professionals/profession.service';
import { pointToGeoJSON } from '../../shared/utils/geo.utils';
import { AppError, NotFoundError, ConflictError } from '../../shared/utils/AppError';
import { ServiceRequest, Job } from '@prisma/client';
import { eventBus } from '../../shared/events/event-bus';

export class CustomersService {
  private repository: CustomersRepository;
  private categoriesService: CategoriesService;
  private professionsService: ProfessionsService;

  constructor() {
    this.repository = new CustomersRepository();
    this.categoriesService = new CategoriesService();
    this.professionsService = new ProfessionsService();
  }

  // --- Requests ---
  async createRequest(
    customerId: string,
    data: {
      category_id: string;
      profession_id: string;
      description: string;
      latitude: number;
      longitude: number;
      address?: string;
      professional_id?: string;  // Direct booking to a specific professional
      budget?: number;
      preferred_date?: string;
      preferred_time?: string;
      images?: string[];
    },
  ): Promise<ServiceRequest> {
    // Validate that category and profession exist
    await this.categoriesService.getById(data.category_id);
    await this.professionsService.getById(data.profession_id);

    const location = pointToGeoJSON(data.latitude, data.longitude);
    
    // Create the service request (always as pending)
    const request = await this.repository.createRequest({
      customer_id: customerId,
      category_id: data.category_id,
      profession_id: data.profession_id,
      description: data.description,
      location,
      address: data.address,
      budget: data.budget,
      preferred_date: data.preferred_date ? new Date(data.preferred_date) : undefined,
      preferred_time: data.preferred_time,
      images: data.images ?? [],
    });

    // If a specific professional was selected, create a direct RequestOffer
    if (data.professional_id) {
      await this.repository.createDirectOffer({
        request_id: request.id,
        professional_id: data.professional_id,
      });

      // Emit event for real-time notification via Socket.IO
      eventBus.emit('booking:new_request', {
        requestId: request.id,
        professionalId: data.professional_id,
        customerId,
        categoryId: data.category_id,
        professionId: data.profession_id,
        description: data.description,
        address: data.address,
        budget: data.budget,
        preferredDate: data.preferred_date,
        preferredTime: data.preferred_time,
      });
    }

    return request;
  }

  async getCustomerRequests(customerId: string, status?: string): Promise<ServiceRequest[]> {
    return this.repository.findRequestsByCustomer(
      customerId,
      status ? { status } : undefined,
    );
  }

  async getRequestById(customerId: string, requestId: string): Promise<ServiceRequest> {
    const request = await this.repository.findRequestById(requestId);
    if (!request) throw new NotFoundError('Request not found');
    if (request.customer_id !== customerId) {
      throw new AppError('You do not have permission to view this request', 403);
    }
    return request;
  }

  async cancelRequest(
    customerId: string,
    requestId: string,
    reason?: string,
  ): Promise<ServiceRequest> {
    const request = await this.getRequestById(customerId, requestId);
    if (request.status === 'completed' || request.status === 'cancelled') {
      throw new ConflictError('Request cannot be cancelled in its current status');
    }
    return this.repository.updateRequestStatus(requestId, 'cancelled', 'customer', reason);
  }

  // --- Jobs ---
  async getCustomerJobs(customerId: string): Promise<Job[]> {
    return this.repository.findJobsByCustomer(customerId);
  }

  async getJobById(customerId: string, jobId: string): Promise<Job> {
    const job = await this.repository.findJobById(jobId);
    if (!job) throw new NotFoundError('Job not found');
    if ((job as any).customer_id !== customerId) {
      throw new AppError('You do not have permission to view this job', 403);
    }
    return job;
  }

  // --- Favorites ---
  async addFavorite(customerId: string, professionalId: string): Promise<void> {
    const exists = await this.repository.isFavorite(customerId, professionalId);
    if (exists) throw new ConflictError('Professional is already in your favorites');
    await this.repository.addFavorite(customerId, professionalId);
  }

  async removeFavorite(customerId: string, professionalId: string): Promise<void> {
    await this.repository.removeFavorite(customerId, professionalId);
  }

  async getFavorites(customerId: string): Promise<any[]> {
    const favorites = await this.repository.findFavoritesByCustomer(customerId);
    return favorites.map((fav) => (fav as any).professional);
  }

  // --- Reviews ---
  async createReview(
    customerId: string,
    data: { job_id: string; rating: number; comment?: string },
  ): Promise<any> {
    const job = await this.repository.findJobById(data.job_id);
    if (!job) throw new NotFoundError('Job not found');
    if ((job as any).customer_id !== customerId) {
      throw new AppError('You are not authorized to review this job', 403);
    }
    if ((job as any).status !== 'completed') {
      throw new AppError('Job must be completed before leaving a review', 400);
    }
    if ((job as any).review) {
      throw new ConflictError('A review has already been submitted for this job');
    }

    return this.repository.createReview({
      job_id: data.job_id,
      reviewer_id: customerId,
      professional_id: (job as any).professional_id,
      rating: data.rating,
      comment: data.comment,
    });
  }

  async getCustomerReviews(customerId: string): Promise<any[]> {
    return this.repository.findReviewsByCustomer(customerId);
  }
}
