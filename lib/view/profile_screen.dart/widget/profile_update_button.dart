import 'dart:developer';

import 'package:dating_app/models/user_current_model.dart';
import 'package:dating_app/state/user_bloc/user_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileUpdateButton extends StatelessWidget {
  const ProfileUpdateButton({
    super.key,
    required TextEditingController bioController,
    required this.getImages,
    required this.getUserModel,
    required this.deleteImages,
    required this.interests,
  }) : _bioController = bioController;

  final TextEditingController _bioController;
  final List getImages;
  final UserCurrentModel getUserModel;
  final List<String> deleteImages;
  final Set<String> interests;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final newModel = UserCurrentModel(
          bio: _bioController.text.trim(),
          images: getImages,
          userId: getUserModel.userId,
          interests: interests,
        );
        log(getUserModel.interests.toString());
        log(newModel.interests.toString());
        log("${getUserModel == newModel}");
        if (getUserModel == newModel) {
          flutterToast(msg: "No updates");
        } else if (getImages.length < 2) {
          flutterToast(msg: "Please select minimum two images");
        } else if (interests.length < 2) {
          flutterToast(msg: "Please select minimum two your interest");
        } else {
          //Call update event
          context.read<UserBloc>().add(
            UpdateUserPrfileEvent(
              userCurrentModel: newModel,
              deleteImages: deleteImages,
            ),
          );
        }
      },
      backgroundColor: primary, // Use your theme color
      child: Icon(Icons.check, color: kWhite),
    );
  }
}
