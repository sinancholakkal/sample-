import 'dart:ui';

import 'package:dating_app/state/auth_bloc/auth_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/utils/app_string.dart';
import 'package:dating_app/view/widgets/app_circular_widget.dart';
import 'package:dating_app/view/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class PhoneInputView extends StatefulWidget {

  const PhoneInputView({super.key,});

  @override
  State<PhoneInputView> createState() => _PhoneInputViewState();
}

class _PhoneInputViewState extends State<PhoneInputView> {
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
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.enterNo,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kWhite
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          //TextFieldwidget-----------
          AppTextField(controller: _phoneController,prefixText: "+91 ",),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                SendOtpEvent(phoneNumber: _phoneController.text),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: BlocSelector<AuthBloc, AuthState, bool>(
              selector: (state) => state is AuthLoadingState,
              builder: (context, isLoading) {
                return isLoading
                    ? const AppCirculaWidget()
                    : const Text("Send OTP");
              },
            ),
          ),
        ],
      ),
    );
  }
}




