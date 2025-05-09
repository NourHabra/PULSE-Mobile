import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../services/connections.dart';
import '../../models/doctor_model_featured_homepage.dart';

class DoctorFirstpageController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  // Featured Doctors
  RxList<FeaturedDoctor> featuredDoctors = <FeaturedDoctor>[].obs;
  RxBool isFeaturedLoading = true.obs;
  RxString featuredErrorMessage = ''.obs;

  // All Doctors
  RxList<FeaturedDoctor> _allDoctors = <FeaturedDoctor>[].obs;
  RxList<FeaturedDoctor> get allDoctors => _allDoctors;
  RxBool isAllDoctorsLoading = true.obs;
  RxString allDoctorsErrorMessage = ''.obs;

  // Search Functionality
  final TextEditingController searchController = TextEditingController();
  RxString searchQuery = ''.obs;
  RxList<FeaturedDoctor> filteredDoctors = <FeaturedDoctor>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFeaturedDoctors();
    fetchAllDoctors();
    ever<String>(searchQuery, _filterDoctors);
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
      final List<FeaturedDoctor> fetchedDoctors = data
          .map((json) => FeaturedDoctor.fromJson(json as Map<String, dynamic>))
          .toList();
      _allDoctors.assignAll(fetchedDoctors);
      filteredDoctors.assignAll(fetchedDoctors); // Initially, filtered list is all doctors
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

  void _filterDoctors(String query) {
    if (query.isEmpty) {
      filteredDoctors.assignAll(_allDoctors);
    } else {
      filteredDoctors.value = _allDoctors.where((doctor) =>
      doctor.fullName.toLowerCase().contains(query.toLowerCase()) ||
          doctor.specialization.toLowerCase().contains(query.toLowerCase())).toList();
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}