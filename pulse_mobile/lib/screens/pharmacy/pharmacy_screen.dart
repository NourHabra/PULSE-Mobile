// lib/screens/pharmacy_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/widgets/appbar.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../controllers/pharmacy/pharmacy_controller.dart';
import '../../theme/app_light_mode_colors.dart';
import '../../widgets/bottombar.dart';
import '../../widgets/pharmacy_card.dart';
import 'pharmacy_details_screen.dart'; // Import the new pharmacy details screen

class PharmacyScreen extends StatelessWidget {
  const PharmacyScreen({super.key});

  // Define the common border style for the search bar
  final OutlineInputBorder _searchBarBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
    borderSide: BorderSide(color: AppLightModeColors.blueText, width: 1.5),
  );

  @override
  Widget build(BuildContext context) {
    // Initialize PharmacyController if it's not already initialized.
    final PharmacyController controller = Get.put(PharmacyController());

    return Scaffold(
      appBar: const CustomAppBar(titleText: 'Pharmacies'),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20, top: 10),
        child: Obx(
              () {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar and filter icon row
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextField(
                          controller: controller.searchController,
                          onChanged: (value) => controller.updateSearchQuery(value),
                          style: const TextStyle(color: AppLightModeColors.blueText),
                          decoration: InputDecoration(
                            hintText: 'Search by Name or Address',
                            hintStyle: const TextStyle(color: AppLightModeColors.blueText),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(
                                FeatherIcons.search,
                                color: AppLightModeColors.blueText,
                              ),
                            ),
                            border: _searchBarBorder,
                            focusedBorder: _searchBarBorder,
                            enabledBorder: _searchBarBorder,
                            fillColor: const Color(0xFFFBFBFB),
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: IconButton(
                        icon: const Icon(
                          FeatherIcons.sliders,
                          size: 27,
                          color: AppLightModeColors.blueText,
                        ),
                        onPressed: () {
                          // Add functionality for the filter button here if needed
                        },
                      ),
                    ),
                  ],
                ),

                // Conditional display for loading, error, empty, or list states
                Expanded(
                  child: controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : controller.errorMessage.isNotEmpty && controller.pharmacies.isEmpty
                      ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 50),
                          const SizedBox(height: 10),
                          Text(
                            controller.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16, color: Colors.red),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => controller.fetchPharmacies(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppLightModeColors.blueText,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                      : controller.filteredPharmacies.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FeatherIcons.search,
                          size: 80,
                          color: AppLightModeColors.mainColor,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          controller.searchQuery.isEmpty
                              ? 'No pharmacies found.'
                              : 'No pharmacies found matching "${controller.searchQuery.value}".\nTry a different keyword!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: controller.filteredPharmacies.length,
                    itemBuilder: (context, index) {
                      final pharmacy = controller.filteredPharmacies[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: InkWell( // Wrap PharmacyCard with InkWell for tap functionality
                          onTap: () {
                            Get.to(
                                  () => const PharmacyDetailsScreen(), // Navigate to PharmacyDetailsScreen
                              arguments: {'pharmacyId': pharmacy.pharmacyId}, // Pass the pharmacyId
                            );
                          },
                          borderRadius: BorderRadius.circular(10.0), // Match card border radius
                          child: PharmacyCard(pharmacy: pharmacy),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
