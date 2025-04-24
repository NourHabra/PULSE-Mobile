import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pulse_mobile/widgets/bottombar.dart';
import 'package:get/get.dart';
import '../../controllers/profile/profile_controller.dart';
import '../../theme/app_light_mode_colors.dart';
import '../../widgets/profileMenuOption.dart';
import '../../widgets/infoCard.dart';

class ProfileScreen1 extends GetView<ProfileController> {
  // GetX requires you to define the controller.
  @override
  final ProfileController controller = Get.put(ProfileController());

  ProfileScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.errorMessage.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          } else if (controller.profile.value == null) { // Use controller.profile
            return const Center(child: Text('No profile data available.'));
          } else {
            final profile = controller.profile.value!; // Get the Profile object

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Gradient Container Start
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xFF007BFF),
                          Color(0xFF00B8D4),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.only(bottom: 50, top: 90),
                    child: Column(
                      children: [
                        // Profile Image
                        _buildProfileImage(profile.pictureUrl), // Use profile.pictureUrl
                        const SizedBox(height: 16),
                        // User Name.  Since Profile doesn't have first/last name,
                        //  we display a placeholder or empty string.  You might
                        //  fetch this from another source if available.
                        Text(
                          'User Name', //  Change this as needed.
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Blood Type, Weight, Height Section
                        Row(
                          children: [
                            Expanded(
                              child: InfoCard(
                                context: context,
                                title: 'Blood Type',
                                content: profile.bloodType ?? 'N/A', // Use profile.bloodType
                                icon: Icons.water_drop,
                              ),
                            ),
                            _buildVerticalDivider(),
                            Expanded(
                              child: InfoCard(
                                context: context,
                                title: 'Weight',
                                content: profile.weight != null
                                    ? '${profile.weight} kg' // Use profile.weight
                                    : 'N/A',
                                icon: Icons.fitness_center,
                              ),
                            ),
                            _buildVerticalDivider(),
                            Expanded(
                              child: InfoCard(
                                context: context,
                                title: 'Height',
                                content: profile.height != null
                                    ? '${profile.height} cm' // Use profile.height
                                    : 'N/A',
                                icon: Icons.accessibility,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Gradient Container End

                  // Menu Options
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    transform: Matrix4.translationValues(0, -15, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Column(children: [
                        MenuOption(
                          title: 'My Saved',
                          icon: Icons.favorite_border,
                          onTap: () {
                            Get.toNamed('/saved');
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          // Add horizontal padding
                          child: Divider(
                              color: AppLightModeColors.textFieldBorder),
                        ),
                        MenuOption(
                          title: 'Edit Profile',
                          icon: Icons.person_outline,
                          onTap: () {
                            Get.toNamed('/editProfile');
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          // Add horizontal padding
                          child: Divider(
                              color: AppLightModeColors.textFieldBorder),
                        ),
                        MenuOption(
                          title: 'Settings',
                          icon: Icons.settings_outlined,
                          onTap: () {
                            Get.toNamed('/settings');
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          // Add horizontal padding
                          child: Divider(
                              color: AppLightModeColors.textFieldBorder),
                        ),
                        MenuOption(
                          title: 'Medications & Prescriptions',
                          icon: Icons.medical_services_outlined,
                          onTap: () {
                            Get.toNamed('/med&pres');

                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          // Add horizontal padding
                          child: Divider(
                              color: AppLightModeColors.textFieldBorder),
                        ),
                        MenuOption(
                          title: 'Logout',
                          icon: Icons.logout,
                          onTap: () {
                            controller.logout();
                          },
                          isRed: true,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  // Extracted method for profile image
  Widget _buildProfileImage(String? imageUrl) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.blue,
          width: 2,
        ),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl ??
              'https://via.placeholder.com/150', // Use the provided imageUrl
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1.0,
      height: 60.0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
    );
  }
}

