class ApiConstants {
  // Override at build time: --dart-define=API_BASE_URL=https://api.yourserver.com
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:4000', // Android emulator → host machine
  );

  static const String apiVersion = 'v1';
  static const String apiBase = '$baseUrl/api/$apiVersion';

  // ── Auth ──────────────────────────────────────────────────────────────────
  static const String sendOtp      = '$apiBase/auth/send-otp';
  static const String verifyOtp    = '$apiBase/auth/verify-otp';
  static const String refreshToken = '$apiBase/auth/refresh';
  static const String logout       = '$apiBase/auth/logout';
  static const String logoutAll    = '$apiBase/auth/logout-all';
  static const String me           = '$apiBase/auth/me';
  static const String selectRole   = '$apiBase/auth/select-role';

  // ── Users ─────────────────────────────────────────────────────────────────
  static const String userProfile  = '$apiBase/users/profile';
  static const String userFcmToken = '$apiBase/users/fcm-token';

  // ── Categories & Professions ──────────────────────────────────────────────
  static const String categories          = '$apiBase/categories';
  static const String professions         = '$apiBase/professions';

  // ── Search ────────────────────────────────────────────────────────────────
  static const String search              = '$apiBase/search';
  static const String searchProfessional  = '$apiBase/search/professionals';

  /// ETA calculation endpoint.
  /// Query params: originLat, originLng, destLat, destLng
  /// Response: { data: { duration: String, distance: String } }
  static const String eta                 = '$apiBase/search/eta';

  // ── Customer ──────────────────────────────────────────────────────────────
  static const String customerRequests    = '$apiBase/customers/requests';
  static const String customerJobs        = '$apiBase/customers/jobs';
  static const String customerFavorites   = '$apiBase/customers/favorites';
  static const String customerReviews     = '$apiBase/customers/reviews';

  // ── Professional ──────────────────────────────────────────────────────────
  static const String professionalProfile      = '$apiBase/professionals/profile';
  static const String professionalAvailability = '$apiBase/professionals/availability';
  static const String professionalVerification = '$apiBase/professionals/verification';
  static const String professionalCertificates = '$apiBase/professionals/certificates';
  static const String professionalPortfolio    = '$apiBase/professionals/portfolio';
  static const String professionalRequests     = '$apiBase/professionals/requests/pending';
  static const String professionalJobs         = '$apiBase/professionals/jobs';
  static const String professionalPerformance  = '$apiBase/professionals/performance';
  static const String professionalLocation     = '$apiBase/professionals/location';

  // ── Payments ──────────────────────────────────────────────────────────────
  static const String initiatePayment = '$apiBase/payments/initiate';
  static const String myPayments      = '$apiBase/payments/me';

  // ── Subscriptions ─────────────────────────────────────────────────────────
  static const String subscriptions        = '$apiBase/subscriptions';
  static const String mySubscription       = '$apiBase/subscriptions/me';
  static const String subscriptionHistory  = '$apiBase/subscriptions/history';

  // ── Notifications ─────────────────────────────────────────────────────────
  static const String notifications        = '$apiBase/notifications';
  static const String notificationsUnread  = '$apiBase/notifications/unread/count';
  static const String notificationsReadAll = '$apiBase/notifications/read-all';

  // ── Chat ──────────────────────────────────────────────────────────────────
  static const String chatRecent   = '$apiBase/chat/recent';
  static const String chatMessages = '$apiBase/chat/messages';
  static const String chatUnread   = '$apiBase/chat/unread';

  // ── Socket.IO ─────────────────────────────────────────────────────────────
  static const String socketUrl = baseUrl;
}
