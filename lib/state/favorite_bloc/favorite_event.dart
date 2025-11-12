part of 'favorite_bloc.dart';

sealed class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}
class FavoriteActionEvent extends FavoriteEvent{
  final UserProfile user;

  const FavoriteActionEvent({required this.user});
}
class FetchAllFavoritesEvent extends FavoriteEvent{}