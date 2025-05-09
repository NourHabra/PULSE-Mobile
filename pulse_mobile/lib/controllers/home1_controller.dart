import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../services/connections.dart';
import '../../models/categoryModel.dart';
import '../models/doctor_model_featured_homepage.dart';
import '../models/vitals_model.dart'; // Import for Icons

class HomeController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();

  // Reactive variables for main categories
  final RxList<Category> mainCategories = <Category>[].obs;
  final RxBool loadingMainCategories = true.obs;
  final RxString mainCategoriesErrorMessage = ''.obs;

  // Reactive variables for vitals
  final RxList<Vital> vitalsList = <Vital>[].obs;
  final RxBool loadingVitals = true.obs;
  final RxString vitalsErrorMessage = ''.obs;

  // Reactive variables for featured doctors
  final RxList<FeaturedDoctor> featuredDoctors = <FeaturedDoctor>[].obs;
  final RxBool loadingFeaturedDoctors = false.obs;
  final RxString featuredDoctorsErrorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMainCategories();
    fetchPatientVitals();
    fetchFeaturedDoctors();
  }

  // Fetch main categories
  Future<void> fetchMainCategories() async {
    loadingMainCategories.value = true;
    mainCategoriesErrorMessage.value = '';

    try {
      final fetchedCategories = await apiService.getCategories();
      mainCategories.assignAll(fetchedCategories);
      loadingMainCategories.value = false;
    } catch (error) {
      loadingMainCategories.value = false;
      if (error is Exception) {
        mainCategoriesErrorMessage.value = error.toString();
      } else {
        mainCategoriesErrorMessage.value = 'An unexpected error occurred';
      }
      mainCategories.clear();
      mainCategories.add(Category(id: 0, title: 'Error', imageUrl: ''));
      print('Error fetching main categories: $error');
    }
  }

  Future<void> fetchPatientVitals() async {
    loadingVitals.value = true;
    vitalsErrorMessage.value = '';
    try {
      final vitalsData = await apiService.getPatientVitals(); // Now returns List<Vital>?
      if (vitalsData != null) {
        vitalsList.assignAll(vitalsData); // Assign the list of Vital objects
      } else {
        vitalsErrorMessage.value = 'No Vitals Data';
        vitalsList.clear();
      }
      loadingVitals.value = false;
    } catch (error) {
      loadingVitals.value = false;
      if (error is Exception) {
        vitalsErrorMessage.value = error.toString();
      } else {
        vitalsErrorMessage.value = 'An unexpected error occurred';
      }
      print('Error fetching patient vitals: $error');
    }
  }

  Future<void> fetchFeaturedDoctors() async {
    loadingFeaturedDoctors.value = true;
    featuredDoctorsErrorMessage.value = '';
    try {
      final fetchedDoctors = await apiService.fetchFeaturedDoctorsFromApi();
      featuredDoctors.assignAll(fetchedDoctors);
      loadingFeaturedDoctors.value = false;
      if (fetchedDoctors.isEmpty) {
        featuredDoctorsErrorMessage.value = 'No featured doctors available.';
      }
    } catch (error) {
      loadingFeaturedDoctors.value = false;
      if (error is Exception) {
        featuredDoctorsErrorMessage.value = error.toString();
      } else {
        featuredDoctorsErrorMessage.value = 'An unexpected error occurred';
      }
      featuredDoctors.clear(); // Clear any previous data on error
      print('Error fetching featured doctors: $error');
    }
  }

  Color getVitalCardColor(String? vitalName) {
    if (vitalName == null) {
      return Colors.blueAccent; // Or any default color you prefer
    }
    switch (vitalName.toLowerCase()) {
      case 'temperature':
        return Colors.orangeAccent;
      case 'heart rate':
        return const Color(0xFF4DA8F6);
      case 'blood pressure':
        return const Color(0xFF3286B2);
      case 'oxygen saturation':
        return const Color(0xFF74D2FD);
      case 'blood sugar':
        return const Color(0xFF65E6EB);
      default:
        return Colors.blueAccent;
    }
  }

  IconData getVitalIcon(String? vitalName) {
    if (vitalName == null) {
      return Icons.healing; // Or a default icon.
    }
    switch (vitalName.toLowerCase()) {
      case 'temperature':
        return Icons.thermostat;
      case 'heart rate':
        return FeatherIcons.heart;
      case 'blood pressure':
        return FeatherIcons.activity;
      case 'oxygen saturation':
        return FeatherIcons.droplet; // Changed to droplet for oxygen
      case 'blood sugar':
        return FeatherIcons.box; // Changed to box for blood sugar
      default:
        return Icons.healing; // Default icon
    }
  }
}