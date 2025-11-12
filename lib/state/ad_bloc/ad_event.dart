part of 'ad_bloc.dart';

sealed class AdEvent extends Equatable {
  const AdEvent();

  @override
  List<Object> get props => [];
}

class AdCompletedAndSwipResetEvent extends AdEvent{}