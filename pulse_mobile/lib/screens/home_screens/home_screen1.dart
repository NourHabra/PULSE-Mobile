import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/widgets/bottombar.dart';
import 'package:pulse_mobile/widgets/homeAppBar.dart';
import 'package:pulse_mobile/widgets/square_category_item.dart';
import '../../controllers/home1_controller.dart';
import 'package:pulse_mobile/widgets/vital_card_homepage.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../widgets/Emergncy_button_homepage.dart';
import '../../widgets/circular_doctor_widget_homepage.dart';
import '../doctor_screens/first_doctor_screen.dart';
import '../emergencyEvents_screens/emergencyEvent_screen.dart';
import '../lab_screens/first_lab_screen.dart';
import '../../theme/app_light_mode_colors.dart'; // Import your colors for consistent styling

// Import the DoctorDetailsScreen
import '../doctor_screens/doctor_details_screen.dart';
import '../pharmacy/pharmacy_screen.dart'; // <--- ADD THIS IMPORT

class HomeScreen1 extends StatelessWidget {
  const HomeScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      appBar: const HomeAppBar(titleText: 'Home'),
      bottomNavigationBar: CustomBottomNavBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildMainCategoryList(controller),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: _buildVitalsSection(controller),
                  ),
                  const SizedBox(height: 25),
                  EmergencyButton(
                    onPressed:() {
                      Get.toNamed('/emergency_events');
                      print('Navigating to emergency events');
                    },
                    text: 'View Personal Emergency Events',
                  ),
                  const SizedBox(height: 25),
                  _buildFeaturedDoctorsList(controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedDoctorsList(HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Featured Doctors',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w600,
            color: AppLightModeColors.normalText,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 170,
          child: Obx(() {
            if (controller.loadingFeaturedDoctors.isTrue) {
              return const Center(child: CircularProgressIndicator());
            } else if (controller.featuredDoctorsErrorMessage.isNotEmpty) {
              return Center(
                child: Text(
                  controller.featuredDoctorsErrorMessage.value,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (controller.featuredDoctors.isEmpty) {
              return const Center(
                child: Text(
                  'No featured doctors available.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            } else {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.featuredDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = controller.featuredDoctors[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularDoctorWidget(
                      imageUrl: doctor.pictureUrl,
                      id: doctor.id.toString(), // Ensure doctor.id is used here
                      name: doctor.fullName,
                      radius: 40.0,
                      onTap: () {
                        // MODIFIED: Navigate to DoctorDetailsScreen and pass doctor.id
                        Get.to(
                              () => DoctorDetailsScreen(),
                          arguments: {
                            'doctorId': doctor.id, // Pass the actual doctor ID
                          },
                        );
                        print('Navigating to doctor details for: ${doctor.fullName} (ID: ${doctor.id})');
                      },
                    ),
                  );
                },
              );
            }
          }),
        ),
      ],
    );
  }

  Widget _buildMainCategoryList(HomeController controller) {
    return SizedBox(
      height: 120,
      child: Obx(() {
        if (controller.loadingMainCategories.isTrue) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.mainCategories.isEmpty) {
          return const Center(
            child: Text(
              'No main categories available',
              style: TextStyle(color: Colors.grey),
            ),
          );
        } else if (controller.mainCategories.first.title == 'Error') {
          return Center(
            child: Text(
              controller.mainCategoriesErrorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else {
          print('Loaded Main Categories: ${controller.mainCategories.map((c) => c.title).toList()}');

          return Center(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.mainCategories.length,
              itemBuilder: (context, index) {
                final category = controller.mainCategories[index];
                return Center(
                  child: SizedBox(
                    width: 131,
                    child: SquareCategoryItem(
                      data: category,
                      onTap: () {
                        print('Tapped Category: ${category.title}');

                        if (category.title.toLowerCase() == 'doctors') {
                          Get.to(() => FirstDoctorScreen());
                        } else if (category.title.toLowerCase() == 'laboratories') {
                          Get.to(() => FirstLabScreen());
                        } else if (category.title.toLowerCase() == 'pharmacies') {
                          Get.to(() => PharmacyScreen());
                        } else {
                          print('Unhandled category tap: ${category.title}');
                        }
                      },
                      imageKey: 'url',
                      title: category.title,
                    ),
                  ),
                );
              },
            ),
          );
        }
      }),
    );
  }

  void _showComingSoonDialog(BuildContext context) {
    print('Showing Coming Soon dialog...');
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Coming Soon...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color:  AppLightModeColors.normalText,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    print('Coming Soon dialog dismissed.');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppLightModeColors.mainColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildVitalsSection(HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Obx(() {
          if (controller.loadingVitals.isTrue) {
            return const Center(child: CircularProgressIndicator());
          } else {
            // Use a Column to stack the message (if any) and the vital cards
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Only show the message if vitalsErrorMessage is not empty
                if (controller.vitalsErrorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      controller.vitalsErrorMessage.value,
                      // Change color to grey if it's just an informative message,
                      // or keep red for actual errors.
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),

                // Now, always attempt to build the vital cards if the list is not empty
                if (controller.vitalsList.isEmpty)
                  const Center(
                    child: Text(
                      'No vitals data available.', // This should ideally only show if _createDefaultVitals also failed (highly unlikely)
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cardWidth = (constraints.maxWidth - 9) / 2;
                      return Wrap(
                        spacing: 9,
                        runSpacing: 9,
                        children: controller.vitalsList.map((vital) {
                          final now = DateTime.now();
                          final difference = now.difference(vital.timestamp);
                          String timeAgo;

                          if (difference.inMinutes < 60) {
                            timeAgo = 'Updated ${difference.inMinutes} min ago';
                          } else if (difference.inHours < 24) {
                            timeAgo =
                            'Updated ${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
                          } else if (difference.inDays < 7) {
                            timeAgo =
                            'Updated ${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
                          } else if (difference.inDays < 30) {
                            final weeks = (difference.inDays / 7).floor();
                            timeAgo = 'Updated ${weeks} week${weeks == 1 ? '' : 's'} ago';
                          } else if (difference.inDays < 365) {
                            final months = (difference.inDays / 30).floor();
                            timeAgo =
                            'Updated ${months} month${months == 1 ? '' : 's'} ago';
                          } else {
                            final years = (difference.inDays / 365).floor();
                            timeAgo =
                            'Updated ${years} year${years == 1 ? '' : 's'} ago';
                          }

                          return SizedBox(
                            width: cardWidth,
                            child: VitalCard(
                              color: controller.getVitalCardColor(vital.name),
                              topText: vital.name,
                              middleMainText: vital.measurement,
                              middleSubText: '',
                              bottomText: timeAgo,
                              icon: controller.getVitalIcon(vital.name),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
              ],
            );
          }
        }),
      ],
    );

  }
}