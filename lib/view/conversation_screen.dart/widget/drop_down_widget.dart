import 'dart:developer';

import 'package:dating_app/models/chat_user_model.dart';
import 'package:dating_app/services/auth_services.dart';
import 'package:dating_app/state/conversation_bloc/conversation_bloc.dart';
import 'package:dating_app/state/conversation_bloc/conversation_event.dart';
import 'package:dating_app/state/conversation_bloc/conversation_state.dart';
import 'package:dating_app/state/user_bloc_and_report_bloc/user_bloc_and_report_bloc.dart' hide UserBlocSuccess;
import 'package:dating_app/view/conversation_screen.dart/widget/show_report_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class DropDownWidget extends StatelessWidget {
  final ChatUserModel chatUserModel;
  const DropDownWidget({super.key, required this.chatUserModel});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showActionSheet(context, chatUserModel);
      },
      icon: Icon(Icons.more_vert),
    );
  }
}

void showActionSheet(BuildContext context, ChatUserModel chatUserModel) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      title: Text(
        'Options for ${chatUserModel.name}',
        style: GoogleFonts.poppins(),
      ),
      message: Text(
        'Select an action you would like to take.',
        style: GoogleFonts.poppins(),
      ),
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            context.read<UserBlocAndReportBloc>().add(UserBlocEvent(chatRoomId: chatUserModel.chatRoomId, currentUserId: AuthService().getCurrentUser()!.uid));
            Navigator.pop(context);
            
            log('Block user tapped');
          },
          child: const Text('Block'),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            showReportDialog(context, otherUser: chatUserModel,bloc: context.read<UserBlocAndReportBloc>());
          },
          child: const Text('Report'),
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


