part of 'profile_setup_bloc.dart';

abstract class ProfileSetupEvent {}

class ContinueTappedEvent extends ProfileSetupEvent {
  final int currentPage;
  final PageController pageController;
  ContinueTappedEvent( {required this.pageController,required this.currentPage});
}

class GoBackTappedEvent extends ProfileSetupEvent {
  final PageController pageController;
    final int currentPage;
  GoBackTappedEvent( {required this.currentPage,required this.pageController});
}
class StartProfileSetupEvent extends ProfileSetupEvent{}
class StartProfileSetup extends ProfileSetupEvent {}
class SelfieImageUploadEvent extends ProfileSetupEvent{
  final ImageSource source;

  SelfieImageUploadEvent({required this.source});
}

class ImagePickEvent extends ProfileSetupEvent{
  final ImageSource source;

  ImagePickEvent({required this.source});
}
class ImageRemoveEvent extends ProfileSetupEvent{
  final int index;

  ImageRemoveEvent({required this.index});
}
class ClearImageEvent extends ProfileSetupEvent{}