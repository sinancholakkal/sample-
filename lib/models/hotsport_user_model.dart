import 'package:cloud_firestore/cloud_firestore.dart';

class HotsportUserModel {
  final String uid;
  final String name;
  final String? bio;
  final List<String> imageUrls;
  final bool isProfileVerified;
  final bool hotspotMatchEnabled;
  final Map<String, dynamic>? lastKnownLocation;
  final String? currentHotspotId;
  final String? currentHotspotName; // Store name for convenience
  final Timestamp? hotspotCheckInTime;
  final List<Map<String, dynamic>> profilePhotos;

  HotsportUserModel({
    required this.uid,
    required this.name,
    this.bio,
    required this.imageUrls,
    this.isProfileVerified = false,
    this.hotspotMatchEnabled = true,
    this.lastKnownLocation,
    this.currentHotspotId,
    this.currentHotspotName,
    this.hotspotCheckInTime,
    required this.profilePhotos,
  });

  factory HotsportUserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; // Handle null data
    if (data == null) {
      // Return a dummy/error User if data is missing, or throw
      return HotsportUserModel(
        uid: doc.id,
        name: 'Unknown User',
        imageUrls: [],
        profilePhotos: [],
      );
    }
    return HotsportUserModel(
      uid: doc.id,
      name: data['name'] as String? ?? 'N/A',
      bio: data['bio'] as String?,
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      isProfileVerified: data['isProfileVerified'] as bool? ?? false,
      hotspotMatchEnabled: data['hotspotMatchEnabled'] as bool? ?? true,
      lastKnownLocation: data['lastKnownLocation'] as Map<String, dynamic>?,
      currentHotspotId: data['currentHotspotId'] as String?,
      currentHotspotName: data['currentHotspotName'] as String?,
      hotspotCheckInTime: data['hotspotCheckInTime'] as Timestamp?,
      profilePhotos: List<Map<String, dynamic>>.from(data['profilePhotos'] ?? []),
    );
  }

  // Factory to create from a Map (used when Cloud Function returns raw map data)
  factory HotsportUserModel.fromMap(Map<String, dynamic> data, String id) {
     return HotsportUserModel(
      uid: id,
      name: data['name'] as String? ?? 'N/A',
      bio: data['bio'] as String?,
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      isProfileVerified: data['isProfileVerified'] as bool? ?? false,
      hotspotMatchEnabled: data['hotspotMatchEnabled'] as bool? ?? true,
      lastKnownLocation: data['lastKnownLocation'] as Map<String, dynamic>?,
      currentHotspotId: data['currentHotspotId'] as String?,
      currentHotspotName: data['currentHotspotName'] as String?,
      hotspotCheckInTime: data['hotspotCheckInTime'] as Timestamp?,
      profilePhotos: List<Map<String, dynamic>>.from(data['profilePhotos'] ?? []),
    );
  }


  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'bio': bio,
      'imageUrls': imageUrls,
      'isProfileVerified': isProfileVerified,
      'hotspotMatchEnabled': hotspotMatchEnabled,
      'lastKnownLocation': lastKnownLocation,
      'currentHotspotId': currentHotspotId,
      'currentHotspotName': currentHotspotName,
      'hotspotCheckInTime': hotspotCheckInTime,
      'profilePhotos': profilePhotos,
    };
  }
}

// Define a simple Photo model for clarity and type safety
class Photo {
  final String url;
  final bool isPrivate;
  final String? id; // Optional ID if you use it

  Photo({required this.url, this.isPrivate = false, this.id});

  factory Photo.fromMap(Map<String, dynamic> data) {
    return Photo(
      url: data['url'] as String,
      isPrivate: data['isPrivate'] as bool? ?? false,
      id: data['id'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'isPrivate': isPrivate,
      'id': id,
    };
  }
}

class Photos {
  final String url;
  final bool isPrivate;
  final String? id; // Optional ID if you use it

  Photos({required this.url, this.isPrivate = false, this.id});

  factory Photos.fromMap(Map<String, dynamic> data) {
    return Photos(
      url: data['url'] as String,
      isPrivate: data['isPrivate'] as bool? ?? false,
      id: data['id'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'isPrivate': isPrivate,
      'id': id,
    };
  }
}