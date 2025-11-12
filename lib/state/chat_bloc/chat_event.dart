part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}
// Fired by the UI to start listening to the chat list
class LoadChatsEvent extends ChatEvent {}

// A private event used by the BLoC to pass stream updates to its state
class _ChatsUpdatedEvent extends ChatEvent {
  final List<ChatUserModel> chats;
  _ChatsUpdatedEvent(this.chats);
}