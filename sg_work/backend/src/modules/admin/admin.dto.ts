export class UpdateUserStatusDto {
  is_active!: boolean;
}

export class UpdateProfessionalVerificationDto {
  status!: 'approved' | 'rejected';
  rejection_reason?: string;
  admin_notes?: string;
}

export class ManageFeaturedDto {
  is_featured!: boolean;
  duration_days?: number; // 7, 30, 90
}

export class CreateCategoryDto {
  name!: string;
  icon?: string;
}

export class CreateProfessionDto {
  name!: string;
  category_id!: string;
}

export class ResolveReportDto {
  admin_note?: string;
  action?: string; // 'warning', 'suspend', 'ban'
}

export class BroadcastNotificationDto {
  title!: string;
  body!: string;
  target_users?: string[]; // optional: specific user ids
  target_roles?: string[]; // optional: 'customer', 'professional'
}