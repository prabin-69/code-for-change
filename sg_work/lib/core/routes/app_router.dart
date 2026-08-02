import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/route_constants.dart';


// AUTH
import '../../features/auth/presentation/pages/splash_screen.dart';
import '../../features/auth/presentation/pages/phone_login_screen.dart';
import '../../features/auth/presentation/pages/otp_verification_screen.dart';
import '../../features/auth/presentation/pages/role_selection_screen.dart';
import '../../features/auth/presentation/pages/category_selection_screen.dart';
import '../../features/auth/presentation/pages/request_description_screen.dart';
import '../../features/auth/presentation/pages/my_requests_screen.dart';
import '../../features/auth/presentation/pages/request_details_screen.dart';
import '../../features/auth/presentation/pages/favorites_screen.dart';
import '../../features/auth/presentation/pages/customer_profil_screen.dart';


// HOME – Shared Home Screen replaces GuestHomeScreen, HomeScreen, and CustomerHomeScreen
import '../../features/home/presentation/pages/shared_home_screen.dart';
// Old home screens preserved for backward compatibility (not routed to directly)
// import '../../features/home/presentation/pages/home_screen.dart';
// import '../../features/home/presentation/pages/guest_home_screen.dart';


// SETTINGS
import '../../features/settings/presentation/pages/settings_screen.dart';


// CUSTOMER
// import '../../features/customer/presentation/pages/customer_home_screen.dart'; // Replaced by SharedHomeScreen
import '../../features/customer/presentation/pages/booking_screen.dart';


// SEARCH
import '../../features/search/presentation/pages/search_result_screen.dart';
import '../../features/search/presentation/pages/professional_preview_screen.dart';
import '../../features/search/professional_dashboard.dart';
import '../../features/search/pending_requests_screen.dart';
import '../../features/search/job_management_screen.dart';


// PROFESSIONAL
import '../../features/professional/presentation/pages/professional_home_screen.dart';
import '../../features/professional/presentation/pages/professional_requests_screen.dart';
import '../../features/professional/presentation/pages/professional_profile_screen.dart';
import '../../features/professional/presentation/pages/professional_profile_setup_screen.dart';
import '../../features/professional/presentation/pages/professional_edit_profile_screen.dart';
import '../../features/professional/presentation/bloc/professional_bloc.dart';

// CHAT
import '../../features/chat/presentation/pages/chat_screen.dart';

// AUTH BLOC
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// GET_IT
import 'package:get_it/get_it.dart';



class AppRouter {


  static final _rootNavigatorKey =
      GlobalKey<NavigatorState>();



