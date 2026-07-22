import { AdminRepository } from './admin.repository';
import { NotFoundError } from '../../shared/utils/AppError';
import { eventBus } from '../../shared/events/event-bus';
import prisma from '../../config/database';

export class AdminService {
  private repository: AdminRepository;

  constructor() {
    this.repository = new AdminRepository();
  }

  // --- Dashboard ---
  async getDashboardStats() {
    return this.repository.getDashboardStats();
  }

  // --- Users ---
  async getAllUsers(filters?: any) {
    return this.repository.findAllUsers(filters);
  }

  async getUserDetails(userId: string) {
    const user = await this.repository.findUserById(userId);
    if (!user) throw new NotFoundError('User not found');
    return user;
  }

  async updateUserStatus(userId: string, isActive: boolean) {
    const user = await this.repository.findUserById(userId);
    if (!user) throw new NotFoundError('User not found');
    return this.repository.updateUserStatus(userId, isActive);
  }

  // --- Professionals ---
  async getAllProfessionals(filters?: any) {
    return this.repository.findAllProfessionals(filters);
  }

  async getProfessionalDetails(professionalId: string) {
    const profile = await this.repository.getProfessionalDetails(professionalId);
    if (!profile) throw new NotFoundError('Professional not found');
    return profile;
  }

  async updateProfessionalVerification(
    professionalId: string,
    status: 'approved' | 'rejected',
    rejectionReason?: string,
    adminNotes?: string,
    adminId?: string,
  ) {
    const profile = await this.repository.getProfessionalDetails(professionalId);
    if (!profile) throw new NotFoundError('Professional not found');

    const result = await this.repository.updateProfessionalVerification(
      professionalId,
      status,
      rejectionReason,
      adminNotes,
      adminId,
    );

    eventBus.emit(
      status === 'approved' ? 'VerificationApprovedEvent' : 'VerificationRejectedEvent',
      { professionalId, reason: rejectionReason },
    );

    return result;
  }

  async updateFeaturedStatus(
    professionalId: string,
    isFeatured: boolean,
    durationDays?: number,
  ) {
    const profile = await this.repository.getProfessionalDetails(professionalId);
    if (!profile) throw new NotFoundError('Professional not found');
    return this.repository.updateFeaturedStatus(professionalId, isFeatured, durationDays);
  }

  // --- Categories ---
  async createCategory(name: string, icon?: string) {
    return this.repository.createCategory({ name, icon });
  }

  async updateCategory(id: string, data: { name?: string; icon?: string; is_active?: boolean }) {
    return this.repository.updateCategory(id, data);
  }

  async deleteCategory(id: string) {
    return this.repository.deleteCategory(id);
  }

  // --- Professions ---
  async createProfession(name: string, categoryId: string) {
    return this.repository.createProfession({ name, category_id: categoryId });
  }

  async updateProfession(id: string, data: { name?: string; is_active?: boolean }) {
    return this.repository.updateProfession(id, data);
  }

  async deleteProfession(id: string) {
    return this.repository.deleteProfession(id);
  }

  // --- Jobs ---
  async getAllJobs(filters?: any) {
    return this.repository.findAllJobs(filters);
  }

  // --- Reports ---
  async getAllReports(status?: string) {
    return this.repository.findAllReports(status);
  }

  async resolveReport(reportId: string, adminNote?: string, action?: string) {
    const reports = await this.repository.findAllReports();
    const report = reports.find((r) => r.id === reportId);
    if (!report) throw new NotFoundError('Report not found');
    return this.repository.resolveReport(reportId, adminNote, action);
  }

  // --- Analytics ---
  async getAnalytics(timeframe?: 'daily' | 'weekly' | 'monthly') {
    return this.repository.getAnalytics(timeframe);
  }

  // --- Payments ---
  async getAllPayments(filters?: any) {
    return this.repository.findAllPayments(filters);
  }

  // --- Subscriptions ---
  async getAllSubscriptions(filters?: any) {
    return this.repository.findAllSubscriptions(filters);
  }

  // --- Broadcast Notification ---
  async broadcastNotification(data: {
    title: string;
    body: string;
    target_users?: string[];
    target_roles?: string[];
  }) {
    // If specific user IDs provided, send to those users
    if (data.target_users && data.target_users.length > 0) {
      return Promise.all(
        data.target_users.map((userId) =>
          this.repository.createNotification({
            user_id: userId,
            title: data.title,
            body: data.body,
            type: 'broadcast',
          }),
        ),
      );
    }

    // If specific roles provided, look up matching users first
    const whereClause: any = { is_active: true };
    if (data.target_roles && data.target_roles.length > 0) {
      whereClause.role = { in: data.target_roles as any };
    }

    const users = await prisma.user.findMany({ where: whereClause });
    return Promise.all(
      users.map((user) =>
        this.repository.createNotification({
          user_id: user.id,
          title: data.title,
          body: data.body,
          type: 'broadcast',
        }),
      ),
    );
  }
}
