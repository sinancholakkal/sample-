import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class UserProfile extends Equatable{
  final String id;
  final String name;
  final String age;            
  final String gender;       
  final String bio;          
   List<XFile>? imageUrls;
   XFile? selfieImageUrl; 
  final Set<String> interests;
  List<String>?getImages;
  String?getSelfie;
  final GeoPoint? currentGeoPoint;
    final double? distanceInMeters; 

   UserProfile({
    required this.id,
    required this.name,           
    required this.age,           
    required this.gender,      
    required this.bio,            
     this.imageUrls,      
     this.selfieImageUrl, 
    required this.interests,     
    this.getImages,
    this.getSelfie, 
    this.currentGeoPoint,
    this.distanceInMeters
  });
    @override
  List<Object?> get props => [
        id,
        name,
        age,
        gender,
        bio,
        imageUrls,
        selfieImageUrl,
        interests,
      ];
}