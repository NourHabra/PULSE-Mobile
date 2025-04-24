import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../theme/app_light_mode_colors.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int initialIndex;

  CustomBottomNavBar({this.initialIndex = 0});

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the corresponding page
    switch (index) {
      case 0:
        Get.toNamed('/home1');
        break;
      case 1:
        Get.toNamed('/record1');
        break;
      case 2:
        Get.toNamed('/search1');
        break;
      case 3:
        Get.toNamed('/notification1');
        break;
      case 4:
        Get.toNamed('/profile1');
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
        height: 79.0,
        child: Row(
          children: <Widget>[
            SizedBox(width: 35.0), // Left padding
            Expanded(
              child: InkWell(
                onTap: () => _onItemTapped(0),
                child: Center(child: Icon(FeatherIcons.home, size: 27.0, color: _selectedIndex == 0 ? AppLightModeColors.mainColor : AppLightModeColors.icons)),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => _onItemTapped(1),
                child: Center(child: Icon(FeatherIcons.clipboard, size: 27.0, color: _selectedIndex == 1 ? AppLightModeColors.mainColor : AppLightModeColors.icons)),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => _onItemTapped(2),
                child: Center(child: Icon(FeatherIcons.search, size: 27.0, color: _selectedIndex == 2 ? AppLightModeColors.mainColor : AppLightModeColors.icons)),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => _onItemTapped(3),
                child: Center(child: Icon(FeatherIcons.bell, size: 27.0, color: _selectedIndex == 3 ? AppLightModeColors.mainColor : AppLightModeColors.icons)),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => _onItemTapped(4),
                child: Center(child: Icon(FeatherIcons.user, size: 27.0, color: _selectedIndex == 4 ? AppLightModeColors.mainColor : AppLightModeColors.icons)),
              ),
            ),
            SizedBox(width: 35.0), // Right padding
          ],
        ),
      ),
    );
  }
}