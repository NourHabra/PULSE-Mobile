import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import '../../controllers/Labs/firstLab_controller.dart';
import '../../theme/app_light_mode_colors.dart';
import '../../widgets/LabCard.dart';
import '../../widgets/appbar.dart';
import '../../widgets/bottombar.dart';
// Screen
class FirstLabScreen extends StatelessWidget {
  final LabController labController = Get.put(LabController());
  final OutlineInputBorder _searchBarBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: const BorderSide(color: AppLightModeColors.blueText, width: 1.5),
  );

  FirstLabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Labs'),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20, top: 10),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextField(
                        controller: labController.searchController,
                        onChanged: labController.updateSearchQuery,
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
                        // Add functionality for the filter button here
                      },
                    ),
                  ),
                ],
              ),

              Expanded(
                child: labController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : labController.errorMessage.isNotEmpty
                    ? Center(child: Text(labController.errorMessage.value))
                    : labController.filteredLabs.isEmpty
                    ? Center( // Centered the message
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                    children: [
                      Icon(
                        FeatherIcons.search, // Error icon
                        size: 80,
                        color: AppLightModeColors.mainColor, // Subtle color
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No labs found matching your search.\nTry a different keyword!', // More appealing text
                        textAlign: TextAlign.center, // Center text
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
                  itemCount: labController.filteredLabs.length,
                  itemBuilder: (context, index) {
                    final lab = labController.filteredLabs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: LabCard(lab: lab),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

