import 'package:dating_app/state/profile_setup_bloc/profile_setup_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceActionSheet {
  static void show(
    BuildContext context, {
    required ProfileSetupBloc bloc,
  }) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              bloc.add(ImagePickEvent(source: ImageSource.camera));
            },
            child: const Text('Camera'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              bloc.add(ImagePickEvent(source: ImageSource.gallery));
            },
            child: const Text('Photo Gallery'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}