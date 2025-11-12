// You can place this in its own file, e.g., features/authentication/widgets/otp_input_view.dart

import 'package:dating_app/state/auth_bloc/auth_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class OtpInputView extends StatefulWidget {
  final String phoneNumber;

  const OtpInputView({super.key, required this.phoneNumber});

  @override
  State<OtpInputView> createState() => _OtpInputViewState();
}

class _OtpInputViewState extends State<OtpInputView> {
  late final TextEditingController _otpController;
  @override
  void initState() {
    _otpController = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: GoogleFonts.poppins(fontSize: 22),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Enter the OTP sent to +91 ${widget.phoneNumber}",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: kWhite
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Pinput(
            length: 6,
            controller: _otpController, // Use the controller passed in
            defaultPinTheme: defaultPinTheme,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                VerifyOtpEvent(otp: _otpController.text),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text("Verify & Continue"),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => context.read<AuthBloc>().add(ResetAuthEvent()),
            child: const Text("Change Number"),
          ),
        ],
      ),
    );
  }
}
