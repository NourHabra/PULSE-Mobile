// routes/google_maps_routes.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../screens/home_screens/test2.dart';

List<GetPage> getPages = [
  GetPage(name: '/map', page: () => const GoogleMapsEmbedScreen()),
];
