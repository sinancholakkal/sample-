import 'package:dating_app/services/auth_services.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ScreenOnboarding extends StatelessWidget {
  ScreenOnboarding({super.key});

  final PageController _controller = PageController();

  ValueNotifier<int> currentIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: appGradient),
        child: SafeArea(
          child: ValueListenableBuilder(
            valueListenable: currentIndex,
            builder: (context, currentIdxNoti, child) {
              return Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: AppStrings.onboardingData.length,
                      onPageChanged: (value) {
                        currentIndex.value = value;
                      },
                      itemBuilder: (context, index) {
                        final item = AppStrings.onboardingData[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),

                            // Title
                            Text(
                              item["title"]!,
                              style: GoogleFonts.poppins(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),

                            // Subtitle
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                              ),
                              child: Text(
                                item["subtitle"]!,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // Dots Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      AppStrings.onboardingData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 20,
                        ),
                        width: currentIdxNoti == index ? 16 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: currentIdxNoti == index
                              ? Colors.white
                              : Colors.white54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  // Get Started Button
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 55),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        if (currentIndex.value ==
                            AppStrings.onboardingData.length - 1) {
                          context.push("/authlanding");
                        } else {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(
                        currentIdxNoti == AppStrings.onboardingData.length - 1
                            ? "Get Started"
                            : "Next",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
