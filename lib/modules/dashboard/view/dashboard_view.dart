import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/dashboard_controller.dart';
import 'package:own_holiday_app/utils/app_colors.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:ui';
import '../../membership/view/membership_form_view.dart';
import '../../membership/model/membership_tier.dart';
import '../../../routes/app_pages.dart';
import 'package:own_holiday_app/widgets/skeleton.dart';
import 'package:own_holiday_app/widgets/membership_bottom_sheet.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: controller.pages[controller.currentIndex.value],
          )),
      bottomNavigationBar: Container(
        height: 85,
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Background Navbar
            Container(
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlack,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlack.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.home_rounded, 'Home'),
                  const SizedBox(width: 50), 
                  _buildNavItem(2, Icons.person_rounded, 'Account'),
                ],
              ),
            ),

            // Overlapping Middle Icon (Membership)
            Positioned(
              bottom: 25,
              child: GestureDetector(
                onTap: () => MembershipBottomSheet.show(context),
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primaryYellow,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryYellow.withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.primaryBlack,
                      width: 3,
                    ),
                  ),
                  child: const Icon(
                    Icons.card_membership_rounded,
                    size: 28,
                    color: AppColors.primaryBlack,
                  ),
                ),
              ),
            ),
            
            // Middle Label
            Positioned(
              bottom: 6,
              child: const Text(
                'Membership',
                style: TextStyle(
                  color: AppColors.primaryWhite,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    return InkWell(
      onTap: () => controller.changeIndex(index),
      child: Obx(() {
        bool isSelected = controller.currentIndex.value == index;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryYellow : AppColors.primaryWhite.withOpacity(0.5),
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primaryYellow : AppColors.primaryWhite.withOpacity(0.5),
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        );
      }),
    );
  }

}
