// Augment the Socket.IO Socket class so that userId and userRole can be
// attached in the authentication middleware without requiring `as any` casts.
//
// Usage in middleware:
//   socket.userId  = decoded.sub as string;
//   socket.userRole = decoded.role as string;
//
// Usage in handlers:
//   const userId = socket.userId!;

import 'socket.io';

declare module 'socket.io' {
  interface Socket {
    userId?: string;
    userRole?: string;
  }
}
