import 'package:get/get.dart';
import 'mysavedDetails_controller.dart'; // Adjust path as needed

class MySavedDetailsBinding implements Bindings {
  @override
  void dependencies() {
    // Get arguments from Get.arguments when the binding is created
    // These arguments will be available when the controller is put/initialized
    final Map<String, dynamic> arguments = Get.arguments as Map<String, dynamic>;
    final String categoryName = arguments['categoryName'] ?? 'Items';
    final int categoryId = arguments['categoryId'] ?? 0;
    final List<String> savedItemIds = arguments['savedItemIds'] ?? [];

    Get.lazyPut<MySavedDetailsController>(
          () => MySavedDetailsController(
        categoryName: categoryName,
        categoryId: categoryId,
        savedItemIds: savedItemIds,
      ),
      tag: categoryName, // Use categoryName as tag for specific controller instance
    );
  }
}