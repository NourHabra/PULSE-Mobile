import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class GoogleMapsEmbed extends StatefulWidget {
  final String googleMapsUrl;

  const GoogleMapsEmbed({super.key, required this.googleMapsUrl});

  @override
  State<GoogleMapsEmbed> createState() => _GoogleMapsEmbedState();
}

class _GoogleMapsEmbedState extends State<GoogleMapsEmbed> {
  late final WebViewController _controller;
  bool _isLoading = true; // Track loading state
  String _loadError = ''; // Track any loading errors

  @override
  void initState() {
    super.initState();

    PlatformWebViewControllerCreationParams params =
    const PlatformWebViewControllerCreationParams();
    _controller =
    WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _loadError = ''; // Clear any previous error
            });
            print('Page started loading: $url'); // Debugging
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            print('Page finished loading: $url'); // Debugging
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
              _loadError =
              'Error: ${error.description} (Code: ${error.errorCode})';
            });
            print('Web resource error: $_loadError'); // Debug
          },
          onNavigationRequest: (NavigationRequest request) {
            print('Navigation request to ${request.url}'); // Debugging
            return NavigationDecision.navigate; // Allow all navigations
          },
        ),
      );

    // Load the iframe HTML directly
    _controller.loadHtmlString(_buildHtml(widget.googleMapsUrl));
  }

  // Helper method to construct the HTML with the iframe
  String _buildHtml(String googleMapsUrl) {
    return '''
      <!DOCTYPE html>
      <html>
      <head>
        <title>Embedded Google Map</title>
        <style>
          /* Ensure the map fills the entire WebView */
          body { margin: 0; padding: 0; }
          .container {
            width: 100%;
            height: 100vh; /* Use 100vh for full viewport height */
            display: flex;
            justify-content: center;
            align-items: center;
          }
          iframe {
            width: 100%;
            height: 100%;
            border: none; /* Remove the border */
          }
        </style>
      </head>
      <body>
        <div class="container">
          <iframe
            src="$googleMapsUrl"
            width="600"
            height="450"
            style="border:0;"
            allowfullscreen=""
            loading="lazy"
            referrerpolicy="no-referrer-when-downgrade">
          </iframe>
        </div>
      </body>
      </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading) // Show loading indicator
          const Center(child: CircularProgressIndicator()),
        if (_loadError.isNotEmpty) // Show error message
          Center(
            child: Text(
              'Failed to load map: $_loadError',
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}