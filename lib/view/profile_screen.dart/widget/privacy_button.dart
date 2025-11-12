import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildPrivacyPolicyLink(BuildContext context) {
    // Replace this with your actual privacy policy URL
    final Uri privacyPolicyUrl = Uri.parse('https://www.termsfeed.com/live/364ad209-b439-4b36-8241-f750b34a410d');

    return ListTile(
      leading: Icon(Icons.privacy_tip_outlined, color: kWhite),
      title: Text('Privacy Policy', style: GoogleFonts.poppins(color: kWhite)),
      trailing:  Icon(Icons.arrow_forward_ios, color: kWhite, size: 16),
      onTap: () async {
        if (await canLaunchUrl(privacyPolicyUrl)) {
          await launchUrl(privacyPolicyUrl, mode: LaunchMode.inAppWebView);
        } else {
          // Optional: show a toast that the URL can't be launched
          flutterToast(msg: 'Could not open privacy policy');
        }
      },
    );
  }