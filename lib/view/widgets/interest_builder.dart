import 'package:dating_app/view/profile_setup_screen/widget/interested_setup.dart';
import 'package:flutter/material.dart';


class InterestBuilderWidget extends StatelessWidget {
  Set<String>userInterests;
   InterestBuilderWidget({super.key,required this.userInterests});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: userInterests.map((interest) {
        return InterestChip(
          label: interest,
          isSelected: true,
          onSelected: (selected) {},
        );
      }).toList(),
    );
  }
}