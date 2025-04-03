import 'package:flutter/material.dart';
import 'package:pulse_mobile/widgets/bottombar.dart';
class HomeScreen1 extends StatefulWidget {
  const HomeScreen1({super.key});

  @override
  State<HomeScreen1> createState() => _HomeScreen1State();
}

class _HomeScreen1State extends State<HomeScreen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: const Center(
        child: Text('This is the Home Screen'),
      ),
      bottomNavigationBar:CustomBottomNavBar() ,
    );
  }
}