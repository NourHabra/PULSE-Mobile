import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/medications/currentMedications_controller.dart';
import '../../widgets/appbar.dart';
import '../../widgets/bottombar.dart';
import '../../widgets/currentMedication.dart';

class CurrentMedicationsScreen extends StatelessWidget {
  final CurrentMedicationsController _controller = Get.put(CurrentMedicationsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(titleText: 'Current Medications'),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Obx(
              () {
            if (_controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (_controller.errorMessage.isNotEmpty) {
              return Center(child: Text(_controller.errorMessage.value));
            } else if (_controller.medications.isEmpty) {
              return const Center(child: Text('No current medications found.'));
            } else {
              return ListView.builder(
                itemCount: _controller.medications.length,
                itemBuilder: (context, index) {
                  final medication = _controller.medications[index];
                  return Currentmedication(
                    // Pass the correct fields from the updated Medication model
                    name: medication.name, // Changed from tradeName to name
                    activeSubstance: medication.activeSubstance, // Changed from pharmaComposition
                    dosage: medication.dosage, // New field for dosage
                    duration: medication.duration, // New field for duration
                    prescribedDate: medication.prescribedDate, // Changed from untilDate to prescribedDate
                  );
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}