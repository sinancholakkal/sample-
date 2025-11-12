import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

abstract class ConversationEvent {}

class LoadMessagesEvent extends ConversationEvent {
  final String chatRoomId;
  LoadMessagesEvent({required this.chatRoomId});
}

class SendMessageEvent extends ConversationEvent {
  final String chatRoomId;
  final String messageText;
  final String senderId;
  final String recipientId;

  SendMessageEvent({
    required this.chatRoomId,
    required this.messageText,
    required this.senderId,
    required this.recipientId,
  });
}

class MessagesUpdatedEvent extends ConversationEvent {
  final List<QueryDocumentSnapshot> messages;
  MessagesUpdatedEvent(this.messages);
}
class SendImageEvent extends ConversationEvent{

  final String chatRoomId;
  final XFile image;
  final String senderId;
  final String recipientId;

  SendImageEvent({
    required this.chatRoomId,
    required this.image,
    required this.senderId,
    required this.recipientId,
  });
}

