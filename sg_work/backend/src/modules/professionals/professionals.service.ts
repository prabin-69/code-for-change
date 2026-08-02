import { ProfessionalsRepository } from './professionals.repository';
import { AuthRepository } from '../auth/auth.repository';
import { NotFoundError, BadRequestError, ConflictError, AppError } from '../../shared/utils/AppError';
import { ProfessionalProfile, Job } from '@prisma/client';
import prisma from '../../config/database';
import { eventBus } from '../../shared/events/event-bus';

export class ProfessionalsService {
  private repository: ProfessionalsRepository;
  private authRepo: AuthRepository;

  constructor() {
    this.repository = new ProfessionalsRepository();
    this.authRepo = new AuthRepository();
  }

  // --- Profile ---
  async getProfessionalProfile(userId: string): Promise<any> {
    let profile = await this.repository.findProfessionalByUserId(userId);
    if (!profile) {
      // Auto-create profile for professional users
      const user = await this.authRepo.findUserById(userId);
      if (!user) throw new NotFoundError('User not found');
      if (user.role !== 'PROFESSIONAL') {
        throw new BadRequestError('User is not a professional');
      }
      profile = await this.repository.createProfessionalProfile({ user_id: userId });
    }
    return profile;
  }

  async updateProfessionalProfile(userId: string, data: any): Promise<ProfessionalProfile> {
    return this.repository.updateProfessionalProfile(userId, data);
  }

  async updateAvailability(
    userId: string,
    availability: string,
  ): Promise<ProfessionalProfile> {
    const validStatuses = ['available', 'busy', 'offline'];
    if (!validStatuses.includes(availability)) {
      throw new BadRequestError(
        `Invalid availability status. Must be one of: ${validStatuses.join(', ')}`,
      );
    }
    return this.repository.updateProfessionalProfile(userId, { availability });
  }

  // --- Verification ---
  async submitVerification(userId: string): Promise<any> {
    const profile = await this.getProfessionalProfile(userId);
    if (profile.verification_status !== 'pending') {
      throw new ConflictError('Verification already submitted or processed');
    }
    return this.repository.submitVerificationRequest(userId, {});
  }

  async getVerificationStatus(userId: string): Promise<any> {
    await this.getProfessionalProfile(userId); // ensure profile exists
    return this.repository.getVerificationStatus(userId);
  }

  // --- Certificates ---
  async addCertificate(userId: string, data: any): Promise<any> {
    await this.getProfessionalProfile(userId);
    return this.repository.createCertificate({
      professional_id: userId,
      ...data,
    });
  }

  async getCertificates(userId: string): Promise<any[]> {
    return this.repository.findCertificatesByProfessional(userId);
  }

  async deleteCertificate(userId: string, certificateId: string): Promise<void> {
    const certs = await this.repository.findCertificatesByProfessional(userId);
    if (!certs.find((c) => c.id === certificateId)) {
      throw new NotFoundError('Certificate not found');
    }
    await this.repository.deleteCertificate(certificateId);
  }

  // --- Portfolio ---
  async addPortfolio(userId: string, data: any): Promise<any> {
    await this.getProfessionalProfile(userId);
    return this.repository.createPortfolio({
      professional_id: userId,
      ...data,
    });
  }

  async getPortfolio(userId: string): Promise<any[]> {
    return this.repository.findPortfolioByProfessional(userId);
  }

  async deletePortfolio(userId: string, portfolioId: string): Promise<void> {
    const items = await this.repository.findPortfolioByProfessional(userId);
    if (!items.find((p) => p.id === portfolioId)) {
      throw new NotFoundError('Portfolio item not found');
    }
    await this.repository.deletePortfolio(portfolioId);
  }

  // --- Jobs ---
  async getPendingRequests(
    userId: string,
    lat: number,
    lng: number,
    radiusKm: number = 10,
  ): Promise<any[]> {
    const profile = await this.getProfessionalProfile(userId);
    if (profile.availability !== 'available') {
      throw new BadRequestError('You are not available to accept requests');
    }
    // Get both nearby requests (existing) and direct offers (new)
    const nearbyRequests = await this.repository.getPendingRequestsNearby(lat, lng, radiusKm, userId);
    const directOffers = await this.repository.getDirectOffers(userId);
    
    // Merge: include requests that were directly assigned to this professional
    // Filter out duplicates (a request might be both nearby AND directly assigned)
    const seenIds = new Set(nearbyRequests.map((r: any) => r.id));
    
    // Add direct offer requests that are NOT already in nearby results
    for (const offer of directOffers) {
      const reqId = (offer as any).request_id || (offer.request?.id);
      if (reqId && !seenIds.has(reqId)) {
        nearbyRequests.push(offer.request || offer);
        seenIds.add(reqId);
      }
    }
    
    return nearbyRequests;
  }

