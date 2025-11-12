part of 'favorite_bloc.dart';

sealed class FavoriteState extends Equatable {
  const FavoriteState();
  
  @override
  List<Object> get props => [];
}

final class FavoriteInitial extends FavoriteState {}
class LocalRemoveSucessState extends FavoriteState{
  final List<UserProfile>userProfiles;

  const LocalRemoveSucessState({required this.userProfiles});
}
class FavoriteLoadedState extends FavoriteState{
  final List<UserProfile>favorites;

  const FavoriteLoadedState({required this.favorites});
  
}
class FavoriteLoadingState extends FavoriteState{}
