import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/doctors/doctor_firstpage_controller.dart';
import '../../models/doctor_model_featured_homepage.dart';
import '../../widgets/appbar.dart';
import '../../widgets/bottombar.dart';
import '../../widgets/doctor_card.dart';
import '../../theme/app_light_mode_colors.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../widgets/square_category_item.dart'; // Import the SquareCategoryItem

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
        padding: const EdgeInsets.only(bottom: 20.0,left: 20,right: 20,top: 10),
        child: Obx(() {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row( // Added Row here
                  children: [
                    Expanded( // Added Expanded to make TextField take up available space
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0,),
                        child: TextField(
                          controller: _doctorFirstpageController.searchController,
                          onChanged: _doctorFirstpageController.updateSearchQuery,
                          style: const TextStyle(color: AppLightModeColors.blueText),
                          decoration: InputDecoration(
                            hintText: 'Name, Location, or Specialization',
                            hintStyle: const TextStyle(color: AppLightModeColors.blueText),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 10,), // Reduced padding here
                              child: const Icon(
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
                              vertical: 10.0, // Reduced vertical padding.  Original was 12.0
                              horizontal: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 7), // Add some spacing between TextField and Icon
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: IconButton( // Use IconButton for better touch interaction
                        icon: const Icon(
                          FeatherIcons.sliders,
                          size: 27, // Set the size
                          color: AppLightModeColors.blueText,
                        ),
                        onPressed: () {
                          //  Add functionality for the filter button here
                          //  For example:
                          //  Get.bottomSheet(FilterBottomSheet());
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10,),
                const Text(
                  // Added Text widget here
                  "Specialization",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10), // Add some spacing between the title and the list
                // Display Filter Categories
                SizedBox(
                  height: 140, // Adjust the height as needed
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _doctorFirstpageController.filterCategories.length,
                    itemBuilder: (context, index) {
                      final filter = _doctorFirstpageController.filterCategories[index];
                      return SquareCategoryItem(
                        data: filter,
                        onTap: () {
                          _doctorFirstpageController.updateSelectedFilter(filter['name']!);
                        },
                        imageKey: 'icon', // Use 'icon' as the imageKey
                        title: filter['name']!,
                      );
                    },
                  ),
                ),
                if (_doctorFirstpageController.searchQuery.isEmpty &&
                    _doctorFirstpageController.selectedFilter.isEmpty) // Show Featured
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                    ],
                  ),
                if (_doctorFirstpageController.searchQuery.isNotEmpty ||
                    _doctorFirstpageController.selectedFilter.isNotEmpty) // Show Searched
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Search Results',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Obx(() {
                        if (_doctorFirstpageController.isAllDoctorsLoading.value) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (_doctorFirstpageController.allDoctorsErrorMessage.isNotEmpty) {
                          return Center(child: Text(_doctorFirstpageController.allDoctorsErrorMessage.value));
                        } else if (_doctorFirstpageController.filteredDoctors.isEmpty) {
                          return Center( // Centered the message
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                              children: [
                                SizedBox(height: 50,),
                                Icon(
                                  FeatherIcons.search, // Error icon
                                  size: 80, // Big size
                                  color: AppLightModeColors.mainColor, // Subtle color
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'No doctors found matching your search.\nTry a different keyword!', // More appealing text
                                  textAlign: TextAlign.center, // Center text
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _doctorFirstpageController.filteredDoctors.length,
                            itemBuilder: (context, index) {
                              final generalDoctor = _doctorFirstpageController.filteredDoctors[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: DoctorCard(
                                  doctor: FeaturedDoctor(
                                    id: generalDoctor.id,
                                    fullName: generalDoctor.fullName,
                                    pictureUrl: generalDoctor.pictureUrl ?? '',
                                    specialization: generalDoctor.specialization ?? '',
                                    coordinates: generalDoctor.coordinates,
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      }),
                    ],
                  ),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
