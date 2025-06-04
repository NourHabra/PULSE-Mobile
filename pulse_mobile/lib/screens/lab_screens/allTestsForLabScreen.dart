import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/widgets/bottombar.dart';
import '../../controllers/Labs/allTestsForLab_controller.dart'; // Corrected capitalization
import '../../widgets/testItemCard.dart';
import '../../widgets/appbar.dart';

class AllTestsForLabScreen extends StatelessWidget {
  // Now use Get.find() because the controller is provided by the binding
  final AllTestsForLabController _controller = Get.find<AllTestsForLabController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'All Tests'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        
        child: Obx(() {
          if (_controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (_controller.errorMessage.value.isNotEmpty) {
            return Center(child: Text(_controller.errorMessage.value));
          } else if (_controller.allLabTests.isEmpty) {
            return const Center(child: Text('No tests available for this lab.'));
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
                childAspectRatio: 118 / 170,
              ),
              itemCount: _controller.allLabTests.length,
              itemBuilder: (context, index) {
                final test = _controller.allLabTests[index];
                return TestItemCard(
                  imageUrl: test.imageUrl,
                  title: test.name,
                  price: test.price,
                );
              },
            );
          }
        }),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
