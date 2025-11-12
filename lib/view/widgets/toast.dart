import 'package:dating_app/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> flutterToast({
  required String msg,
  Color backgroundColor = textDark, 
  Color textColor = textLight, 
}) {
  return Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: 14.0,
  );
}