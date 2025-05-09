import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/widgets/appbar.dart';
import 'package:pulse_mobile/widgets/bottombar.dart';
import 'package:pulse_mobile/widgets/homeAppBar.dart';
import 'package:pulse_mobile/widgets/square_category_item.dart';
import 'package:string_2_icon/string_2_icon.dart';
import '../../controllers/home1_controller.dart';
import 'package:pulse_mobile/widgets/vital_card_homepage.dart';
import '../../models/categoryModel.dart';
import '../../theme/app_light_mode_colors.dart';
import '../../widgets/Emergncy_button_homepage.dart';

import '../../widgets/circular_doctor_widget_homepage.dart';
import '../doctor_screens/first_doctor_screen.dart';
import '../lab_screens/first_lab_screen.dart'; // Import the FeaturedDoctor model

class HomeScreen1 extends StatelessWidget {
  const HomeScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      appBar: const HomeAppBar(titleText: 'Home'),
      bottomNavigationBar: CustomBottomNavBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildMainCategoryList(controller),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: _buildVitalsSection(controller),
              ),
              const SizedBox(height: 30),
              _buildEmergencyButton(),
              const SizedBox(height: 20), // Add some space below the emergency button
              _buildFeaturedDoctorsList(controller), // Add the featured doctors list
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyButton() {
    return EmergencyButton(
      text: 'Request Emergency Medical Services',
      onPressed: () {
        print('Request Emergency Medical Services button pressed!');
      },
      icon: Icons.local_shipping,
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
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 160, // Adjust the height as needed
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
                      id: doctor.id.toString(),
                      name: doctor.fullName,
                      radius: 40.0,
                      onTap: () {


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
          return Center(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.mainCategories.length,
              itemBuilder: (context, index) {
                final category = controller.mainCategories[index];
                return Center(
                  child: SizedBox(
                    width: 120,
                    child: SquareCategoryItem(
                      data: category,
                      onTap: () {
                        if (category.title.toLowerCase() == 'doctors') {
                          Get.to(() =>  FirstDoctorScreen());
                        } else if (category.title.toLowerCase() == 'labs') {
                          Get.to(() => FirstLabScreen());
                        }                    },
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

  Widget _buildVitalsSection(HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Obx(() {
          if (controller.loadingVitals.isTrue) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.vitalsErrorMessage.isNotEmpty) {
            return Center(
              child: Text(
                controller.vitalsErrorMessage.value,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (controller.vitalsList.isEmpty) {
            return const Center(
              child: Text(
                'No vitals data available.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          } else {
            return LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = (constraints.maxWidth - 10) / 2; // Adjust spacing as needed
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
                      'Updated ${difference.inHours} hour${difference.inHours == 1
                          ? ''
                          : 's'} ago';
                    } else if (difference.inDays < 7) {
                      timeAgo =
                      'Updated ${difference.inDays} day${difference.inDays == 1
                          ? ''
                          : 's'} ago';
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
                      height: Get.width / 2.8, // Keep the height consistent
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
            );
          }
        }),
      ],
    );
  }
  }