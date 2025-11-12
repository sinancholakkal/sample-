part of 'profile_setup_bloc.dart';

@immutable
sealed class ProfileSetupState {}

final class ProfileSetupInitial extends ProfileSetupState {}

class ProfileSetUpNextPage extends ProfileSetupState{
  final int currentPage;

  ProfileSetUpNextPage({required this.currentPage});
  
}

final class ProfileSetupSuccess extends ProfileSetupState {}

final class ProfileSetupFailure extends ProfileSetupState {
  final String error;
  ProfileSetupFailure({required this.error});
}
class SelfieImageUploadedState extends ProfileSetupState{
  final XFile pickedFile;

  SelfieImageUploadedState({required this.pickedFile});
  
}
class ImageUploadedState extends ProfileSetupState{
  final XFile pickedFile;

  ImageUploadedState({required this.pickedFile});
}

class ImageRemovedState extends ProfileSetupState{
   //List<dynamic>images;
  final int index;
  ImageRemovedState({required this.index});

}

class ChatImageUploadState extends ProfileSetupState{
  final XFile pickedFile;

  ChatImageUploadState({required this.pickedFile});
  
}

class ClearedImageState extends ProfileSetupState{}