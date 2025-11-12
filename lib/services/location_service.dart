// import 'package:geolocator/geolocator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
// import 'package:cloud_functions/cloud_functions.dart';
// import 'dart:developer';

// class LocationService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFunctions _functions = FirebaseFunctions.instance;

//   // Request location permissions
//   Future<bool> _handleLocationPermission() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       log("Location services are disabled.");
//       // Consider showing a dialog to the user here.
//       return false;
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         log("Location permissions were denied.");
//         return false;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       log("Location permissions are permanently denied.");
//       // Consider showing a dialog explaining how to enable in settings.
//       return false;
//     }
//     return true;
//   }

//   // Get current position and call Cloud Function to update hotspot status
//   Future<void> updateCurrentUserLocationAndHotspotStatus() async {
//     final user = _auth.currentUser;
//     if (user == null) {
//       log("User not logged in.");
//       return;
//     }

//     final hasPermission = await _handleLocationPermission();
//     if (!hasPermission) {
//       log("Location permissions not granted.");
//       return;
//     }

//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//         timeLimit: const Duration(seconds: 10), // Add a timeout
//       );

//       // Call Cloud Function to update location and determine hotspot status
//       // The Cloud Function will handle writing to 'users' collection
//       final HttpsCallable callable = _functions.httpsCallable('updateUserHotspotStatus');
//       final result = await callable.call({
//         'latitude': position.latitude,
//         'longitude': position.longitude,
//       });

//       if (result.data['success']) {
//         log("Location and Hotspot status updated successfully: ${result.data['message']}");
//       } else {
//         log("Failed to update hotspot status: ${result.data['message']}");
//       }

//     } on FirebaseFunctionsException catch (e) {
//       log("Firebase Functions Error updating hotspot status: ${e.code} - ${e.message}");
//       // Handle specific function errors
//     } catch (e) {
//       log("Error updating location or hotspot status: $e");
//     }
//   }

//   // Dummy function for checking if two users are matched
//   // THIS NEEDS TO BE REPLACED WITH YOUR ACTUAL MATCH LOGIC
//   Future<bool> areUsersMatched(String userId1, String userId2) async {
//     // In a real app, you would query your 'matches' collection
//     // Example:
//     // final querySnapshot = await _firestore.collection('matches')
//     //     .where('participants', arrayContainsAny: [userId1, userId2]) // Or similar
//     //     .get();
//     // return querySnapshot.docs.any((doc) {
//     //   final participants = List<String>.from(doc['participants']);
//     //   return participants.contains(userId1) && participants.contains(userId2);
//     // });
//     await Future.delayed(const Duration(milliseconds: 100)); // Simulate network delay
//     return false; // For now, assume no one is matched to demonstrate blurring
//   }
// }
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/models/user_profile_model.dart';
import 'package:dating_app/services/user_profile_services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

// Initialize FirebaseFirestore
final FirebaseFirestore firestore = FirebaseFirestore.instance;

// --- Function to update or set a user's location ---
Future<void> updateUserLocation(String userId, Position position) async {
  // Create a GeoFirePoint by instantiating it with GeoPoint
  final GeoFirePoint geoFirePoint = GeoFirePoint(
    GeoPoint(position.latitude, position.longitude),
  );

  // The documentation shows saving the GeoFirePoint's 'data' map
  // into a sub-field like 'geo' within your document.
  // This 'geo' field will contain {'geopoint': GeoPoint(...), 'geohash': '...'}.
  await firestore.collection('user_locations').doc(userId).set({
    'userId': userId,
    'geo': geoFirePoint
        .data, // This is key: storing the geopoint and geohash within a 'geo' map
    'lastUpdate': FieldValue.serverTimestamp(),
    'isOnline': true,
  }, SetOptions(merge: true));
}

Future<bool> isUserMatched({
  required String currentUserId,
  required String otherUserId,
}) async {
  try {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(currentUserId)
        .get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null && data.containsKey('matches')) {
        final List<dynamic> matches = data['matches'] as List<dynamic>;
        return matches.contains(otherUserId);
      }
    }
    return false; // No matches field or document doesn't exist
  } catch (e) {
    print('Error checking if user is matched: $e');
    return false; // Assume not matched on error
  }
}

