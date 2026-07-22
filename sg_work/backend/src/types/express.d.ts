// Augment Express Request so req.user is available without a cast.
// Matches the AuthRequest interface in shared/middlewares/auth.ts

declare global {
  namespace Express {
    interface Request {
      user?: {
        id: string;
        role: string;
      };
    }
  }
}

export {};
