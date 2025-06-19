import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/services/connections.dart';

import '../../models/LabResultsModel.dart';
import '../../models/medicalrecordlistitemsModel.dart';

enum FilterType { medicalEvents, labResults }

class MedicalRecordController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final RxList<MedicalRecord> medicalRecords = <MedicalRecord>[].obs;
  final RxList<LabResultListItem> labResults = <LabResultListItem>[].obs; // New list for lab results

  final RxList<dynamic> filteredItems = <dynamic>[].obs; // To hold either MedicalRecords or LabResultListItems
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  final Rx<FilterType> activeFilter = FilterType.medicalEvents.obs; // Default filter


  @override
  void onInit() {
    super.onInit();
    fetchDataBasedOnFilter(activeFilter.value);
    debounce(searchQuery, (_) => _filterItems(), time: const Duration(milliseconds: 300));
    ever(activeFilter, (_) => fetchDataBasedOnFilter(activeFilter.value));
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setActiveFilter(FilterType filter) {
    if (activeFilter.value != filter) {
      activeFilter.value = filter;
      searchQuery.value = '';
      searchController.clear();
    }
  }

  Future<void> fetchDataBasedOnFilter(FilterType filter) async {
    isLoading(true);
    errorMessage('');
    try {
      if (filter == FilterType.medicalEvents) {
        await fetchMedicalRecords();
      } else { // FilterType.labResults
        await fetchLabResults();
      }
      _filterItems();
    } catch (e) {
      errorMessage('Failed to load data: $e');
      print('Error in MedicalRecordController.fetchDataBasedOnFilter: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchMedicalRecords() async {
    try {
      isLoading(true);
      errorMessage('');
      final fetchedRecords = await _apiService.getMedicalRecords();
      medicalRecords.assignAll(fetchedRecords);
    } catch (e) {
      errorMessage('Failed to load medical records: $e');
      print('Error fetching medical records: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchLabResults() async {
    try {
      isLoading(true);
      errorMessage('');
      final fetchedResults = await _apiService.getLabResults();
      labResults.assignAll(fetchedResults);
    } catch (e) {
      errorMessage('Failed to load lab results: $e');
      print('Error fetching lab results: $e');
    } finally {
      isLoading(false);
    }
  }

  void _filterItems() {
    String query = searchQuery.value.toLowerCase();
    if (activeFilter.value == FilterType.medicalEvents) {
      if (query.isEmpty) {
        filteredItems.assignAll(medicalRecords.where((record) => !record.hasLabResult).toList());
      } else {
        filteredItems.assignAll(
          medicalRecords.where((record) =>
          !record.hasLabResult &&
              (record.type.toLowerCase().contains(query) ||
                  record.recordDate.toLowerCase().contains(query))
          ).toList(),
        );
      }
    } else {
      if (query.isEmpty) {
        filteredItems.assignAll(labResults);
      } else {
        filteredItems.assignAll(
          labResults.where((result) =>
          result.testName.toLowerCase().contains(query) ||
              result.formattedDate.toLowerCase().contains(query) ||
              (result.laboratory?.name?.toLowerCase().contains(query) ?? false) // Add laboratory name search
          ).toList(),
        );
      }
    }
  }

  Future<void> refreshMedicalRecords() async {
    await fetchMedicalRecords();
    _filterItems();
  }

  Future<void> refreshLabResults() async {
    await fetchLabResults();
    _filterItems();
  }

  Future<void> refreshCurrentList() async {
    if (activeFilter.value == FilterType.medicalEvents) {
      await refreshMedicalRecords();
    } else {
      await refreshLabResults();
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}