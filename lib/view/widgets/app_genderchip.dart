import 'package:dating_app/utils/app_color.dart' as AppColors;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GenderChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.kWhite : AppColors.kWhite.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.kWhite : AppColors.kWhite.withOpacity(0.3),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primary : AppColors.kWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }
}