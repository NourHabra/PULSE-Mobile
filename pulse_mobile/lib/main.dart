import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/routes/splash_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash1',
      getPages: getPages, // Use the routes from routes.dart
    );
  }
}