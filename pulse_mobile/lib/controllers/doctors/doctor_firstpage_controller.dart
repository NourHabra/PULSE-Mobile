// lib/controllers/doctor_firstpage_controller.dart

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../models/generalDoctorModel.dart';
import '../../services/connections.dart';
import '../../models/doctor_model_featured_homepage.dart';

class DoctorFirstpageController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  // Featured Doctors
  RxList<FeaturedDoctor> featuredDoctors = <FeaturedDoctor>[].obs;
  RxBool isFeaturedLoading = true.obs;
  RxString featuredErrorMessage = ''.obs;

  // All Doctors
  RxList<GeneralDoctor> _allDoctors = <GeneralDoctor>[].obs;
  RxList<GeneralDoctor> get allDoctors => _allDoctors;
  RxBool isAllDoctorsLoading = true.obs;
  RxString allDoctorsErrorMessage = ''.obs;

  // Search Functionality
  final TextEditingController searchController = TextEditingController();
  RxString searchQuery = ''.obs;
  RxList<GeneralDoctor> filteredDoctors = <GeneralDoctor>[].obs;

  // Filter Functionality
  RxString selectedFilter = ''.obs;
  final List<Map<String, String>> filterCategories = [
    {'d_id': '101', 'name': 'Cardiology', 'icon': 'assets/cardiology_600dp.png'},
    {'d_id': '102', 'name': 'Dermatology', 'icon': 'assets/accessibility_600dp.png'},
    {'d_id': '103', 'name': 'Pediatrics', 'icon': 'assets/child_friendly_600dp.png'},
    {'d_id': '104', 'name': 'Neurology', 'icon': 'assets/neurology_600dp_.png'},
    {'d_id': '105', 'name': 'Internal Medicine', 'icon': 'assets/gastroenterology_600dp.png'},
  ];

  @override
  void onInit() {
    super.onInit();
    fetchFeaturedDoctors();
    fetchAllDoctors();
    ever<String>(searchQuery, _filterDoctors);
    ever<String>(selectedFilter, _filterDoctors);
  }

  Future<void> fetchFeaturedDoctors() async {
    isFeaturedLoading(true);
    featuredErrorMessage('');
    try {
      final fetchedDoctors = await _apiService.fetchFeaturedDoctorsFromApi();
      featuredDoctors.assignAll(fetchedDoctors);
    } catch (e) {
      featuredErrorMessage('Failed to load featured doctors: $e');
    } finally {
      isFeaturedLoading(false);
    }
  }

  Future<void> fetchAllDoctors() async {
    isAllDoctorsLoading(true);
    allDoctorsErrorMessage('');
    try {
      final List<dynamic> data = await _apiService.getAllDoctors();
      final List<GeneralDoctor> fetchedDoctors = data
          .map((json) => GeneralDoctor.fromJson(json as Map<String, dynamic>))
          .toList();
      _allDoctors.assignAll(fetchedDoctors);
      _filterDoctors(searchQuery.value);
    } catch (e) {
      allDoctorsErrorMessage('Failed to load doctors: $e');
      _allDoctors.clear();
      filteredDoctors.clear();
    } finally {
      isAllDoctorsLoading(false);
    }
  }

  void updateSearchQuery(String value) {
    searchQuery.value = value;
  }

  void updateSelectedFilter(String value) {
    selectedFilter.value = value;
  }

  void _filterDoctors(String? _) {
    List<GeneralDoctor> result = _allDoctors;

    final String lowerCaseQuery = searchQuery.value.toLowerCase();
    final String lowerCaseFilter = selectedFilter.value.toLowerCase();

    // Apply search query filter if not empty
    if (lowerCaseQuery.isNotEmpty) {
      result = result.where((doctor) {
        final bool matchesName = doctor.fullName.toLowerCase().contains(lowerCaseQuery);
        final bool matchesSpecialization = (doctor.specialization?.toLowerCase().contains(lowerCaseQuery) ?? false);
        final bool matchesAddress = (doctor.address?.toLowerCase().contains(lowerCaseQuery) ?? false);

        return matchesName || matchesSpecialization || matchesAddress;
      }).toList();
    }

    // Apply category filter if not empty
    if (lowerCaseFilter.isNotEmpty) {
      result = result.where((doctor) =>
      (doctor.specialization?.toLowerCase() == lowerCaseFilter)
      ).toList();
    }

    filteredDoctors.assignAll(result);
  }


  @override
  void onClose() {
    searchController.dispose();
    searchQuery.value = '';
    selectedFilter.value = '';
    super.onClose();
  }
}