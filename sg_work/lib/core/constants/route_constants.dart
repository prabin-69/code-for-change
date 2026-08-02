class RouteConstants {
  static const String splash = '/splash';
  static const String phoneLogin = '/login';
  static const String otpVerification = '/otp';
  static const String roleSelection = '/select-role';

  // ─── SHARED HOME ───
  // The single entry point for all users.
  // Guests: browse + redirect to login on protected actions.
  // Customers: same screen with features unlocked.
  // Professionals: redirected to /professional/dashboard via router redirect.
  static const String home = '/';

  // ─── DEPRECATED ROUTES ───
  // These are kept for backward compatibility but no longer routed to directly.
  // @deprecated Use home ('/') instead – guest_home_screen.dart & customer_home_screen.dart
  // are preserved on disk but no longer reachable via the router.
  // static const String guestHome = '/guest';         // ← replaced by '/'
  // static const String customerHome = '/customer/home'; // ← replaced by '/'

  static const String professionalHome = '/professional/home';
  static const String adminHome = '/admin/home';
}
