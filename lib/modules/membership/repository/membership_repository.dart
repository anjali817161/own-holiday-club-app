import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../../utils/api_constants.dart';

class MembershipRepository {
  void _logResponse(String url, http.Response response) {
    if (kDebugMode) {
      print('--- API CALL ---');
      print('URL: $url');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('----------------');
    }
  }

  Future<http.Response> getMembershipTiers() async {
    final url = ApiConstants.membershipTiers;
    final response = await http.get(Uri.parse(url));
    _logResponse(url, response);
    return response;
  }

  Future<http.Response> sendMobileOtp(String mobile) async {
    final url = ApiConstants.sendMobileOtp;
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'mobile': mobile}),
    );
    _logResponse(url, response);
    return response;
  }

  Future<http.Response> verifyMobileOtp(String mobile, String otp) async {
    final url = ApiConstants.verifyMobileOtp;
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'mobile': mobile, 'otp': otp}),
    );
    _logResponse(url, response);
    return response;
  }

  Future<http.Response> sendEmailOtp(String email) async {
    final url = ApiConstants.sendEmailOtp;
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    _logResponse(url, response);
    return response;
  }

  Future<http.Response> verifyEmailOtp(String email, String otp) async {
    final url = ApiConstants.verifyEmailOtp;
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );
    _logResponse(url, response);
    return response;
  }

  Future<http.Response> createOrder(String tierId, Map<String, dynamic> memberDetails) async {
    final url = ApiConstants.createOrder;
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'tierId': tierId,
        'memberDetails': memberDetails,
      }),
    );
    _logResponse(url, response);
    return response;
  }

  Future<http.Response> verifyPayment(Map<String, dynamic> data) async {
    final url = ApiConstants.verifyPayment;
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    _logResponse(url, response);
    return response;
  }
}
