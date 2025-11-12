import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/services/auth_services.dart';

class UserActionsServices {
  Future<void> dislikeAction({required String dislikeUserId}) async {
    try {
      final String currentUserId = AuthService().getCurrentUser()!.uid;

      final docRef = FirebaseFirestore.instance
          .collection("dislike")
          .doc(currentUserId);

      await docRef.set({
        'ids': FieldValue.arrayUnion([dislikeUserId]),
      }, SetOptions(merge: true));

      log("Successfully disliked user: $dislikeUserId");
    } catch (e) {
      log("Something issue while dislike action $e");
    }
  }

  Future<void> likeAction({
    required String likeUserId,
    required String likeUserName,
    required String currentUserId,
    required String currentUserName,
    required String image,
  }) async {
    try {
      //final currentUserId = AuthService().getCurrentUser()!.uid;
      final instance = FirebaseFirestore.instance;
      await instance.collection("like").doc(currentUserId).set({
        "likes": FieldValue.arrayUnion([
          {"isAccept": false, "likedId": likeUserId, "name": likeUserName},
        ]),
      }, SetOptions(merge: true));

      await instance.collection("user").doc(likeUserId).set({
        "requests": FieldValue.arrayUnion([
          {
            "sendername": currentUserName,
            "senderid": currentUserId,
            "image": image,
            "isAccept": false,
          },
        ]),
      }, SetOptions(merge: true));
    } catch (e) {
      log("Something issue while like Action $e");
      throw "$e";
    }
  }

  Future<List<dynamic>> getDislikeusers({required String currentUserId}) async {
    final reference = await FirebaseFirestore.instance
        .collection('dislike')
        .doc(currentUserId)
        .get();
    List<dynamic> dislikeIds = [];
    final data = reference.data();

    if (data != null) {
      dislikeIds.addAll(data["ids"]);
    }
    return dislikeIds;
  }

  Future<void> addToFavorites({required String favoriteUserId}) async {
    final currentUserId = AuthService().getCurrentUser()!.uid;
    final docRef = FirebaseFirestore.instance
        .collection("favorites")
        .doc(currentUserId);

    await docRef.set({
      'favs': FieldValue.arrayUnion([favoriteUserId]),
    }, SetOptions(merge: true));
  }

  Future<void> removeFromFavorites({required String favoriteUserId}) async {
    final currentUserId = AuthService().getCurrentUser()!.uid;
    final docRef = FirebaseFirestore.instance
        .collection("favorites")
        .doc(currentUserId);

    await docRef.update({
      'favs': FieldValue.arrayRemove([favoriteUserId]),
    });
  }
}
