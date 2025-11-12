import 'dart:io';

import 'package:dating_app/state/profile_setup_bloc/profile_setup_bloc.dart';
import 'package:dating_app/utils/app_color.dart' as AppColors;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class PhotosStep extends StatelessWidget {
  final VoidCallback onContinue;
   PhotosStep({super.key, required this.onContinue});

  List<XFile>images =[];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Add your best photos",
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.kWhite,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "Upload at least 2 photos to continue.",
            style: GoogleFonts.poppins(fontSize: 16, color: AppColors.kWhite70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: BlocConsumer<ProfileSetupBloc, ProfileSetupState>(
              listener: (context, state) {
                if(state is ImageUploadedState){
                  images.add(state.pickedFile);
                }
              },
              builder: (context, state) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        context.read<ProfileSetupBloc>().add(
                          SelfieImageUploadEvent(source: ImageSource.gallery),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.kWhite.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.kWhite.withOpacity(0.3),
                          ),
                        ),
                        child: (index<images.length)?ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                          child: Image.file(File(images[index].path),fit: BoxFit.fill,)):Icon(
                          Icons.add_a_photo_outlined,
                          color: AppColors.kWhite54,
                          size: 40,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: onContinue,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 55),
              backgroundColor: AppColors.kWhite,
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              "Continue",
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
}
