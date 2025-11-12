// import 'dart:io';
// import 'package:equatable/equatable.dart';
// import 'package:image_picker/image_picker.dart';

// class UserCurrentModel extends Equatable {
//   final String bio;
//   final String userId;
//   final List<dynamic> images;

//   const UserCurrentModel({
//     required this.bio,
//     required this.images,
//     required this.userId
//   });

//   // Strict comparison: type + value
//   bool _areListsEqual(List<dynamic> other) {
//     if (images.length != other.length) return false;

//     for (int i = 0; i < images.length; i++) {
//       final a = images[i];
//       final b = other[i];

//       // Compare types first
//       if (a.runtimeType != b.runtimeType) return false;

//       // Compare values
//       if (a is String && b is String && a != b) return false;
//       if (a is XFile && b is XFile && a.path != b.path) return false;
//       if (a is File && b is File && a.path != b.path) return false;

//       // fallback for other types
//       if (a.runtimeType != String && a.runtimeType != XFile && a.runtimeType != File) {
//         if (a != b) return false;
//       }
//     }

//     return true;
//   }

//   @override
//   List<Object?> get props => [
//         bio,
//         images, // only used for equatable; override == for custom comparison
//       ];

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     return other is UserCurrentModel &&
//         other.bio == bio &&
//         _areListsEqual(other.images);
//   }

//   @override
//   int get hashCode => bio.hashCode ^ images.hashCode;
// }
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class UserCurrentModel extends Equatable {
  final String bio;
  final String userId;
  final List<dynamic> images;
  final Set<String> interests; // 1. New property added

  const UserCurrentModel({
    required this.bio,
    required this.images,
    required this.userId,
    required this.interests, // 2. Added to the constructor
  });

  // Strict comparison for lists remains the same
  bool _areListsEqual(List<dynamic> other) {
    if (images.length != other.length) return false;
    for (int i = 0; i < images.length; i++) {
      final a = images[i];
      final b = other[i];
      if (a.runtimeType != b.runtimeType) return false;
      if (a is String && b is String && a != b) return false;
      if (a is XFile && b is XFile && a.path != b.path) return false;
      if (a is File && b is File && a.path != b.path) return false;
      if (a.runtimeType != String && a.runtimeType != XFile && a.runtimeType != File) {
        if (a != b) return false;
      }
    }
    return true;
  }

  // Helper to compare sets
  bool _areSetsEqual(Set<String> other) {
    if (interests.length != other.length) return false;
    return interests.containsAll(other);
  }

  @override
  List<Object?> get props => [
        bio,
        images,
        interests, // 3. Added to props for Equatable
      ];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserCurrentModel &&
        other.bio == bio &&
        _areListsEqual(other.images) &&
        _areSetsEqual(other.interests); // 4. Added to the custom equality check
  }

  @override
  int get hashCode =>
      bio.hashCode ^
      images.hashCode ^
      interests.hashCode; // 5. Added to the hashCode calculation
}