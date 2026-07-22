import prisma from '../../config/database';
import { Message } from '@prisma/client';

export class ChatRepository {
  async createMessage(data: {
    sender_id: string;
    receiver_id: string;
    content: string;
    job_id?: string;
    type?: string;
  }): Promise<Message> {
    return prisma.message.create({
      data: {
        sender_id: data.sender_id,
        receiver_id: data.receiver_id,
        content: data.content,
        job_id: data.job_id,
        type: data.type || 'text',
        is_read: false,
      },
    });
  }

  async getMessagesBetweenUsers(user1Id: string, user2Id: string, jobId?: string, limit = 50, offset = 0): Promise<Message[]> {
    return prisma.message.findMany({
      where: {
        OR: [
          { sender_id: user1Id, receiver_id: user2Id },
          { sender_id: user2Id, receiver_id: user1Id },
        ],
        ...(jobId && { job_id: jobId }),
      },
      orderBy: { created_at: 'desc' },
      take: limit,
      skip: offset,
    });
  }

  async markMessagesAsRead(userId: string, senderId: string, jobId?: string): Promise<void> {
    await prisma.message.updateMany({
      where: {
        receiver_id: userId,
        sender_id: senderId,
        is_read: false,
        ...(jobId && { job_id: jobId }),
      },
      data: { is_read: true },
    });
  }

  async getUnreadCount(userId: string): Promise<number> {
    return prisma.message.count({
      where: { receiver_id: userId, is_read: false },
    });
  }

  async getRecentChats(userId: string): Promise<any[]> {
    // Get distinct conversations with latest message
    const messages = await prisma.$queryRaw`
      SELECT DISTINCT ON (LEAST(sender_id, receiver_id), GREATEST(sender_id, receiver_id))
        sender_id, receiver_id, content, created_at, is_read
      FROM messages
      WHERE sender_id = ${userId} OR receiver_id = ${userId}
      ORDER BY LEAST(sender_id, receiver_id), GREATEST(sender_id, receiver_id), created_at DESC
    `;
    return messages as any[];
  }
}