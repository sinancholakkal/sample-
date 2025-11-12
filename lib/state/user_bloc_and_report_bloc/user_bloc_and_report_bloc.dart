import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/services/chat_service.dart';
import 'package:equatable/equatable.dart';

part 'user_bloc_and_report_event.dart';
part 'user_bloc_and_report_state.dart';

class UserBlocAndReportBloc
    extends Bloc<UserBlocAndReportEvent, UserBlocAndReportState> {
  final ChatService _chatService;
  UserBlocAndReportBloc(this._chatService) : super(UserBlocAndReportInitial()) {
    on<UserBlocEvent>((event, emit) async {
      final res = await _chatService.blockChat(
        chatRoomId: event.chatRoomId,
        currentUserId: event.currentUserId,
      );
      log(res.toString());
      if (res) {
        log("Going to emit success");
        emit(UserBlockSuccess());
      } else {
        log("Error state");
      }
    });

    on<UserUnblockEvent>((event, emit) async {
      await _chatService.unblockChat(chatRoomId: event.chatRoomId);

      log("Unblock Suceess");

      emit(UserUnblockSuccess());
    });

    on<UserReportSubmitEvent>((event, emit) async {
      await _chatService.reportUser(reason: event.reason,reportedUserId: event.reporUserId,chatRoomId: event.chatId);

      log("User report Suceess");

    });
  }
}
