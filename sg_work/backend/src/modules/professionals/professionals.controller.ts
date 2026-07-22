import { Response, NextFunction } from 'express';
import { AuthRequest } from '../../shared/middlewares/auth';
import { ProfessionalsService } from './professionals.service';
import { UpdateProfessionalProfileDto, UpdateJobStatusDto } from './professionals.dto';
import { AppError, BadRequestError } from '../../shared/utils/AppError';
import prisma from '../../config/database';
import axios from 'axios';
import { env } from '../../config/env';

export class ProfessionalsController {
  private service: ProfessionalsService;

  constructor() {
    this.service = new ProfessionalsService();
  }

  // --- Profile ---
  getProfile = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const profile = await this.service.getProfessionalProfile(userId);
      res.status(200).json({
        success: true,
        data: profile,
        message: 'Professional profile retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  updateProfile = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const data = req.body as UpdateProfessionalProfileDto;
      const profile = await this.service.updateProfessionalProfile(userId, data);
      res.status(200).json({
        success: true,
        data: profile,
        message: 'Profile updated',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  updateAvailability = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const { availability } = req.body;
      const profile = await this.service.updateAvailability(userId, availability);
      res.status(200).json({
        success: true,
        data: profile,
        message: 'Availability updated',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  // --- Verification ---
  submitVerification = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const result = await this.service.submitVerification(userId);
      res.status(201).json({
        success: true,
        data: result,
        message: 'Verification submitted',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  getVerificationStatus = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const status = await this.service.getVerificationStatus(userId);
      res.status(200).json({
        success: true,
        data: status,
        message: 'Verification status retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  // --- Certificates ---
  addCertificate = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const data = req.body;
      const cert = await this.service.addCertificate(userId, data);
      res.status(201).json({
        success: true,
        data: cert,
        message: 'Certificate added',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  getCertificates = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const certs = await this.service.getCertificates(userId);
      res.status(200).json({
        success: true,
        data: certs,
        message: 'Certificates retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  deleteCertificate = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const { id } = req.params;
      await this.service.deleteCertificate(userId, id);
      res.status(200).json({
        success: true,
        data: null,
        message: 'Certificate deleted',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  // --- Portfolio ---
  addPortfolio = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const data = req.body;
      const item = await this.service.addPortfolio(userId, data);
      res.status(201).json({
        success: true,
        data: item,
        message: 'Portfolio item added',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  getPortfolio = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const items = await this.service.getPortfolio(userId);
      res.status(200).json({
        success: true,
        data: items,
        message: 'Portfolio retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  deletePortfolio = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const { id } = req.params;
      await this.service.deletePortfolio(userId, id);
      res.status(200).json({
        success: true,
        data: null,
        message: 'Portfolio item deleted',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  // --- Jobs ---
  getPendingRequests = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const { lat, lng, radius } = req.query;
      if (!lat || !lng) {
        throw new BadRequestError('Latitude and longitude are required');
      }
      const latitude = parseFloat(lat as string);
      const longitude = parseFloat(lng as string);
      const radiusKm = radius ? parseFloat(radius as string) : 10;
      const requests = await this.service.getPendingRequests(userId, latitude, longitude, radiusKm);
      res.status(200).json({
        success: true,
        data: requests,
        message: 'Pending requests retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  acceptRequest = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const { requestId } = req.params;
      const job = await this.service.acceptRequest(userId, requestId);
      res.status(201).json({
        success: true,
        data: job,
        message: 'Request accepted',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  getMyJobs = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const { status } = req.query;
      const jobs = await this.service.getMyJobs(userId, status as string);
      res.status(200).json({
        success: true,
        data: jobs,
        message: 'Jobs retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  getJobDetails = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const { jobId } = req.params;
      const job = await this.service.getJobDetails(userId, jobId);
      res.status(200).json({
        success: true,
        data: job,
        message: 'Job details retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  updateJobStatus = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const { jobId } = req.params;
      const data = req.body as UpdateJobStatusDto;
      const job = await this.service.updateJobStatus(userId, jobId, data);
      res.status(200).json({
        success: true,
        data: job,
        message: 'Job status updated',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  // --- Performance ---
  getPerformance = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const metrics = await this.service.getPerformance(userId);
      res.status(200).json({
        success: true,
        data: metrics,
        message: 'Performance metrics retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  // --- Location ---
  updateLocation = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const { latitude, longitude, accuracy } = req.body;

      if (latitude == null || longitude == null) {
        throw new AppError('Latitude and longitude are required', 400);
      }

      if (latitude < -90 || latitude > 90 || longitude < -180 || longitude > 180) {
        throw new AppError('Invalid coordinates', 400);
      }

      const location = await prisma.professionalLocation.create({
        data: {
          professional_id: userId,
          latitude,
          longitude,
          accuracy: accuracy ?? null,
        },
      });

      res.status(200).json({
        success: true,
        data: location,
        message: 'Location updated',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  getLatestLocation = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { professionalId } = req.params;
      const location = await prisma.professionalLocation.findFirst({
        where: { professional_id: professionalId },
        orderBy: { timestamp: 'desc' },
      });

      if (!location) {
        return res.status(404).json({
          success: false,
          data: null,
          message: 'No location found for this professional',
          errors: null,
          timestamp: new Date().toISOString(),
        });
      }

      res.status(200).json({
        success: true,
        data: location,
        message: 'Latest location retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  // --- ETA (Google Maps Directions API) – Requires Manual Verification ---
  getEta = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { originLat, originLng, destLat, destLng } = req.query;

      if (!originLat || !originLng || !destLat || !destLng) {
        throw new AppError('Origin and destination coordinates are required', 400);
      }

      if (!env.GOOGLE_MAPS_API_KEY) {
        throw new AppError('Google Maps API key not configured', 503);
      }

      const response = await axios.get(
        'https://maps.googleapis.com/maps/api/directions/json',
        {
          params: {
            origin: `${originLat},${originLng}`,
            destination: `${destLat},${destLng}`,
            key: env.GOOGLE_MAPS_API_KEY,
            mode: 'driving',
          },
        },
      );

      if (response.data.status === 'OK') {
        const route = response.data.routes[0];
        const leg = route.legs[0];
        res.status(200).json({
          success: true,
          data: {
            distance: leg.distance.text,
            distance_meters: leg.distance.value,
            duration: leg.duration.text,
            duration_seconds: leg.duration.value,
            polyline: route.overview_polyline.points,
          },
          message: 'ETA calculated',
          errors: null,
          timestamp: new Date().toISOString(),
        });
      } else {
        throw new AppError('Could not calculate route: ' + response.data.status, 400);
      }
    } catch (error) {
      next(error);
    }
  };
}
