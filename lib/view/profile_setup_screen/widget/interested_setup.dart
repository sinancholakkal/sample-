import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/utils/app_string.dart';
import 'package:dating_app/view/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InterestsStep extends StatefulWidget {
  final Function(String bio, Set<String> interests) onContinue;
  final TextEditingController bioController;
  final Set<String> initialInterests;

  const InterestsStep({
    super.key,
    required this.onContinue,
    required this.bioController,
    required this.initialInterests,
  });

  @override
  State<InterestsStep> createState() => _InterestsStepState();
}

class _InterestsStepState extends State<InterestsStep> {
  late final ValueNotifier<Set<String>> _selectedInterestsNotifier;

 

  @override
  void initState() {
    super.initState();
    _selectedInterestsNotifier = ValueNotifier(Set.from(widget.initialInterests));
  }

  @override
  void dispose() {
    _selectedInterestsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Tell us about you",
            style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: kWhite),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Text(
            "Your Bio",
            style: GoogleFonts.poppins(color: kWhite.withOpacity(0.7), fontSize: 16),
          ),
          const SizedBox(height: 8),
          AppTextField(
            controller: widget.bioController,
            hintText: "Write something about yourself...",
            maxLines: 3,
          ),
          const SizedBox(height: 32),
          Text(
            "Your Interests",
            style: GoogleFonts.poppins(color: kWhite.withOpacity(0.7), fontSize: 16),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: ValueListenableBuilder<Set<String>>(
                valueListenable: _selectedInterestsNotifier,
                builder: (context, currentSelectedInterests, child) {
                  return Wrap(
                    spacing: 12.0,
                    runSpacing: 12.0,
                    children: AppStrings.allInterests.map((interest) {
                      final bool isSelected = currentSelectedInterests.contains(interest);
                      return InterestChip(
                        label: interest,
                        isSelected: isSelected,
                        onSelected: (selected) {
                          final newSet = Set<String>.from(currentSelectedInterests);
                          if (isSelected) {
                            newSet.remove(interest);
                          } else {
                            newSet.add(interest);
                          }
                          _selectedInterestsNotifier.value = newSet;
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => widget.onContinue(
              widget.bioController.text,
              _selectedInterestsNotifier.value,
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 55),
              backgroundColor: kWhite,
              foregroundColor: primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text(
              "Continue",
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}


class InterestChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;

  const InterestChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      labelStyle: GoogleFonts.poppins(
        color: isSelected ? primary : kWhite,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: isSelected?kWhite.withOpacity(0.1):kGrey.withOpacity(0.4),
      selectedColor: kWhite,
      checkmarkColor: primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: kWhite.withOpacity(0.3)),
      ),
    );
  }
}