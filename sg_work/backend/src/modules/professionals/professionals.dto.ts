export class UpdateProfessionalProfileDto {
  category_id?: string;
  profession_id?: string;
  skills?: string[];
  experience_years?: number;
  about?: string;
  availability?: string; // available, busy, offline
}

export class UpdateAvailabilityDto {
  availability!: string;
}

export class SubmitVerificationDto {
  // We'll handle file uploads separately
}

export class UpdateJobStatusDto {
  status!: string; // on_the_way, in_progress, completed
  before_photos?: string[];
  after_photos?: string[];
}

export class CertificateDto {
  name!: string;
  issuing_org?: string;
  issued_date?: string;
  file_url!: string;
}

export class PortfolioDto {
  title?: string;
  description?: string;
  image_url!: string;
}