  static final router = GoRouter(

    navigatorKey: _rootNavigatorKey,


    initialLocation: '/',



    redirect: (context, state) {
      // Try to read AuthBloc. If not available, let the route load.
      final authBloc = context.read<AuthBloc>();
      final authState = authBloc.state;

      // ─── Old route redirects ───
      final uri = state.uri.toString();
      if (uri == '/guest' || uri == '/home' || uri == '/customer/home') {
        return '/';
      }

      // ─── Auth-based redirects (only for the home route '/') ───
      if (uri == '/') {
        if (authState is AuthSuccess) {
          final role = authState.user.role.toUpperCase();
          if (role == 'PROFESSIONAL') {
            return '/professional/dashboard';
          }
          // Customer stays on shared home – no redirect
        } else if (authState is RoleSelectionRequired) {
          return RouteConstants.roleSelection;
        }
        // Guest stays on shared home – no redirect
      }

      return null;
    },



    routes: [



      // ================= SHARED HOME (Guest + Customer) =================


      GoRoute(

        path: '/',

        builder: (context, state) =>
        const SharedHomeScreen(),

      ),




      // ================= SETTINGS =================


      GoRoute(

        path:'/settings',

        builder:(context,state)=>
        const SettingsScreen(),

      ),




      // ================= AUTH =================


      GoRoute(

        path:RouteConstants.splash,

        builder:(context,state)=>
        const SplashScreen(),

      ),



      GoRoute(

        path:RouteConstants.phoneLogin,

        builder:(context,state)=>
        const PhoneLoginScreen(),

      ),



      GoRoute(

        path:RouteConstants.otpVerification,

        builder:(context,state){

          final phone =
              state.extra as String? ?? '';

          return OtpVerificationScreen(

            phoneNumber: phone,

          );

        },

      ),



      GoRoute(

        path:RouteConstants.roleSelection,

        builder:(context,state)=>
        const RoleSelectionScreen(),

      ),





      // ================= CUSTOMER =================



      GoRoute(

        path:'/customer/professions',

        builder:(context,state){

          final categoryId =
              state.extra as String? ?? '';

          return CategorySelectionScreen(

            categoryId: categoryId,

          );

        },

      ),




      GoRoute(

        path:'/customer/request-description',

        builder:(context,state){

          final args =
              state.extra as Map<String,String>? ?? {};


          return RequestDescriptionScreen(

            categoryId:
            args['categoryId'] ?? '',


            professionId:
            args['professionId'] ?? '',

          );

        },

      ),




      GoRoute(

        path:'/customer/my-requests',

        builder:(context,state)=>
        const MyRequestsScreen(),

      ),




      GoRoute(

        path:'/customer/request-details',

        builder:(context,state){

          final requestId =
              state.extra as String? ?? '';


          return RequestDetailsScreen(

            requestId: requestId,

          );

        },

      ),




      GoRoute(

        path:'/customer/favorites',

        builder:(context,state)=>
        const FavoritesScreen(),

      ),




      GoRoute(

        path:'/customer/profile',

        builder:(context,state)=>
        const CustomerProfileScreen(),

      ),





      // ================= SEARCH =================



      GoRoute(

        path:'/search',

        builder:(context,state){

          final query =
              state.extra as String? ?? '';


          return SearchResultScreen(

            query: query,

          );

        },

      ),





      GoRoute(

        path:'/professional-preview',

        builder:(context,state){

          final data =
              state.extra as Map<String,String>? ?? {};


          return ProfessionalPreviewScreen(

            name:data['name'] ?? '',

            profession:data['profession'] ?? '',

            professionalId: data['id'],

            categoryId: data['categoryId'],

            professionId: data['professionId'],

          );

        },

      ),






      // ================= PROFESSIONAL =================



      GoRoute(
        path:'/professional/dashboard',
        builder:(context,state)=> BlocProvider(
          create: (_) => GetIt.I<ProfessionalBloc>(),
          child: const ProfessionalHomeScreen(),
        ),
      ),

      GoRoute(
        path:'/professional/requests',
        builder:(context,state)=> BlocProvider(
          create: (_) => GetIt.I<ProfessionalBloc>(),
          child: const ProfessionalRequestsScreen(),
        ),
      ),

      GoRoute(
      path:'/professional/profile',
      builder:(context,state)=>
      const ProfessionalProfileScreen(),
    ),

      GoRoute(
      path:'/professional/setup',
      builder:(context,state)=>
      const ProfessionalProfileSetupScreen(),
    ),





      GoRoute(

        path:RouteConstants.professionalHome,

        builder:(context,state)=>
        const ProfessionalDashboard(),

      ),




      GoRoute(

        path:'/professional/pending-requests',

        builder:(context,state)=>
        const PendingRequestsScreen(),

      ),




      GoRoute(

        path:'/professional/my-jobs',

        builder:(context,state)=>
        const JobManagementScreen(),

      ),

      GoRoute(

      path:'/professional/edit-profile',

     builder:(context,state)=>
     const ProfessionalEditProfileScreen(),

),





      // ================= CHAT =================



      GoRoute(

        path:'/chat',

        builder:(context,state){

          final name =
              state.extra as String? ??
              'Professional';


          return ChatScreen(

            userName:name,

          );

        },

      ),






      // ================= BOOKING =================



      GoRoute(

        path:'/booking',

        builder:(context,state){


          final data =
              state.extra as Map<String,String>? ?? {};


          return BookingScreen(

            professionalName:
            data['name'] ?? 'Professional',


            profession:
            data['profession'] ?? 'Service',

            professionalId:
            data['professionalId'],

            categoryId:
            data['categoryId'],

            professionId:
            data['professionId'],

          );

        },


      ),


    ],





    // ================= ERROR =================


    errorBuilder:(context,state){


      return Scaffold(

        body:Center(

          child:Column(

            mainAxisAlignment:
            MainAxisAlignment.center,


            children:[


              const Icon(

                Icons.error_outline,

                color:Colors.red,

                size:64,

              ),



              const SizedBox(height:20),



              Text(

                'Page not found: ${state.matchedLocation}',

              ),



              const SizedBox(height:20),



              ElevatedButton(

                onPressed:(){

              context.go('/');

                },


                child:
                const Text(
                  'Go Home',
                ),

              ),

            ],

          ),

        ),

      );

    },

  );

}