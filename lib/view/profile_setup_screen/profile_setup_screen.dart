import 'dart:developer';

import 'package:dating_app/models/user_profile_model.dart';
import 'package:dating_app/services/auth_services.dart';
import 'package:dating_app/state/profile_setup_bloc/profile_setup_bloc.dart';
import 'package:dating_app/state/user_bloc/user_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/utils/app_color.dart' as AppColors;
import 'package:dating_app/utils/app_string.dart';
import 'package:dating_app/view/profile_setup_screen/widget/details_setup.dart';
import 'package:dating_app/view/profile_setup_screen/widget/interested_setup.dart';
import 'package:dating_app/view/profile_setup_screen/widget/photos_setp.dart';
import 'package:dating_app/view/profile_setup_screen/widget/verification_step.dart';
import 'package:dating_app/view/widgets/app_genderchip.dart';
import 'package:dating_app/view/widgets/app_text_field.dart';
import 'package:dating_app/view/widgets/loading.dart';
import 'package:dating_app/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  late final PageController _pageController;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  //Gender _selectedGender = Gender.none;
  ValueNotifier<Gender> selectedGender = ValueNotifier(Gender.none);
  int _currentPage = 0;
  Set<String> interest = {};
  List<XFile> images = [];
  XFile? selfieImage;
  String? bio;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if(state is AddProfileLoadingState){
          loadingWidget(context);
        }else if(state is ProfileSuccessState){
          log("user profile set up success");
          if(Navigator.canPop(context)){
            Navigator.of(context).pop();
              log("Loading poped");
          }else{
              log("Can't pop");
          }
           log("user profile set up success");
           flutterToast(msg: AppStrings.userSetup);
          
          log("Loading poped");
        flutterToast(msg: AppStrings.userSetup);
        context.go("/easytab");
        }else if(state is ErrorState){
          context.pop();
        flutterToast(msg: state.msg);
        }
      },
      child: Container(
        decoration: const BoxDecoration(gradient: appGradient),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: kWhite),

            title: BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
              builder: (context, state) {
                if (state is ProfileSetUpNextPage) {
                  _currentPage = state.currentPage;
                }
                return LinearProgressIndicator(
                  value: (_currentPage + 1) / 4,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                );
              },
            ),
          ),
          body: BlocListener<ProfileSetupBloc, ProfileSetupState>(
            listener: (context, state) {
              if (state is ImageUploadedState) {
                images.add(state.pickedFile);
              } else if (state is SelfieImageUploadedState) {
                selfieImage = state.pickedFile;
              }
            },
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ValueListenableBuilder(
                  valueListenable: selectedGender,
                  builder: (context, genderNoti, child) {
                    //Detailse setup widget session----
                    return DetailsStep(
                      onContinue: () {
                        log(_nameController.text);
                        if (_nameController.text.isNotEmpty &&
                            _ageController.text.isNotEmpty &&
                            selectedGender.value != Gender.none) {
                          context.read<ProfileSetupBloc>().add(
                            ContinueTappedEvent(
                              pageController: _pageController,
                              currentPage: _currentPage,
                            ),
                          );
                        } else {
                          flutterToast(msg: "Please fill the form");
                        }
                      },
                      nameController: _nameController,
                      ageController: _ageController,
                      selectedGender: genderNoti,
                      onGenderSelected: (gender) {
                        selectedGender.value = gender;
                      },
                    );
                  },
                ),
                //Photo upload session------------------
                PhotosStep(
                  onContinue: () {
                    if (images.length < 2) {
                      flutterToast(msg: "Upload at least 2 photos");
                    } else {
                      context.read<ProfileSetupBloc>().add(
                        ContinueTappedEvent(
                          pageController: _pageController,
                          currentPage: _currentPage,
                        ),
                      );
                    }
                  },
                ),
                //Person interest-----------
                InterestsStep(
                  onContinue: (bio, interests) {
                    if (bio.isEmpty && interests.isEmpty) {
                      flutterToast(
                        msg: "Plase fill bio and select your interests",
                      );
                    } else if (bio.isEmpty) {
                      flutterToast(msg: "Please fill the bio");
                    } else if (interests.isEmpty) {
                      flutterToast(msg: "Please select your interests");
                    } else {
                      this.bio = bio;
                      interest = interests;
                      context.read<ProfileSetupBloc>().add(
                        ContinueTappedEvent(
                          pageController: _pageController,
                          currentPage: _currentPage,
                        ),
                      );
                    }

                    log(bio.toString());
                    log(interests.toString());
                  },
                  bioController: TextEditingController(),
                  initialInterests: interest,
                ),

                //Verification(Selfie image upload)-------
                VerificationStep(
                  onContinue: (selfie) {
                    log("Finish button pressed");
                    if (selfieImage == null) {
                      flutterToast(msg: "Please upload your selfie");
                    } else {
                      //context.push("/home");
                      log(_nameController.text);
                      log(_ageController.text);
                      log(selectedGender.value.toString());
                      log(images.toString());
                      log(bio.toString());
                      log(selfie.toString());
                      log(interest.toString());
                      final UserProfile model = UserProfile(
                        id: AuthService().getCurrentUser()!.uid,
                        name: _nameController.text.trim(),
                        age: _ageController.text.trim().toString(),
                        gender: selectedGender.value.toString().split(".")[1],
                        bio: bio!,
                        imageUrls: images,
                        selfieImageUrl: selfieImage!,
                        interests: interest,
                      );
                      log("user setup event called");
                      context.read<UserBloc>().add(
                        AddUserProfileSetupEvent(userProfile: model),
                      );
                      //log(message)
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum Gender { none, woman, man }
