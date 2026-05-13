import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:own_holiday_app/data/api/api_client.dart';
import 'package:own_holiday_app/data/repository/auth_repo.dart';
import 'package:own_holiday_app/data/repository/service_repo.dart';
import 'package:own_holiday_app/data/repository/membership_repo.dart';
import 'package:own_holiday_app/modules/account/controller/account_controller.dart';
import 'package:own_holiday_app/utils/api_constants.dart';

Future<void> init() async {
  // Storage
  Get.lazyPut(() => GetStorage());

  // Api Client
  Get.lazyPut(() => ApiClient(baseUrl: ApiConstants.baseUrl));

  // Repositories
  Get.put(AuthRepo(apiClient: Get.find()), permanent: true);
  Get.put(ServiceRepo(apiClient: Get.find()), permanent: true);
  Get.put(MembershipRepo(apiClient: Get.find()), permanent: true);

  // Global Controllers
  Get.put(AccountController(), permanent: true);
}
