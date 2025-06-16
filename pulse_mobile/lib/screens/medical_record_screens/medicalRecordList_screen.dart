import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:pulse_mobile/widgets/appbar.dart';
import 'package:pulse_mobile/widgets/bottombar.dart';

import '../../controllers/medical_record/medicalRecordDetails_controller.dart';
import '../../controllers/medical_record/medicalrecordList_controller.dart';
import '../../controllers/medical_record/labResult_controller.dart'; // Corrected import for LabResultDetailsController
import '../../models/LabResultsModel.dart'; // This now contains LabResultListItem
import '../../models/medicalrecordlistitemsModel.dart';
import '../../theme/app_light_mode_colors.dart';
import '../../widgets/medialRecordListItem.dart';
import 'labResult_screen.dart';
import 'medicalRecordDetails_screen.dart';

class MedicalRecordListScreen extends StatelessWidget {
  MedicalRecordListScreen({Key? key}) : super(key: key);

  final MedicalRecordController controller = Get.put(MedicalRecordController());

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
            padding: const EdgeInsets.only(top: 20.0,left: 20,right: 20,bottom: 10),
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
                fillColor: const Color(0xFFFBFBFB),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 16.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFilterPill(
                  context,
                  'Medical Events',
                  FilterType.medicalEvents,
                ),
                _buildFilterPill(
                  context,
                  'Lab Results',
                  FilterType.labResults,
                ),
              ],
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
                          style: const TextStyle(color:  AppLightModeColors.normalText, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => controller.fetchDataBasedOnFilter(controller.activeFilter.value),
                          child: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppLightModeColors.mainColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                else if (controller.filteredItems.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        Icon(
                          controller.searchQuery.isNotEmpty ? FeatherIcons.search : FeatherIcons.fileText,
                          size: 80,
                          color: AppLightModeColors.mainColor,
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            controller.searchQuery.isNotEmpty
                                ? 'No results found matching your search for ${controller.activeFilter.value == FilterType.medicalEvents ? 'Medical Events' : 'Lab Results'}.'
                                : 'No ${controller.activeFilter.value == FilterType.medicalEvents ? 'medical events' : 'lab results'} found.',
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
                }
                else {
                  return RefreshIndicator(
                    onRefresh: () => controller.refreshCurrentList(),
                    color: AppLightModeColors.mainColor,
                    child: ListView.builder(
                      itemCount: controller.filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = controller.filteredItems[index];

                        if (item is MedicalRecord) {
                          return MedicalRecordListItem(
                            title: item.type,
                            subtitle: item.recordDate,
                            imagePath: 'assets/mre.png',
                            onTap: () {
                              Get.to(
                                    () => MedicalRecordDetailsScreen(),
                                binding: BindingsBuilder(() {
                                  Get.put(MedicalRecordDetailsController(medicalRecordId: item.id));
                                }),
                              );
                            },
                          );
                        } else if (item is LabResultListItem) { // Changed to LabResultListItem
                          return MedicalRecordListItem(
                            title: item.testName,
                            subtitle: item.laboratory?.name ?? 'N/A', // Changed to display laboratory name
                            imagePath: 'assets/mre.png',
                            onTap: () {
                              Get.to(
                                    () => const LabResultDetailsScreen(),
                                binding: BindingsBuilder(() {
                                  Get.put(LabResultDetailsController(labResultId: item.testResultId));
                                }),
                              );
                            },
                          );
                        }
                        return const SizedBox.shrink();
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

  Widget _buildFilterPill(BuildContext context, String text, FilterType filterType) {
    return Obx(() {
      final isSelected = controller.activeFilter.value == filterType;
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ElevatedButton(
            onPressed: () => controller.setActiveFilter(filterType),
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? AppLightModeColors.textFieldBackground : Colors.white,
              foregroundColor: isSelected ? AppLightModeColors.icons : AppLightModeColors.icons,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(
                  color: isSelected ? AppLightModeColors.textFieldBorder : AppLightModeColors.textFieldBorder,
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              elevation: 0,
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: AppLightModeColors.normalText,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    });
  }
}
