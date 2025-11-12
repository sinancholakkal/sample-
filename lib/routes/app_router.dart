


import 'package:dating_app/view/home_screen/persistent_nav.dart';
import 'package:dating_app/view/auth_landing_screen/auth_landing_screen.dart';
import 'package:dating_app/view/email_auth_screen/email_auth_screen.dart';
import 'package:dating_app/view/home_screen/home_screen.dart';
import 'package:dating_app/view/home_screen/widget/other_profile_details_screen.dart';
import 'package:dating_app/view/phone_otp_screen/phone_otp_screen.dart';
import 'package:dating_app/view/profile_setup_screen/profile_setup_screen.dart';
import 'package:dating_app/view/screen_onboarding/screen_onboarding.dart';
import 'package:dating_app/view/screen_spash.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/onboarding', builder: (context, state) =>  ScreenOnboarding()),
    GoRoute(path: '/authlanding', builder: (context, state) =>  AuthLandingScreen()),
    GoRoute(path: '/phoneotp', builder: (context, state) =>  PhoneOtpScreen()),
    GoRoute(path: '/emailauth', builder: (context, state) =>  EmailAuthScreen()),
    GoRoute(path: '/profilesetup', builder: (context, state) =>  ProfileSetupScreen()),
    GoRoute(path: '/home', builder: (context, state) =>  HomeScreen()),
    GoRoute(path: '/easytab', builder: (context, state) =>  EasyTabbar()),
    GoRoute(path: '/splash', builder: (context, state) =>  ScreenSplash()),
    // GoRoute(
    //   path: '/profile/:userId', // The ':userId' is the parameter
    //   builder: (context, state) {
    //     // Extract the userId from the route's state
    //     final index = state.pathParameters['userId']!;
    //     return OtherProfileDetailsScreen(index: int.parse(index));
    //   },
    // ),
    // GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    // GoRoute(
    //   path: '/register',
    //   builder: (context, state) => const RegisterScreen(),
    // ),
    // GoRoute(path: "/home", builder: (context, state) =>  HomeScreen()),
    //  GoRoute(path: "/splash", builder: (context, state) =>  ScreenSplash()),
    //  GoRoute(path: '/viewItem', builder: (context, state) {
    //   final passWordModel = state.extra as PasswordModel;
    //   return ViewScreen(passwordModel: passWordModel,);
    //  }),
    //  GoRoute(path: '/addedit', builder: (context, state) {
    //   final Map<String,dynamic> params = state.extra as Map<String,dynamic>;

    //   return AddEditItemScreen(type: params['type'],passwordModel: params['model'],);
    //  }),
    //  GoRoute(path: '/forgot', builder: (context, state) => const ForgotScreen()),
    //  GoRoute(path: '/search', builder: (context, state) {
    //   final params = state.extra as List<PasswordModel>;

    //   return SearchScreen(models: params,);
    //  }),

  ],
);
