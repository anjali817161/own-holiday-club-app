import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:own_holiday_app/utils/app_colors.dart';
import 'package:own_holiday_app/routes/app_pages.dart';

class MembershipDetailsView extends StatelessWidget {
  const MembershipDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      appBar: AppBar(
        backgroundColor: AppColors.primaryWhite,
        elevation: 0,
        centerTitle: true,
        title: const Text('Membership Details', style: TextStyle(color: AppColors.primaryBlack, fontWeight: FontWeight.normal, fontSize: 14.0)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primaryBlack),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Success Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryYellow.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: AppColors.primaryYellow, size: 50),
            ),
            const SizedBox(height: 20),
            const Text(
              'Payment Successful!',
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal, color: AppColors.primaryBlack),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your membership has been activated.',
              style: TextStyle(fontSize: 12.0, color: AppColors.greyText),
            ),
            const SizedBox(height: 40),
            
            // Details Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryBlack,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('PACKAGE NAME', style: TextStyle(color: AppColors.primaryYellow, fontSize: 12.0, fontWeight: FontWeight.normal)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryYellow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('ACTIVE', style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.normal)),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('OHC Privilege', style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.normal)),
                  const SizedBox(height: 24),
                  
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('VALIDITY', style: TextStyle(color: AppColors.greyText, fontSize: 12.0, fontWeight: FontWeight.normal)),
                          SizedBox(height: 4),
                          Text('5 Years', style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.normal)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('AMOUNT PAID', style: TextStyle(color: AppColors.greyText, fontSize: 12.0, fontWeight: FontWeight.normal)),
                          SizedBox(height: 4),
                          Text('₹ 2', style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.normal)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('START DATE', style: TextStyle(color: AppColors.greyText, fontSize: 12.0, fontWeight: FontWeight.normal)),
                          SizedBox(height: 4),
                          Text('Oct 24, 2023', style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.normal)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('RENEWAL DATE', style: TextStyle(color: AppColors.greyText, fontSize: 12.0, fontWeight: FontWeight.normal)),
                          SizedBox(height: 4),
                          Text('Oct 24, 2028', style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.normal)),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryYellow,
                  foregroundColor: AppColors.primaryBlack,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Get.offAllNamed(Routes.MEMBER_DETAILS);
                },
                child: const Text('Go to Dashboard', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12.0)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