Future<bool> isUserLiked({
    required String currentUserId,
    required String otherUserId,
  }) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance.collection('like').doc(currentUserId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data.containsKey('likes')) {
          final List<dynamic> likes = data['likes'] as List<dynamic>;
          // Check if any map in the list contains 'likedId' equal to otherUserId
          return likes.any((likeMap) =>
              likeMap is Map<String, dynamic> && likeMap['likedId'] == otherUserId);
        }
      }
      return false;
    } catch (e) {
      print('Error checking if user is liked: $e');
      return false;
    }
  }

Stream<List<UserProfile>> getNearbyUsersWithProfiles(
  String currentUserId,
  Position centerPosition,
  double radiusInMeters,
) {
  final GeoPoint centerGeoPoint = GeoPoint(
    centerPosition.latitude,
    centerPosition.longitude,
  );
  final GeoFirePoint center = GeoFirePoint(centerGeoPoint);

  final double radiusInKm = radiusInMeters / 1000;
  const String geoDataField = 'geo';

  final CollectionReference<Map<String, dynamic>> collectionReference =
      firestore.collection('user_locations');

  GeoPoint geopointFrom(Map<String, dynamic> data) {
    final Map<String, dynamic> geoMap =
        data[geoDataField] as Map<String, dynamic>;
    return geoMap['geopoint'] as GeoPoint;
  }

  Query<Map<String, dynamic>> customQueryBuilder(
    Query<Map<String, dynamic>> query,
  ) => query
      .where('isOnline', isEqualTo: true)
      .where('userId', isNotEqualTo: currentUserId); // Exclude self

  final Stream<List<DocumentSnapshot<Map<String, dynamic>>>> stream =
      GeoCollectionReference<Map<String, dynamic>>(
        collectionReference,
      ).subscribeWithin(
        center: center,
        radiusInKm: radiusInKm,
        field: geoDataField,
        geopointFrom: geopointFrom,
        queryBuilder: customQueryBuilder,
      );

  return stream.asyncMap((
    List<DocumentSnapshot<Map<String, dynamic>>> documents,
  ) async {
    final List<UserProfile> userProfiles = [];
    for (final doc in documents) {
      if (!doc.exists || doc.data() == null) continue;

      final data = doc.data()!;
      final String otherUserId = data['userId'] as String;

      if (!data.containsKey(geoDataField) ||
          !(data[geoDataField] is Map<String, dynamic>))
        continue;
      final Map<String, dynamic> geoMap =
          data[geoDataField] as Map<String, dynamic>;
      if (!geoMap.containsKey('geopoint') || !(geoMap['geopoint'] is GeoPoint))
        continue;

      final GeoPoint docGeoPoint = geoMap['geopoint'] as GeoPoint;

      final double distance = Geolocator.distanceBetween(
        centerPosition.latitude,
        centerPosition.longitude,
        docGeoPoint.latitude,
        docGeoPoint.longitude,
      );

      if (distance <= radiusInMeters) {
        try {
          bool isMatch = await isUserMatched(
            otherUserId: otherUserId,
            currentUserId: currentUserId,
          );
          bool isUserLike = await isUserLiked(currentUserId: currentUserId,otherUserId: otherUserId);
          log(isMatch.toString());
          log(isUserLike.toString());
          log("==================");
          if (!isMatch ) {
            if(!isUserLike){
            final UserProfile? profile = await UserProfileServices()
                .fetchUserProfile(userId: otherUserId);

            // Manually create a new UserProfile object with the added location and distance data
            userProfiles.add(
              UserProfile(
                id: profile!.id,
                name: profile.name,
                bio: profile.bio,
                getImages: profile.getImages,
                currentGeoPoint: docGeoPoint,
                distanceInMeters: distance,
                age: profile.age,
                gender: profile.gender,
                interests: profile.interests,
              ),
            );
            }
          }
          // Fetch full user profile
        } catch (e) {
          print('Error fetching profile for $otherUserId: $e');
          // Optionally, add a partial profile or skip this user
        }
      }
    }
    return userProfiles;
  });
}

// --- Function to set user's status to offline ---
Future<void> setOffline(String userId) async {
  await firestore.collection('user_locations').doc(userId).update({
    'isOnline': false,
    'lastUpdate': FieldValue.serverTimestamp(),
  });
}
