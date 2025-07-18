// lib/screens/prescriptions_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../controllers/medications/PrescriptionList_controller.dart';
import '../../theme/app_light_mode_colors.dart';
import '../../widgets/appbar.dart';
import '../../widgets/bottombar.dart';
import '../../widgets/prescriptionsListItem.dart'; // Ensure this widget exists and is correctly imported

class PrescriptionsScreen extends StatelessWidget {
  final PrescriptionController _controller = Get.put(PrescriptionController());
  final OutlineInputBorder _searchBarBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: const BorderSide(color: AppLightModeColors.blueText, width: 1.5),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(titleText: 'My Prescriptions'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller.searchController,
              onChanged: _controller.updateSearchQuery,
              style: const TextStyle(color: AppLightModeColors.blueText),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(color: AppLightModeColors.blueText),
                prefixIcon: const Icon(
                  FeatherIcons.search,
                  color: AppLightModeColors.blueText,
                ),
                border: _searchBarBorder,
                focusedBorder: _searchBarBorder,
                enabledBorder: _searchBarBorder,
              ),
            ),
          ),
          Expanded(
            child: Obx(
                  () {
                if (_controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (_controller.errorMessage.isNotEmpty) {
                  return Center(child: Text(_controller.errorMessage.value));
                } else if (_controller.prescriptions.isEmpty && _controller.searchQuery.isEmpty) {
                  return const Center(child: Text('No prescriptions found.',style: TextStyle(color: AppLightModeColors.normalText),));
                } else if (_controller.prescriptions.isEmpty && _controller.searchQuery.isNotEmpty) {
                  return const Center(child: Text('No prescriptions match your search.',style: TextStyle(color: AppLightModeColors.normalText),));
                } else {
                  final filteredPrescriptions = _controller.prescriptions.where((p) =>
                  p.doctorName.toLowerCase().contains(_controller.searchQuery.toLowerCase()) ||
                      p.doctorSpeciality.toLowerCase().contains(_controller.searchQuery.toLowerCase())).toList();
                  return ListView.builder(
                    itemCount: filteredPrescriptions.length,
                    itemBuilder: (context, index) {
                      final prescription = filteredPrescriptions[index];
                      // Removed the InkWell here, as it's now handled inside Prescriptionslistitem
                      return Prescriptionslistitem(
                        prescriptionId: prescription.id,
                        name: prescription.doctorName,
                        speciality: prescription.doctorSpeciality,
                        notes: prescription.notes,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
