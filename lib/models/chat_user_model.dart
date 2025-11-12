class ChatUserModel {
  final String chatRoomId;
  final String otherUserId;
  final String name;
  final String imageUrl;
  final String lastMessage;
  final DateTime lastMessageTimestamp;
  final int unreadCount;
  final String blockedBy;

  ChatUserModel( {
    required this.unreadCount,
    required this.blockedBy,
    required this.chatRoomId,
    required this.otherUserId,
    required this.name,
    required this.imageUrl,
    required this.lastMessage,
    required this.lastMessageTimestamp,
  });
}