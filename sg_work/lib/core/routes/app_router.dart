import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/route_constants.dart';

import '../../features/auth/presentation/pages/splash_screen.dart';
import '../../features/auth/presentation/pages/phone_login_screen.dart';
import '../../features/auth/presentation/pages/otp_verification_screen.dart';
import '../../features/auth/presentation/pages/role_selection_screen.dart';

import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/home/presentation/pages/guest_home_screen.dart';
import '../../features/settings/presentation/pages/settings_screen.dart';

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
import '../../features/search/presentation/pages/search_result_screen.dart';
import '../../features/search/presentation/pages/professional_preview_screen.dart';


// CHAT
import '../../features/chat/presentation/pages/chat_screen.dart';
import '../../features/customer/presentation/pages/booking_screen.dart';


class AppRouter {


  static final _rootNavigatorKey =
      GlobalKey<NavigatorState>();



  static final router = GoRouter(


    navigatorKey: _rootNavigatorKey,


    initialLocation: '/guest',



    redirect: (context, state) {

      return null;

    },



    routes: [



      // ================= GUEST =================


      GoRoute(

        path: '/guest',

        builder: (context,state) =>
            const GuestHomeScreen(),

      ),




      // ================= SETTINGS =================


      GoRoute(

        path:'/settings',

        builder:(context,state)=>
            const SettingsScreen(),

      ),





      // ================= AUTH =================



      GoRoute(

        path: RouteConstants.splash,

        builder:(context,state)=>
            const SplashScreen(),

      ),



      GoRoute(

        path: RouteConstants.phoneLogin,

        builder:(context,state)=>
            const PhoneLoginScreen(),

      ),



      GoRoute(

        path: RouteConstants.otpVerification,

        builder:(context,state){


          final phone =
              state.extra as String? ?? '';



          return OtpVerificationScreen(

            phoneNumber: phone,

          );


        },

      ),




      GoRoute(

        path: RouteConstants.roleSelection,

        builder:(context,state)=>
            const RoleSelectionScreen(),

      ),





      // ================= HOME =================



      GoRoute(

        path: RouteConstants.home,

        builder:(context,state)=>
            const HomeScreen(),

      ),



      GoRoute(

        path: RouteConstants.customerHome,

        builder:(context,state)=>
            const CustomerHomeScreen(),

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





      // ================= PROFESSIONAL PREVIEW =================



      GoRoute(

        path:'/professional-preview',

        builder:(context,state){


          final data =
              state.extra as Map<String,String>? ?? {};



          return ProfessionalPreviewScreen(

            name:
            data['name'] ?? '',


            profession:
            data['profession'] ?? '',


          );


        },

      ),






      // ================= PROFESSIONAL =================



      GoRoute(

        path: RouteConstants.professionalHome,

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





      // ================= CHAT =================



      GoRoute(

        path:'/chat',

        builder:(context,state){


          final name =
              state.extra as String? ??
              'Professional';



          return ChatScreen(

            userName: name,

          );


        },

      ),
    
     // ================= BOOKING =================

GoRoute(

  path: '/booking',

  builder: (context, state) {

    final data =
        state.extra as Map<String, String>? ?? {};

    return BookingScreen(

      professionalName:
          data['name'] ?? 'Professional',

      profession:
          data['profession'] ?? 'Service',

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


                  context.go('/guest');


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