import 'package:flutter/material.dart';
import 'package:pulse_mobile/widgets/bottombar.dart';
class RecordScreen1 extends StatefulWidget {
  const RecordScreen1({super.key});

  @override
  State<RecordScreen1> createState() => _RecordScreen1State();
}

class _RecordScreen1State extends State<RecordScreen1> {
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