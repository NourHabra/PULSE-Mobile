import 'package:get/get.dart';
import 'package:flutter/material.dart'; // Import for TextEditingController
import '../../models/medicalrecordlistitemsModel.dart';
import '../../services/connections.dart';

class MedicalRecordController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final RxList<MedicalRecord> medicalRecords = <MedicalRecord>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  final TextEditingController searchController = TextEditingController();
  RxString searchQuery = ''.obs;
  RxList<MedicalRecord> filteredMedicalRecords = <MedicalRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMedicalRecords();
    ever<String>(searchQuery, (_) => _filterMedicalRecords());
  }


  Future<void> fetchMedicalRecords() async {
    try {
      isLoading(true);
      errorMessage('');
      final List<MedicalRecord> fetchedRecords = await _apiService.getMedicalRecords();
      medicalRecords.assignAll(fetchedRecords);
      filteredMedicalRecords.assignAll(fetchedRecords); // Initialize filtered list
    } catch (e) {
      errorMessage('Failed to load medical records. Please try again. Error: $e');
      print('Error in MedicalRecordController: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> refreshMedicalRecords() async {
    searchQuery.value = '';
    searchController.clear();
    await fetchMedicalRecords();
  }

  void updateSearchQuery(String value) {
    searchQuery.value = value;
  }

  void _filterMedicalRecords() {
    List<MedicalRecord> result = medicalRecords;

    if (searchQuery.isNotEmpty) {
      result = result.where((record) {
        final query = searchQuery.value.toLowerCase();
        // Check if type contains the query OR recordDate contains the query
        return record.type.toLowerCase().contains(query) ||
            record.recordDate.toLowerCase().contains(query);
      }).toList();
    }

    filteredMedicalRecords.assignAll(result);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}