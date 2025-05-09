import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/doctors/doctor_firstpage_controller.dart';
import '../../widgets/appbar.dart';
import '../../widgets/bottombar.dart';
import '../../widgets/doctor_card.dart'; // Import the DoctorCard widget
import '../../theme/app_light_mode_colors.dart'; // Import your color theme
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class FirstDoctorScreen extends StatelessWidget {
  final DoctorFirstpageController _doctorFirstpageController = Get.put(DoctorFirstpageController());
  final OutlineInputBorder _searchBarBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: const BorderSide(color: AppLightModeColors.blueText, width: 1.5),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(titleText: 'Doctors'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextField(
                    controller: _doctorFirstpageController.searchController,
                    onChanged: _doctorFirstpageController.updateSearchQuery,
                    style: const TextStyle(color: AppLightModeColors.blueText),
                    decoration: InputDecoration(
                      hintText: 'Search Doctors',
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
                const SizedBox(height: 10),
                const Text(
                  'Featured Doctors',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Obx(() {
                  if (_doctorFirstpageController.isFeaturedLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (_doctorFirstpageController.featuredErrorMessage.value.isNotEmpty) {
                    return Center(child: Text(_doctorFirstpageController.featuredErrorMessage.value));
                  } else if (_doctorFirstpageController.featuredDoctors.isEmpty) {
                    return const Center(child: Text('No featured doctors available.'));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _doctorFirstpageController.featuredDoctors.length,
                      itemBuilder: (context, index) {
                        final featuredDoctor = _doctorFirstpageController.featuredDoctors[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DoctorCard(doctor: featuredDoctor),
                        );
                      },
                    );
                  }
                }),
                const SizedBox(height: 20),
                const Text(
                  'All Doctors',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Obx(() {
                  if (_doctorFirstpageController.isAllDoctorsLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (_doctorFirstpageController.allDoctorsErrorMessage.isNotEmpty) {
                    return Center(child: Text(_doctorFirstpageController.allDoctorsErrorMessage.value));
                  }
                  if (_doctorFirstpageController.filteredDoctors.isEmpty && _doctorFirstpageController.searchQuery.isNotEmpty) {
                    return const Center(child: Text('No doctors match your search.'));
                  }
                  if (_doctorFirstpageController.allDoctors.isEmpty && _doctorFirstpageController.searchQuery.isEmpty) {
                    return const Center(child: Text('No doctors available.'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _doctorFirstpageController.filteredDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = _doctorFirstpageController.filteredDoctors[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: DoctorCard(doctor: doctor),
                      );
                    },
                  );
                }),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}