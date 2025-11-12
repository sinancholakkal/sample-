import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'profile_setup_event.dart';
part 'profile_setup_state.dart';

class ProfileSetupBloc extends Bloc<ProfileSetupEvent, ProfileSetupState> {
  int currentPage = 0;
  ProfileSetupBloc() : super(ProfileSetupInitial()) {
    on<StartProfileSetup>((event, emit) {
      // emit( ProfileSetupInProgress());
    });

    on<ContinueTappedEvent>((event, emit) {
      if (event.currentPage < 3) {
        currentPage = event.currentPage + 1;
        event.pageController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        emit(ProfileSetUpNextPage(currentPage: currentPage));
      }
    });

    on<GoBackTappedEvent>((event, emit) {
      if (currentPage > 0) {
        currentPage = event.currentPage - 1;
        event.pageController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        emit(ProfileSetUpNextPage(currentPage: currentPage));
      }
    });

    on<SelfieImageUploadEvent>((event, emit) async {
      final ImagePicker _picker = ImagePicker();
      final XFile? pickedFile = await _picker.pickImage(
        source: event.source,
        imageQuality: 80, 
      );

      if (pickedFile != null) {
        if(event.source==ImageSource.camera){
          emit(SelfieImageUploadedState(pickedFile: pickedFile));
        }else{
          emit(ImageUploadedState(pickedFile: pickedFile));
        }
      }
    });
     on<ImagePickEvent>((event, emit) async {
      final ImagePicker _picker = ImagePicker();
      final XFile? pickedFile = await _picker.pickImage(
        source: event.source,
        imageQuality: 80, 
      );

      if (pickedFile != null) {
        emit(ChatImageUploadState(pickedFile: pickedFile));
      }
    });

    on<ImageRemoveEvent>((event, emit) {
      emit(ImageRemovedState(index: event.index));
    });

    on<ClearImageEvent>((event, emit) {
      emit(ClearedImageState());
    });
  }
}
