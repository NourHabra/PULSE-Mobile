// lib/controllers/pharmacy/pharmacy_controller.dart

import 'package:flutter/material.dart'; // Required for TextEditingController
import 'package:get/get.dart';

import '../../models/pharmacy.dart';
import '../../services/connections.dart';


class PharmacyController extends GetxController {
  final RxList<PharmacylistModel> pharmacies = <PharmacylistModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;


  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxList<PharmacylistModel> filteredPharmacies = <PharmacylistModel>[].obs;

  final ApiService _apiService = Get.find<ApiService>();

  @override
  void onInit() {
    super.onInit();
    fetchPharmacies();

    ever(pharmacies, (_) => _filterPharmacies());

    debounce(searchQuery, (_) => _filterPharmacies(), time: const Duration(milliseconds: 300));

    searchController.addListener(() {
      updateSearchQuery(searchController.text);
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void _filterPharmacies() {
    if (searchQuery.isEmpty) {
      filteredPharmacies.assignAll(pharmacies);
    } else {
      final lowerCaseQuery = searchQuery.value.toLowerCase();
      filteredPharmacies.assignAll(pharmacies.where((pharmacy) {
        return pharmacy.name.toLowerCase().contains(lowerCaseQuery) ||
            pharmacy.address.toLowerCase().contains(lowerCaseQuery);
      }).toList());
    }
  }

  Future<void> fetchPharmacies() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final fetchedPharmacies = await _apiService.fetchPharmacies();
      pharmacies.assignAll(fetchedPharmacies);
    } catch (e) {
      errorMessage.value = 'Failed to load pharmacies: ${e.toString()}';
      print('Error in PharmacyController: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
