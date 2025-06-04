// lib/routes/home_routes.dart
import 'package:get/get.dart';

// Import the screen and binding for emergency events
import '../controllers/emergencyEvents/emergency_event_binder.dart';
import '../screens/emergencyEvents_screens/emergencyEvent_screen.dart';


List<GetPage> homeRoutes = [
  GetPage(
    // Define the route name directly as a string literal
    name: '/emergency_events',
    page: () => const EmergencyEventsScreen(),
    binding: EmergencyEventsBinding(),
  ),
  // Add other home-related routes here if you have any (e.g., '/profile', '/settings')
  // GetPage(name: '/profile', page: () => ProfileScreen(), binding: ProfileBinding()),
];