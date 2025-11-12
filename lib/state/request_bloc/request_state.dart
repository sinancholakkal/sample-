part of 'request_bloc.dart';

sealed class RequestState extends Equatable {
  const RequestState();
  
  @override
  List<Object> get props => [];
}

final class RequestInitial extends RequestState {}
class FetchLoadingState extends RequestState{}
class FetchLoadedState extends RequestState{
  final List<RequestModel>requests;

  const FetchLoadedState({required this.requests});
}
class EmptyRequestState extends RequestState{
  final String message;

  const EmptyRequestState({required this.message});
  
}