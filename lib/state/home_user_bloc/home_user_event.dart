part of 'home_user_bloc.dart';

sealed class HomeUserEvent extends Equatable {
  const HomeUserEvent();

  @override
  List<Object> get props => [];
}

class FetchHomeAllUsers extends HomeUserEvent{}