import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/models/request_model.dart';
import 'package:dating_app/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestServices {
  Future<List<RequestModel>> fetchRequests() async {
    List<RequestModel> requestModels = [];
    final currentUserId = AuthService().getCurrentUser()!.uid;
    try {
      final docRef = await FirebaseFirestore.instance
          .collection('user')
          .doc(currentUserId)
          .get();
      final data = docRef.data();
      if (data == null) return requestModels;

      final req = List<Map<String, dynamic>>.from(data['requests'] ?? []);
      log(req.toString());
      for (var val in req) {
        final model = RequestModel(
          senderId: val['senderid'],
          senderName: val['sendername'],
          senderImageUrl: val['image'] ?? "",
        );
        requestModels.add(model);
      }

      return requestModels;
    } catch (e) {
      log("Somthing issue while fetch requests $e");
      throw "$e";
    }
  }

  Future<void> declineRequest({required RequestModel requestModel}) async {
    final currentUserId = AuthService().getCurrentUser()!.uid;

    final instance = FirebaseFirestore.instance;
    final docRef = instance.collection('user').doc(currentUserId);

    log("Attempting to decline request from ${requestModel.senderId}...");

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          throw Exception("User document does not exist!");
        }

        final List<dynamic> requests = List.from(
          snapshot.data()?['requests'] ?? [],
        );

        final updatedRequests = requests
            .where(
              (requestMap) => requestMap['senderid'] != requestModel.senderId,
            )
            .toList();

        transaction.update(docRef, {'requests': updatedRequests});
      });

      log("Successfully declined request and updated document.");
    } catch (e) {
      log("Error during decline transaction: $e");
    }
  }


  String createChatRoomId(String uid1, String uid2) {
    if (uid1.compareTo(uid2) > 0) {
      return '${uid1}_${uid2}';
    } else {
      return '${uid2}_${uid1}';
    }
  }


  Future<void> acceptChatRequest(String otherUserId) async {
  final firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    throw Exception("No user logged in");
  }

  final currentUserId = currentUser.uid;
  final batch = firestore.batch();

 
  final chatRoomId = createChatRoomId(currentUserId, otherUserId);
  final chatRoomRef = firestore.collection('chats').doc(chatRoomId);
  batch.set(chatRoomRef, {
    'users': [currentUserId, otherUserId],
    'lastMessage': 'You are now connected!',
    'lastMessageTimestamp': FieldValue.serverTimestamp(),
  });

 
  final currentUserRef = firestore.collection('user').doc(currentUserId);
  batch.set(currentUserRef, { 
    'matches': FieldValue.arrayUnion([otherUserId]),
    'pendingRequests': FieldValue.arrayRemove([otherUserId]),
  }, SetOptions(merge: true)); 

  final otherUserRef = firestore.collection('user').doc(otherUserId);
  batch.set(otherUserRef, { 
    'matches': FieldValue.arrayUnion([currentUserId]),
  }, SetOptions(merge: true)); 
  
  try {
    await batch.commit();
    await removeFromLikeCollection(documentId: otherUserId, likedUserIdToRemove: currentUserId);
    log("Removed from like collection");
    await removeRequestFromUser(currentUserId: currentUserId, userIdToRemove: otherUserId);
    log("Reuest removed from current user");
    log('Successfully accepted request and created chat room.');
  } catch (e) {
    log('Error accepting request: $e');
    rethrow;
  }
}



Future<void> removeRequestFromUser({
  required String currentUserId,
  required String userIdToRemove,
}) async {
  final firestore = FirebaseFirestore.instance;
  final docRef = firestore.collection('user').doc(currentUserId);

  log('Attempting to remove request from user: $userIdToRemove');

  try {
    await firestore.runTransaction((transaction) async {
      // 1. READ: Get the latest version of the document
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        throw Exception("User document does not exist!");
      }

      final List<dynamic> requests = List.from(snapshot.data()?['requests'] ?? []);

      requests.removeWhere((requestMap) {
        if (requestMap is Map && requestMap.containsKey('senderid')) {
          return requestMap['senderid'] == userIdToRemove;
        }
        return false;
      });

      transaction.update(docRef, {'requests': requests});
    });
    
    log("Successfully removed request.");

  } catch (e) {
    log("Failed to remove request: $e");
    rethrow;
  }
}


  Future<void> removeFromLikeCollection({
    required String
    documentId, 
    required String likedUserIdToRemove, 
  }) async {
    final docRef = FirebaseFirestore.instance
        .collection('like')
        .doc(documentId);

    log(
      "Attempting to remove like for user: $likedUserIdToRemove from doc: $documentId",
    );

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          throw Exception("Document does not exist!");
        }

        final List<dynamic> likes = List.from(snapshot.data()?['likes'] ?? []);

        final updatedLikes = likes
            .where((likeMap) => likeMap['likedId'] != likedUserIdToRemove)
            .toList();

        transaction.update(docRef, {'likes': updatedLikes});
      });

      log("Successfully removed like and updated document.");
    } catch (e) {
      log("Error during remove like transaction: $e");
    }
  }




  
}
