import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

import '../constants/route_constants.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/splash_screen.dart';
import '../../features/auth/presentation/pages/phone_login_screen.dart';
import '../../features/auth/presentation/pages/otp_verification_screen.dart';
import '../../features/auth/presentation/pages/role_selection_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/auth/presentation/pages/category_selection_screen.dart';
import '../../features/auth/presentation/pages/request_description_screen.dart';
import '../../features/auth/presentation/pages/my_requests_screen.dart';
import '../../features/auth/presentation/pages/request_details_screen.dart';
import '../../features/auth/presentation/pages/favorites_screen.dart';
import '../../features/auth/presentation/pages/customer_profil_screen.dart';
import '../../features/customer/presentation/pages/customer_home_screen.dart';
import '../../features/search/professional_dashboard.dart';
import '../../features/search/pending_requests_screen.dart';
import '../../features/search/job_management_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteConstants.splash,
    redirect: (context, state) {
      final authBloc = GetIt.I<AuthBloc>();
      final authState = authBloc.state;
      final onAuthPages = state.matchedLocation == RouteConstants.phoneLogin ||
          state.matchedLocation == RouteConstants.otpVerification ||
          state.matchedLocation == RouteConstants.roleSelection ||
          state.matchedLocation == RouteConstants.splash;

      if (authState is Unauthenticated && !onAuthPages) {
        return RouteConstants.phoneLogin;
      }

      // A user who has verified OTP but hasn't chosen Customer/Professional
      // yet must not be able to reach any other route (Home, deep links,
      // browser back/forward, etc.) until the role is set.
      if (authState is RoleSelectionRequired &&
          state.matchedLocation != RouteConstants.roleSelection) {
        return RouteConstants.roleSelection;
      }

      // Once authenticated with a role, don't let the user sit on the
      // auth-only screens (e.g. navigating back after completing setup).
      if (authState is Authenticated &&
          (state.matchedLocation == RouteConstants.phoneLogin ||
              state.matchedLocation == RouteConstants.otpVerification ||
              state.matchedLocation == RouteConstants.roleSelection ||
              state.matchedLocation == RouteConstants.splash)) {
        return RouteConstants.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteConstants.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteConstants.phoneLogin,
        builder: (context, state) => const PhoneLoginScreen(),
      ),
      GoRoute(
        path: RouteConstants.otpVerification,
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return OtpVerificationScreen(phoneNumber: phone);
        },
      ),
      GoRoute(
        path: RouteConstants.roleSelection,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: RouteConstants.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteConstants.customerHome,
        builder: (context, state) => const CustomerHomeScreen(),
      ),
      GoRoute(
        path: '/customer/professions',
        builder: (context, state) {
          final categoryId = state.extra as String? ?? '';
          return CategorySelectionScreen(categoryId: categoryId);
        },
      ),
      GoRoute(
        path: '/customer/request-description',
        builder: (context, state) {
          final args = state.extra as Map<String, String>? ?? {};
          return RequestDescriptionScreen(
            categoryId: args['categoryId'] ?? '',
            professionId: args['professionId'] ?? '',
          );
        },
      ),
      GoRoute(
        path: '/customer/my-requests',
        builder: (context, state) => const MyRequestsScreen(),
      ),
      GoRoute(
        path: '/customer/request-details',
        builder: (context, state) {
          final requestId = state.extra as String? ?? '';
          return RequestDetailsScreen(requestId: requestId);
        },
      ),
      GoRoute(
        path: '/customer/favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/customer/profile',
        builder: (context, state) => const CustomerProfileScreen(),
      ),
      GoRoute(
        path: RouteConstants.professionalHome,
        builder: (context, state) => const ProfessionalDashboard(),
      ),
      GoRoute(
        path: '/professional/pending-requests',
        builder: (context, state) => const PendingRequestsScreen(),
      ),
      GoRoute(
        path: '/professional/my-jobs',
        builder: (context, state) => const JobManagementScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Page not found: ${state.matchedLocation}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(RouteConstants.splash),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
