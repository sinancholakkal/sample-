import 'package:dating_app/services/auth_services.dart';
import 'package:dating_app/state/auth_bloc/auth_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/utils/app_sizedbox.dart';
import 'package:dating_app/utils/app_string.dart';
import 'package:dating_app/view/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthLandingScreen extends StatelessWidget {
  const AuthLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if(state is AuthSuccessNavigateToHome){
          context.go("/easytab");
        }else if(state is AuthSuccessNavigateToProfileSetup){
          context.go("/profilesetup");
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(gradient: appGradient),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite, size: 80, color: Colors.white),
                const SizedBox(height: 20),
                Text(
                  "Join LoveMatch ❤️",
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: kWhite,
                  ),
                ),
                AppSizedBox.h40,

                authButton(
                  text: AppStrings.continuePh,
                  icon: Icons.phone_android,
                  onTap: () => context.push("/phoneotp"),
                ),
                AppSizedBox.h16,

                authButton(
                  text: AppStrings.continueG,
                  icon: Icons.g_mobiledata,
                  onTap: () {
                    context.read<AuthBloc>().add(GoogleSigninEvent());
                  },
                ),
                AppSizedBox.h16,

                authButton(
                  text: AppStrings.continueE,
                  icon: Icons.email_outlined,
                  onTap: () => context.push("/emailauth"),
                ),

                AppSizedBox.h30,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "By continuing, you agree to our Terms & Privacy Policy",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
