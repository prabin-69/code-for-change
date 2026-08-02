import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/datasources/chat_remote_datasource.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRemoteDataSource remoteDataSource;

  ChatBloc({required this.remoteDataSource}) : super(ChatInitial()) {
    on<LoadChatsEvent>(_onLoadChats);
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onLoadChats(LoadChatsEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final chats = await remoteDataSource.getRecentChats();
      emit(ChatsLoaded(chats));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _onLoadMessages(LoadMessagesEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final messages = await remoteDataSource.getMessages(event.otherUserId, jobId: event.jobId);
      emit(MessagesLoaded(messages));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    // Messages are sent via WebSocket (Socket.IO), not HTTP REST.
    // This bloc is for loading messages and recent chats.
    // The socket service handles real-time message sending.
    emit(const ChatActionSuccess('Message sent'));
  }
}

