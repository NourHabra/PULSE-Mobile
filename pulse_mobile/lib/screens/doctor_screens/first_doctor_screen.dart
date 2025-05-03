import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/doctors/doctor_firstpage_controller.dart';
import '../../widgets/appbar.dart';
import '../../widgets/bottombar.dart';
import '../../widgets/square_category_item.dart';


class DoctorCategoryScreen extends StatelessWidget {
  final DoctorCategoryController _doctorCategoryController = Get.put(DoctorCategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(33.0),
        child: CustomAppBar(titleText: 'Doctors',),
      ),

      body: Obx(() {
        if (_doctorCategoryController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (_doctorCategoryController.hasError.value) {
          return Center(child: Text(_doctorCategoryController.errorMessage.value));
        }
        if (_doctorCategoryController.doctorCategories.isEmpty) {
          return Center(child: Text('No doctor categories to show.'));
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 1.8),
                ),
                itemCount: _doctorCategoryController.doctorCategories.length,
                itemBuilder: (BuildContext context, int index) {
                  final doctorCategory = _doctorCategoryController.doctorCategories[index];
                  return SquareCategoryItem(
                    data: doctorCategory,
                    onTap: () {
                      Get.back(); // Close the drawer
                      Get.to(() => DoctorListScreen(doctorCategory.id, doctorCategory.name));
                    },
                    iconKey: "icon",
                    title: doctorCategory.name,
                  );
                },
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

class DoctorListScreen {
  DoctorListScreen(int id, String name);
}