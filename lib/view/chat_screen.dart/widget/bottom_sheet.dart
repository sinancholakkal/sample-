import 'dart:developer';

import 'package:dating_app/models/chat_user_model.dart';
import 'package:dating_app/state/user_bloc_and_report_bloc/user_bloc_and_report_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void showActionSheetUnblock(
  BuildContext context, {
  required ChatUserModel chat,
}) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      message: Text(
        'Select an action you would like to take.',
        style: GoogleFonts.poppins(),
      ),
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            context.read<UserBlocAndReportBloc>().add(
              UserUnblockEvent(chatRoomId: chat.chatRoomId),
            );
            Navigator.pop(context);
            log('UnBlock  user tapped');
          },

          child: const Text('Unblock'),
        ),
      ],

      cancelButton: CupertinoActionSheetAction(
        isDefaultAction: true,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Cancel'),
      ),
    ),
  );
}
