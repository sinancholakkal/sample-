part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

class GetProfileLoadingState extends UserState{}
class AddProfileLoadingState extends UserState{}
class UpdateProfileLoadingState extends UserState{}
class UpdatedProfileState extends UserState{}
class ProfileSuccessState extends UserState{}

class ErrorState extends UserState{
  final String msg;

  ErrorState({required this.msg});
}
class GetSuccessState extends UserState{
  final UserProfile userProfile;

  GetSuccessState({required this.userProfile});
}