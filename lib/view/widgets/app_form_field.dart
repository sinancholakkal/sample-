import 'package:dating_app/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;

  const PasswordTextField({
    super.key,
    required this.controller,
    this.hintText = "Password",
    this.validator,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: !_isPasswordVisible,
      style: GoogleFonts.poppins(color: kWhite, fontSize: 18),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: GoogleFonts.poppins(color: kWhite54),
        filled: true,
        fillColor: kWhite.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: kWhite.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: kWhite.withOpacity(0.8)),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: kWhite70,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
    );
  }
}