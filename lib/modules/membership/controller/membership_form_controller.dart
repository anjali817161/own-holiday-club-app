import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:own_holiday_app/data/repository/membership_repo.dart';
import 'package:own_holiday_app/data/repository/auth_repo.dart';
import 'package:own_holiday_app/modules/auth/login/model/user_model.dart';
import 'package:own_holiday_app/modules/account/controller/account_controller.dart';
import 'package:own_holiday_app/modules/membership/model/membership_tier.dart';
import 'package:own_holiday_app/routes/app_pages.dart';
import 'dart:convert';
import 'package:own_holiday_app/modules/account/controller/account_controller.dart';

class MembershipFormController extends GetxController {
  final MembershipRepo membershipRepo = Get.find();
  final AuthRepo authRepo = Get.find();
  late Razorpay _razorpay;
  
  var currentStep = 1.obs;
  var isLoading = false.obs;
  
  late MembershipTier selectedTier;

  // Controllers for Step 1
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dobController = TextEditingController();
  final mobileController = TextEditingController();
  final mobileOtpController = TextEditingController();
  final emailController = TextEditingController();
  final emailOtpController = TextEditingController();
  final anniversaryController = TextEditingController();
  
  // Address Controllers
  final houseNoController = TextEditingController();
  final residenceAddressController = TextEditingController();
  final residenceCityController = TextEditingController();
  final pinController = TextEditingController();
  
  // Office Controllers
  final officeAddressController = TextEditingController();
  final officeCityController = TextEditingController();
  final officePhoneController = TextEditingController();
  final officePinController = TextEditingController();

  // OTP Logic
  var isMobileOtpSent = false.obs;
  var isMobileVerified = false.obs;
  var isEmailOtpSent = false.obs;
  var isEmailVerified = false.obs;
  String? _tempMobile;
  String? _tempEmail;

  // Selected dropdowns
  var selectedTitle = RxnString();
  var selectedOccupation = RxnString();
  var selectedGender = RxnString();
  var selectedMarried = RxnString();
  var selectedStateRes = RxnString();
  var selectedStateOff = RxnString();
  var selectedCountryRes = RxnString('India');
  var selectedAddressProof = RxnString();
  
  // Consent
  var isConsentChecked = false.obs;

