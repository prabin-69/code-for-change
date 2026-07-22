import { Request, Response, NextFunction } from 'express';
import { AuthService } from './auth.service';
import { AuthRequest } from '../../shared/middlewares/auth';
import {
  SendOtpRequestDto,
  VerifyOtpRequestDto,
  RefreshTokenRequestDto,
  SelectRoleRequestDto
} from './auth.dto';

export class AuthController {
  private authService: AuthService;

  constructor() {
    this.authService = new AuthService();
  }


  /**
   * @swagger
   * /auth/send-otp:
   *   post:
   *     summary: Send OTP
   *     tags:
   *       - Auth
   *     security: []
   *     requestBody:
   *       required: true
   *       content:
   *         application/json:
   *           schema:
   *             type: object
   *             required:
   *               - phone
   *             properties:
   *               phone:
   *                 type: string
   *                 example: "+9779812345678"
   *     responses:
   *       200:
   *         description: OTP sent successfully
   */
  sendOtp = async (
    req: Request,
    res: Response,
    next: NextFunction
  ) => {
    try {

      const { phone } = req.body as SendOtpRequestDto;

      await this.authService.sendOtp(phone);

      res.status(200).json({
        success: true,
        data: null,
        message: "OTP sent successfully",
        errors: null,
        timestamp: new Date().toISOString()
      });

    } catch(error) {
      next(error);
    }
  };



  /**
   * @swagger
   * /auth/verify-otp:
   *   post:
   *     summary: Verify OTP
   *     tags:
   *       - Auth
   *     security: []
   *     requestBody:
   *       required: true
   *       content:
   *         application/json:
   *           schema:
   *             type: object
   *             required:
   *               - phone
   *               - otp
   *             properties:
   *               phone:
   *                 type: string
   *                 example: "+9779812345678"
   *               otp:
   *                 type: string
   *                 example: "123456"
   *     responses:
   *       200:
   *         description: Authentication successful
   */
  verifyOtp = async (
    req: Request,
    res: Response,
    next: NextFunction
  ) => {

    try {

      const {phone, otp} =
        req.body as VerifyOtpRequestDto;


      const deviceInfo =
        req.headers['user-agent'] || "unknown";


      const {
        accessToken,
        refreshToken,
        user,
        isNewUser

      } = await this.authService.verifyOtp(
        phone,
        otp,
        {
          userAgent: deviceInfo
        }
      );


      res.status(200).json({

        success:true,

        data:{
          access_token:accessToken,
          refresh_token:refreshToken,

          user:{
            id:user.id,
            phone:user.phone_number,
            first_name:user.first_name,
            last_name:user.last_name,
            photo_url:user.photo_url,
            role:user.role,
            role_selected:user.role_selected,
            is_active:user.is_active
          },

          is_new_user:isNewUser
        },

        message:"Authentication successful",
        errors:null,
        timestamp:new Date().toISOString()

      });


    }catch(error){
      next(error);
    }

  };




  /**
   * @swagger
   * /auth/refresh:
   *   post:
   *     summary: Refresh access token
   *     tags:
   *       - Auth
   *     security: []
   *     requestBody:
   *       required: true
   *       content:
   *         application/json:
   *           schema:
   *             type: object
   *             required:
   *               - refresh_token
   *             properties:
   *               refresh_token:
   *                 type: string
   *                 example: "your_refresh_token"
   */
  refreshToken = async (
    req:Request,
    res:Response,
    next:NextFunction
  )=>{

    try{

      const {refresh_token} =
      req.body as RefreshTokenRequestDto;


      const {
        accessToken,
        refreshToken

      } =
      await this.authService.refreshToken(refresh_token);



      res.status(200).json({

        success:true,

        data:{
          access_token:accessToken,
          refresh_token:refreshToken
        },

        message:"Token refreshed",
        errors:null,
        timestamp:new Date().toISOString()

      });


    }catch(error){
      next(error);
    }

  };





  /**
   * @swagger
   * /auth/logout:
   *   post:
   *     summary: Logout user
   *     tags:
   *       - Auth
   *     security: []
   *     requestBody:
   *       required: true
   *       content:
   *         application/json:
   *           schema:
   *             type: object
   *             properties:
   *               refresh_token:
   *                 type: string
   *                 example: "refresh_token"
   */
  logout = async(
    req:Request,
    res:Response,
    next:NextFunction
  )=>{

    try{

      const {refresh_token}
      = req.body as RefreshTokenRequestDto;


      await this.authService.logout(refresh_token);


      res.status(200).json({

        success:true,
        data:null,
        message:"Logged out successfully",
        errors:null,
        timestamp:new Date().toISOString()

      });


    }catch(error){
      next(error);
    }

  };




  /**
   * @swagger
   * /auth/logout-all:
   *   post:
   *     summary: Logout all devices
   *     tags:
   *       - Auth
   *     security:
   *       - bearerAuth: []
   */
  logoutAll = async(
    req:AuthRequest,
    res:Response,
    next:NextFunction
  )=>{

    try{

      await this.authService.logoutAll(
        req.user!.id
      );


      res.status(200).json({

        success:true,
        data:null,
        message:"Logged out from all devices",
        errors:null,
        timestamp:new Date().toISOString()

      });


    }catch(error){
      next(error);
    }

  };




  /**
   * @swagger
   * /auth/me:
   *   get:
   *     summary: Get current user profile
   *     tags:
   *       - Auth
   *     security:
   *       - bearerAuth: []
   */
  getMe = async(
    req:AuthRequest,
    res:Response,
    next:NextFunction
  )=>{

    try{

      const user =
      await this.authService.getUserProfile(
        req.user!.id
      );


      res.status(200).json({

        success:true,
        data:user,
        message:"User profile",
        errors:null,
        timestamp:new Date().toISOString()

      });


    }catch(error){
      next(error);
    }

  };





  /**
   * @swagger
   * /auth/select-role:
   *   post:
   *     summary: Select user role
   *     tags:
   *       - Auth
   *     security:
   *       - bearerAuth: []
   *     requestBody:
   *       required: true
   *       content:
   *         application/json:
   *           schema:
   *             type: object
   *             properties:
   *               role:
   *                 type: string
   *                 example: "PROFESSIONAL"
   */
  selectRole = async(
    req:AuthRequest,
    res:Response,
    next:NextFunction
  )=>{

    try{


      const {role}
      = req.body as SelectRoleRequestDto;



      const user =
      await this.authService.selectRole(
        req.user!.id,
        role
      );



      res.status(200).json({

        success:true,
        data:user,
        message:"Role selected successfully",
        errors:null,
        timestamp:new Date().toISOString()

      });



    }catch(error){
      next(error);
    }

  };


}