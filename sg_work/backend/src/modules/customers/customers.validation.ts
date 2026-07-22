import { z } from 'zod';

export const createRequestSchema = z.object({
  body: z.object({
    category_id: z.string().uuid(),
    profession_id: z.string().uuid(),
    description: z.string().min(10, 'Description must be at least 10 characters'),
    latitude: z.number().min(-90).max(90),
    longitude: z.number().min(-180).max(180),
    address: z.string().optional(),
  }),
});

export const cancelRequestSchema = z.object({
  body: z.object({
    reason: z.string().optional(),
  }),
});

export const createReviewSchema = z.object({
  body: z.object({
    job_id: z.string().uuid(),
    rating: z.number().int().min(1).max(5),
    comment: z.string().optional(),
  }),
});