  import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget authButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(text,
          style: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(280, 55),
        backgroundColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: onTap,
    );
  }
