 import 'package:flutter/material.dart';

Future<dynamic> loadingWidget(BuildContext context) {
    return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return WillPopScope(
              onWillPop: () async => false,
              child: Center(
                child: Image.asset(
                  height: 60,
                  "asset/loading.gif",
                ),
              ),
            );
          },
        );
  }
