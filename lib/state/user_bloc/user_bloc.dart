import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/models/user_current_model.dart';
import 'package:dating_app/models/user_profile_model.dart';
import 'package:dating_app/services/user_profile_services.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final userService = UserProfileServices();
  UserBloc() : super(UserInitial()) {
    on<AddUserProfileSetupEvent>((event, emit)async {
      try{
        emit(AddProfileLoadingState());
        await userService.userProfileStoring(userProfile: event.userProfile);
        emit(ProfileSuccessState());
      }catch(e){
        log("something issue while add data $e");
        emit(ErrorState(msg: "Your profile setup has failed!"));
      }
    });


    on<GetUserProfileEvent>((event, emit)async {
      try{
        emit(GetProfileLoadingState());
        final userProfile = await userService.fetchUserProfile();
        if(userProfile!=null){
          emit(GetSuccessState(userProfile: userProfile));
        }else{
          emit(ErrorState(msg: "Something wrong"));
        }
        
      }catch(e){
        log("something issue while fetch data $e");
        emit(ErrorState(msg: "Your profile fetch has failed!"));
      }
    });

    //Update event---------
     on<UpdateUserPrfileEvent>((event, emit)async {
      try{
        emit(UpdateProfileLoadingState());
         await userService.updateUserProfile(deleteImages: event.deleteImages,userModel: event.userCurrentModel);
        
        emit(UpdatedProfileState());
        
      }catch(e){
        log("something issue while update data $e");
        emit(ErrorState(msg: "Your profile update has failed!"));
      }
    });
  }
}
