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
                  child: RectangularCategoryItem(
                    category: category,
                    onTap: () {
                      final savedItemIds =
                      controller.getSavedItemIds(category.title);

                      _navigateToCategoryDetail(
                        context,
                        category.id,
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
      int categoryId,
      String categoryName,
      List<String> savedItemIds,
      ) {
    Get.toNamed(
      '/savedDetails', // Use the correct route name
      arguments: {
        'categoryId': categoryId,
        'savedItemIds': savedItemIds,
        'categoryName': categoryName, // Pass categoryName here
      },
    );
  }
}
