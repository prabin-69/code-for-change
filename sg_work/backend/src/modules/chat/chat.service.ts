import { ChatRepository } from './chat.repository';

export class ChatService {
  private repo: ChatRepository;

  constructor() {
    this.repo = new ChatRepository();
  }

  async getRecentChats(userId: string) {
    return this.repo.getRecentChats(userId);
  }

  async getMessages(
    userId: string,
    otherUserId: string,
    jobId?: string,
    limit = 50,
    offset = 0,
  ) {
    return this.repo.getMessagesBetweenUsers(userId, otherUserId, jobId, limit, offset);
  }

  async markAsRead(userId: string, senderId: string, jobId?: string) {
    return this.repo.markMessagesAsRead(userId, senderId, jobId);
  }

  async getUnreadCount(userId: string) {
    return this.repo.getUnreadCount(userId);
  }

  async sendMessage(data: {
    sender_id: string;
    receiver_id: string;
    content: string;
    job_id?: string;
    type?: string;
  }) {
    return this.repo.createMessage(data);
  }
}
