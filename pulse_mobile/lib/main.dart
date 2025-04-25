import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/routes/splash_routes.dart' as splash_routes;
import 'package:pulse_mobile/routes/login_routes.dart' as login_routes;
import 'package:pulse_mobile/routes/bottomBar_routes.dart' as bottombar_routes;
import 'package:pulse_mobile/routes/profile_routes.dart' as profile_routes;
import 'package:pulse_mobile/routes/signup_routes.dart' as signup_routes;
import 'package:pulse_mobile/services/connections.dart'; // Import ApiService

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Register ApiService with GetX
    Get.put(ApiService()); //  before GetMaterialApp
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash1',
      getPages: [
        ...splash_routes.getPages,
        ...login_routes.getPages,
        ...bottombar_routes.getPages,
        ...profile_routes.getPages,
        ...signup_routes.getPages,
      ],
    );
  }
}
