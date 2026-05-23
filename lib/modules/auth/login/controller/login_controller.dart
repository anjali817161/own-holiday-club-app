import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:own_holiday_app/routes/app_pages.dart';
import 'package:own_holiday_app/data/repository/auth_repo.dart';
import 'package:own_holiday_app/modules/auth/login/model/user_model.dart';
import 'package:own_holiday_app/utils/app_colors.dart';
import 'dart:convert';

class LoginController extends GetxController {
  final AuthRepo authRepo = Get.find();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  
  var isLoading = false.obs;
  var isOtpSent = false.obs;
  var timerSeconds = 60.obs;
  
  final Rxn<UserModel> user = Rxn<UserModel>();

  void sendOtp() async {
    if (phoneController.text.length < 10) {
      Get.snackbar(
        'Invalid Number',
        'Please enter a valid 10-digit phone number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.brownAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await authRepo.sendMobileOtp(phoneController.text);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        isOtpSent.value = true;
        startTimer();
        Get.snackbar(
          'OTP Sent',
          data['message'] ?? 'Verification code sent successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primaryYellow,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          data['message'] ?? 'Failed to send OTP',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.brownAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.brownAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void startTimer() {
    timerSeconds.value = 60;
    _runTimer();
  }

  void _runTimer() async {
    while (timerSeconds.value > 0 && isOtpSent.value) {
      await Future.delayed(const Duration(seconds: 1));
      timerSeconds.value--;
    }
  }

  void verifyOtp() async {
    if (otpController.text.length < 6) {
      Get.snackbar(
        'Invalid OTP',
        'Please enter the 6-digit verification code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.brownAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await authRepo.verifyMobileOtp(
        phoneController.text,
        otpController.text,
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['verified'] == true) {
        Get.snackbar(
          'Success',
          'Verification Successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primaryYellow,
          colorText: Colors.white,
        );
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        Get.snackbar(
          'Verification Failed',
          data['message'] ?? 'Invalid OTP',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.brownAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Verification failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.brownAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void resetLogin() {
    isOtpSent.value = false;
    otpController.clear();
  }

  @override
  void onClose() {
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
