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
        height: 75,
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Background Navbar (Full width, square corners, light background)
            Container(
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(50, 50, 93, 0.12),
                    offset: Offset(0, -2),
                    blurRadius: 5,
                    spreadRadius: -1,
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    offset: Offset(0, -1),
                    blurRadius: 3,
                    spreadRadius: -1,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.home_rounded, 'Home'),
                  const SizedBox(width: 60), 
                  _buildNavItem(2, Icons.person_rounded, 'Account'),
                ],
              ),
            ),

            // Overlapping Middle Icon (Membership)
            Positioned(
              bottom: 12,
              child: GestureDetector(
                onTap: () => MembershipBottomSheet.show(context),
                child: Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primaryYellow,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryYellow.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white,
                      width: 2.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.card_membership_rounded,
                    size: 24,
                    color: AppColors.primaryBlack,
                  ),
                ),
              ),
            ),
            
            // Middle Label
            Positioned(
              bottom: 2,
              child: const Text(
                'Membership',
                style: TextStyle(
                  color: AppColors.primaryBlack,
                  fontSize: 11.0,
                  fontWeight: FontWeight.w500,
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
              color: isSelected ? AppColors.primaryYellow : AppColors.greyText,
              size: 26,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primaryYellow : AppColors.greyText,
                fontSize: 12.0,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        );
      }),
    );
  }

}
