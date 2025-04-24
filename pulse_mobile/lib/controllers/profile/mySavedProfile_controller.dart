import 'package:get/get.dart';
import '../../models/categoryModel.dart';
import '../../services/connections.dart';

class MySavedController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final RxList<Category> categories = <Category>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxMap<String, List<String>> savedItemIds = <String, List<String>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    final List<Category>? fetchedCategories = await _apiService.getCategories();
    isLoading.value = false;
    if (fetchedCategories != null) {
      categories.value = fetchedCategories;
      // Initialize savedItemIds based on fetched categories:
      for (var category in fetchedCategories) {
        savedItemIds[category.title] =
        []; // Initialize each category's saved items list.
      }
    } else {
      errorMessage.value = 'Failed to load categories.';
    }
  }

 /* void addItemId(String category, String itemId) {
    if (savedItemIds.containsKey(category)) {
      savedItemIds[category]?.add(itemId);
      update();
    }
  }

 void removeItemId(String category, String itemId) {
    if (savedItemIds.containsKey(category)) {
      savedItemIds[category]?.remove(itemId);
      update();
    }
  }*/

  //  Method to get saved item IDs for a category.
  List<String> getSavedItemIds(String category) {
    return savedItemIds[category] ?? [];
  }
}