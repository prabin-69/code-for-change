import prisma from '../../config/database';
import {
  User,
  ProfessionalProfile,
  Category,
  Profession,
  Job,
  Report,
  Payment,
  Subscription,
} from '@prisma/client';

export class AdminRepository {
  // --- Dashboard Stats ---
  async getDashboardStats(): Promise<any> {
    const [
      totalUsers,
      totalProfessionals,
      pendingVerifications,
      totalJobs,
      completedJobs,
      cancelledJobs,
      totalRevenue,
      totalSubscriptions,
      featuredCount,
    ] = await Promise.all([
      prisma.user.count(),
      prisma.professionalProfile.count(),
      prisma.verificationRequest.count({ where: { status: 'pending' } }),
      prisma.job.count(),
      prisma.job.count({ where: { status: 'completed' } }),
      prisma.job.count({ where: { status: 'cancelled' } }),
      prisma.payment.aggregate({ _sum: { amount: true } }),
      prisma.subscription.count({ where: { status: 'active' } }),
      prisma.professionalProfile.count({ where: { is_featured: true } }),
    ]);

    return {
      totalUsers,
      totalProfessionals,
      pendingVerifications,
      totalJobs,
      completedJobs,
      cancelledJobs,
      totalRevenue: totalRevenue._sum.amount ?? 0,
      totalSubscriptions,
      featuredCount,
    };
  }

  // --- Users ---
  async findAllUsers(filters?: {
    role?: string;
    is_active?: boolean;
    search?: string;
  }): Promise<User[]> {
    return prisma.user.findMany({
      where: {
        ...(filters?.role && { role: filters.role as any }),
        ...(filters?.is_active !== undefined && { is_active: filters.is_active }),
        ...(filters?.search && {
          OR: [
            { phone_number: { contains: filters.search, mode: 'insensitive' } },
            { first_name: { contains: filters.search, mode: 'insensitive' } },
            { last_name: { contains: filters.search, mode: 'insensitive' } },
          ],
        }),
      },
      orderBy: { created_at: 'desc' },
      include: {
        professional_profile: true,
      },
    });
  }

  async findUserById(id: string): Promise<User | null> {
    return prisma.user.findUnique({
      where: { id },
      include: {
        professional_profile: {
          include: {
            certificates: true,
            portfolio: true,
            verification_requests: true,
          },
        },
      },
    });
  }

  async updateUserStatus(id: string, isActive: boolean): Promise<User> {
    return prisma.user.update({
      where: { id },
      data: { is_active: isActive },
    });
  }

  // --- Professionals ---
  async findAllProfessionals(filters?: {
    verification_status?: string;
    is_featured?: boolean;
    availability?: string;
    search?: string;
  }): Promise<ProfessionalProfile[]> {
    return prisma.professionalProfile.findMany({
      where: {
        ...(filters?.verification_status && {
          verification_status: filters.verification_status,
        }),
        ...(filters?.is_featured !== undefined && { is_featured: filters.is_featured }),
        ...(filters?.availability && { availability: filters.availability }),
        ...(filters?.search && {
          OR: [
            { user: { phone_number: { contains: filters.search, mode: 'insensitive' } } },
            { user: { first_name: { contains: filters.search, mode: 'insensitive' } } },
            { user: { last_name: { contains: filters.search, mode: 'insensitive' } } },
          ],
        }),
      },
      include: {
        user: true,
        category: true,
        profession: true,
        certificates: true,
        verification_requests: true,
      },
      orderBy: { created_at: 'desc' },
    });
  }

