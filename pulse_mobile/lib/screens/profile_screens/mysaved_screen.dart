import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/widgets/appbar.dart';
import '../../controllers/profile/mySavedProfile_controller.dart';
import '../../models/categoryModel.dart';
import '../../widgets/bottombar.dart';
import '../../widgets/rectangular_category_item.dart'; // Import the new widget

class MySavedPage extends StatelessWidget {
  final MySavedController controller = Get.put(MySavedController());

  MySavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'My Saved'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        } else if (controller.categories.isEmpty) {
          return const Center(child: Text('No categories available.'));
        } else {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: controller.categories.map((Category category) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: RectangularCategoryItem( // Use RectangularCategoryItem here
                    category: category,
                    onTap: () {
                      final savedItemIds =
                      controller.getSavedItemIds(category.title);
                      // Pass the category ID
                      _navigateToCategoryDetail(
                        context,
                        category.id, // Pass the category ID
                        category.title,
                        savedItemIds,
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          );
        }
      }),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  void _navigateToCategoryDetail(
      BuildContext context,
      int categoryId, // Receive the category ID
      String categoryName,
      List<String> savedItemIds,
      ) {
    String routeName = '';
    switch (categoryName) {
      case 'Doctors':
        routeName = '/savedDoctors';
        break;
      case 'Pharmacies':
        routeName = '/savedPharmacies';
        break;
      case 'Laboratories':
        routeName = '/savedLabs';
        break;
      default:
        routeName = '/unknown';
    }

    Get.toNamed(
      routeName,
      arguments: {
        'categoryId': categoryId, // Pass the ID
        'savedItemIds': savedItemIds,
      },
    );
  }
}