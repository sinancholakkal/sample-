import 'dart:io';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/utils/app_sizedbox.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadCard extends StatelessWidget {
  final String title;
  final String description;
  final File? image;
  final VoidCallback onTap;

  const UploadCard({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: bgcard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kWhite.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: kWhite),
              textAlign: TextAlign.center,
            ),
            AppSizedBox.h8,
            Text(
              description,
              style: GoogleFonts.poppins(fontSize: 14, color: kWhite70),
              textAlign: TextAlign.center,
            ),
            AppSizedBox.h16,
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: kWhite.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kWhite.withOpacity(0.3), width: 1),
                image: image != null
                    ? DecorationImage(image: FileImage(image!), fit: BoxFit.cover)
                    : null,
              ),
              child: image == null
                  ?  Icon(Icons.add_a_photo_outlined, color: kWhite54, size: 50)
                  : null,
            ),
            if (image != null) AppSizedBox.h8,
            if (image != null)
              Text(
                "Tap to Change",
                style: GoogleFonts.poppins(color: kWhite70, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }
}