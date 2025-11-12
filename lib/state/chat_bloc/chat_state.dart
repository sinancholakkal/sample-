part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();
  
  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}
class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatUserModel> chats;
  ChatLoaded(this.chats);
}

class ChatError extends ChatState {}