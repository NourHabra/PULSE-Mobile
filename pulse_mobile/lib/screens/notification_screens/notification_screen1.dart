import 'package:flutter/material.dart';
import 'package:pulse_mobile/widgets/bottombar.dart';
class NotificationScreen1 extends StatefulWidget {
  const NotificationScreen1({super.key});

  @override
  State<NotificationScreen1> createState() => _NotificationScreen1State();
}

class _NotificationScreen1State extends State<NotificationScreen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('record Screen'),
      ),
      body: const Center(
        child: Text('This is the record Screen'),
      ),
      bottomNavigationBar:CustomBottomNavBar() ,
    );
  }
}