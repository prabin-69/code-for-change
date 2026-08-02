part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class LoadChatsEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class LoadMessagesEvent extends ChatEvent {
  final String otherUserId;
  final String? jobId;
  const LoadMessagesEvent({required this.otherUserId, this.jobId});
  @override
  List<Object?> get props => [otherUserId, jobId];
}

class SendMessageEvent extends ChatEvent {
  final String receiverId;
  final String message;
  final String? jobId;
  const SendMessageEvent({required this.receiverId, required this.message, this.jobId});
  @override
  List<Object?> get props => [receiverId, message, jobId];
}

