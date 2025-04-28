// lib/controllers/prescription_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/prescriptionListitemModel.dart';
import '../../screens/medicalDrug_screens/prescriptionList_screen.dart';
import '../../services/connections.dart';
// Import the detail screen

class PrescriptionController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  RxList<Prescription> _allPrescriptions = <Prescription>[].obs;
  RxList<Prescription> get prescriptions => _allPrescriptions;
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;
  final TextEditingController searchController = TextEditingController();
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPrescriptions();
    ever<String>(searchQuery, _filterPrescriptions);
  }

  Future<void> fetchPrescriptions() async {
    isLoading(true);
    errorMessage('');
    try {
      final List<Prescription> fetchedPrescriptions = await _apiService.getPrescriptions();
      _allPrescriptions.assignAll(fetchedPrescriptions);
    } catch (e) {
      errorMessage('Failed to load prescriptions: $e');
    } finally {
      isLoading(false);
    }
  }

  void goToPrescriptionDetail(int prescriptionId) {
    //Get.to(() => PrescriptionsScreen(prescriptionId: prescriptionId));
  }

  void updateSearchQuery(String value) {
    searchQuery.value = value;
  }

  void _filterPrescriptions(String query) {
    if (query.isEmpty) {
      _allPrescriptions.refresh(); // Trigger UI update with the original list
    } else {
      _allPrescriptions.value = _allPrescriptions.where((p) =>
      p.doctorName.toLowerCase().contains(query.toLowerCase()) ||
          p.doctorSpeciality.toLowerCase().contains(query.toLowerCase())).toList();
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}