import prisma from '../../config/database';
import { ServiceRequest, Job, Favorite, Review } from '@prisma/client';

export class CustomersRepository {
  // --- Service Requests ---
  async createRequest(data: {
    customer_id: string;
    category_id: string;
    profession_id: string;
    description: string;
    location?: any; // GeoJSON
    address?: string;
  }): Promise<ServiceRequest> {
    return prisma.serviceRequest.create({
      data: {
        customer_id: data.customer_id,
        category_id: data.category_id,
        profession_id: data.profession_id,
        description: data.description,
        location: data.location,
        address: data.address,
        status: 'pending',
      },
    });
  }

  async findRequestsByCustomer(customerId: string, filters?: { status?: string }): Promise<ServiceRequest[]> {
    return prisma.serviceRequest.findMany({
      where: {
        customer_id: customerId,
        ...(filters?.status && { status: filters.status }),
      },
      orderBy: { created_at: 'desc' },
      include: {
        category: true,
        profession: true,
        job: true,
      },
    });
  }

  async findRequestById(id: string): Promise<ServiceRequest | null> {
    return prisma.serviceRequest.findUnique({
      where: { id },
      include: {
        customer: true,
        category: true,
        profession: true,
        job: {
          include: {
            professional: true,
          },
        },
      },
    });
  }

  async updateRequestStatus(id: string, status: string, cancelledBy?: string, reason?: string): Promise<ServiceRequest> {
    return prisma.serviceRequest.update({
      where: { id },
      data: {
        status,
        cancelled_by: cancelledBy,
        cancellation_reason: reason,
        ...(status === 'cancelled' && { updated_at: new Date() }),
      },
    });
  }

  // --- Jobs ---
  async findJobsByCustomer(customerId: string): Promise<Job[]> {
    return prisma.job.findMany({
      where: { customer_id: customerId },
      orderBy: { started_at: 'desc' },
      include: {
        request: {
          include: { category: true, profession: true },
        },
        professional: true,
        review: true,
      },
    });
  }

  async findJobById(id: string): Promise<Job | null> {
    return prisma.job.findUnique({
      where: { id },
      include: {
        request: {
          include: { category: true, profession: true },
        },
        professional: true,
        review: true,
      },
    });
  }

  // --- Favorites ---
  async addFavorite(customerId: string, professionalId: string): Promise<Favorite> {
    return prisma.favorite.create({
      data: {
        customer_id: customerId,
        professional_id: professionalId,
      },
    });
  }

  async removeFavorite(customerId: string, professionalId: string): Promise<void> {
    await prisma.favorite.delete({
      where: {
        customer_id_professional_id: {
          customer_id: customerId,
          professional_id: professionalId,
        },
      },
    });
  }

  async findFavoritesByCustomer(customerId: string): Promise<Favorite[]> {
    return prisma.favorite.findMany({
      where: { customer_id: customerId },
      include: {
        professional: true,
      },
    });
  }

  async isFavorite(customerId: string, professionalId: string): Promise<boolean> {
    const favorite = await prisma.favorite.findUnique({
      where: {
        customer_id_professional_id: {
          customer_id: customerId,
          professional_id: professionalId,
        },
      },
    });
    return !!favorite;
  }

  // --- Reviews ---
  async createReview(data: {
    job_id: string;
    reviewer_id: string;
    professional_id: string;
    rating: number;
    comment?: string;
  }): Promise<Review> {
    return prisma.review.create({
      data: data,
    });
  }

  async findReviewsByCustomer(customerId: string): Promise<Review[]> {
    return prisma.review.findMany({
      where: { reviewer_id: customerId },
      orderBy: { created_at: 'desc' },
      include: {
        job: {
          include: {
            request: { include: { category: true, profession: true } },
          },
        },
        professional: true,
      },
    });
  }
}