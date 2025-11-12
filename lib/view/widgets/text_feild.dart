import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final FontWeight? fontWeight;
  final TextOverflow textOverflow;
  final int maxLine;
  TextAlign? textAlign;

   TextWidget(
      {super.key,
      required this.text,
      this.color = Colors.white,
      this.size,
      this.fontWeight,
      this.textOverflow = TextOverflow.ellipsis,
      this.maxLine =1,
      this.textAlign = TextAlign.center
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      
      textAlign: textAlign,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
      text,
      
      style: TextStyle(color: color, fontSize: size, fontWeight: fontWeight),
    );
  }
}