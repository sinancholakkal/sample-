import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/widgets/text_feild.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final double width;
  final double height;
  final String text;
  void Function()? onTap;
   CustomButton({
    super.key,
     this.color = Kred,
     this.width = 80,
     this.height = 40,
     required this.text,
     this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
      
        child: Center(child: TextWidget(text: text, size: 14)),
      ),
    );
  }
}
