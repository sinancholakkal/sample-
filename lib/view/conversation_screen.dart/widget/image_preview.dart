import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dating_app/utils/app_color.dart'; // Ensure kWhite is accessible

class ImagePreview extends StatelessWidget {
  final XFile xFile;
  final VoidCallback? cancelOnTap;

  const ImagePreview({
    Key? key,
    required this.xFile,
    this.cancelOnTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Stack(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: FileImage(File(xFile.path)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: InkWell(
              onTap: cancelOnTap,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: kWhite, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}