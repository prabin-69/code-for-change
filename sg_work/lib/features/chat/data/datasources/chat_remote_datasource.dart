import 'package:dio/dio.dart';

class ChatRemoteDataSource {
  final Dio dio;

  ChatRemoteDataSource({required this.dio});

  static const String _base = '/api/v1/chat';

  Future<List<Map<String, dynamic>>> getRecentChats() async {
    final response = await dio.get('$_base/recent');
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getMessages(String otherUserId, {String? jobId, int limit = 50, int offset = 0}) async {
    final Map<String, dynamic> params = {'limit': limit, 'offset': offset};
    if (jobId != null) params['jobId'] = jobId;
    final response = await dio.get('$_base/messages/$otherUserId', queryParameters: params);
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<void> markAsRead(String senderId, {String? jobId}) async {
    await dio.put('$_base/messages/$senderId/read', data: {'jobId': jobId});
  }

  Future<int> getUnreadCount() async {
    final response = await dio.get('$_base/unread');
    return (response.data['data']['count'] as num).toInt();
  }
}

