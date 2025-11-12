part of 'home_user_bloc.dart';

sealed class HomeUserState extends Equatable {
  const HomeUserState();
  
  @override
  List<Object> get props => [];
}

final class HomeUserInitial extends HomeUserState {}
class FetchAllUsersLoadingState extends HomeUserState{}

class FetchAllUsersLoadedState extends HomeUserState{
  final List<UserProfile>userProfiles;

  const FetchAllUsersLoadedState({required this.userProfiles});
  
}
class ErrorState extends HomeUserState{
  final String msg;

  const ErrorState({required this.msg});
  
}

