import 'dart:ui';
import 'package:flutter/material.dart';

class PrivacyBlurCard extends StatelessWidget {
  final String imageUrl;
  final bool isMatched;

  const PrivacyBlurCard({
    Key? key,
    required this.imageUrl,
    required this.isMatched,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main profile image
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(imageUrl),
            ),
          ),
        ),

        // If not matched → show blur + overlay
        if (!isMatched) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.6,
                color: Colors.black.withOpacity(0.3), // dim overlay
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Lock icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Message text
                    Text(
                      "Private until match",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "You’ll see each other after matching ❤️",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
