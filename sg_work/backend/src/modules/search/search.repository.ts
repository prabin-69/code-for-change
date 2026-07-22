import prisma from '../../config/database';

export class SearchRepository {
  async searchProfessionalsNearby(params: {
    lat: number;
    lng: number;
    radiusKm: number;
    categoryId?: string;
    professionId?: string;
    minRating?: number;
    availability?: string;
    isFeatured?: boolean;
    limit: number;
    offset: number;
  }): Promise<any[]> {
    // Use raw SQL for PostGIS spatial query
    const result = await prisma.$queryRaw<any[]>`
      SELECT
        pp.user_id,
        pp.bio,
        pp.skills,
        pp.experience_years,
        pp.availability,
        pp.verification_status,
        pp.is_featured,
        pp.average_rating,
        pp.total_jobs,
        pp.total_reviews,
        u.first_name,
        u.last_name,
        u.photo_url,
        u.phone_number,
        c.name  AS category_name,
        pr.name AS profession_name,
        pl.latitude  AS last_lat,
        pl.longitude AS last_lng
      FROM "ProfessionalProfile" pp
      JOIN "User" u ON pp.user_id = u.id
      LEFT JOIN "Category"   c  ON pp.category_id   = c.id
      LEFT JOIN "Profession"  pr ON pp.profession_id  = pr.id
      LEFT JOIN LATERAL (
        SELECT latitude, longitude
        FROM   "ProfessionalLocation"
        WHERE  professional_id = pp.user_id
        ORDER  BY timestamp DESC
        LIMIT  1
      ) pl ON true
      WHERE u.is_active = true
        AND pp.verification_status = 'approved'
        AND pp.availability != 'offline'
        ${params.categoryId   ? prisma.$queryRaw`AND pp.category_id   = ${params.categoryId}`   : prisma.$queryRaw``}
        ${params.professionId ? prisma.$queryRaw`AND pp.profession_id = ${params.professionId}` : prisma.$queryRaw``}
        ${params.minRating    ? prisma.$queryRaw`AND pp.average_rating >= ${params.minRating}`  : prisma.$queryRaw``}
        ${params.availability ? prisma.$queryRaw`AND pp.availability  = ${params.availability}` : prisma.$queryRaw``}
        ${params.isFeatured   ? prisma.$queryRaw`AND pp.is_featured   = true`                   : prisma.$queryRaw``}
      ORDER BY pp.is_featured DESC, pp.average_rating DESC
      LIMIT  ${params.limit}
      OFFSET ${params.offset}
    `;
    return result;
  }

  // Simple non-spatial fallback (used when location not provided)
  async searchProfessionals(params: {
    categoryId?: string;
    professionId?: string;
    minRating?: number;
    availability?: string;
    isFeatured?: boolean;
    search?: string;
    limit: number;
    offset: number;
  }): Promise<any[]> {
    return prisma.professionalProfile.findMany({
      where: {
        user: { is_active: true },
        verification_status: 'approved',
        availability: { not: 'offline' },
        ...(params.categoryId && { category_id: params.categoryId }),
        ...(params.professionId && { profession_id: params.professionId }),
        ...(params.minRating && { average_rating: { gte: params.minRating } }),
        ...(params.availability && { availability: params.availability }),
        ...(params.isFeatured && { is_featured: true }),
        ...(params.search && {
          OR: [
            { bio: { contains: params.search, mode: 'insensitive' } },
            { user: { first_name: { contains: params.search, mode: 'insensitive' } } },
            { user: { last_name: { contains: params.search, mode: 'insensitive' } } },
          ],
        }),
      },
      include: {
        user: { select: { first_name: true, last_name: true, photo_url: true, phone_number: true } },
        category: { select: { id: true, name: true } },
        profession: { select: { id: true, name: true } },
      },
      orderBy: [{ is_featured: 'desc' }, { average_rating: 'desc' }],
      take: params.limit,
      skip: params.offset,
    });
  }

  async getProfessionalPublicProfile(professionalId: string): Promise<any | null> {
    return prisma.professionalProfile.findUnique({
      where: { user_id: professionalId },
      include: {
        user: { select: { first_name: true, last_name: true, photo_url: true, phone_number: true } },
        category: true,
        profession: true,
        certificates: true,
        portfolio: true,
      },
    });
  }

  async getProfessionalReviews(professionalId: string, limit = 20, offset = 0): Promise<any[]> {
    return prisma.review.findMany({
      where: { professional_id: professionalId },
      include: {
        reviewer: { select: { first_name: true, last_name: true, photo_url: true } },
      },
      orderBy: { created_at: 'desc' },
      take: limit,
      skip: offset,
    });
  }
}
