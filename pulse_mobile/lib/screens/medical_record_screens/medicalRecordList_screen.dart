import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:pulse_mobile/widgets/appbar.dart';
import 'package:pulse_mobile/widgets/bottombar.dart';

import '../../controllers/medical_record/medicalRecordDetails_controller.dart';
import '../../controllers/medical_record/medicalrecordList_controller.dart';
import '../../theme/app_light_mode_colors.dart';
import '../../widgets/medialRecordListItem.dart';
import 'medicalRecordDetails_screen.dart'; // For FeatherIcons

class MedicalRecordListScreen extends StatelessWidget {
  MedicalRecordListScreen({Key? key}) : super(key: key);

  final MedicalRecordController controller = Get.put(MedicalRecordController());

  // Define the search bar border here to reuse it
  final OutlineInputBorder _searchBarBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: const BorderSide(color: AppLightModeColors.blueText, width: 1.5),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Medical Record'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0), // Keep initial padding
            child: TextField(
              controller: controller.searchController,
              onChanged: (value) => controller.updateSearchQuery(value),
              style: const TextStyle(color: AppLightModeColors.blueText),
              decoration: InputDecoration(
                hintText: 'Search for a record Entry',
                hintStyle: const TextStyle(color: AppLightModeColors.blueText),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Icon(
                    FeatherIcons.search,
                    color: AppLightModeColors.blueText,
                  ),
                ),
                border: _searchBarBorder,
                focusedBorder: _searchBarBorder,
                enabledBorder: _searchBarBorder,
                fillColor: const Color(0xFFFBFBFB), // Set the fill color here
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 16.0,
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(
                  () {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.errorMessage.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => controller.fetchMedicalRecords(),
                          child: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppLightModeColors.mainColor, // Use your primary color
                          ),
                        ),
                      ],
                    ),
                  );
                }
                // Check filteredMedicalRecords for emptiness when displaying search results
                else if (controller.filteredMedicalRecords.isEmpty && controller.searchQuery.isNotEmpty) {
                  // If a search query is active but no results are found
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                      children: [
                        SizedBox(height: 50,), // Add some space from the top
                        Icon(
                          FeatherIcons.search, // Search icon
                          size: 80,
                          color: AppLightModeColors.mainColor,
                        ),
                        const SizedBox(height: 20),
                        Padding(

                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'No medical records found matching your search',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (controller.medicalRecords.isEmpty && controller.searchQuery.isEmpty) {
                  // Original message when no records are loaded at all AND no search is active
                  return Center(
                    child: Text(
                      'No medical records found.',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  );
                }
                else {
                  // Display filteredMedicalRecords
                  return RefreshIndicator(
                    onRefresh: () => controller.refreshMedicalRecords(),
                    color: AppLightModeColors.mainColor, // Refresh indicator color
                    child: ListView.builder(
                      itemCount: controller.filteredMedicalRecords.length, // <-- USE FILTERED LIST HERE
                      itemBuilder: (context, index) {
                        final record = controller.filteredMedicalRecords[index]; // <-- USE FILTERED LIST HERE
                        return MedicalRecordListItem(
                          record: record,

                          onTap: () {
                            // Handle tap on a medical record item, e.g., navigate to details
                            Get.to(
                                    () => MedicalRecordDetailsScreen(),
                                binding: BindingsBuilder(() {
                              Get.put(MedicalRecordDetailsController(medicalRecordId: record.id));
                            }),
                            );
                          },
                        );
                      },
                    ),
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