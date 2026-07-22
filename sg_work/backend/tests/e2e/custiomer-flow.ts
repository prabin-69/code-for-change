import request from 'supertest';
import app from '../../src/app';
import prisma from '../../src/config/database';
import redis from '../../src/config/redis';

describe('E2E: Customer Flow', () => {
  let customerToken: string;
  let requestId: string;

  beforeAll(async () => {
    await prisma.$connect();
  });

  afterAll(async () => {
    await prisma.$disconnect();
    await redis.quit();
  });

  it('should sign up customer', async () => {
    // 1. Send OTP
    await request(app)
      .post('/api/v1/auth/send-otp')
      .send({ phone: '+9779876543210' });
    
    // 2. Verify OTP and get token
    const otp = await redis.get('otp:+9779876543210');
    const response = await request(app)
      .post('/api/v1/auth/verify-otp')
      .send({ phone: '+9779876543210', otp });
    
    expect(response.status).toBe(200);
    customerToken = response.body.data.access_token;
  });

  it('should create a service request', async () => {
    const response = await request(app)
      .post('/api/v1/customers/requests')
      .set('Authorization', `Bearer ${customerToken}`)
      .send({
        category_id: 'cat1',
        profession_id: 'prof1',
        description: 'Fix leaking pipe',
        latitude: 27.7172,
        longitude: 85.3240,
      });
    
    expect(response.status).toBe(201);
    requestId = response.body.data.id;
  });

  it('should get customer requests', async () => {
    const response = await request(app)
      .get('/api/v1/customers/requests')
      .set('Authorization', `Bearer ${customerToken}`);
    
    expect(response.status).toBe(200);
    expect(response.body.data.length).toBeGreaterThan(0);
  });
});