part of 'ad_bloc.dart';

sealed class AdState extends Equatable {
  const AdState();
  
  @override
  List<Object> get props => [];
}

final class AdInitial extends AdState {}
class SwipResetLoadingState extends AdState{}
class SwipResetedState extends AdState{}