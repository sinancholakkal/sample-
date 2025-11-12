import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/models/user_profile_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///
  /// Returns an empty list if the user has no favorites or no document exists.
  Future<List<String>> getFavoritesId() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // Return empty list if no user is logged in
      return [];
    }
    
    try {
      // 1. Get the specific document for the current user.
      final docSnapshot = await _firestore.collection('favorites').doc(currentUser.uid).get();

      // 2. Check if the document exists and has data.
      if (docSnapshot.exists && docSnapshot.data() != null) {
        final data = docSnapshot.data()!;
        // 3. Safely access the 'favs' field and convert it to a List<String>.
        return List<String>.from(data['favs'] ?? []);
      } else {
        // If no document exists, the user has no favorites.
        return [];
      }
    } catch (e) {
      log("Error fetching favorites: $e");
      return []; // Return an empty list on error
    }
  }
  Future<List<UserProfile>> fetchUsersByIds(List<String> userIds) async {
  if (userIds.isEmpty) {
    return [];
  }

  try {
    log("Fetching profiles for ${userIds.length} users.");
    
    final querySnapshot = await FirebaseFirestore.instance
        .collection("user")
        .where(FieldPath.documentId, whereIn: userIds)
        .get();

    // Convert the documents to UserProfile objects manually
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      
      // Manually create the UserProfile object by mapping each field
      return UserProfile(
        
        id: data['id'] ?? '',
        name: data['name'] ?? '',
        age: data['age'],
        gender: data['gender'] ?? '', // Add null checks for safety
        bio: data['bio'],
        getImages: List<String>.from(data['images'] ?? []),
        getSelfie: data['selfie'],
        interests: Set<String>.from(data['interests'] ?? []),
      );
    }).toList();

  } catch (e) {
    log("Error fetching users by IDs: $e");
    rethrow;
  }
}
}