import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:own_holiday_app/utils/app_colors.dart';
import 'membership_details_view.dart';

class RazorpayMockView extends StatelessWidget {
  const RazorpayMockView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack.withOpacity(0.5),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Top Panel (Yellow)
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.primaryYellow,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.payment, color: AppColors.primaryBlack),
                            SizedBox(width: 8),
                            Text('Own Holiday Club', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13.0)),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.primaryBlack),
                          onPressed: () => Get.back(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Price Summary', style: TextStyle(color: AppColors.primaryBlack, fontSize: 12.0, fontWeight: FontWeight.normal)),
                            Text('₹ 2', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal, color: AppColors.primaryBlack)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                          child: const Row(
                            children: [
                              Text('+91 98765 43210', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Bottom Panel (White)
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Payment Options', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal)),
                      const SizedBox(height: 16),
                      _buildPaymentOption('UPI', Icons.qr_code),
                      const SizedBox(height: 12),
                      _buildPaymentOption('Cards', Icons.credit_card, subtitle: 'Upto 1.5% savings...'),
                      const SizedBox(height: 12),
                      _buildPaymentOption('Netbanking', Icons.account_balance),
                      const SizedBox(height: 12),
                      _buildPaymentOption('Wallet', Icons.account_balance_wallet),
                      const SizedBox(height: 24),
                      
                      const Text('UPI QR', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12.0)),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          Get.off(() => const MembershipDetailsView());
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlack.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.qr_code_2, size: 100),
                              SizedBox(height: 8),
                              Text('Tap to Pay', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.blue)),
                              SizedBox(height: 4),
                              Text('Scan the QR using any UPI App', style: TextStyle(fontSize: 12.0, color: AppColors.greyText)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Center(
                        child: Text('Secured by Razorpay', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: AppColors.greyText)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon, {String? subtitle}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.greyText.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryBlack),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12.0)),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 12.0, color: AppColors.primaryYellow, fontWeight: FontWeight.normal)),
              ]
            ],
          ),
          const Spacer(),
          const Icon(Icons.chevron_right, size: 16, color: AppColors.greyText),
        ],
      ),
    );
  }
}
