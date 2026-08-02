part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();
}

class ChatInitial extends ChatState {
  @override
  List<Object?> get props => [];
}

class ChatLoading extends ChatState {
  @override
  List<Object?> get props => [];
}

class ChatFailure extends ChatState {
  final String message;
  const ChatFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class ChatsLoaded extends ChatState {
  final List<Map<String, dynamic>> chats;
  const ChatsLoaded(this.chats);
  @override
  List<Object?> get props => [chats];
}

class MessagesLoaded extends ChatState {
  final List<Map<String, dynamic>> messages;
  const MessagesLoaded(this.messages);
  @override
  List<Object?> get props => [messages];
}

class ChatActionSuccess extends ChatState {
  final String message;
  const ChatActionSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

