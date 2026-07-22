import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    // Initialize local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _localNotifications.initialize(settings);

    // Request permissions
    NotificationSettings settings2 = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token and save to backend
    final token = await _fcm.getToken();
    if (token != null) {
      await _saveTokenToBackend(token);
    }

    // Listen to messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
  }

  static Future<void> _saveTokenToBackend(String token) async {
    // Call backend API to save token
    // POST /api/v1/notifications/fcm-token
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    // Show local notification
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails('chat_channel', 'Chat Notifications',
            importance: Importance.high, priority: Priority.high);
    const NotificationDetails details = NotificationDetails(android: androidDetails);
    _localNotifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      details,
    );
  }

  static void _handleBackgroundMessage(RemoteMessage message) {
    // Navigate to relevant screen
    // e.g., open chat or job details
  }
}