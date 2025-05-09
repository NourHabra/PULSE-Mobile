// lib/screens/first_lab_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirstLabScreen extends StatelessWidget {
  const FirstLabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Labs')),
      body: const Center(child: Text('This is the First Lab Screen')),
    );
  }
}