part of 'user_actions_bloc.dart';

sealed class UserActionsState extends Equatable {
  const UserActionsState();
  
  @override
  List<Object> get props => [];
}

final class UserActionsInitial extends UserActionsState {}
class UserActionSuccessState extends UserActionsState{}
class SuperLikeSuccessState extends UserActionsState{}
class SwipeLimitReachedState extends UserActionsState {}