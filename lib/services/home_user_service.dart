import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/models/user_profile_model.dart';
import 'package:dating_app/services/auth_services.dart';
import 'package:dating_app/services/user_actions_services.dart';
import 'package:dating_app/services/user_profile_services.dart';

class HomeUserService {
  Future<List<UserProfile>> fetchAllUsers() async {
    List<UserProfile> userModels = [];
    List<String> dislikeIds = [];
    String? id;
    try {
      final doc = await FirebaseFirestore.instance.collection("user").get();
      final currentUser = AuthService().getCurrentUser()!.uid;
      log("going to fetch dislike id's");
      final disIds = await UserActionsServices().getDislikeusers(
        currentUserId: currentUser,
      );
      for (var d in disIds) {
        if (d is String) {
          dislikeIds.add(d);
        }
      }
      final currentUserModel = await UserProfileServices().fetchUserProfile();
      final currentInteres = currentUserModel!.interests;
      //dislikeIds.addAll(await UserActionsServices().getDislikeusers(currentUserId: currentUser));
      // log("success");
      // log("Dislike id's:= $dislikeIds");
      final userDocs = doc.docs;
      for (var user in userDocs) {
        // log(user.id);
        final data = user.data();
        //  log(data['interests'].toString());
        final List<dynamic> rawUserInterestsList =
            data['interests'] as List<dynamic>? ?? [];

        // Then convert to a Set
        Set<String> userInterests = Set<String>.from(
          rawUserInterestsList.map((e) => e.toString()),
        );

        // No need for userInterests??={} anymore because it's already guaranteed not null

        bool hasCommon = userInterests.any(
          (item) => currentInteres.contains(item),
        );
        log("has common $hasCommon");

        if (hasCommon) {
          if (currentUser != user.id &&
              !dislikeIds.contains(user.id) &&
              user.data()["id"] != null) {
            log(data['name']);
            final userProfile = UserProfile(
              id: data['id'] ?? "",
              name: data['name'] ?? "",
              age: data['age'],
              gender: data['gender'] ?? "",
              bio: data['bio'],
              interests: Set<String>.from(data['interests'] ?? []),
              getImages: List<String>.from(data['images'] ?? []),
            );
            id = userProfile.id;
            log(userProfile.interests.toString());
            userModels.add(userProfile);
          }
        }
      }
      log(userModels.length.toString());
      return userModels;
    } catch (e) {
      log("Something issue while fetching all users data $e");
      log(id.toString());
      throw "$e";
    }
  }
}
