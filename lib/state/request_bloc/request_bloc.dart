import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/models/request_model.dart';
import 'package:dating_app/services/auth_services.dart';
import 'package:dating_app/services/request_services.dart';
import 'package:equatable/equatable.dart';

part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final service = RequestServices();
  RequestBloc() : super(RequestInitial()) {
    on<FetchRequestsEvent>((event, emit) async {
      emit(FetchLoadingState());
      try {
        final datas = await service.fetchRequests();
        if (datas.isEmpty) {
          emit(EmptyRequestState(message: "No new requests yet."));
        } else {
          emit(FetchLoadedState(requests: datas));
        }
      } catch (e) {
        log(e.toString());
      }
    });

    on<DeclineRequestEvent>((event, emit)async {
      if (state is FetchLoadedState) {
        log("state is FetchLoadedState");
        final currentState = state as FetchLoadedState;

        final List<RequestModel> updatedRequests = List.from(
          currentState.requests,
        )..removeWhere((req) => req.senderId == event.request.senderId);
         if (updatedRequests.isEmpty) {
          emit(EmptyRequestState(message: "No new requests yet."));
        } else {
          emit(FetchLoadedState(requests: updatedRequests));
        }
          await service.declineRequest(requestModel: event.request);
          log("decline from user");
          await service.removeFromLikeCollection(documentId: event.request.senderId, likedUserIdToRemove: AuthService().getCurrentUser()!.uid);
          log("Decline from like");
       
      }
    });

    on<AcceptRequestEvent>((event, emit)async {
      if (state is FetchLoadedState) {
        log("state is FetchLoadedState");
        final currentState = state as FetchLoadedState;

        final List<RequestModel> updatedRequests = List.from(
          currentState.requests,
        )..removeWhere((req) => req.senderId == event.request.senderId);
         if (updatedRequests.isEmpty) {
          emit(EmptyRequestState(message: "No new requests yet."));
        } else {
          emit(FetchLoadedState(requests: updatedRequests));
        }
        log("Chat room created fuction called");
           await service.acceptChatRequest(event.request.senderId);
           log("chat room created");
          // await service.removeFromLikeCollection(documentId: event.request.senderId, likedUserIdToRemove: AuthService().getCurrentUser()!.uid);
          // log("Decline from like");
       
      }
    });
  }
}
