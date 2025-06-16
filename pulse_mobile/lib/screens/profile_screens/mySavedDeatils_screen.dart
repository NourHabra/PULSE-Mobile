// lib/screens/profile_screens/mySavedDeatils_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile/mysavedDetails_controller.dart';
import '../../models/mySavedDoctor_model.dart';
import '../../models/mySavedLab_model.dart';
import '../../models/mySavedPharmacy_model.dart';
import '../../theme/app_light_mode_colors.dart';
import '../../widgets/appbar.dart';
import '../../widgets/bottombar.dart';
import '../../widgets/mySavedCard.dart';

class MySavedDetailsPage extends StatelessWidget {
  const MySavedDetailsPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final String categoryNameTag = Get.arguments['categoryName'] ?? 'Items';
    final MySavedDetailsController controller = Get.find<MySavedDetailsController>(tag: categoryNameTag);

    final String categoryName = controller.categoryName;

    return Scaffold(
      appBar: CustomAppBar(titleText: 'Saved $categoryName', ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        } else if (controller.savedItems.isEmpty) {
          return Center(child: Text('No saved ${categoryName.toLowerCase()}.',style: TextStyle(color: AppLightModeColors.normalText),));
        } else {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView.builder(
              itemCount: controller.savedItems.length,
              itemBuilder: (context, index) {
                final item = controller.savedItems[index];

                String imageUrl;
                String name;
                String description;
                String type;
                VoidCallback? cardOnTap; // NEW: Define a callback for card tap

                if (item is SavedDoctorModel) {
                  imageUrl = item.pictureUrl ?? '';
                  name = item.fullName;
                  description = item.specialization ?? 'N/A';
                  type = 'doctor';
                  // NEW: Navigation for Doctor
                  cardOnTap = () {
                    Get.toNamed('/doctordetails', arguments: {'doctorId': item.doctorUserId});
                  };
                } else if (item is SavedLaboratoryModel) {
                  imageUrl = item.pictureUrl ?? '';
                  name = item.name ?? '';
                  description = item.address ?? 'N/A';
                  type = 'laboratory';
                  // NEW: Navigation for Lab
                  cardOnTap = () {
                    Get.toNamed('/labdetails', arguments: {'labId': item.laboratoryId});
                  };
                } else if (item is PharmacyModel) {
                  imageUrl = item.pictureUrl ?? '';
                  name = item.name ?? '';
                  description = item.address ?? 'N/A';
                  type = 'pharmacy';
                  // NEW: Navigation for Pharmacy (if applicable, or keep null)
                  cardOnTap = () {
                     Get.toNamed('/pharmacydetails', arguments: {'pharmacyId': item.id});
                    // For now, no specific navigation for pharmacies, or add your pharmacy route.

                  };
                } else {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: MySavedCard(
                    imageUrl: imageUrl,
                    name: name,
                    description: description,
                    type: type,
                    onFavoriteTap: () {
                      controller.removeSavedItem(item);
                    },
                    onTap: cardOnTap, // NEW: Pass the navigation callback
                  ),
                );
              },
            ),
          );
        }
      }),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}