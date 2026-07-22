export class CreateRequestDto {
  category_id!: string;
  profession_id!: string;
  description!: string;
  latitude!: number;
  longitude!: number;
  address?: string;
}

export class CancelRequestDto {
  reason?: string;
}

export class CreateReviewDto {
  job_id!: string;
  rating!: number;
  comment?: string;
}