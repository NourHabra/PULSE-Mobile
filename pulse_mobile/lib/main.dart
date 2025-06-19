// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/routes/AppRoutes.dart';
import 'package:pulse_mobile/services/Stom_service.dart';
import 'package:pulse_mobile/services/connections.dart';
import 'dart:io';

import 'package:pulse_mobile/services/http.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  Get.put(ApiService());
  Get.put(StompService());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash1',
      getPages: AppPages.pages,



      theme: ThemeData(

        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}