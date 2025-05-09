/*import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';   // Import for Android


class GoogleMapsEmbed extends StatefulWidget {
  final String googleMapsUrl;

  const GoogleMapsEmbed({super.key, required this.googleMapsUrl});

  @override
  State<GoogleMapsEmbed> createState() => _GoogleMapsEmbedState();
}

class _GoogleMapsEmbedState extends State<GoogleMapsEmbed> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(widget.googleMapsUrl));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}*/
