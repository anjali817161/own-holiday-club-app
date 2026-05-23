import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:own_holiday_app/utils/app_colors.dart';
import 'package:own_holiday_app/data/repository/service_repo.dart';

class EnquiryFormSheet extends StatefulWidget {
  final Map<String, dynamic> destination;
  const EnquiryFormSheet({super.key, required this.destination});

  @override
  State<EnquiryFormSheet> createState() => _EnquiryFormSheetState();
}

class _EnquiryFormSheetState extends State<EnquiryFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  
  DateTime? _startDate;
  DateTime? _endDate;
  int _adults = 2;
  int _children = 0;
  bool _isSubmitting = false;

  late final ServiceRepo _serviceRepo;
  
  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<ServiceRepo>()) {
      Get.put(ServiceRepo(apiClient: Get.find()));
    }
    _serviceRepo = Get.find<ServiceRepo>();
  }

  Future<void> _submitEnquiry() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final Map<String, dynamic> data = {
        "name": _nameController.text,
        "email": _emailController.text,
        "phone": _phoneController.text,
        "destinationId": widget.destination['id'] ?? widget.destination['_id'],
        "destinationName": widget.destination['name'] ?? widget.destination['title'],
        "startDate": _startDate?.toIso8601String(),
        "endDate": _endDate?.toIso8601String(),
        "adults": _adults,
        "children": _children,
        "message": _messageController.text,
        "source": "Mobile App Destination Reel"
      };

      final response = await _serviceRepo.submitDestinationEnquiry(data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar(
          "Success", 
          "Your enquiry has been submitted successfully. Our team will contact you soon.",
          backgroundColor: AppColors.primaryYellow,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error", 
          "Failed to submit enquiry. Please try again later.",
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
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
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.borderGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Request an Itinerary",
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.normal,
                  color: AppColors.primaryBlack,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Complete the details below to begin planning your journey to ${widget.destination['name'] ?? widget.destination['title']}.",
                style: TextStyle(
                  fontSize: 12.0,
                  color: AppColors.primaryBlack,
                ),
              ),
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _nameController,
                      label: "Full Name",
                      icon: Icons.person_outline,
                      validator: (v) => v!.isEmpty ? "Required" : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField(
                      controller: _phoneController,
                      label: "Phone Number",
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (v) => v!.isEmpty ? "Required" : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                label: "Email Address",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.isEmpty || !v.contains('@') ? "Valid email required" : null,
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: _buildDatePicker(
                      label: _startDate == null ? "Check-in" : DateFormat('MM/dd/yyyy').format(_startDate!),
                      icon: Icons.calendar_today_outlined,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                        );
                        if (date != null) setState(() => _startDate = date);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildDatePicker(
                      label: _endDate == null ? "Check-out" : DateFormat('MM/dd/yyyy').format(_endDate!),
                      icon: Icons.calendar_today_outlined,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _startDate?.add(const Duration(days: 1)) ?? DateTime.now(),
                          firstDate: _startDate?.add(const Duration(days: 1)) ?? DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                        );
                        if (date != null) setState(() => _endDate = date);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: _buildCounterField(
                      label: "Adults",
                      icon: Icons.group_outlined,
                      value: _adults,
                      onChanged: (v) => setState(() => _adults = v),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildCounterField(
                      label: "Children",
                      icon: Icons.child_care_outlined,
                      value: _children,
                      onChanged: (v) => setState(() => _children = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _messageController,
                label: "Special Requests or Preferences... (Optional)",
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlack,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: _isSubmitting ? null : _submitEnquiry,
                  child: _isSubmitting 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "SUBMIT INQUIRY",
                            style: TextStyle(fontWeight: FontWeight.normal, letterSpacing: 1),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.send_rounded, size: 18),
                        ],
                      ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  "YOUR INFORMATION IS STRICTLY CONFIDENTIAL.",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: AppColors.greyText,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 0.5,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(color: AppColors.greyText, fontSize: 12.0),
        prefixIcon: icon != null ? Icon(icon, size: 20, color: AppColors.greyText) : null,
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
          borderSide: const BorderSide(color: AppColors.primaryYellow),
        ),
      ),
    );
  }

  Widget _buildDatePicker({required String label, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderGrey!),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.greyText),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: label.contains('/') ? AppColors.primaryBlack : AppColors.greyText, 
                  fontSize: 12.0, // Slightly smaller
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterField({required String label, required IconData icon, required int value, required Function(int) onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGrey!),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.greyText),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label, 
              style: TextStyle(color: AppColors.greyText, fontSize: 12.0),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () { if (value > 0) onChanged(value - 1); },
            child: Icon(Icons.remove_circle_outline, size: 18, color: AppColors.greyText),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(value.toString(), style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12.0)),
          ),
          GestureDetector(
            onTap: () { onChanged(value + 1); },
            child: const Icon(Icons.add_circle_outline, size: 18, color: AppColors.primaryYellow),
          ),
        ],
      ),
    );
  }
}
