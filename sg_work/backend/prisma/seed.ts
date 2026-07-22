import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Seeding database...');

  // Seed categories
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

  // Seed professions under Plumbing
  const plumbing = await prisma.category.findUnique({ where: { name: 'Plumbing' } });
  if (plumbing) {
    const plumbingProfessions = ['Pipe Fitting', 'Drain Cleaning', 'Water Heater Repair'];
    for (const name of plumbingProfessions) {
      await prisma.profession.upsert({
        where:  { id: `seed-${name.toLowerCase().replace(/\s+/g, '-')}` },
        update: {},
        create: { id: `seed-${name.toLowerCase().replace(/\s+/g, '-')}`, name, category_id: plumbing.id },
      });
    }
  }

  console.log('✅ Database seeded successfully');
}

main()
  .catch((e) => {
    console.error('❌ Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
