import 'package:flutter/material.dart';
import 'package:pulse_mobile/widgets/bottombar.dart';

import '../../widgets/appbar.dart';
class SearchScreen1 extends StatefulWidget {
  const SearchScreen1({super.key});

  @override
  State<SearchScreen1> createState() => _SearchScreen1State();
}

class _SearchScreen1State extends State<SearchScreen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      CustomAppBar(titleText: 'Search',),
      body: const Center(
        child: Text('This is the search Screen'),
      ),
      bottomNavigationBar:CustomBottomNavBar() ,
    );
  }
}