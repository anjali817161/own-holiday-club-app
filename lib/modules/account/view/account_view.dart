import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:own_holiday_app/utils/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:own_holiday_app/routes/app_pages.dart';
import '../controller/account_controller.dart';
import 'package:own_holiday_app/modules/auth/member_details/view/member_details_view.dart';
import 'package:own_holiday_app/modules/auth/member_details/controller/member_details_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoggedIn.value) {
        if (!Get.isRegistered<MemberDetailsController>()) {
          Get.put(MemberDetailsController());
        }
        return const MemberDetailsView();
      }
      return Scaffold(
        backgroundColor: AppColors.primaryWhite,
        endDrawer: _buildRightDrawer(context),
        appBar: AppBar(
          backgroundColor: AppColors.primaryWhite,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryBlack),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            'Account',
            style: TextStyle(
              color: AppColors.primaryBlack, 
              fontWeight: FontWeight.normal,
              fontSize: 10.0,
            ),
          ),
          actions: [
            Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.settings_outlined, color: AppColors.primaryBlack),
                onPressed: () => Scaffold.of(ctx).openEndDrawer(),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Profile Image & Name
              Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryYellow, width: 3),
                      color: AppColors.lightGrey,
                    ),
                    child: const Icon(Icons.person, size: 50, color: AppColors.primaryBlack),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Guest User',
                    style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.normal, color: AppColors.primaryBlack),
                  ),
                  const SizedBox(height: 6),
                  const Text('Login to access your premium membership benefits', style: TextStyle(color: AppColors.greyText, fontSize: 8.0)),
                ],
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildMenuItem(Icons.login_rounded, 'Login to Account', 'Access your membership details', onTap: () => Get.toNamed(Routes.MEMBER_LOGIN)),
                    _buildMenuItem(Icons.security, 'Privacy & Security', 'Manage your data and biometrics'),
                    _buildMenuItem(Icons.info_outline, 'About Own Holiday', 'Learn more about our services'),
                    _buildMenuItem(Icons.help_outline_rounded, 'Help & FAQ', 'Common questions & support', onTap: () => Get.toNamed(Routes.FAQ)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMenuItem(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.lightGrey, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.lightGrey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primaryBlack),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.normal, color: AppColors.primaryBlack, fontSize: 9.0)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 8.0, color: AppColors.greyText)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.greyText),
          ],
        ),
      ),
    );
  }

  Widget _buildRightDrawer(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.65,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      backgroundColor: AppColors.primaryWhite,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 20, 20, 20),
            color: AppColors.primaryBlack,
            child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.primaryWhite,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryYellow, width: 2),
                  ),
                  child: controller.userData.value?.profileImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(35),
                          child: CachedNetworkImage(
                            imageUrl: controller.userData.value!.profileImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.person_rounded, size: 40, color: AppColors.primaryBlack),
                ),
                const SizedBox(height: 16),
                Text(
                  controller.isLoggedIn.value 
                      ? (controller.userData.value?.name ?? 'Member')
                      : 'Guest User',
                  style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.normal, color: AppColors.primaryYellow),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.isLoggedIn.value 
                      ? (controller.userData.value?.mobile ?? 'OHC Member')
                      : 'Welcome to OHC',
                  style: const TextStyle(fontSize: 8.0, color: AppColors.primaryWhite),
                ),
              ],
            )),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                _DrawerItem(Icons.home_rounded, 'Home', () => Get.back()),
                _DrawerItem(Icons.bookmark_rounded, 'My Bookings', () {}),
                _DrawerItem(Icons.favorite_rounded, 'Wishlist', () {}),
                _DrawerItem(Icons.help_outline_rounded, 'Help & FAQ', () {
                  Get.back();
                  Get.toNamed(Routes.FAQ);
                }),
                _DrawerItem(Icons.people_rounded, 'Refer & Earn', () {}),
                _DrawerItem(Icons.settings_rounded, 'Settings', () {}),
                const Divider(indent: 20, endIndent: 20),
                _DrawerItem(Icons.privacy_tip_outlined, 'Privacy Policy', () {
                  Get.back();
                  Get.toNamed(Routes.PRIVACY_POLICY);
                }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Obx(() => controller.isLoggedIn.value 
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryYellow,
                              foregroundColor: AppColors.primaryBlack,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              Get.back();
                              Get.toNamed(Routes.MEMBER_LOGIN);
                            },
                            child: const Text('MEMBER LOGIN',
                                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 8.0, letterSpacing: 1.0)),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    )),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryBlack,
                      side: const BorderSide(color: AppColors.primaryBlack),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {},
                    child: const Text('ENQUIRY',
                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 8.0, letterSpacing: 1.0)),
                  ),
                ),
                if (controller.isLoggedIn.value)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.brownAccent,
                      side: const BorderSide(color: AppColors.brownAccent),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => controller.logout(),
                    icon: const Icon(Icons.logout_rounded, size: 20),
                    label: const Text('Logout',
                        style: TextStyle(fontWeight: FontWeight.normal)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _DrawerItem(this.icon, this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Icon(icon, color: AppColors.primaryBlack, size: 22),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 8.0, color: AppColors.primaryBlack)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: AppColors.greyText),
      onTap: onTap,
    );
  }
}
