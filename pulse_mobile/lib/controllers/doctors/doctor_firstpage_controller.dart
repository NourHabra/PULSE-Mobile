import 'package:get/get.dart';

import '../../models/doctor_category_model.dart';
import '../../services/connections.dart';


class DoctorCategoryController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  RxBool isLoading = true.obs;
  RxBool hasError = false.obs;
  RxList<DoctorCategory> doctorCategories = <DoctorCategory>[].obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    fetchDoctorCategories();
    super.onInit();
  }

  Future<void> fetchDoctorCategories() async {
    try {
      isLoading(true);
      hasError(false);
      errorMessage('');
      final List<dynamic> response = await _apiService.fetchcategoryData('doctor_categories'); // Adjust the endpoint
      final List<DoctorCategory> fetchedCategories = response.map((json) => DoctorCategory.fromJson(json)).toList();
      doctorCategories.assignAll(fetchedCategories);
    } catch (e) {
      hasError(true);
      errorMessage('Failed to load doctor categories. Please try again.');
      print('Error fetching doctor categories: $e');
    } finally {
      isLoading(false);
    }
  }
}
