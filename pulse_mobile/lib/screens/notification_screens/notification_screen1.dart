import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/widgets/appbar.dart';
import 'package:pulse_mobile/widgets/bottombar.dart';

import '../../services/Stom_service.dart';
import '../../models/consent_request.dart';
import '../../theme/app_light_mode_colors.dart'; // Ensure this import is correct


class NotificationScreen1 extends StatelessWidget {
  const NotificationScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final StompService stompService = Get.find<StompService>();

    return Scaffold(
      appBar: CustomAppBar(titleText: 'Notification History'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Obx(
              () {
            if (stompService.consentHistory.isEmpty) {
              return const Center(
                child: Text(
                  'No consent requests found yet.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            } else {
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: stompService.consentHistory.length,
                itemBuilder: (context, index) {
                  final request = stompService.consentHistory[index];
                  Color statusColor;
                  String statusText;

                  switch (request.status) {
                    case 'PENDING':
                      statusColor = Colors.orange;
                      statusText = 'Pending';
                      break;
                    case 'APPROVE':
                      statusColor = Colors.green;
                      statusText = 'Allowed';
                      break;
                    case 'DENY':
                      statusColor = Colors.red;
                      statusText = 'Denied';
                      break;
                    default:
                      statusColor = Colors.grey;
                      statusText = 'Unknown';
                  }

                  // --- MODIFIED: Display receivedAt ---
                  final String formattedDate = request.receivedAt.toLocal().toString().split('.')[0];

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: AppLightModeColors.textFieldBorder,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.message,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Status: ',
                              style: TextStyle(fontSize: 16, color: AppLightModeColors.icons),
                            ),
                            Text(
                              statusText,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Received:', // --- MODIFIED: Display receivedAt label ---
                              style: TextStyle(fontSize: 16, color: AppLightModeColors.icons),
                            ),
                            Text(' $formattedDate',style: TextStyle(fontSize: 16, color: AppLightModeColors.icons,)
                            ),],
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}