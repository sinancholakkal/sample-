import 'dart:developer';
import 'dart:io';

import 'package:dating_app/state/profile_setup_bloc/profile_setup_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/conversation_screen.dart/widget/image_preview.dart';
import 'package:dating_app/view/conversation_screen.dart/widget/image_secure_sheet.dart' show ImageSourceActionSheet;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

// Define a callback type for sending messages
typedef OnSendMessageCallback = void Function({String? messageText, XFile? xFile});

class MessageInputField extends StatefulWidget {
  final ValueChanged<String> onMessageChanged;
  final OnSendMessageCallback onSendMessage;

  const MessageInputField({
    super.key,
    required this.onMessageChanged,
    required this.onSendMessage,
  });

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  late final TextEditingController _messageController;
  XFile? _xFile; // Manage the picked image file locally

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // Wrapper for sendMessage, clearing text field if text was sent
  void _sendCurrentMessage() {
    if (_messageController.text.trim().isNotEmpty || _xFile != null) {
      widget.onSendMessage(messageText: _messageController.text.trim(), xFile: _xFile);
      _messageController.clear();
      // After sending image, clear the local _xFile and trigger UI update
      if (_xFile != null) {
        setState(() {
          _xFile = null;
        });
        context.read<ProfileSetupBloc>().add(ClearImageEvent()); // Ensure bloc also clears
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(color: bgcard.withOpacity(0.5)),
      child: BlocListener<ProfileSetupBloc, ProfileSetupState>(
        listener: (context, state) {
          if (state is ChatImageUploadState) {
            setState(() {
              _xFile = state.pickedFile;
            });
          } else if (state is ClearedImageState) {
            setState(() {
              _xFile = null;
            });
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Image preview
            if (_xFile != null)
              ImagePreview(
                xFile: _xFile!,
                cancelOnTap: () {
                  log("canceled image from MessageInputField");
                  context.read<ProfileSetupBloc>().add(ClearImageEvent());
                },
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.add, color: kWhite),
                      onPressed: () => 
                      ImageSourceActionSheet.show(
                        context,
                        bloc: context.read<ProfileSetupBloc>(),
                      ),
                    ),
                    if (_xFile != null) const Spacer(), // Pushes send button to right if image exists
                    if (_xFile == null) // Only show TextField if no image is selected
                      Expanded(
                        child: TextField(
                          onChanged: widget.onMessageChanged,
                          controller: _messageController,
                          style: GoogleFonts.poppins(color: kWhite),
                          decoration: InputDecoration(
                            hintText: "Type a message...",
                            hintStyle: GoogleFonts.poppins(color: kWhite70),
                            filled: true,
                            fillColor: kWhite.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: Icon(Icons.send, color: kWhite),
                      onPressed: _sendCurrentMessage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}