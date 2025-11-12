import 'package:dating_app/firebase_options.dart';
import 'package:dating_app/routes/app_router.dart';
import 'package:dating_app/services/chat_service.dart';
import 'package:dating_app/state/ad_bloc/ad_bloc.dart';
import 'package:dating_app/state/auth_bloc/auth_bloc.dart';
import 'package:dating_app/state/chat_bloc/chat_bloc.dart';
import 'package:dating_app/state/conversation_bloc/conversation_bloc.dart';
import 'package:dating_app/state/favorite_bloc/favorite_bloc.dart';
import 'package:dating_app/state/home_user_bloc/home_user_bloc.dart';
import 'package:dating_app/state/profile_setup_bloc/profile_setup_bloc.dart';
import 'package:dating_app/state/request_bloc/request_bloc.dart';
import 'package:dating_app/state/user_actions_bloc/user_actions_bloc.dart';
import 'package:dating_app/state/user_bloc/user_bloc.dart';
import 'package:dating_app/state/user_bloc_and_report_bloc/user_bloc_and_report_bloc.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 MobileAds.instance.initialize();
  await Firebase.initializeApp();
  // --- ADD THIS CODE ---
  RequestConfiguration configuration = RequestConfiguration(
    testDeviceIds: ["DBB64DAF31C4A709D4F674EE7B51F2A0"], //sjidfaslfhslakjdfas Use the ID from your log
  );
  MobileAds.instance.updateRequestConfiguration(configuration);
  // --- END ADDED CODE ---
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug, 
  );


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider(create: (context) => ChatService())],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc()),
          BlocProvider(create: (context) => ProfileSetupBloc()),
          BlocProvider(create: (context) => UserBloc()),
          BlocProvider(create: (context) => HomeUserBloc()),
          BlocProvider(create: (context) => UserActionsBloc()),
          BlocProvider(create: (context) => RequestBloc()),
          BlocProvider(
            create: (context) => ChatBloc(context.read<ChatService>()),
          ),
          BlocProvider(create: (context) => ConversationBloc(context.read<ChatService>()),),
            BlocProvider(create: (context) => UserBlocAndReportBloc(context.read<ChatService>())),
            BlocProvider(
            create: (context) => FavoriteBloc(),
          ),
             BlocProvider(create: (context) => AdBloc())
        ],
        child: CupertinoTheme(
          data: const CupertinoThemeData(
            brightness: Brightness.dark
          ),
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter,
            theme: ThemeData(
              colorScheme: ColorScheme.light(
                background: Colors.grey.shade200,
                onBackground: Colors.black,
                primary: const Color(0xFFFe3c72),
                onPrimary: Colors.black,
                secondary: const Color(0xFF424242),
                onSecondary: Colors.white,
                tertiary: const Color.fromRGBO(255, 204, 128, 1),
                error: Colors.red,
                outline: const Color(0xFF424242),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