  @override
  void onInit() {
    super.onInit();
    selectedTier = Get.arguments as MembershipTier;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void onClose() {
    _razorpay.clear();
    // Dispose all controllers
    nameController.dispose();
    lastNameController.dispose();
    dobController.dispose();
    mobileController.dispose();
    mobileOtpController.dispose();
    emailController.dispose();
    emailOtpController.dispose();
    anniversaryController.dispose();
    houseNoController.dispose();
    residenceAddressController.dispose();
    residenceCityController.dispose();
    pinController.dispose();
    officeAddressController.dispose();
    officeCityController.dispose();
    officePhoneController.dispose();
    officePinController.dispose();
    super.onClose();
  }

  void nextStep() {
    if (currentStep.value == 1) {
      if (!isMobileVerified.value) {
        Get.snackbar('Verification Required', 'Please verify your mobile number first',
            backgroundColor: Colors.orange, colorText: Colors.white);
        return;
      }
      if (!isEmailVerified.value) {
        Get.snackbar('Verification Required', 'Please verify your email address first',
            backgroundColor: Colors.orange, colorText: Colors.white);
        return;
      }
      currentStep.value = 2;
    }
  }

  void previousStep() {
    if (currentStep.value == 2) {
      currentStep.value = 1;
    }
  }

  // --- API Methods ---

  Future<void> sendMobileOtp() async {
    if (mobileController.text.length != 10) {
      Get.snackbar('Error', 'Invalid mobile number');
      return;
    }
    try {
      isLoading.value = true;
      final mobile = mobileController.text;
      final response = await authRepo.sendMobileOtp(mobile);
      if (response.statusCode == 200) {
        _tempMobile = mobile;
        mobileController.clear();
        isMobileOtpSent.value = true;
        Get.snackbar('Success', 'OTP sent to mobile');
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar('Error', data['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      Get.snackbar('Error', 'Connection failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyMobileOtp() async {
    if (mobileController.text.isEmpty) return;
    if (_tempMobile == null) return;
    try {
      isLoading.value = true;
      final response = await authRepo.verifyMobileOtp(_tempMobile!, mobileController.text);
      if (response.statusCode == 200) {
        isMobileVerified.value = true;
        isMobileOtpSent.value = false;
        mobileController.text = _tempMobile!; // Restore mobile number after verification
        Get.snackbar('Success', 'Mobile verified');
      } else {
        Get.snackbar('Error', 'Invalid OTP');
      }
    } catch (e) {
      Get.snackbar('Error', 'Verification failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendEmailOtp() async {
    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar('Error', 'Invalid email address');
      return;
    }
    try {
      isLoading.value = true;
      final email = emailController.text;
      final response = await authRepo.sendEmailOtp(email);
      if (response.statusCode == 200) {
        _tempEmail = email;
        emailController.clear();
        isEmailOtpSent.value = true;
        Get.snackbar('Success', 'OTP sent to email');
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar('Error', data['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      Get.snackbar('Error', 'Connection failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyEmailOtp() async {
    if (emailController.text.isEmpty) return;
    if (_tempEmail == null) return;
    try {
      isLoading.value = true;
      final response = await authRepo.verifyEmailOtp(_tempEmail!, emailController.text);
      if (response.statusCode == 200) {
        isEmailVerified.value = true;
        isEmailOtpSent.value = false;
        emailController.text = _tempEmail!; // Restore email after verification
        Get.snackbar('Success', 'Email verified');
      } else {
        Get.snackbar('Error', 'Invalid OTP');
      }
    } catch (e) {
      Get.snackbar('Error', 'Verification failed');
    } finally {
      isLoading.value = false;
    }
  }

  // --- Payment Flow ---

  Map<String, dynamic> _buildMemberDetails() {
    return {
      'personalDetails': {
        'firstName': nameController.text,
        'fullName': '${nameController.text} ${lastNameController.text}'.trim(),
        'email': emailController.text,
        'mobile': mobileController.text,
        'dob': dobController.text,
        'occupation': selectedOccupation.value,
        'gender': selectedGender.value,
        'maritalStatus': selectedMarried.value,
        'anniversary': anniversaryController.text,
        'residenceAddress': {
          'houseNo': houseNoController.text,
          'addressLine': residenceAddressController.text,
          'city': residenceCityController.text,
          'state': selectedStateRes.value,
          'country': selectedCountryRes.value,
          'pin': pinController.text,
        },
        'officeAddress': {
          'addressLine': officeAddressController.text,
          'city': officeCityController.text,
          'state': selectedStateOff.value,
          'phone': officePhoneController.text,
          'pin': officePinController.text,
        }
      },
      'familyDetails': {
        'spouse': {'name': '', 'dob': ''},
        'children': []
      },
      'documents': {
        'profileImage': {'name': 'profile.jpg', 'type': 'image/jpeg', 'size': 1024, 'dataUrl': ''},
        'idProof': {'name': 'aadhaar.jpg', 'type': 'image/jpeg', 'size': 1024, 'dataUrl': '', 'proofType': 'Aadhaar'},
        'addressProof': {'name': 'pan.jpg', 'type': 'image/jpeg', 'size': 1024, 'dataUrl': '', 'proofType': selectedAddressProof.value ?? 'PAN'}
      },
      'acceptedTerms': isConsentChecked.value
    };
  }

  Future<void> proceedToPayment() async {
    if (!isConsentChecked.value) {
      Get.snackbar('Error', 'Please agree to the Terms & Conditions',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      final memberDetails = _buildMemberDetails();
      final response = await membershipRepo.createRazorpayOrder(selectedTier.id, memberDetails);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        var options = {
          'key': data['key'],
          'amount': data['order']['amount'],
          'name': 'Own Holiday Club',
          'description': data['tier']['name'],
          'order_id': data['order']['id'],
          'prefill': {
            'contact': mobileController.text,
            'email': emailController.text
          },
          'notes': data['order']['notes']
        };
        _razorpay.open(options);
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar('Error', data['message'] ?? 'Failed to create order');
      }
    } catch (e) {
      Get.snackbar('Error', 'Payment initialization failed');
    } finally {
      isLoading.value = false;
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      isLoading.value = true;
      final data = {
        'tierId': selectedTier.id,
        'memberDetails': _buildMemberDetails(),
        'razorpay_payment_id': response.paymentId,
        'razorpay_order_id': response.orderId,
        'razorpay_signature': response.signature,
      };

      final verifyRes = await membershipRepo.verifyPayment(data);
      if (verifyRes.statusCode == 200) {
        final verifyData = jsonDecode(verifyRes.body);
        final userModel = UserModel.fromJson(verifyData['user']);
        
        // Save to AccountController
        Get.find<AccountController>().userData.value = userModel;
        Get.find<AccountController>().isLoggedIn.value = true;

        Get.offAllNamed(Routes.DASHBOARD);
        Get.snackbar('Success', 'Welcome to Own Holiday Club!');
      } else {
        Get.snackbar('Error', 'Payment verification failed. Please contact support.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Internal error during verification');
    } finally {
      isLoading.value = false;
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar('Payment Failed', response.message ?? 'Unknown error',
        backgroundColor: Colors.red, colorText: Colors.white);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar('External Wallet', response.walletName ?? '');
  }
}
