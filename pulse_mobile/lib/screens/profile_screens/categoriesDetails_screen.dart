import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavedDoctorsPage extends StatelessWidget {
  const SavedDoctorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
    Get.arguments as Map<String, dynamic>; // Get the arguments
    final int categoryId = args['categoryId'] as int;
    final List<String> savedDoctorIds = args['savedItemIds'] as List<String>;

    //  Use categoryId and savedDoctorIds to fetch and display doctor data
    //  Example (you'll need to adapt this):
    //  final doctorDetails = await fetchDoctorDetails(savedDoctorIds);  //  your method
    return Scaffold(
      appBar: AppBar(title: const Text('Doctors')),
      body: Center(
        child: Column(
          children: [
            Text('Category ID: $categoryId'),
            Text('Saved Doctor IDs: $savedDoctorIds'),
            //  Display doctor details here
          ],
        ),
      ),
    );
  }
}