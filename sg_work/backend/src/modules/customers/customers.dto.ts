export class CreateRequestDto {
  category_id!: string;
  profession_id!: string;
  description!: string;
  latitude!: number;
  longitude!: number;
  address?: string;
  // Direct booking to a specific professional (optional – when a customer books from a professional's page)
  professional_id?: string;
  // New booking fields (all optional for backward compatibility)
  budget?: number;
  preferred_date?: string;  // ISO date string
  preferred_time?: string;  // HH:MM format
  images?: string[];
}

export class CancelRequestDto {
  reason?: string;
}

export class CreateReviewDto {
  job_id!: string;
  rating!: number;
  comment?: string;
}
