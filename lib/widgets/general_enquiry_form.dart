import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:own_holiday_app/utils/app_colors.dart';
import 'package:own_holiday_app/data/repository/service_repo.dart';

class GeneralEnquiryForm extends StatefulWidget {
  const GeneralEnquiryForm({super.key});

  @override
  State<GeneralEnquiryForm> createState() => _GeneralEnquiryFormState();
}

class _GeneralEnquiryFormState extends State<GeneralEnquiryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isSubmitting = false;

  final ServiceRepo _serviceRepo = Get.find<ServiceRepo>();

  Future<void> _submitEnquiry() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final Map<String, dynamic> data = {
        "name": _nameController.text,
        "email": _emailController.text,
        "phone": _phoneController.text,
        "source": "Mobile App Side Drawer"
      };

      final response = await _serviceRepo.submitGeneralEnquiry(data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessDialog();
      } else {
        Get.snackbar(
          "Error", 
          "Failed to submit. Please try again later.",
          backgroundColor: AppColors.brownAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error", 
        "Something went wrong. Please check your connection.",
        backgroundColor: AppColors.brownAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.primaryYellow, size: 70),
            const SizedBox(height: 20),
            const Text(
              "Submission Successful",
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 10),
            const Text(
              "Thank you for your interest. We will contact you shortly.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.greyText),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlack,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Get.back(); // Close dialog
                  Get.back(); // Close form
                  Get.offAllNamed('/dashboard'); // Back to home
                },
                child: const Text("CLOSE", style: TextStyle(fontWeight: FontWeight.normal)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Enquiry Form",
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.normal,
                    color: AppColors.primaryBlack,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Please provide your details below.",
                  style: TextStyle(fontSize: 12.0, color: AppColors.greyText),
                ),
                const SizedBox(height: 32),
                
                _buildField(
                  controller: _nameController,
                  label: "Name",
                  hint: "Enter your full name",
                  icon: Icons.person_rounded,
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 20),
                
                _buildField(
                  controller: _emailController,
                  label: "Email",
                  hint: "Enter your email address",
                  icon: Icons.email_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v!.isEmpty || !v.contains('@') ? "Valid email required" : null,
                ),
                const SizedBox(height: 20),
                
                _buildField(
                  controller: _phoneController,
                  label: "Phone Number",
                  hint: "Enter your phone number",
                  icon: Icons.phone_rounded,
                  keyboardType: TextInputType.phone,
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 40),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryYellow,
                      foregroundColor: AppColors.primaryBlack,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: _isSubmitting ? null : _submitEnquiry,
                    child: _isSubmitting 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.primaryBlack, strokeWidth: 2))
                      : const Text(
                          "SUBMIT",
                          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13.0, letterSpacing: 1),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: AppColors.primaryBlack),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.greyText, fontSize: 12.0),
            prefixIcon: Icon(icon, size: 20, color: AppColors.primaryYellow),
            filled: true,
            fillColor: AppColors.lightGrey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderGrey!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderGrey!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryYellow, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
