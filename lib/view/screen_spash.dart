import 'package:dating_app/services/auth_services.dart';
import 'package:dating_app/state/auth_bloc/auth_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    context.read<AuthBloc>().add(CheckLoginStatusEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: appGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccessNavigateToHome) {
            context.go("/easytab");
          } else if (state is AuthNoFountState) {
            context.go("/onboarding");
          }else if(state is AuthSuccessNavigateToProfileSetup){
            context.go("/profilesetup");
          }
        },
          
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Your App Logo
                 Image.asset("asset/app_icon.png",cacheHeight: 80,),
                const SizedBox(height: 24),
                // Your App Name
                Text(
                  "PairUp Meet", // Or your app's name
                  style: GoogleFonts.poppins(
                    color: kWhite,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 80),
                // Loading Indicator
                 CircularProgressIndicator(
                  color: kWhite,
                ),
              ],
            ),)
        ),
      ),
    );
  }
}
