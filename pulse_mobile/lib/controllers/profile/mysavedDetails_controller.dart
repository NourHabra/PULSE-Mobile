// lib/controllers/profile/mysavedDetails_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/connections.dart';
import '../../models/mySavedDoctor_model.dart';
import '../../models/mySavedLab_model.dart';
import '../../models/mySavedPharmacy_model.dart';

class MySavedDetailsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final RxList<dynamic> savedItems = <dynamic>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  final String categoryName;
  final int categoryId;
  final List<String> savedItemIds; // This might become redundant for filtering purposes

  MySavedDetailsController({
    required this.categoryName,
    required this.categoryId,
    required this.savedItemIds,
  });


  @override
  void onInit() {
    super.onInit();
    print('MySavedDetailsController initialized for: $categoryName');
    print('Initial savedItemIds passed to controller: $savedItemIds');
    fetchSavedItems();
  }

  Future<void> fetchSavedItems() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      List<dynamic>? rawFetchedData;
      List<dynamic>? convertedModels;

      switch (categoryName) {
        case 'Doctors':
          rawFetchedData = await _apiService.fetchData('/patient/saved/doctor');
          if (rawFetchedData != null) {
            convertedModels = rawFetchedData.map((json) => SavedDoctorModel.fromJson(json)).toList();
          }
          break;
        case 'Pharmacies':
          rawFetchedData = await _apiService.fetchData('/patient/saved/pharmacy');
          if (rawFetchedData != null) {
            convertedModels = rawFetchedData.map((json) => PharmacyModel.fromJson(json)).toList();
          }
          break;
        case 'Laboratories':
          rawFetchedData = await _apiService.fetchData('/patient/saved/laboratory');
          if (rawFetchedData != null) {
            convertedModels = rawFetchedData.map((json) => SavedLaboratoryModel.fromJson(json)).toList();
          }
          break;
        default:
          errorMessage.value = 'Invalid category: $categoryName';
          isLoading.value = false;
          return;
      }

      if (convertedModels != null) {
        print('Fetched and converted models count for $categoryName: ${convertedModels.length}');
        // As discussed, if the API directly returns only saved items,
        // you can assign all fetched models directly without further filtering.
        savedItems.assignAll(convertedModels);
      } else {
        errorMessage.value = 'Failed to load saved $categoryName (convertedModels is null).';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString().split(':').last}';
      print('Error fetching saved items in controller: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeSavedItem(dynamic itemToRemove) async {

    int? idToRemove;
    String? itemName; // For snackbar message

    // Determine the type of item and extract its ID for the API call
    if (itemToRemove is SavedDoctorModel) {
      idToRemove = itemToRemove.doctorUserId; // Use doctorUserId for Doctors
      itemName = 'Doctor';
      print('Attempting to remove saved Doctor with ID: $idToRemove');
    } else if (itemToRemove is SavedLaboratoryModel) {
      idToRemove = itemToRemove.id;
      itemName = 'Laboratory';
      print('Attempting to remove saved Laboratory with ID: $idToRemove');
    } else if (itemToRemove is PharmacyModel) {
      idToRemove = itemToRemove.id; // Use 'id' for PharmacyModel
      itemName = 'Pharmacy';
      print('Attempting to remove saved Pharmacy with ID: $idToRemove');
    } else {
      print('Unknown item type encountered for removal.');
      return; // Exit if item type is unknown
    }

    if (idToRemove == null) {
      Get.snackbar('Error', 'Could not get ID for item removal.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      // Make the specific API call based on the item type
      if (itemToRemove is SavedDoctorModel) {
        await _apiService.removeSavedDoctor(idToRemove);
      } else if (itemToRemove is SavedLaboratoryModel) {
        await _apiService.removeSavedLaboratory(idToRemove);
      }

      // If API call is successful, remove the item from the observable list
      savedItems.removeWhere((item) {
        dynamic currentItemId;
        if (item is SavedDoctorModel) currentItemId = item.doctorUserId;
        else if (item is SavedLaboratoryModel) currentItemId = item.id;
        else if (item is PharmacyModel) currentItemId = item.id; // Though not removed, keeping consistent
        return currentItemId == idToRemove;
      });



      Get.snackbar('Success', '$itemName removed from saved.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.snackBarTheme.backgroundColor?.withOpacity(0.9) ?? Colors.green,
        colorText: Get.theme.snackBarTheme.actionTextColor ?? Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove $itemName: ${e.toString().split(':').last}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.snackBarTheme.backgroundColor?.withOpacity(0.9) ?? Colors.red,
        colorText: Get.theme.snackBarTheme.actionTextColor ?? Colors.white,
      );
      print('Error removing saved item: $e');
    }
  }
}