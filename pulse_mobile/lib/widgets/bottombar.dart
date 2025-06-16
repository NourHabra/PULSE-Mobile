import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../theme/app_light_mode_colors.dart'; // Ensure this path is correct

class CustomBottomNavBar extends StatefulWidget {
  final int initialIndex; // Can still be used as a fallback or for specific cases

  CustomBottomNavBar({this.initialIndex = 0});

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late int _selectedIndex;

  // Helper function to map route names to their corresponding bottom bar index
  // This helps the bottom nav bar to know which item should be active
  // based on the current page's route.
  int _getPageIndex(String routeName) {
    switch (routeName) {
      case '/home1':
        return 0;
      case '/record1':
        return 1;
      case '/notification1':
        return 2;
      case '/profile1':
        return 3;
      default:
      // Fallback to initialIndex if the current route doesn't match any tab.
      // This is important for robustness.
        return widget.initialIndex;
    }
  }

  @override
  void initState() {
    super.initState();

    _selectedIndex = _getPageIndex(Get.currentRoute);
  }




  void _onItemTapped(int index) {

    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    switch (index) {
      case 0:
        if (Get.currentRoute != '/home1') { // Prevent navigating if already on the page
          Get.offNamed('/home1');
        }
        break;
      case 1:
        if (Get.currentRoute != '/record1') {
          Get.offNamed('/record1');
        }
        break;
      case 2:
        if (Get.currentRoute != '/notification1') {
          Get.offNamed('/notification1');
        }
        break;
      case 3:
        if (Get.currentRoute != '/profile1') {
          Get.offNamed('/profile1');
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0.0,
      shape: Border(
        top: BorderSide(
          color: AppLightModeColors.bottomBarBorder,
          width: 1.5,
        ),
      ),
      child: SizedBox(
        height: 85.0,
        child: Row(
          children: <Widget>[
            SizedBox(width: 35.0), // Left padding
            Expanded(
              child: InkWell(
                onTap: () => _onItemTapped(0),
                child: Center(
                  child: Icon(
                    FeatherIcons.home,
                    size: 29.0,
                    color: _selectedIndex == 0 ? AppLightModeColors.mainColor : AppLightModeColors.icons,
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => _onItemTapped(1),
                child: Center(
                  child: Icon(
                    FeatherIcons.clipboard,
                    size: 29.0,
                    color: _selectedIndex == 1 ? AppLightModeColors.mainColor : AppLightModeColors.icons,
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => _onItemTapped(2),
                child: Center(
                  child: Icon(
                    FeatherIcons.bell,
                    size: 29.0,
                    // FIX: This was checking for index 3, should be 2 for the bell icon
                    color: _selectedIndex == 2 ? AppLightModeColors.mainColor : AppLightModeColors.icons,
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => _onItemTapped(3),
                child: Center(
                  child: Icon(
                    FeatherIcons.user,
                    size: 29.0,
                    // FIX: This was checking for index 4, should be 3 for the user icon
                    color: _selectedIndex == 3 ? AppLightModeColors.mainColor : AppLightModeColors.icons,
                  ),
                ),
              ),
            ),
            SizedBox(width: 35.0), // Right padding
          ],
        ),
      ),
    );
  }
}