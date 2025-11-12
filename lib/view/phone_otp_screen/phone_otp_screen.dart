import 'package:dating_app/state/auth_bloc/auth_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/utils/app_string.dart';
import 'package:dating_app/view/widgets/otp_input_view.dart';
import 'package:dating_app/view/widgets/phone_input_view.dart';
import 'package:dating_app/view/widgets/text_feild.dart';
import 'package:dating_app/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


class PhoneOtpScreen extends StatefulWidget {
  const PhoneOtpScreen({super.key});

  @override
  State<PhoneOtpScreen> createState() => _PhoneOtpScreenState();
}

class _PhoneOtpScreenState extends State<PhoneOtpScreen> {
  late final TextEditingController _phoneController;


  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: TextWidget(text: "Phone Verification"),backgroundColor: Colors.transparent,iconTheme: IconThemeData(color: kWhite),),
      body: Container(
        decoration: BoxDecoration(
          gradient: appGradient
        ),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthErrorState) {
              
              flutterToast(msg: state.message,backgroundColor: Kred);
            }
            if(state is AuthError){
              flutterToast(msg:state.message);
            }
            if (state is AuthVerifiedState) {
              flutterToast(msg: AppStrings.phVerified);
            }
            if(state is AuthSuccessNavigateToHome){
             context.go("/easytab");
            }
            if(state is AuthSuccessNavigateToProfileSetup){
              context.go("/profilesetup");
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthCodeSentSuccess) {
                return OtpInputView(phoneNumber: state.phoneNumber);
              }
              return PhoneInputView();
            },
          ),
        ),
      ),
    );
  }

}