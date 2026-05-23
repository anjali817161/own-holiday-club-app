import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:own_holiday_app/utils/app_colors.dart';
import 'package:own_holiday_app/modules/account/controller/account_controller.dart';
import 'package:own_holiday_app/modules/auth/login/model/user_model.dart';

class MyBookingsView extends StatelessWidget {
  const MyBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final accountController = Get.find<AccountController>();
    
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        title: const Text(
          'My Booking History',
          style: TextStyle(fontWeight: FontWeight.normal, color: AppColors.primaryBlack),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primaryBlack),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final bookings = accountController.userData.value?.holidayBookings ?? [];
        
        if (bookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_busy_rounded, size: 80, color: AppColors.borderGrey),
                const SizedBox(height: 16),
                Text(
                  'No bookings found',
                  style: TextStyle(color: AppColors.primaryBlack, fontSize: 9.0, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return _BookingCard(booking: booking);
          },
        );
      }),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlack.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryYellow.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.hotel_class_rounded, color: AppColors.primaryYellow, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.place ?? 'Unknown Destination',
                      style: const TextStyle(
                        fontSize: 9.0,
                        fontWeight: FontWeight.normal,
                        color: AppColors.primaryBlack,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Request ID: #${booking.id?.substring(booking.id!.length - 6).toUpperCase() ?? "N/A"}',
                      style: TextStyle(fontSize: 8.0, color: AppColors.greyText, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                _StatusBadge(status: booking.status ?? 'booking'),
                const Spacer(),
                Text(
                  booking.requestedAt != null 
                    ? DateFormat('dd MMM yyyy').format(DateTime.parse(booking.requestedAt!))
                    : 'Date Unknown',
                  style: TextStyle(fontSize: 8.0, color: AppColors.greyText),
                ),
              ],
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Column(
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  _buildDetailRow(Icons.calendar_today_rounded, 'Check-in', 
                      booking.checkIn != null ? DateFormat('dd MMM yyyy').format(DateTime.parse(booking.checkIn!)) : 'N/A'),
                  _buildDetailRow(Icons.calendar_month_rounded, 'Check-out', 
                      booking.checkOut != null ? DateFormat('dd MMM yyyy').format(DateTime.parse(booking.checkOut!)) : 'N/A'),
                  _buildDetailRow(Icons.people_outline_rounded, 'Guests', 
                      '${booking.adults ?? 0} Adults, ${booking.kids ?? 0} Children'),
                  if (booking.slotNumber != null)
                    _buildDetailRow(Icons.confirmation_number_outlined, 'Slot Number', '#${booking.slotNumber}'),
                  if (booking.confirmedAt != null)
                    _buildDetailRow(Icons.check_circle_outline_rounded, 'Confirmed On', 
                        DateFormat('dd MMM yyyy HH:mm').format(DateTime.parse(booking.confirmedAt!))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.greyText),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: AppColors.primaryBlack, fontSize: 8.0, fontWeight: FontWeight.normal)),
          const Spacer(),
          Text(value, style: const TextStyle(color: AppColors.primaryBlack, fontSize: 8.0, fontWeight: FontWeight.normal)),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    
    switch (status.toLowerCase()) {
      case 'booked':
      case 'confirmed':
        color = AppColors.primaryYellow;
        label = 'CONFIRMED';
        break;
      case 'cancelled':
        color = AppColors.brownAccent;
        label = 'CANCELLED';
        break;
      default:
        color = AppColors.primaryYellow;
        label = 'PENDING';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 8.0, fontWeight: FontWeight.normal, letterSpacing: 0.5),
      ),
    );
  }
}
