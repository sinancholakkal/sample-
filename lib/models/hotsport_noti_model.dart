import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String type; // e.g., 'like', 'super_like', 'message', 'wink'
  final String senderId;
  final String senderName;
  final String senderPhotoUrl;
  final String recipientId;
  final Timestamp timestamp;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.senderId,
    required this.senderName,
    required this.senderPhotoUrl,
    required this.recipientId,
    required this.timestamp,
    this.isRead = false,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception("Notification data is null for doc ${doc.id}");
    }
    return NotificationModel(
      id: doc.id,
      type: data['type'] as String? ?? 'unknown',
      senderId: data['senderId'] as String? ?? '',
      senderName: data['senderName'] as String? ?? 'Unknown',
      senderPhotoUrl: data['senderPhotoUrl'] as String? ?? 'https://via.placeholder.com/150',
      recipientId: data['recipientId'] as String? ?? '',
      timestamp: data['timestamp'] as Timestamp? ?? Timestamp.now(),
      isRead: data['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'type': type,
      'senderId': senderId,
      'senderName': senderName,
      'senderPhotoUrl': senderPhotoUrl,
      'recipientId': recipientId,
      'timestamp': timestamp,
      'isRead': isRead,
    };
  }
}