  async rejectRequest(userId: string, requestId: string): Promise<void> {
    // Update the direct offer status to 'rejected' if exists
    await prisma.requestOffer.updateMany({
      where: { request_id: requestId, professional_id: userId },
      data: { response: 'rejected', accepted_at: new Date() },
    });

    // Get the request to find the customer
    const request = await prisma.serviceRequest.findUnique({
      where: { id: requestId },
      select: { customer_id: true, status: true },
    });

    if (!request) throw new NotFoundError('Request not found');

    // Emit real-time event that booking was rejected
    eventBus.emit('booking:rejected', {
      requestId,
      professionalId: userId,
      customerId: request.customer_id,
    });
  }

  async acceptRequest(userId: string, requestId: string): Promise<Job> {
    // 1. Check professional availability before entering the transaction
    const profile = await this.getProfessionalProfile(userId);
    if (profile.availability !== 'available') {
      throw new BadRequestError('You are not available');
    }

    // 2. Atomically transition the request from 'pending' → 'accepted'.
    const job = await prisma.$transaction(async (tx) => {
      const updateResult = await tx.serviceRequest.updateMany({
        where: { id: requestId, status: 'pending' },
        data: { status: 'accepted', accepted_by: userId },
      });

      if (updateResult.count === 0) {
        const existing = await tx.serviceRequest.findUnique({
          where: { id: requestId },
          select: { id: true, status: true },
        });
        if (!existing) throw new NotFoundError('Request not found');
        throw new ConflictError('Request was already accepted by another professional');
      }

      const request = await tx.serviceRequest.findUnique({
        where: { id: requestId },
        select: { customer_id: true },
      });

      const newJob = await tx.job.create({
        data: {
          request_id: requestId,
          professional_id: userId,
          customer_id: request!.customer_id,
          status: 'on_the_way',
          started_at: new Date(),
        },
      });

      await tx.professionalProfile.update({
        where: { user_id: userId },
        data: { total_jobs: { increment: 1 } },
      });

      // Update the direct offer status to 'accepted' if exists
      await tx.requestOffer.updateMany({
        where: { request_id: requestId, professional_id: userId },
        data: { response: 'accepted', accepted_at: new Date() },
      });

      return { newJob, customerId: request!.customer_id };
    });

    // Emit real-time event that booking was accepted
    eventBus.emit('booking:accepted', {
      jobId: (job as any).newJob.id,
      requestId,
      professionalId: userId,
      customerId: (job as any).customerId,
    });

    return (job as any).newJob;
  }

  async getMyJobs(userId: string, status?: string): Promise<Job[]> {
    return this.repository.findJobsByProfessional(userId, status ? { status } : undefined);
  }

  async getJobDetails(userId: string, jobId: string): Promise<Job> {
    const job = await this.repository.findJobById(jobId);
    if (!job) throw new NotFoundError('Job not found');
    if ((job as any).professional_id !== userId) {
      throw new AppError('You do not have permission to view this job', 403);
    }
    return job;
  }

  async updateJobStatus(
    userId: string,
    jobId: string,
    data: { status: string; before_photos?: string[]; after_photos?: string[] },
  ): Promise<Job> {
    const job = await this.getJobDetails(userId, jobId);
    if ((job as any).status === 'completed' || (job as any).status === 'cancelled') {
      throw new BadRequestError('Job already finalized');
    }

    const updateData: any = { status: data.status };
    if (data.status === 'completed') {
      updateData.completed_at = new Date();
    }
    if (data.before_photos) updateData.before_photos = data.before_photos;
    if (data.after_photos) updateData.after_photos = data.after_photos;

    return this.repository.updateJobStatus(jobId, updateData);
  }

  // --- Performance ---
  async getPerformance(userId: string): Promise<any> {
    await this.getProfessionalProfile(userId);
    return this.repository.getPerformanceMetrics(userId);
  }
}
