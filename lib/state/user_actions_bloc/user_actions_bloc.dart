import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/services/swip_service.dart';
import 'package:dating_app/services/user_actions_services.dart';
import 'package:equatable/equatable.dart';

part 'user_actions_event.dart';
part 'user_actions_state.dart';

class UserActionsBloc extends Bloc<UserActionsEvent, UserActionsState> {
  final service = UserActionsServices();
  UserActionsBloc() : super(UserActionsInitial()) {
    on<UserDislikeActionEvent>((event, emit) async {
      final bool canSwipe = await SwipeService().canSwipe();
      if (canSwipe) {
        await service.dislikeAction(dislikeUserId: event.dislikeUserId);
        emit(UserActionSuccessState());
        log("User dislike success");
      } else {
        log("BLoC: Swipe limit reached.");
        emit(SwipeLimitReachedState());
      }
    });

    on<UserLikeActionEvent>((event, emit) async {
      final bool canSwipe = await SwipeService().canSwipe();
      log("can swap $canSwipe");
      if (canSwipe) {
        await service.likeAction(
          image: event.image,
          currentUserId: event.currentUserId,
          currentUserName: event.currentUserName,
          likeUserId: event.likeUserId,
          likeUserName: event.likeUserName,
        );
        emit(UserActionSuccessState());
        log("User like  success");
      } else {
        log("BLoC: Swipe limit reached.");
        emit(SwipeLimitReachedState());
      }
    });
    on<SuperLikeEvent>((event, emit) async {
      // await service.likeAction(image: event.image, currentUserId: event.currentUserId,currentUserName: event.currentUserName,likeUserId: event.likeUserId,likeUserName: event.likeUserName);
      // emit(UserActionSuccessState());
      try {
        final bool canSwipe = await SwipeService().canSwipe();
        if (canSwipe) {
          await service.addToFavorites(favoriteUserId: event.likeUserId);
          log("Added into favorite");
          log("Added into like and request");
          log("Super User like  success");
        } else {
          log("BLoC: Swipe limit reached.");
          emit(SwipeLimitReachedState());
        }

        // await service.likeAction(
        //   image: event.image,
        //   currentUserId: event.currentUserId,
        //   currentUserName: event.currentUserName,
        //   likeUserId: event.likeUserId,
        //   likeUserName: event.likeUserName,
        // );
      } catch (e) {
        log("something issue while add to fav $e");
      }
    });

    on<SwipeLimitWarningAcknowledgedEvent>((event, emit) {
      // Reset the state to allow the listener to fire again in the future
      emit(
        UserActionSuccessState(),
      ); // Or whatever your default/neutral state is
    });

    on<SwipeLimitWarningShownEvent>((event, emit) {
      // Get the current list of profiles from the last loaded state
      // final profiles = (state as UserActionSuccessState);
      // Re-emit the HomeLoaded state to reset the UI
      emit(UserActionSuccessState());
    });
  }
}
