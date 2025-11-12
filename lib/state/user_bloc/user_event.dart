part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class AddUserProfileSetupEvent extends UserEvent{
  final UserProfile userProfile;

  AddUserProfileSetupEvent({required this.userProfile});
  
} 

class GetUserProfileEvent extends UserEvent{}

class UpdateUserPrfileEvent extends UserEvent{
  final UserCurrentModel userCurrentModel;
  final List<String>deleteImages;

  UpdateUserPrfileEvent({required this.userCurrentModel, required this.deleteImages});
  
}