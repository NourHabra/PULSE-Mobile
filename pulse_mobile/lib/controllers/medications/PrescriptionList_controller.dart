import 'package:flutter/material.dart'; // Import for Get.snackbar colors
import 'package:get/get.dart';
import '../../models/prescriptionListitemModel.dart';
import '../../services/connections.dart';

class PrescriptionController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  RxList<Prescription> _allPrescriptions = <Prescription>[].obs;
  // This will hold the unfiltered list of prescriptions for filtering purposes
  List<Prescription> _originalPrescriptions = [];

  RxList<Prescription> get prescriptions => _allPrescriptions;
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;
  final TextEditingController searchController = TextEditingController();
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPrescriptions();
    // Use debounce to prevent frequent filtering on every keystroke
    debounce(searchQuery, _filterPrescriptions, time: const Duration(milliseconds: 300));
  }

  Future<void> fetchPrescriptions() async {
    isLoading(true);
    errorMessage('');
    try {
      final List<Prescription> fetchedPrescriptions = await _apiService.getPrescriptions();
      _originalPrescriptions = fetchedPrescriptions; // Store the original fetched list
      _allPrescriptions.assignAll(fetchedPrescriptions); // Assign to observable list
    } catch (e) {
      errorMessage('Failed to load prescriptions: $e');
      Get.snackbar('Error', 'Failed to load prescriptions: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  // <--- IMPORTANT CHANGE IS HERE --->
  void goToPrescriptionDetail(int prescriptionId) {
    print('Navigating to /prescription-details with ID: $prescriptionId'); // Debugging print
    Get.toNamed(
      '/prescription-details',
      arguments: prescriptionId,
    );
  }

  void updateSearchQuery(String value) {
    searchQuery.value = value;
  }

  void _filterPrescriptions(String query) {
    if (query.isEmpty) {
      _allPrescriptions.assignAll(_originalPrescriptions); // Reset to original list
    } else {
      // Adjusted filtering logic to use direct properties from the Prescription model
      _allPrescriptions.assignAll(_originalPrescriptions.where((p) =>
      p.doctorName.toLowerCase().contains(query.toLowerCase()) || // Use p.doctorName directly
          p.doctorSpeciality.toLowerCase().contains(query.toLowerCase()) // Use p.doctorSpeciality directly
      ).toList());
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
