// lib/widgets/prescriptions_list_item_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart';
import 'package:get/get.dart';

import '../controllers/medications/PrescriptionList_controller.dart';

class Prescriptionslistitem extends StatelessWidget {
  final String name;
  final String speciality;
  final String notes; // Changed from untilDate
  final int prescriptionId;

  const Prescriptionslistitem({
    super.key,
    required this.name,
    required this.speciality,
    required this.notes, // Changed from untilDate
    required this.prescriptionId,
  });

  @override
  Widget build(BuildContext context) {
    final PrescriptionController controller = Get.find<PrescriptionController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: InkWell(
        onTap: () {
          controller.goToPrescriptionDetail(prescriptionId);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppLightModeColors.textFieldBorder,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:AppLightModeColors.normalText,
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    speciality,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppLightModeColors.blueText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      const Text(
                        "Notes: ", // Changed text
                        style: TextStyle(
                          fontSize: 15,
                          color: AppLightModeColors.blueText,
                        ),
                      ),
                      Text(
                        notes, // Changed from untilDate
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppLightModeColors.blueText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Icon(

                FeatherIcons.chevronRight,
                color: AppLightModeColors.blueText,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}