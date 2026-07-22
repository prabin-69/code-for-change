import { Server as SocketIOServer, Socket } from 'socket.io';
// Side-effect import: ensures Socket augmentation (userId / userRole) is in scope
import { ChatService } from './chat.service';
import logger from '../../config/logger';

const chatService = new ChatService();

export function setupSocketHandlers(io: SocketIOServer): void {
  io.on('connection', (socket: Socket) => {
    // userId is set by the auth middleware in server.ts using the Socket augmentation
    const userId = socket.userId!;
    logger.info(`Socket connected: ${socket.id} (user: ${userId})`);

    // Join the user's own room for private messages
    socket.join(`user:${userId}`);

    // Join a job-specific room
    socket.on('join_job_room', (jobId: string) => {
      socket.join(`job:${jobId}`);
      logger.debug(`User ${userId} joined job room ${jobId}`);
    });

    socket.on('leave_job_room', (jobId: string) => {
      socket.leave(`job:${jobId}`);
    });

    // Send a message
    socket.on('send_message', async (data: {
      receiver_id: string;
      content: string;
      job_id?: string;
      type?: string;
    }) => {
      try {
        const message = await chatService.sendMessage({
          sender_id: userId,
          receiver_id: data.receiver_id,
          content: data.content,
          job_id: data.job_id,
          type: data.type ?? 'text',
        });

        // Emit to both sender and receiver
        io.to(`user:${userId}`).to(`user:${data.receiver_id}`).emit('new_message', message);

        // Also emit to job room if applicable
        if (data.job_id) {
          io.to(`job:${data.job_id}`).emit('new_message', message);
        }
      } catch (err) {
        socket.emit('error', { message: 'Failed to send message' });
        logger.error('Socket send_message error:', err);
      }
    });

    // Mark messages as read
    socket.on('mark_read', async (data: { sender_id: string; job_id?: string }) => {
      try {
        await chatService.markAsRead(userId, data.sender_id, data.job_id);
        // Notify the sender that their messages were read
        io.to(`user:${data.sender_id}`).emit('messages_read', {
          by: userId,
          job_id: data.job_id,
        });
      } catch (err) {
        logger.error('Socket mark_read error:', err);
      }
    });

    // Typing indicators
    socket.on('typing_start', (data: { receiver_id: string; job_id?: string }) => {
      io.to(`user:${data.receiver_id}`).emit('user_typing', {
        user_id: userId,
        job_id: data.job_id,
      });
    });

    socket.on('typing_stop', (data: { receiver_id: string; job_id?: string }) => {
      io.to(`user:${data.receiver_id}`).emit('user_stopped_typing', {
        user_id: userId,
        job_id: data.job_id,
      });
    });

    socket.on('disconnect', () => {
      logger.info(`Socket disconnected: ${socket.id} (user: ${userId})`);
    });
  });
}