  async getProfessionalDetails(professionalId: string): Promise<any> {
    return prisma.professionalProfile.findUnique({
      where: { user_id: professionalId },
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

  async updateProfessionalVerification(
    professionalId: string,
    status: 'approved' | 'rejected',
    rejectionReason?: string,
    adminNotes?: string,
    adminId?: string,
  ): Promise<any> {
    return prisma.$transaction(async (tx) => {
      const verificationRequest = await tx.verificationRequest.update({
        where: { professional_id: professionalId },
        data: {
          status,
          reviewed_at: new Date(),
          reviewed_by: adminId,
          rejection_reason: rejectionReason,
          admin_notes: adminNotes,
        },
      });

      await tx.professionalProfile.update({
        where: { user_id: professionalId },
        data: { verification_status: status },
      });

      return verificationRequest;
    });
  }

  async updateFeaturedStatus(
    professionalId: string,
    isFeatured: boolean,
    durationDays?: number,
  ): Promise<ProfessionalProfile> {
    const featuredExpires =
      isFeatured && durationDays
        ? new Date(Date.now() + durationDays * 24 * 60 * 60 * 1000)
        : null;

    return prisma.professionalProfile.update({
      where: { user_id: professionalId },
      data: {
        is_featured: isFeatured,
        featured_expires: featuredExpires,
      },
    });
  }

  // --- Categories ---
  async createCategory(data: { name: string; icon?: string }): Promise<Category> {
    return prisma.category.create({ data });
  }

  async updateCategory(id: string, data: Partial<Category>): Promise<Category> {
    return prisma.category.update({ where: { id }, data });
  }

  async deleteCategory(id: string): Promise<Category> {
    return prisma.category.update({ where: { id }, data: { is_active: false } });
  }

  // --- Professions ---
  async createProfession(data: { name: string; category_id: string }): Promise<Profession> {
    return prisma.profession.create({ data });
  }

  async updateProfession(id: string, data: Partial<Profession>): Promise<Profession> {
    return prisma.profession.update({ where: { id }, data });
  }

  async deleteProfession(id: string): Promise<Profession> {
    return prisma.profession.update({ where: { id }, data: { is_active: false } });
  }

  // --- Jobs ---
  async findAllJobs(filters?: {
    status?: string;
    category_id?: string;
    profession_id?: string;
    date_from?: Date;
    date_to?: Date;
  }): Promise<Job[]> {
    return prisma.job.findMany({
      where: {
        ...(filters?.status && { status: filters.status }),
        ...(filters?.category_id && {
          request: { category_id: filters.category_id },
        }),
        ...(filters?.profession_id && {
          request: { profession_id: filters.profession_id },
        }),
        ...(filters?.date_from && { started_at: { gte: filters.date_from } }),
        ...(filters?.date_to && { started_at: { lte: filters.date_to } }),
      },
      include: {
        request: {
          include: { category: true, profession: true, customer: true },
        },
        professional: true, // User
        customer: true,     // User
        review: true,
      },
      orderBy: { started_at: 'desc' },
    });
  }

  // --- Reports ---
  async findAllReports(status?: string): Promise<Report[]> {
    return prisma.report.findMany({
      where: status ? { status } : {},
      include: {
        reporter: true,
        reported: true,
        job: { include: { request: true } },
      },
      orderBy: { created_at: 'desc' },
    });
  }

  async resolveReport(id: string, adminNote?: string, _action?: string): Promise<Report> {
    return prisma.report.update({
      where: { id },
      data: {
        status: 'resolved',
        admin_note: adminNote,
        resolved_at: new Date(),
      },
    });
  }

  // --- Analytics ---
  async getAnalytics(timeframe: 'daily' | 'weekly' | 'monthly' = 'monthly'): Promise<any> {
    const now = new Date();
    let startDate: Date;

    switch (timeframe) {
      case 'daily':
        startDate = new Date(now);
        startDate.setDate(now.getDate() - 7);
        break;
      case 'weekly':
        startDate = new Date(now);
        startDate.setDate(now.getDate() - 30);
        break;
      case 'monthly':
      default:
        startDate = new Date(now);
        startDate.setMonth(now.getMonth() - 12);
        break;
    }

    const jobsByDate = await prisma.$queryRaw`
      SELECT
        DATE_TRUNC('day', started_at)            AS date,
        COUNT(*)                                  AS count,
        COUNT(CASE WHEN status = 'completed' THEN 1 END) AS completed,
        COUNT(CASE WHEN status = 'cancelled' THEN 1 END) AS cancelled
      FROM "Job"
      WHERE started_at >= ${startDate}
      GROUP BY DATE_TRUNC('day', started_at)
      ORDER BY date ASC
    `;

    const topProfessionals = await prisma.$queryRaw`
      SELECT
        u.id,
        u.first_name,
        u.last_name,
        COUNT(j.id)      AS job_count,
        AVG(r.rating)    AS avg_rating
      FROM "User" u
      JOIN "Job" j  ON j.professional_id = u.id
      LEFT JOIN "Review" r ON r.job_id = j.id
      WHERE j.status = 'completed'
        AND u.role = 'PROFESSIONAL'
      GROUP BY u.id, u.first_name, u.last_name
      ORDER BY job_count DESC
      LIMIT 10
    `;

    const topServices = await prisma.$queryRaw`
      SELECT
        pr.name         AS profession_name,
        c.name          AS category_name,
        COUNT(sr.id)    AS request_count
      FROM "ServiceRequest" sr
      JOIN "Profession" pr ON pr.id = sr.profession_id
      JOIN "Category"   c  ON c.id  = sr.category_id
      GROUP BY pr.name, c.name
      ORDER BY request_count DESC
      LIMIT 10
    `;

    return { jobsByDate, topProfessionals, topServices };
  }

  // --- Notifications ---
  async createNotification(data: {
    user_id?: string;
    title: string;
    body: string;
    type: string;
    data?: any;
  }): Promise<any> {
    return prisma.notification.create({
      data: {
        user_id: data.user_id,
        title: data.title,
        body: data.body,
        type: data.type,
        data: data.data,
        is_read: false,
      },
    });
  }

  // --- Payments ---
  async findAllPayments(filters?: {
    status?: string;
    type?: string;
    date_from?: Date;
    date_to?: Date;
  }): Promise<Payment[]> {
    return prisma.payment.findMany({
      where: {
        ...(filters?.status && { status: filters.status as any }),
        ...(filters?.type && { type: filters.type as any }),
        ...(filters?.date_from && { created_at: { gte: filters.date_from } }),
        ...(filters?.date_to && { created_at: { lte: filters.date_to } }),
      },
      include: { user: true },
      orderBy: { created_at: 'desc' },
    });
  }

  // --- Subscriptions ---
  async findAllSubscriptions(filters?: {
    status?: string;
    plan?: string;
  }): Promise<Subscription[]> {
    return prisma.subscription.findMany({
      where: {
        ...(filters?.status && { status: filters.status }),
        ...(filters?.plan && { plan: filters.plan }),
      },
      include: {
        customer: true,
        payments: true,
      },
      orderBy: { created_at: 'desc' },
    });
  }
}
