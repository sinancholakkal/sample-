import 'package:dating_app/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? prefixText;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final int maxLines;

  const AppTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.prefixText,
    this.keyboardType = TextInputType.text, // Sensible default
    this.validator,
    this.obscureText = false, // Default to not obscure text
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    // We use TextFormField for built-in validation support
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText,
      maxLines: maxLines,
      style: GoogleFonts.poppins(
        color: kWhite,
        fontSize: 18,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixText: prefixText,
        hintStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 18),
        prefixStyle: GoogleFonts.poppins(
          color: kWhite,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: kWhite.withOpacity(0.1),
        border: OutlineInputBorder( // Using a single border for consistency
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: kWhite.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: kWhite.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: kWhite.withOpacity(0.8)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}