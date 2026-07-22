import prisma from '../../config/database';
import { ProfessionalProfile, Certificate, Portfolio, Job, VerificationRequest } from '@prisma/client';

export class ProfessionalsRepository {
  // --- Professional Profile ---
  async findProfessionalByUserId(userId: string): Promise<ProfessionalProfile | null> {
    return prisma.professionalProfile.findUnique({
      where: { user_id: userId },
      include: {
        user: true,
        category: true,
        profession: true,
        certificates: true,
        portfolio: true,
        verification_requests: true,
      },
    });
  }

  async createProfessionalProfile(data: { user_id: string }): Promise<ProfessionalProfile> {
    return prisma.professionalProfile.create({
      data: {
        user_id: data.user_id,
        availability: 'available',
        verification_status: 'pending',
      },
    });
  }

  async updateProfessionalProfile(
    userId: string,
    data: Partial<ProfessionalProfile>
  ): Promise<ProfessionalProfile> {
    return prisma.professionalProfile.update({
      where: { user_id: userId },
      data,
    });
  }

  // --- Verification ---
  async submitVerificationRequest(
    professionalId: string,
    data: { status?: string; submitted_at?: Date }
  ): Promise<VerificationRequest> {
    return prisma.verificationRequest.create({
      data: {
        professional_id: professionalId,
        status: 'pending',
        submitted_at: new Date(),
      },
    });
  }

  async getVerificationStatus(professionalId: string): Promise<VerificationRequest | null> {
    return prisma.verificationRequest.findUnique({
      where: { professional_id: professionalId },
    });
  }

  // --- Certificates ---
  async createCertificate(data: {
    professional_id: string;
    name: string;
    issuing_org?: string;
    file_url: string;
    issued_date?: Date;
  }): Promise<Certificate> {
    return prisma.certificate.create({ data });
  }

  async findCertificatesByProfessional(professionalId: string): Promise<Certificate[]> {
    return prisma.certificate.findMany({
      where: { professional_id: professionalId },
      orderBy: { created_at: 'desc' },
    });
  }

  async deleteCertificate(id: string): Promise<void> {
    await prisma.certificate.delete({ where: { id } });
  }

  // --- Portfolio ---
  async createPortfolio(data: {
    professional_id: string;
    title?: string;
    description?: string;
    image_url: string;
  }): Promise<Portfolio> {
    return prisma.portfolio.create({ data });
  }

  async findPortfolioByProfessional(professionalId: string): Promise<Portfolio[]> {
    return prisma.portfolio.findMany({
      where: { professional_id: professionalId },
      orderBy: { created_at: 'desc' },
    });
  }

  async deletePortfolio(id: string): Promise<void> {
    await prisma.portfolio.delete({ where: { id } });
  }

  // --- Jobs ---
  async findJobsByProfessional(professionalId: string, filters?: { status?: string }): Promise<Job[]> {
    return prisma.job.findMany({
      where: {
        professional_id: professionalId,
        ...(filters?.status && { status: filters.status }),
      },
      orderBy: { started_at: 'desc' },
      include: {
        request: {
          include: { category: true, profession: true, customer: true },
        },
        customer: true,
        review: true,
      },
    });
  }

  async findJobById(jobId: string): Promise<Job | null> {
    return prisma.job.findUnique({
      where: { id: jobId },
      include: {
        request: {
          include: { category: true, profession: true, customer: true },
        },
        customer: true,
        review: true,
      },
    });
  }

  async updateJobStatus(jobId: string, data: { status: string; before_photos?: string[]; after_photos?: string[]; completed_at?: Date }): Promise<Job> {
    return prisma.job.update({
      where: { id: jobId },
      data,
    });
  }

  async getPendingRequestsNearby(lat: number, lng: number, radiusKm: number, professionalId: string): Promise<any[]> {
    // Use raw SQL for PostGIS distance query
    const result = await prisma.$queryRaw`
      SELECT r.*, 
             ST_Distance(r.location, ST_SetSRID(ST_MakePoint(${lng}, ${lat}), 4326)) as distance
      FROM "ServiceRequest" r
      WHERE r.status = 'pending'
        AND ST_DWithin(r.location, ST_SetSRID(ST_MakePoint(${lng}, ${lat}), 4326), ${radiusKm * 1000})
        AND r.accepted_by IS NULL
        AND r.customer_id != ${professionalId}
      ORDER BY distance ASC
    `;
    return result as any[];
  }

  // --- Performance ---
  async getPerformanceMetrics(professionalId: string): Promise<any> {
    const jobs = await prisma.job.findMany({
      where: { professional_id: professionalId },
      include: { review: true },
    });
    const totalJobs = jobs.length;
    const completedJobs = jobs.filter(j => j.status === 'completed').length;
    const cancelledJobs = jobs.filter(j => j.status === 'cancelled').length;
    const reviews = jobs.map(j => j.review).filter(r => r !== null);
    const avgRating = reviews.length > 0
      ? reviews.reduce((sum, r) => sum + r!.rating, 0) / reviews.length
      : 0;
    // Response time could be calculated from request -> acceptance time; we'll compute later.
    return {
      totalJobs,
      completedJobs,
      cancelledJobs,
      cancellationRate: totalJobs > 0 ? (cancelledJobs / totalJobs) : 0,
      averageRating: avgRating,
      reviewsCount: reviews.length,
    };
  }
}