import 'package:dating_app/utils/app_sizedbox.dart';
import 'package:dating_app/view/profile_setup_screen/profile_setup_screen.dart';
import 'package:dating_app/view/widgets/app_genderchip.dart';
import 'package:dating_app/view/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsStep extends StatelessWidget {
  final VoidCallback onContinue;
  final TextEditingController nameController;
  final TextEditingController ageController;
  final Gender selectedGender;
  final Function(Gender) onGenderSelected;

  const DetailsStep({
    super.key,
    required this.onContinue,
    required this.nameController,
    required this.ageController,
    required this.selectedGender,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            "First, the basics",
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          AppTextField(controller: nameController, hintText: "Your Name"),
          AppSizedBox.h16,
          AppTextField(
            controller: ageController,
            hintText: "Your Age",
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 24),
          Text(
            "You are a...",
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              GenderChip(
                label: "Woman",
                isSelected: selectedGender == Gender.woman,
                onTap: () => onGenderSelected(Gender.woman),
              ),
              const SizedBox(width: 16),
              GenderChip(
                label: "Man",
                isSelected: selectedGender == Gender.man,
                onTap: () => onGenderSelected(Gender.man),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: onContinue,
            child: Text(
              "Continue",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            // ... button styling is the same ...
          ),
          AppSizedBox.h20
        ],
      ),
    );
  }
}