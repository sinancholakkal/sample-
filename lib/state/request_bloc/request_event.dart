part of 'request_bloc.dart';

sealed class RequestEvent extends Equatable {
  const RequestEvent();

  @override
  List<Object> get props => [];
}

class FetchRequestsEvent extends RequestEvent{}

class DeclineRequestEvent extends RequestEvent {
  final RequestModel request; 

  const DeclineRequestEvent({required this.request});
}

class AcceptRequestEvent extends RequestEvent{
  final RequestModel request; 

  const AcceptRequestEvent({required this.request});
}