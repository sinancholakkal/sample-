import 'dart:developer';

import 'package:dating_app/state/auth_bloc/auth_bloc.dart';
import 'package:dating_app/utils/app_color.dart' as AppColors;
import 'package:dating_app/utils/app_string.dart';
import 'package:dating_app/utils/validators.dart';
import 'package:dating_app/view/widgets/app_form_field.dart';
import 'package:dating_app/view/widgets/app_text_field.dart';
import 'package:dating_app/view/widgets/loading.dart';
import 'package:dating_app/view/widgets/text_feild.dart';
import 'package:dating_app/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailAuthScreen extends StatefulWidget {
  const EmailAuthScreen({super.key});

  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  // Controllers for the input fields
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  final _formKey = GlobalKey<FormState>();

  ValueNotifier<bool> isLoginMode = ValueNotifier(true);
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          loadingWidget(context);
        } else if (state is AuthSuccessNavigateToProfileSetup) {
          context.pop();
          flutterToast(msg: AppStrings.signup);
          context.go("/profilesetup");
        } else if (state is AuthSuccessNavigateToHome) {
          context.pop();
          flutterToast(msg: AppStrings.login);
          context.go("/easytab");
        } else if (state is AuthErrorState) {
          context.pop();
          flutterToast(msg: state.message);
        }
      },
      child: Container(
        decoration: const BoxDecoration(gradient: AppColors.appGradient),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            iconTheme: IconThemeData(color: AppColors.kWhite),
            title: ValueListenableBuilder(
              valueListenable: isLoginMode,
              builder: (context, value, child) {
                return TextWidget(
                  text: value ? AppStrings.welcomeback : AppStrings.createAnAcc,
                );
                //return Text(value ?AppStrings.welcomeback : AppStrings.createAnAcc,style: TextStyle(color: AppColors.kWhite),);
              },
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: ValueListenableBuilder(
                valueListenable: isLoginMode,
                builder: (context, isLoginModeNoti, child) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // --- Email and Password Fields ---
                        AppTextField(
                          controller: _emailController,
                          hintText: "Email",
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            return Validation.emailValidation(value);
                          },
                        ),
                        const SizedBox(height: 16),

                        PasswordTextField(
                          controller: _passwordController,
                          validator: (value) {
                            return Validation.passWordValidation(value);
                          },
                        ),

                        //Conform password field---------------------
                        if (!isLoginModeNoti) ...[
                          const SizedBox(height: 16),
                          PasswordTextField(
                            validator: (value) {
                              return Validation.conformPasswordValidation(
                                value: value,
                                password: _passwordController.text,
                                conformPassword:
                                    _confirmPasswordController.text,
                              );
                            },
                            controller: _confirmPasswordController,
                          ),
                        ],

                        const SizedBox(height: 32),

                        //Login and sign up button--------------
                        ElevatedButton(
                          onPressed: () {

                            if (_formKey.currentState!.validate()) {
                              log(" Validated--------------------");
                              if(isLoginModeNoti){
                                context.read<AuthBloc>().add(SignInEvent(email: _emailController.text.trim(), password: _passwordController.text.trim()));
                              }else{
                                   context.read<AuthBloc>().add(
                                SignUpEvent(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                ),
                              );
                              }
                            } else {
                              log("Not Validated--------------------");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 55),
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            isLoginModeNoti
                                ? AppStrings.login
                                : AppStrings.signup,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        //Google signing session-----------
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(color: Colors.white54),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Text(
                                "OR",
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(color: Colors.white54),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                             context.read<AuthBloc>().add(GoogleSigninEvent());
                          },

                          label: Text(
                            AppStrings.continueG,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 55),
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.textDark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // switch between login and signup
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isLoginModeNoti
                                  ? AppStrings.dontaccount
                                  : AppStrings.alreadycc,
                              style: GoogleFonts.poppins(
                                color: AppColors.kWhite70,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                isLoginMode.value = !isLoginModeNoti;
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.kWhite,
                              ),
                              child: Text(
                                isLoginModeNoti
                                    ? AppStrings.signup
                                    : AppStrings.login,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
