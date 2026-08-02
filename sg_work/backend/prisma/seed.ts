import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Seeding database...');

  // ─────────────────────────────────────────────────────────────
  // 1. SEED CATEGORIES
  // ─────────────────────────────────────────────────────────────
  const categories = [
    { name: 'Plumbing',       icon: 'plumbing' },
    { name: 'Electrical',     icon: 'electrical' },
    { name: 'Cleaning',       icon: 'cleaning' },
    { name: 'Carpentry',      icon: 'carpentry' },
    { name: 'Painting',       icon: 'painting' },
    { name: 'Appliance Repair', icon: 'appliance' },
    { name: 'Gardening',      icon: 'gardening' },
    { name: 'Moving',         icon: 'moving' },
  ];

  for (const cat of categories) {
    await prisma.category.upsert({
      where:  { name: cat.name },
      update: {},
      create: cat,
    });
  }

  console.log(`✅ Seeded ${categories.length} categories`);

  // ─────────────────────────────────────────────────────────────
  // 2. SEED PROFESSIONS
  // ─────────────────────────────────────────────────────────────
  const catPlumbing = await prisma.category.findUnique({ where: { name: 'Plumbing' } });
  if (catPlumbing) {
    const professions = ['Pipe Fitting', 'Drain Cleaning', 'Water Heater Repair'];
    for (const name of professions) {
      await prisma.profession.upsert({
        where:  { id: `seed-plumbing-${name.toLowerCase().replace(/\s+/g, '-')}` },
        update: {},
        create: { id: `seed-plumbing-${name.toLowerCase().replace(/\s+/g, '-')}`, name, category_id: catPlumbing.id },
      });
    }
  }

  const catElectrical = await prisma.category.findUnique({ where: { name: 'Electrical' } });
  if (catElectrical) {
    const professions = ['Home Wiring', 'Appliance Installation', 'Lighting', 'Electrical Repair'];
    for (const name of professions) {
      await prisma.profession.upsert({
        where:  { id: `seed-electrical-${name.toLowerCase().replace(/\s+/g, '-')}` },
        update: {},
        create: { id: `seed-electrical-${name.toLowerCase().replace(/\s+/g, '-')}`, name, category_id: catElectrical.id },
      });
    }
  }

  const catCarpentry = await prisma.category.findUnique({ where: { name: 'Carpentry' } });
  if (catCarpentry) {
    const professions = ['Furniture Making', 'Cabinet Installation', 'Wood Repair'];
    for (const name of professions) {
      await prisma.profession.upsert({
        where:  { id: `seed-carpentry-${name.toLowerCase().replace(/\s+/g, '-')}` },
        update: {},
        create: { id: `seed-carpentry-${name.toLowerCase().replace(/\s+/g, '-')}`, name, category_id: catCarpentry.id },
      });
    }
  }

  const catPainting = await prisma.category.findUnique({ where: { name: 'Painting' } });
  if (catPainting) {
    const professions = ['Interior Painting', 'Exterior Painting', 'Wall Texture', 'Waterproofing'];
    for (const name of professions) {
      await prisma.profession.upsert({
        where:  { id: `seed-painting-${name.toLowerCase().replace(/\s+/g, '-')}` },
        update: {},
        create: { id: `seed-painting-${name.toLowerCase().replace(/\s+/g, '-')}`, name, category_id: catPainting.id },
      });
    }
  }

  const catCleaning = await prisma.category.findUnique({ where: { name: 'Cleaning' } });
  if (catCleaning) {
    const professions = ['House Cleaning', 'Office Cleaning', 'Deep Cleaning', 'Carpet Cleaning'];
    for (const name of professions) {
      await prisma.profession.upsert({
        where:  { id: `seed-cleaning-${name.toLowerCase().replace(/\s+/g, '-')}` },
        update: {},
        create: { id: `seed-cleaning-${name.toLowerCase().replace(/\s+/g, '-')}`, name, category_id: catCleaning.id },
      });
    }
  }

  console.log('✅ Seeded professions');

  // ─────────────────────────────────────────────────────────────
  // 3. SEED DEMO PROFESSIONAL ACCOUNTS
  //    These are REAL database accounts – indistinguishable from
  //    user-registered professionals. They have full profiles,
  //    ratings, job counts, skills, etc.
  // ─────────────────────────────────────────────────────────────

  // Helper to find a profession by category name and profession name pattern
  const findProfession = async (categoryName: string, professionNamePattern: string) => {
    const cat = await prisma.category.findUnique({ where: { name: categoryName } });
    if (!cat) return null;
    const prof = await prisma.profession.findFirst({
      where: { category_id: cat.id, name: { contains: professionNamePattern } },
    });
    return prof ? { categoryId: cat.id, professionId: prof.id } : null;
  };

  const demoProfessionals = [
    {
      phone: '+9779800000001',
      firstName: 'Ram',
      lastName: 'Bahadur',
      categoryName: 'Plumbing',
      professionPattern: 'Pipe Fitting',
      bio: 'Expert plumber with over 10 years of experience in pipe fitting, drain cleaning, and water heater installation. Fully licensed and insured.',
      skills: ['Pipe Fitting', 'Drain Cleaning', 'Water Heater Repair', 'Leak Detection', 'Bathroom Plumbing'],
      experienceYears: 10,
      availability: 'available',
      averageRating: 4.9,
      totalJobs: 156,
      totalReviews: 126,
      isFeatured: true,
    },
    {
      phone: '+9779800000002',
      firstName: 'Sita',
      lastName: 'Sharma',
      categoryName: 'Electrical',
      professionPattern: 'Home Wiring',
      bio: 'Certified electrician specializing in home wiring, appliance installation, and electrical repairs. 8+ years of experience serving Ghorahi.',
      skills: ['Home Wiring', 'Appliance Installation', 'Lighting', 'Electrical Repair', 'Switchboard Installation'],
      experienceYears: 8,
      availability: 'available',
      averageRating: 4.8,
      totalJobs: 98,
      totalReviews: 98,
      isFeatured: true,
    },
    {
      phone: '+9779800000003',
      firstName: 'Hari',
      lastName: 'Thapa',
      categoryName: 'Carpentry',
      professionPattern: 'Furniture Making',
      bio: 'Skilled carpenter with 12 years of experience in custom furniture making, cabinet installation, and wood repair. Quality craftsmanship guaranteed.',
      skills: ['Furniture Making', 'Cabinet Installation', 'Wood Repair', 'Custom Design', 'Polishing'],
      experienceYears: 12,
      availability: 'available',
      averageRating: 4.7,
      totalJobs: 203,
      totalReviews: 189,
      isFeatured: true,
    },
    {
      phone: '+9779800000004',
      firstName: 'Ramesh',
      lastName: 'BK',
      categoryName: 'Painting',
      professionPattern: 'Interior Painting',
      bio: 'Professional painter offering interior and exterior painting services. 6 years of experience with wall texture and waterproofing.',
      skills: ['Interior Painting', 'Exterior Painting', 'Wall Texture', 'Waterproofing', 'Color Consultation'],
      experienceYears: 6,
      availability: 'available',
      averageRating: 4.6,
      totalJobs: 87,
      totalReviews: 72,
      isFeatured: false,
    },
    {
      phone: '+9779800000005',
      firstName: 'Sunita',
      lastName: 'KC',
      categoryName: 'Cleaning',
      professionPattern: 'House Cleaning',
      bio: 'Reliable house cleaner providing top-quality cleaning services. 5 years of experience in residential and office cleaning.',
      skills: ['House Cleaning', 'Office Cleaning', 'Deep Cleaning', 'Carpet Cleaning', 'Sanitization'],
      experienceYears: 5,
      availability: 'available',
      averageRating: 4.9,
      totalJobs: 312,
      totalReviews: 298,
      isFeatured: true,
    },
  ];

  for (const demo of demoProfessionals) {
    // Find or create the user
    let user = await prisma.user.findUnique({ where: { phone_number: demo.phone } });

    if (!user) {
      user = await prisma.user.create({
        data: {
          phone_number: demo.phone,
          first_name: demo.firstName,
          last_name: demo.lastName,
          role: 'PROFESSIONAL',
          role_selected: true,
          is_active: true,
          photo_url: null, // Will use default avatar
        },
      });
      console.log(`  ✅ Created user: ${demo.firstName} ${demo.lastName} (${demo.phone})`);
    }

    // Find category & profession
    const cat = await prisma.category.findUnique({ where: { name: demo.categoryName } });
    if (!cat) {
      console.warn(`  ⚠️ Category "${demo.categoryName}" not found – skipping profile for ${demo.firstName}`);
      continue;
    }

    const prof = await prisma.profession.findFirst({
      where: { category_id: cat.id, name: { contains: demo.professionPattern } },
    });

    // Upsert the professional profile
    const existingProfile = await prisma.professionalProfile.findUnique({
      where: { user_id: user.id },
    });

    if (!existingProfile) {
      await prisma.professionalProfile.create({
        data: {
          user_id: user.id,
          category_id: cat.id,
          profession_id: prof?.id ?? null,
          bio: demo.bio,
          skills: demo.skills,
          experience_years: demo.experienceYears,
          about: demo.bio,
          availability: demo.availability,
          verification_status: 'approved',
          verification_fee_paid: true,
          is_featured: demo.isFeatured,
          average_rating: demo.averageRating,
          total_jobs: demo.totalJobs,
          total_reviews: demo.totalReviews,
        },
      });
      console.log(`  ✅ Created professional profile: ${demo.firstName} ${demo.lastName}`);
    } else {
      // Update existing profile with richer data
      await prisma.professionalProfile.update({
        where: { user_id: user.id },
        data: {
          category_id: cat.id,
          profession_id: prof?.id ?? existingProfile.profession_id,
          bio: demo.bio,
          skills: demo.skills,
          experience_years: demo.experienceYears,
          about: demo.bio,
          availability: demo.availability,
          verification_status: 'approved',
          verification_fee_paid: true,
          is_featured: demo.isFeatured,
          average_rating: demo.averageRating,
          total_jobs: demo.totalJobs,
          total_reviews: demo.totalReviews,
        },
      });
      console.log(`  ✅ Updated professional profile: ${demo.firstName} ${demo.lastName}`);
    }
  }

  console.log('✅ Database seeded successfully');
  console.log('');
  console.log('📋 Demo Professional Accounts:');
  console.log('  📞 +9779800000001 - Ram Bahadur (Plumber)');
  console.log('  📞 +9779800000002 - Sita Sharma (Electrician)');
  console.log('  📞 +9779800000003 - Hari Thapa (Carpenter)');
  console.log('  📞 +9779800000004 - Ramesh BK (Painter)');
  console.log('  📞 +9779800000005 - Sunita KC (House Cleaner)');
  console.log('');
  console.log('🔑 Use any phone number with OTP 123456 to login (dev mode)');
}

main()
  .catch((e) => {
    console.error('❌ Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
