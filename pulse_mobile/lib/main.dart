import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/routes/splash_routes.dart' as splash_routes;
import 'package:pulse_mobile/routes/login_routes.dart' as login_routes;
import 'package:pulse_mobile/routes/bottomBar_routes.dart' as bottombar_routes;
import 'package:pulse_mobile/routes/profile_routes.dart' as profile_routes;
import 'package:pulse_mobile/routes/signup_routes.dart' as signup_routes;
import 'package:pulse_mobile/routes/medications&prescriptions_routes.dart'
    as medspres_routes;
import 'package:pulse_mobile/routes/map_routes.dart' as map_routes;
import 'package:pulse_mobile/services/connections.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart'; // Import for Android

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
      initialRoute: '/login',
      getPages: [
        ...splash_routes.getPages,
        ...login_routes.getPages,
        ...bottombar_routes.getPages,
        ...profile_routes.getPages,
        ...signup_routes.getPages,
        ...medspres_routes.getPages,
        ...map_routes.getPages,
      ],
        theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,),
    );
  }
}
