import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../constants/api_constants.dart';
import 'package:logger/logger.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  final _logger = Logger();

  bool get isConnected => _socket?.connected ?? false;

  void connect(String token) {
    if (_socket != null && _socket!.connected) return;

    _socket = IO.io(
      ApiConstants.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    _socket!.onConnect((_) {
      _logger.i('Socket connected');
    });

    _socket!.onDisconnect((_) {
      _logger.i('Socket disconnected');
    });

    _socket!.onError((err) {
      _logger.e('Socket error: $err');
    });

    _socket!.connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  void emit(String event, dynamic data) {
    if (_socket == null || !_socket!.connected) {
      _logger.w('Socket not connected. Cannot emit event: $event');
      return;
    }
    _socket!.emit(event, data);
  }

  void on(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
  }

  void off(String event) {
    _socket?.off(event);
  }

  // ─── Chat helpers ──────────────────────────────────────────────────────────

  void sendChatMessage(String toUserId, String content, {String? jobId}) {
    emit('chat:send', {
      'toUserId': toUserId,
      'content': content,
      if (jobId != null) 'jobId': jobId,
    });
  }

  void joinChatRoom(String jobId) {
    emit('chat:join', {'jobId': jobId});
  }

  void onChatReceive(Function(Map<String, dynamic>) callback) {
    on('chat:receive', (data) => callback(data as Map<String, dynamic>));
  }
}
