import 'package:dating_app/utils/app_color.dart';
import 'package:flutter/material.dart';

class AppCirculaWidget extends StatelessWidget {
  const AppCirculaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: kBlue,
        strokeWidth: 3,
      ),
    );
  }
}