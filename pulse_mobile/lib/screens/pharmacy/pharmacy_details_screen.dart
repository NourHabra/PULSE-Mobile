// lib/screens/pharmacy_screens/pharmacy_details_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'dart:math';

import '../../controllers/pharmacy/pharmacy_details_controller.dart';
import '../../theme/app_light_mode_colors.dart';
import '../../widgets/GoogleMapsEmbed.dart'; // Ensure this import is correct
import '../../widgets/appbar.dart';
import '../../widgets/bottombar.dart';
import '../doctor_screens/googleMapPage.dart'; // Import GoogleMapPage for navigation


class PharmacyDetailsScreen extends StatelessWidget {
  const PharmacyDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int pharmacyId = Get.arguments['pharmacyId'] as int;
    final PharmacyDetailsController _pharmacyDetailsController = Get.put(PharmacyDetailsController());

    _pharmacyDetailsController.fetchPharmacyDetails(pharmacyId);

    return Scaffold(
      appBar: CustomAppBar(titleText: 'Pharmacy Details'),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, right: 20, left: 20),
        child: Obx(() {
          if (_pharmacyDetailsController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (_pharmacyDetailsController.errorMessage.value.isNotEmpty) {
            return Center(child: Text(_pharmacyDetailsController.errorMessage.value));
          } else if (_pharmacyDetailsController.pharmacy.value == null) {
            return const Center(child: Text('No pharmacy details found.'));
          } else {
            final pharmacy = _pharmacyDetailsController.pharmacy.value!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Heart icon for saving/unsaving
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0, left: 10),
                      child: IconButton(
                        icon: Icon(
                          _pharmacyDetailsController.isFavorited.value
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: AppLightModeColors.mainColor,
                          size: 30,
                        ),
                        onPressed: () {
                          _pharmacyDetailsController.toggleFavoriteStatus(pharmacyId);
                        },
                      ),
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Always display the asset image 'assets/pill_600dp.png' in the top-left
                        SizedBox(
                          width: 135,
                          height: 135,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.asset(
                              'assets/pill_600dp.png', // Explicitly use the asset image
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  pharmacy.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppLightModeColors.normalText,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Pharmacy',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppLightModeColors.blueText,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (pharmacy.phone != null && pharmacy.phone!.isNotEmpty)
                                  Row(
                                    children: [
                                      const Icon(FeatherIcons.phone, size: 18, color: AppLightModeColors.blueText),
                                      const SizedBox(width: 8),
                                      Text(
                                        pharmacy.phone!,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: AppLightModeColors.blueText,
                                        ),
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    const Icon(FeatherIcons.mapPin, size: 18, color: AppLightModeColors.blueText),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        pharmacy.address,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: AppLightModeColors.blueText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height:40),

                  // Map Embed section (moved here)
                  if (_pharmacyDetailsController.mapUrl.value.isNotEmpty)
                    InkWell(
                      onTap: () {
                        Get.to(
                              () => GoogleMapPage(mapUrl: _pharmacyDetailsController.mapUrl.value),
                        );
                        print('Navigating to GoogleMapPage with mapUrl: ${_pharmacyDetailsController.mapUrl.value}');
                      },
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: SizedBox(
                            height: 250, // Fixed height for the map
                            width: double.infinity, // Take full width
                            child: GoogleMapsEmbed(
                              googleMapsUrl: _pharmacyDetailsController.mapUrl.value,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 40), // Spacing after the map

                  const Text(
                    'Working Hours',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: AppLightModeColors.normalText),
                  ),
                  const SizedBox(height: 15),
                  if (pharmacy.workingHours != null && pharmacy.workingHours!.isNotEmpty)
                    Row(
                      children: [
                        const Icon(FeatherIcons.clock, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            pharmacy.workingHours!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      'Working hours not available.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
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
}
