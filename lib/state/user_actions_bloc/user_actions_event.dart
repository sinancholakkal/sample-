part of 'user_actions_bloc.dart';

sealed class UserActionsEvent extends Equatable {
  const UserActionsEvent();

  @override
  List<Object> get props => [];
}

class UserDislikeActionEvent extends UserActionsEvent{
  final String dislikeUserId;

  const UserDislikeActionEvent({required this.dislikeUserId});

}
class UserLikeActionEvent extends UserActionsEvent{
  final String likeUserId;
  final String likeUserName;
  final String currentUserId;
  final String currentUserName;
final String image;
  const UserLikeActionEvent({required this.likeUserId, required this.likeUserName,required this.currentUserId, required this.currentUserName,required this.image});

}

class SuperLikeEvent extends UserActionsEvent{
   final String likeUserId;
  final String likeUserName;
  final String currentUserId;
  final String currentUserName;
final String image;

  const SuperLikeEvent({required this.currentUserId,required this.currentUserName,required this.image,required this.likeUserId,required this.likeUserName});
  
}

class SwipeLimitWarningAcknowledgedEvent extends UserActionsEvent {}

class SwipeLimitWarningShownEvent extends UserActionsEvent {}