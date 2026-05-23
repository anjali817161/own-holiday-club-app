import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:animate_do/animate_do.dart';
import '../controller/onboarding_controller.dart';
import 'package:own_holiday_app/utils/app_colors.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background PageView (Top ~65%)
          Positioned.fill(
            bottom: MediaQuery.of(context).size.height * 0.35,
            child: PageView.builder(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              itemCount: controller.onboardingData.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  controller.onboardingData[index]['image']!,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),

          // Skip Button — top right
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 20,
            child: Obx(() => controller.currentPage.value < controller.onboardingData.length - 1
                ? GestureDetector(
                    onTap: controller.skip,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlack.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink()),
          ),
 
          // Content Card — bottom ~40%
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(30, 40, 30, 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(45)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlack.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, -10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Obx(() {
                      final item = controller.onboardingData[controller.currentPage.value];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeInLeft(
                            key: ValueKey('title_${controller.currentPage.value}'),
                            duration: const Duration(milliseconds: 500),
                            child: Text(
                              item['title']!,
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBlack,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          FadeInLeft(
                            key: ValueKey('desc_${controller.currentPage.value}'),
                            delay: const Duration(milliseconds: 150),
                            duration: const Duration(milliseconds: 500),
                            child: Text(
                              item['description']!,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: AppColors.greyText.withOpacity(0.9),
                                fontWeight: FontWeight.normal,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  
                  // Bottom Navigation: Dots and Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Dots on left
                      SmoothPageIndicator(
                        controller: controller.pageController,
                        count: controller.onboardingData.length,
                        effect: ExpandingDotsEffect(
                          activeDotColor: AppColors.primaryYellow,
                          dotColor: AppColors.primaryYellow.withOpacity(0.3),
                          dotHeight: 8,
                          dotWidth: 8,
                          expansionFactor: 4,
                          spacing: 6,
                        ),
                      ),
                      
                      // Button on right
                      Obx(() {
                        final isLast = controller.currentPage.value == controller.onboardingData.length - 1;
                        return FadeInRight(
                          child: ElevatedButton(
                            onPressed: controller.next,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryYellow,
                              foregroundColor: AppColors.primaryBlack,
                              padding: EdgeInsets.symmetric(
                                horizontal: isLast ? 30 : 20,
                                vertical: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 5,
                              shadowColor: AppColors.primaryYellow.withOpacity(0.4),
                            ),
                            child: isLast 
                              ? const Text(
                                  'Get Started',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                                )
                              : const Icon(Icons.arrow_forward_rounded, size: 28),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
