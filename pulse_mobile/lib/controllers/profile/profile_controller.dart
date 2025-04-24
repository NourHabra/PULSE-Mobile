// lib/controllers/profile_controller.dart
import 'package:get/get.dart';
import '../../models/profile_model.dart';
import '../../services/connections.dart';


class ProfileController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final RxBool isLoading = true.obs;
  final Rxn<Profile> profile = Rxn<Profile>(); // Use the Profile model
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final fetchedProfile = await apiService.getUserProfile();
      if (fetchedProfile != null) {
        profile.value = fetchedProfile;
      } else {
        errorMessage.value = 'Failed to load profile data.';
      }
    } catch (error) {
      errorMessage.value = 'Error: ${error.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    Get.offAllNamed('/login');
  }
}
