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
  RxString selectedFilter = ''.obs; // Add this line
  final List<Map<String, String>> filterCategories = [  // Add this
    {'d_id': '101', 'name': 'Cardiologists', 'icon': 'assets/cardiology_600dp.png'},
    {'d_id': '102', 'name': 'Dermatologists', 'icon': 'assets/accessibility_600dp.png'},
    {'d_id': '103', 'name': 'Pediatricians', 'icon': 'assets/child_friendly_600dp.png'},
    {'d_id': '104', 'name': 'Neurologists', 'icon': 'assets/neurology_600dp_.png'},
    {'d_id': '105', 'name': 'Internal Medicine', 'icon': 'assets/gastroenterology_600dp.png'},
  ];

  @override
  void onInit() {
    super.onInit();
    fetchFeaturedDoctors();
    fetchAllDoctors();
    ever<String>(searchQuery, _filterDoctors);
    ever<String>(selectedFilter, _filterDoctors); // Listen to changes in selectedFilter
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
      filteredDoctors.assignAll(fetchedDoctors);
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

  void updateSelectedFilter(String value) { // Add this
    selectedFilter.value = value;
  }

  void _filterDoctors(String query) { // Modified
    List<GeneralDoctor> result = _allDoctors;

    if (query.isNotEmpty) {
      result = result.where((doctor) =>
      doctor.fullName.toLowerCase().contains(query.toLowerCase()) ||
          (doctor.specialization?.toLowerCase().contains(query.toLowerCase()) ?? false)).toList();
    }

    if (selectedFilter.isNotEmpty) {
      result = result.where((doctor) =>
      doctor.specialization?.toLowerCase() == selectedFilter.toLowerCase()).toList();
    }

    filteredDoctors.assignAll(result);
  }

  @override
  void onClose() {
    searchController.dispose();
    searchQuery.value = ''; // Clear the search query
    selectedFilter.value = ''; // Clear the selected filter.
    super.onClose();
  }
}