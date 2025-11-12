import 'package:dating_app/models/request_model.dart';
import 'package:dating_app/services/request_services.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RequestCard extends StatefulWidget {
  final RequestModel request;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const RequestCard({
    required this.request,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  @override
  void initState() {
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgcard.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage:widget.request.senderImageUrl.isNotEmpty? NetworkImage(widget.request.senderImageUrl):null,
            child: widget.request.senderImageUrl.isEmpty?Icon(Icons.person):SizedBox(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.request.senderName,
                  style:  TextStyle(color: kWhite, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                 Text(
                  'Wants to connect with you.',
                  style: TextStyle(color: kWhite70, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              IconButton(
                icon: const Icon(CupertinoIcons.clear_circled, color: Colors.redAccent, size: 30),
                onPressed: widget.onDecline,
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.check_mark_circled, color: Colors.greenAccent, size: 30),
                onPressed: widget.onAccept,
              ),
            ],
          )
        ],
      ),
    );
  }
}