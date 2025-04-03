import 'package:flutter/material.dart';
import 'package:pulse_mobile/widgets/bottombar.dart';
class SearchScreen1 extends StatefulWidget {
  const SearchScreen1({super.key});

  @override
  State<SearchScreen1> createState() => _SearchScreen1State();
}

class _SearchScreen1State extends State<SearchScreen1> {
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