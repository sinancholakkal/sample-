import 'dart:developer';

import 'package:dating_app/models/chat_user_model.dart';
import 'package:dating_app/state/user_bloc_and_report_bloc/user_bloc_and_report_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showReportDialog(
  BuildContext context, {
  required ChatUserModel otherUser,
  required UserBlocAndReportBloc bloc,
}) {
  final reportController = TextEditingController();

  showCupertinoDialog(
    context: context,
    builder: (dialogContext) => CupertinoAlertDialog(
      title: Text("Report ${otherUser.name}"),
      content: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: CupertinoTextField(
          controller: reportController,
          placeholder: "Please provide a reason for the report...",
          maxLines: 4,
          style: TextStyle(color: kWhite),
        ),
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.pop(dialogContext);
          },
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: const Text("Submit"),
          onPressed: () {
            final reason = reportController.text.trim();
            if (reason.isNotEmpty) {
              Navigator.pop(dialogContext);

              bloc.add(
                UserReportSubmitEvent(
                  reporUserId: otherUser.otherUserId,
                  reason: reason,
                  chatId: otherUser.chatRoomId,
                ),
              );

              log("Report submitted with reason: $reason");
            }
          },
        ),
      ],
    ),
  );
}
