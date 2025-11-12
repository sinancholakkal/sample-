import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dating_app/models/chat_user_model.dart';
import 'package:dating_app/services/chat_service.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService _chatService;
  StreamSubscription? _chatsSubscription;
  ChatBloc(this._chatService) : super(ChatInitial()) {
    on<LoadChatsEvent>((event, emit) {
      emit(ChatLoading());
      
      // Cancel any previous subscription to avoid memory leaks
      _chatsSubscription?.cancel();
      
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
      
      // Subscribe to the stream from the service
      _chatsSubscription = _chatService.getChatsStream(currentUserId).listen(
        (chats) {
          // When new data arrives, add a private event to update the state
          //add(_ChatsUpdatedEvent(chats));
        },
        onError: (error) {
          // Handle stream errors
          emit(ChatError());
        },
      );
    });

    // This handler takes the data from the stream and emits the final state
    on<_ChatsUpdatedEvent>((event, emit) {
      emit(ChatLoaded(event.chats));
    });
  }

  // IMPORTANT: Close the stream subscription when the BLoC is closed
  @override
  Future<void> close() {
    _chatsSubscription?.cancel();
    return super.close();
  }
}
