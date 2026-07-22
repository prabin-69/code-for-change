import { AuthService } from '../../src/modules/auth/auth.service';
import { AuthRepository } from '../../src/modules/auth/auth.repository';
import { TokenService } from '../../src/shared/services/token.service';
import { SmsService } from '../../src/shared/services/sms.service';
import redis from '../../src/config/redis';

jest.mock('../../src/modules/auth/auth.repository');
jest.mock('../../src/shared/services/token.service');
jest.mock('../../src/shared/services/sms.service');
jest.mock('../../src/config/redis');

describe('AuthService', () => {
  let authService: AuthService;
  let mockRepo: jest.Mocked<AuthRepository>;

  beforeEach(() => {
    mockRepo = new AuthRepository() as jest.Mocked<AuthRepository>;
    authService = new AuthService();
    // Inject mock repository
    (authService as any).repository = mockRepo;
  });

  describe('sendOtp', () => {
    it('should send OTP successfully', async () => {
      const phone = '+9779876543210';
      await authService.sendOtp(phone);
      expect(redis.set).toHaveBeenCalled();
      expect(SmsService.sendOtp).toHaveBeenCalled();
    });

    it('should throw rate limit error after max attempts', async () => {
      const phone = '+9779876543210';
      // Mock rate limit exceeded
      (redis.incr as jest.Mock).mockResolvedValue(6);
      await expect(authService.sendOtp(phone)).rejects.toThrow('Too many OTP requests');
    });
  });

  describe('verifyOtp', () => {
    it('should verify OTP and return tokens for existing user', async () => {
      const phone = '+9779876543210';
      const otp = '123456';
      const mockUser = { id: 'user1', phone_number: phone, role: 'CUSTOMER', is_active: true };
      
      (redis.get as jest.Mock).mockResolvedValue(otp);
      mockRepo.findUserByPhone.mockResolvedValue(mockUser);
      mockRepo.saveRefreshToken.mockResolvedValue({ id: 'token1' } as any);
      
      const result = await authService.verifyOtp(phone, otp, {});
      expect(result.user).toEqual(mockUser);
      expect(result.accessToken).toBeDefined();
      expect(result.refreshToken).toBeDefined();
    });
  });
});