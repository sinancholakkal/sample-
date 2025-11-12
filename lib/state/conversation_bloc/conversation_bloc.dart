import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/services/chat_service.dart';
import 'package:dating_app/services/user_profile_services.dart';
import 'package:dating_app/state/conversation_bloc/conversation_event.dart';
import 'package:dating_app/state/conversation_bloc/conversation_state.dart';
// Import your service, events, and states

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final ChatService _chatService;
  StreamSubscription? _messagesSubscription;

  ConversationBloc(this._chatService) : super(ConversationLoading()) {
    on<LoadMessagesEvent>((event, emit) {
      _messagesSubscription?.cancel();
      _messagesSubscription = _chatService
          .getMessagesStream(chatRoomId: event.chatRoomId)
          .listen((snapshot) {
            add(MessagesUpdatedEvent(snapshot.docs));
          });
    });

    on<MessagesUpdatedEvent>((event, emit) {
      emit(ConversationLoaded(event.messages));
    });

    on<SendMessageEvent>((event, emit) {
      _chatService.sendMessage(
        recipientId: event.recipientId,
        chatRoomId: event.chatRoomId,
        messageText: event.messageText,
        senderId: event.senderId,
      );
    });

    on<SendImageEvent>((event, emit)async {
      log("Image upload service called");
     final message =  await UserProfileServices().uploadImageToFirebase(File(event.image.path), event.chatRoomId, false,collection: "chat_images");
    
    log("Image url upload in chat");
     _chatService.sendMessage(
        recipientId: event.recipientId,
        chatRoomId: event.chatRoomId,
        messageText: message,
        senderId: event.senderId,
      );
    });

    
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
