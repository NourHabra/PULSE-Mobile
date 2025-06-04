import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'dart:math';

import '../../controllers/Labs/LabDetails_controller.dart';
import '../../theme/app_light_mode_colors.dart';
import '../../widgets/GoogleMapsEmbed.dart';
import '../../widgets/appbar.dart';
import '../../widgets/bottombar.dart';
import '../../widgets/testItemCard.dart';

class LabDetailsScreen extends StatelessWidget {
  final LabDetailsController _labDetailsController = Get.put(LabDetailsController());

  @override
  Widget build(BuildContext context) {
    final int labId = Get.arguments['labId'] as int;
    // Calling fetchLabDetails here is important for the initial state of the heart icon
    _labDetailsController.fetchLabDetails(labId);

    return Scaffold(
      appBar: CustomAppBar(titleText: 'Lab Details'),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20.0,right: 20,left: 20),
        child: Obx(() {
          if (_labDetailsController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (_labDetailsController.errorMessage.value.isNotEmpty) {
            return Center(child: Text(_labDetailsController.errorMessage.value));
          } else if (_labDetailsController.lab.value == null) {
            return const Center(child: Text('No lab details found.'));
          } else {
            final lab = _labDetailsController.lab.value!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NEW: Heart icon
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0, left: 10),
                      child: IconButton(
                        icon: Icon(
                          _labDetailsController.isFavorited.value // Use observable from controller
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: AppLightModeColors.mainColor, // Or a color that suits your theme
                          size: 30,
                        ),
                        onPressed: () {
                          _labDetailsController.toggleFavoriteStatus(labId);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20,), // Adjusted spacing after new icon

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_labDetailsController.mapEmbedUrl.value.isNotEmpty)
                          SizedBox(
                            width: 135,
                            height: 135,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: GoogleMapsEmbed(
                                googleMapsUrl: _labDetailsController.mapEmbedUrl.value,
                              ),
                            ),
                          )
                        else
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Icon(
                                FeatherIcons.map,
                                size: 70,
                                color: AppLightModeColors.blueText,
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
                                  lab.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Laboratory',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppLightModeColors.blueText,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (lab.phone != null && lab.phone!.isNotEmpty)
                                  Row(
                                    children: [
                                      const Icon(FeatherIcons.phone, size: 18, color: AppLightModeColors.blueText),
                                      const SizedBox(width: 8),
                                      Text(
                                        lab.phone!,
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
                                        lab.address,
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
                  SizedBox(height: 20),

                  // Available Tests Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Available Tests',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed('/alltestsforlab', arguments: {'labId': labId});
                        },
                        child: Text(
                          'See all',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppLightModeColors.blueText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Obx(() {
                    if (_labDetailsController.isTestsLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (_labDetailsController.testsErrorMessage.value.isNotEmpty) {
                      return Center(child: Text(_labDetailsController.testsErrorMessage.value));
                    } else if (_labDetailsController.labTests.isEmpty) {
                      return const Center(child: Text('No tests available for this lab.'));
                    } else {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 15.0,
                          childAspectRatio: 118 / 170,
                        ),
                        itemCount: min(_labDetailsController.labTests.length, 6),
                        itemBuilder: (context, index) {
                          final test = _labDetailsController.labTests[index];
                          return TestItemCard(
                            imageUrl: test.imageUrl,
                            title: test.name,
                            price: test.price,
                          );
                        },
                      );
                    }
                  }),

                  const SizedBox(height: 30),
                  const Text(
                    'Working Hours',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  if (lab.workingHours != null && lab.workingHours!.isNotEmpty)
                    Row(
                      children: [
                        const Icon(FeatherIcons.clock, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            lab.workingHours!,
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