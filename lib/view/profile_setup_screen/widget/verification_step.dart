import 'dart:io'; // For File
import 'package:dating_app/state/profile_setup_bloc/profile_setup_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/utils/app_sizedbox.dart';
import 'package:dating_app/view/profile_setup_screen/widget/build_upload_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart'; // For image selection

class VerificationStep extends StatefulWidget {
  final Function(File? selfie) onContinue;

  const VerificationStep({super.key, required this.onContinue});

  @override
  State<VerificationStep> createState() => _VerificationStepState();
}

class _VerificationStepState extends State<VerificationStep> {
  File? _selfie;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Verify Your Profile",
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: kWhite,
            ),
            textAlign: TextAlign.center,
          ),
          AppSizedBox.h16,
          Text(
            "Help us keep our community safe by taking a quick selfie. This helps prevent fake profiles.",
            style: GoogleFonts.poppins(fontSize: 16, color: kWhite70),
            textAlign: TextAlign.center,
          ),
          AppSizedBox.h30,
          Expanded(
            child: BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
              builder: (context, state) {
                if(state is SelfieImageUploadedState){
                  _selfie = File(state.pickedFile.path);
                }
                return SingleChildScrollView(
                  child: UploadCard(title: "Upload a Selfie", description: "Make sure your face is clearly visible.", image:_selfie , onTap: () {
                    context.read<ProfileSetupBloc>().add(
                        SelfieImageUploadEvent(source: ImageSource.camera),
                      );
                  },),
                  
                );
              },
            ),
          ),
          AppSizedBox.h40,
          ElevatedButton(
            onPressed: () => widget.onContinue(_selfie),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 55),
              backgroundColor:   kWhite ,
              foregroundColor:   primary ,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
               "Finish Setup",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Reusable Card for Photo Upload ---
}