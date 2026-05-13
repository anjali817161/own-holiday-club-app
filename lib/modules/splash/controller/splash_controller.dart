import 'package:get/get.dart';
import 'package:own_holiday_app/routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 10));
    Get.offAllNamed(Routes.ONBOARDING);
  }
}
