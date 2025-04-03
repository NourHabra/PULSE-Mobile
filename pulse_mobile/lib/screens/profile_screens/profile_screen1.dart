import 'package:flutter/material.dart';
import 'package:pulse_mobile/widgets/bottombar.dart';
class ProfileScreen1 extends StatefulWidget {
  const ProfileScreen1({super.key});

  @override
  State<ProfileScreen1> createState() => _ProfileScreen1State();
}

class _ProfileScreen1State extends State<ProfileScreen1> {
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