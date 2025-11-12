import 'package:cloud_firestore/cloud_firestore.dart';


abstract class ConversationState {}

class ConversationLoading extends ConversationState {}

class ConversationLoaded extends ConversationState {
  final List<QueryDocumentSnapshot> messages;
  ConversationLoaded(this.messages);
}

class ConversationError extends ConversationState {}

