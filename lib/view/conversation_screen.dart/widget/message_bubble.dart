// lib/widgets/message_bubble.dart
import 'package:dating_app/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
// No need to import ChatMessage model here if we're not using it directly

// Import ChatService for the reaction logic
import 'package:dating_app/services/chat_service.dart';

class MessageBubble extends StatelessWidget {
  final String messageId; // Unique ID of the message for updating reactions
  final String senderId; // The ID of the user who sent the message
  final bool isMe;
  final String text;
  final Map<String, dynamic> reactions; // Reactions map: {userId: emoji}
  final String currentUserId; // Current logged-in user's ID
  final String chatRoomId; // The ID of the current chat room
  final ChatService chatService; // Instance of ChatService

  const MessageBubble({
    Key? key,
    required this.messageId,
    required this.senderId, // Need senderId to determine MainAxisAlignment for reactions
    required this.isMe,
    required this.text,
    required this.reactions, // Pass the reactions map directly
    required this.currentUserId,
    required this.chatRoomId,
    required this.chatService,
  }) : super(key: key);

  // --- Helper function to show the reaction picker (moved here) ---
  void _showReactionPicker(BuildContext context) {
    final List<String> availableEmojis = ['❤️', '😂', '👍', '👎', '😢', '🤩'];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.0,
            runSpacing: 8.0,
            children: availableEmojis.map((emoji) {
              final hasReactedWithThisEmoji = reactions[currentUserId] == emoji;
              return InkWell(
                onTap: () {
                  Navigator.pop(bc); // Close the picker
                  chatService.addOrRemoveReaction(messageId, emoji, chatRoomId);
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: hasReactedWithThisEmoji ? primary.withOpacity(0.3) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: hasReactedWithThisEmoji ? primary : Colors.transparent, width: 1.0),
                  ),
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // --- Helper function to build and display reactions Widget (moved here) ---
  Widget _buildReactionsDisplay() {
    if (reactions.isEmpty) return const SizedBox.shrink();

    // Aggregate reactions: count how many users reacted with each emoji
    Map<String, int> emojiCounts = {};
    reactions.forEach((userId, emoji) {
      emojiCounts[emoji] = (emojiCounts[emoji] ?? 0) + 1;
    });

    // Check if current user has reacted at all
    final bool currentUserHasReacted = reactions.containsKey(currentUserId);
    final String? currentUserEmoji = reactions[currentUserId];

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: emojiCounts.entries.map((entry) {
          final emoji = entry.key;
          final count = entry.value;

          final bool isCurrentUserReaction = currentUserHasReacted && currentUserEmoji == emoji;

          return GestureDetector(
            onTap: () {
              chatService.addOrRemoveReaction(messageId, emoji, chatRoomId);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 4.0),
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
              decoration: BoxDecoration(
                color: isCurrentUserReaction ? primary.withOpacity(0.3) : kWhite.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: isCurrentUserReaction ? primary : Colors.transparent, width: 0.5),
              ),
              child: Text(
                '$emoji $count',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: kWhite,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isImageMessage = text.startsWith("https://firebasestorage.googleapis.com");

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: isImageMessage
          ? GestureDetector(
              onLongPress: () => _showReactionPicker(context),
              child: Container(
                width: 180,
                height: 230,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: InstaImageViewer(
                    child: Image.network(text, fit: BoxFit.cover),
                  ),
                ),
              ),
            )
          : GestureDetector(
              onLongPress: () => _showReactionPicker(context),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: isMe ? primary : kWhite.withOpacity(0.2),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: isMe
                        ? const Radius.circular(20)
                        : const Radius.circular(4),
                    bottomRight: isMe
                        ? const Radius.circular(4)
                        : const Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(text, style: GoogleFonts.poppins(color: kWhite)),
                    if (reactions.isNotEmpty)
                      _buildReactionsDisplay(), // Call the local helper to display reactions
                  ],
                ),
              ),
            ),
    );
  }
}