// lib/views/doctor_details_screen.dart (no change needed here)
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/widgets/appbar.dart';
import '../../controllers/doctors/doctor_details_controller.dart';
import '../../theme/app_light_mode_colors.dart';
import '../../widgets/GoogleMapsEmbed.dart'; // Ensure this import is correct
import '../../widgets/bottombar.dart';
import 'googleMapPage.dart'; // Ensure this import is correct


class DoctorDetailsScreen extends StatefulWidget {
  @override
  _DoctorDetailsScreenState createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  late final DoctorDetailsController _doctorDetailsController;
  late final int doctorId;

  @override
  void initState() {
    super.initState();
    _doctorDetailsController = Get.put(DoctorDetailsController());
    final Map<String, dynamic> arguments = Get.arguments as Map<String, dynamic>;
    doctorId = arguments['doctorId'] as int;
    _doctorDetailsController.fetchDoctorDetails(doctorId);
  }

  @override
  void dispose() {
    Get.delete<DoctorDetailsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Doctor Details',
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 10.0, right: 10, left: 10),
        child: Obx(() {
          if (_doctorDetailsController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (_doctorDetailsController.errorMessage.value.isNotEmpty) {
            return Center(child: Text(_doctorDetailsController.errorMessage.value));
          } else if (_doctorDetailsController.doctor.value == null) {
            return const Center(child: Text('No doctor details found.'));
          } else {
            final doctor = _doctorDetailsController.doctor.value!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0, left: 10),
                      child: Transform.translate(
                        offset: const Offset(0, 0),
                        child: IconButton(
                          icon: Icon(
                            _doctorDetailsController.isFavorited.value
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            color: AppLightModeColors.mainColor,
                            size: 30,
                          ),
                          onPressed: () {
                            _doctorDetailsController.toggleFavoriteStatus(doctorId);
                          },
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            doctor.pictureUrl ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.person),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctor.fullName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              doctor.specialization ?? 'Not available',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppLightModeColors.blueText,
                              ),
                            ),
                            const SizedBox(height: 15),
                            if (doctor.mobileNumber != null)
                              Row(
                                children: [
                                  const Icon(
                                    FeatherIcons.phone,
                                    color: AppLightModeColors.blueText,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${doctor.mobileNumber}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppLightModeColors.blueText,
                                    ),
                                  ),
                                ],
                              ),
                            SizedBox(
                              height: 3,
                            ),
                            if (doctor.email != null)
                              Row(
                                children: [
                                  const Icon(
                                    FeatherIcons.mail,
                                    color: AppLightModeColors.blueText,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${doctor.email}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppLightModeColors.blueText,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'About',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    doctor.biography ?? 'Biography not available.',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),

                  // Wrap the map container with InkWell for tapping
                  InkWell(
                    onTap: () {
                      // Pass doctor.coordinates to the GoogleMapPage
                      if (doctor.coordinates != null && doctor.coordinates!.isNotEmpty) {
                        Get.to(
                              () => GoogleMapPage(mapUrl: doctor.coordinates!),
                        );
                        print('Navigating to GoogleMapPage with coordinates: ${doctor.coordinates}');
                      } else {
                        Get.snackbar(
                          'Map Error',
                          'Map coordinates are not available for this doctor.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red.withOpacity(0.8),
                          colorText: Colors.white,
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,

                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),

                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: SizedBox(
                          height: 250,
                          width: double.infinity,
                          child: GoogleMapsEmbed(
                            googleMapsUrl: _doctorDetailsController.mapUrl.value, // Pass mapUrl to embed
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (doctor.address != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        children: [
                          const Icon(
                            FeatherIcons.mapPin,
                            color: AppLightModeColors.blueText,
                            size: 15,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                              child: Text(
                                doctor.address!,
                                style: const TextStyle(
                                    color: AppLightModeColors.blueText,
                                    fontSize: 16),
                              )),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (doctor.workingHours != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Opening Hours',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          doctor.workingHours!,
                          style:
                          const TextStyle(color: Colors.grey, fontSize: 16),
                        )
                      ],
                    ),
                ],
              ),
            );
          }
        }),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}