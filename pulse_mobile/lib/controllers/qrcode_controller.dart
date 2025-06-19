// QrScannerController.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/connections.dart';
import '../theme/app_light_mode_colors.dart';

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
    print('DEBUG: QrScannerController onInit called. Attempting to start scanner.');
    _startScanner(); // Start scanner immediately when controller is initialized
  }

  void onDetect(BarcodeCapture capture) async {
    print('DEBUG: onDetect called. _isProcessingScan: ${_isProcessingScan.value}');
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
        print('DEBUG: Scanned QR Code Raw Value: ${scanResult.value}');

        // Stop the scanner immediately after a successful detection
        // This is crucial if you only want to process one QR at a time.
        _stopScanner();
        print('DEBUG: Scanner stopped after detection.');

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

          print('DEBUG: Calling API to post consent for doctor ID: $doctorId');
          final bool success = await _apiService.postConsentForDoctor(doctorId);
          print('DEBUG: API response success: $success');

          if (success) {
            _showConsentSuccessDialog(doctorId); // Call the custom success dialog
          } else {
            Get.snackbar(
              'Failed',
              'An error occurred while sending consent. Please try again.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } on FormatException {
          print('ERROR: FormatException - Raw QR value was not an integer: $rawValue');
          Get.snackbar(
            'Error',
            'Invalid QR Code. Please ensure you are scanning a valid Doctor ID.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        } catch (e) {
          print('ERROR: Unexpected error during QR processing: $e');
          Get.snackbar(
            'Error',
            'An unexpected error occurred. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } finally {
          _isProcessingScan.value = false; // Reset flag
          print('DEBUG: _isProcessingScan reset to false. Current route: ${Get.currentRoute}');
          // If we didn't navigate back (e.g., API call failed or dialog not yet dismissed), restart scanner
          // This ensures the scanner is active again if it's still the current screen.
          // The `_showConsentSuccessDialog` calls `Get.back()` twice, which will remove this screen.
          // So, this restart might only trigger if the API call fails or dialog is dismissed quickly.
          if (Get.currentRoute == '/QrScannerScreen') {
            _startScanner(); // Restart only if still on scanner screen
            print('DEBUG: Restarting scanner because still on QrScannerScreen.');
          } else {
            print('DEBUG: Not restarting scanner because navigated away from QrScannerScreen.');
          }
        }
      } else {
        scanResult.value = 'No data found in QR Code.';
        print('DEBUG: No data found in QR Code.');
        Get.snackbar(
          'No Data',
          'The scanned QR code contains no readable data. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        _isProcessingScan.value = false;
        _startScanner(); // Restart scanner if no data was processed
      }
    } else {
      scanResult.value = 'No barcode detected (capture was empty).';
      print('DEBUG: No barcode detected in capture.');
      // Do not reset _isProcessingScan here, as it might not have been set if barcodes was empty
    }
  }

  Future<void> _startScanner() async {
    if (_isScannerActive.value) {
      print('DEBUG: Scanner already active. Skipping start.');
      return;
    }
    try {
      print('DEBUG: Attempting to start scanner controller.');
      await scannerController.start();
      _isScannerActive.value = true;
      print('DEBUG: Scanner started successfully.');
    } catch (e) {
      print('ERROR: Failed to start scanner: $e');
      _isScannerActive.value = false;
      Get.snackbar(
        'Camera Error',
        'Failed to start camera. Please check camera permissions and try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _stopScanner() async {
    if (!_isScannerActive.value) {
      print('DEBUG: Scanner not active. Skipping stop.');
      return;
    }
    try {
      print('DEBUG: Attempting to stop scanner controller.');
      await scannerController.stop();
      _isScannerActive.value = false;
      print('DEBUG: Scanner stopped successfully.');
    } catch (e) {
      print('ERROR: Failed to stop scanner: $e');
      // No snackbar here, as it might interfere with main flow after successful scan
    }
  }

  void toggleScanner() {
    print('DEBUG: toggleScanner called. Current state: ${_isScannerActive.value}');
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
                    // The double Get.back() will pop the current QR scanner screen
                    // and then pop the screen that navigated to it.
                    // If you want to stay on the scanner screen after success, remove the second Get.back().
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
    print('DEBUG: QrScannerController onClose called. Disposing scanner controller.');
    scannerController.dispose();
    super.onClose();
  }
}
