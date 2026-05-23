import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shimmer/shimmer.dart';
import 'package:own_holiday_app/utils/app_colors.dart';
import 'package:own_holiday_app/routes/app_pages.dart';
import 'package:own_holiday_app/widgets/skeleton.dart';
import 'package:own_holiday_app/modules/dashboard/controller/dashboard_controller.dart';
import 'package:own_holiday_app/modules/membership/model/membership_tier.dart';
import 'package:own_holiday_app/modules/account/controller/account_controller.dart';

class MembershipBottomSheet {
  static void show(BuildContext context) {
    final controller = Get.find<DashboardController>();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.90,
          decoration: const BoxDecoration(
            color: AppColors.scaffoldBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(
              children: [
                const SizedBox(height: 15),
                // Top Bar with Close Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 40),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlack.withOpacity(0.24),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close_rounded, color: AppColors.primaryBlack.withOpacity(0.7), size: 24),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primaryBlack.withOpacity(0.1),
                          padding: const EdgeInsets.all(4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                FadeInDown(
                  duration: const Duration(milliseconds: 500),
                  child: const Text(
                     'CLUB MEMBERSHIPS',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlack,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                FadeInDown(
                  delay: const Duration(milliseconds: 100),
                  child: Text(
                    'Exclusive travel privileges for elite members.',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: AppColors.primaryBlack.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                Obx(() => Expanded(
                  child: controller.isLoading.value 
                    ? Stack(
                        children: [
                          PageView.builder(
                            controller: PageController(viewportFraction: 0.82),
                            itemCount: 3,
                            itemBuilder: (context, index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                              child: Shimmer.fromColors(
                                baseColor: AppColors.borderGrey,
                                highlightColor: AppColors.lightGrey,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGrey,
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Center(
                            child: CircularProgressIndicator(color: AppColors.primaryYellow),
                          ),
                        ],
                      )
                    : PageView.builder(
                        controller: PageController(viewportFraction: 0.82),
                        itemCount: controller.membershipTiers.length,
                        itemBuilder: (context, index) {
                          final plan = controller.membershipTiers[index];
                          return _buildDarkPlanCard(controller, plan, index);
                        },
                      ),
                )),
                const SizedBox(height: 20),
                // Pagination indicator
                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    controller.membershipTiers.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryYellow.withOpacity(0.4),
                      ),
                    ),
                  ),
                )),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildDarkPlanCard(DashboardController controller, MembershipTier plan, int index) {
    final planColor = controller.getPlanColor(plan.name, index);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: AppColors.borderGrey, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlack.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: Stack(
          children: [
            // Background Gradient Glow
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      planColor.withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Column(
              children: [
                // Plan Icon Header
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        planColor.withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.workspace_premium_rounded,
                      size: 50,
                      color: planColor,
                    ),
                  ),
                ),
                
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(28, 0, 28, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.name ?? 'Plan',
                          style: const TextStyle(
                            fontSize: 15.0, 
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlack,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.visible,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.end,
                          children: [
                            if (plan.id == 'ohc-privilege' && plan.actuallyPrice != null && plan.actuallyPrice!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0, bottom: 2.0),
                                child: Text(
                                  '₹ ${plan.actuallyPrice!.replaceAll('₹', '').replaceAll('Rs.', '').replaceAll('Rs', '').trim()}',
                                  style: const TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.greyText,
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: AppColors.brownAccent,
                                    decorationThickness: 2.0,
                                  ),
                                ),
                              ),
                             Text(
                              '₹ ${plan.price.replaceAll('₹', '').replaceAll('Rs.', '').replaceAll('Rs', '').trim()}'
                              ' + ₹ ${plan.adminFee?.replaceAll('₹', '').replaceAll('Rs.', '').replaceAll('Rs', '').trim() ?? '0'} (Admin Fee)',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: planColor,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'BENEFITS',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.greyText,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (plan.features != null)
                          ...List.generate(
                            plan.features.length,
                            (i) => Padding(
                              padding: const EdgeInsets.only(bottom: 14.0),
                              child: Row(
                                children: [
                                  Icon(Icons.verified_rounded, color: planColor, size: 18),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      plan.features[i],
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: AppColors.bodyText,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                
                // Buy Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: planColor,
                        foregroundColor: AppColors.primaryBlack,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 10,
                        shadowColor: planColor.withOpacity(0.4),
                      ),
                      onPressed: () {
                        Navigator.pop(Get.context!);
                        Get.toNamed(Routes.MEMBERSHIP_FORM, arguments: plan);
                      },
                      child: Text(
                        (Get.isRegistered<AccountController>() && Get.find<AccountController>().userData.value?.membership != null)
                            ? 'UPDATE NOW'
                            : 'BUY NOW',
                        style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5, fontSize: 13.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
