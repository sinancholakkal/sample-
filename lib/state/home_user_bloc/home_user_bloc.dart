import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/models/user_profile_model.dart';
import 'package:dating_app/services/home_user_service.dart';
import 'package:dating_app/services/swip_service.dart';
import 'package:equatable/equatable.dart';

part 'home_user_event.dart';
part 'home_user_state.dart';

class HomeUserBloc extends Bloc<HomeUserEvent, HomeUserState> {
  final service = HomeUserService();
  
  HomeUserBloc() : super(HomeUserInitial()) {
    on<FetchHomeAllUsers>((event, emit)async {
      try{
        emit(FetchAllUsersLoadingState());
        final models = await service.fetchAllUsers();
        models.shuffle();
        emit(FetchAllUsersLoadedState(userProfiles: models));
      }catch(e){
        log(e.toString());
        emit(ErrorState(msg: "Something issue, Please try again later"));
      }
    });
    
  }
}
