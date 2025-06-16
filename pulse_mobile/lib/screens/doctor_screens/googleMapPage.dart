// lib/views/google_map_page.dart (no change needed here)
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import '../../widgets/appbar.dart';
import '../../widgets/bottombar.dart';

class GoogleMapPage extends StatefulWidget {
  final String mapUrl; // This will receive doctor.coordinates

  const GoogleMapPage({Key? key, required this.mapUrl}) : super(key: key);

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String _loadError = '';

  @override
  void initState() {
    super.initState();

    PlatformWebViewControllerCreationParams params =
    const PlatformWebViewControllerCreationParams();
    // --- ADD THIS PRINT STATEMENT ---
    print('GoogleMapPage: Attempting to load URL: ${widget.mapUrl}');
    // --- END ADDITION ---
    _controller =
    WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _loadError = '';
            });
            print('GoogleMapPage: Page started loading: $url');
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            print('GoogleMapPage: Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
              _loadError =
              'Error: ${error.description} (Code: ${error.errorCode})';
            });
            print('GoogleMapPage: Web resource error: $_loadError');
          },
          onNavigationRequest: (NavigationRequest request) {
            print('GoogleMapPage: Navigation request to ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.mapUrl)); // Loads the URL passed from DoctorDetailsScreen DIRECTLY
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Map View'),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
          if (_loadError.isNotEmpty)
            Center(
              child: Text(
                'Failed to load map: $_loadError',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}