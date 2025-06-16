// QrScannerController.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/connections.dart'; // Import your ApiService
import '../theme/app_light_mode_colors.dart'; // Import your colors for consistent styling

class QrScannerController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final MobileScannerController scannerController = MobileScannerController();

  RxString scanResult = ''.obs;
  RxBool _isScannerActive = false.obs;
  bool get isScannerActive => _isScannerActive.value;

  RxBool _isProcessingScan = false.obs; // To prevent multiple API calls for the same QR

  @override
  void onInit() {
    super.onInit();
    _startScanner(); // Start scanner immediately when controller is initialized
  }

  void onDetect(BarcodeCapture capture) async {
    if (_isProcessingScan.value) {
      return; // Prevent re-processing if already handling a scan
    }

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      _isProcessingScan.value = true; // Set flag to true

      final Barcode barcode = barcodes.first;
      final String? rawValue = barcode.rawValue;

      if (rawValue != null && rawValue.isNotEmpty) {
        scanResult.value = rawValue;
        print('Scanned QR Code: ${scanResult.value}');

        _stopScanner(); // Stop the scanner immediately after a successful detection

        // Attempt to parse doctor ID
        try {
          final int doctorId = int.parse(rawValue); // QR should contain just the doctor ID as an integer
          Get.showSnackbar(
            GetSnackBar(
              message: 'QR Code Scanned: Doctor ID $doctorId. Sending consent...',
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.blueAccent,
              snackPosition: SnackPosition.TOP,
            ),
          );

          final bool success = await _apiService.postConsentForDoctor(doctorId);

          if (success) {
            _showConsentSuccessDialog(doctorId); // Call the custom success dialog
          } else {
            Get.snackbar(
              'Failed',
              'An error occurred while sending consent. Please try again.', // User-friendly message
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } on FormatException {
          Get.snackbar(
            'Error',
            'Invalid QR Code. Please ensure you are scanning a valid Doctor ID.', // User-friendly message
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        } catch (e) {
          Get.snackbar(
            'Error',
            'An unexpected error occurred. Please try again.', // User-friendly message
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } finally {
          _isProcessingScan.value = false; // Reset flag
          // If we didn't navigate back, restart scanner for next scan (e.g., if API call fails)
          if (Get.currentRoute == '/QrScannerScreen') { // Check if still on scanner screen
            _startScanner();
          }
        }
      } else {
        scanResult.value = 'No data found in QR Code.';
        print('No data found in QR Code.');
        Get.snackbar(
          'No Data',
          'The scanned QR code contains no readable data. Please try again.', // User-friendly message
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        _isProcessingScan.value = false;
        _startScanner(); // Restart scanner if no data was processed
      }
    } else {
      scanResult.value = 'No barcode detected.';
      print('No barcode detected.');
      _isProcessingScan.value = false;
    }
  }

  Future<void> _startScanner() async {
    if (_isScannerActive.value) return;
    try {
      await scannerController.start();
      _isScannerActive.value = true;
      print('Scanner started successfully');
    } catch (e) {
      print('Failed to start scanner: $e');
      _isScannerActive.value = false;
      Get.snackbar(
        'Camera Error',
        'Failed to start camera. Please check camera permissions and try again.', // User-friendly message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _stopScanner() async {
    if (!_isScannerActive.value) return;
    try {
      await scannerController.stop();
      _isScannerActive.value = false;
      print('Scanner stopped successfully');
    } catch (e) {
      print('Failed to stop scanner: $e');
      _isScannerActive.value = false;
    }
  }

  void toggleScanner() {
    if (_isScannerActive.value) {
      _stopScanner();
    } else {
      _startScanner();
    }
  }

  void _showConsentSuccessDialog(int doctorId) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Success!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Consent sent successfully for Doctor ID: $doctorId',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // Dismiss the dialog
                    Get.back(); // Navigate back to the previous screen (e.g., Home)
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppLightModeColors.mainColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }
}