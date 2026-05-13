import 'package:get/get.dart';
import '../model/membership_tier.dart';
import '../../../data/repository/membership_repo.dart';
import 'dart:convert';

class MembershipController extends GetxController {
  final MembershipRepo membershipRepo = Get.find();
  
  var tiers = <MembershipTier>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTiers();
  }

  void fetchTiers() async {
    try {
      isLoading.value = true;
      final response = await membershipRepo.getMembershipPlans();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // The backend returns { tiers: [...] } in membership.js tiers route
        final List<dynamic> tiersJson = data['tiers'] ?? [];
        tiers.value = tiersJson.map((t) => MembershipTier.fromJson(t)).toList();
      }
    } catch (e) {
      print('Error fetching tiers: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
