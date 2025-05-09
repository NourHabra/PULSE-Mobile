import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final VoidCallback? onNotificationPressed;

  const HomeAppBar({
    Key? key,
    required this.titleText,
    this.onNotificationPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
      child: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading:
        false, // To remove the back arrow automatically added
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            titleText,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 26,
            ),
          ),
        ),
        centerTitle: false, // Ensure title aligns to the left
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric( horizontal: 10),
            child: IconButton(
              icon: const Icon(FeatherIcons.bell, size: 30),
              onPressed: onNotificationPressed ?? () {
                print('Notification icon pressed!');
                // Add your notification action here
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}