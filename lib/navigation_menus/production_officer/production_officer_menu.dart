import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import '../../features/shop/screens/home/widgets/home.dart';
import '../../navigation_screens/profile_screen.dart/profile_screen.dart';
import '../../screens/faqs_screen/faqs_screen.dart';
import '../../utils/constants/colors.dart';
import '../../utils/helpers/helper_functions.dart';

class ProductionOfficerMenu extends StatelessWidget {
  const ProductionOfficerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductionOfficerNavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 60,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          backgroundColor: darkMode ? TColors.black : Colors.white,
          indicatorColor: darkMode
              ? TColors.white.withOpacity(0.1)
              : TColors.black.withOpacity(0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            //NavigationDestination(icon: Icon(Iconsax.pen_add), label: 'Post'),
            NavigationDestination(
                icon: Icon(Icons.question_mark_outlined), label: 'Faqs'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class ProductionOfficerNavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    //const CreatePostScreen(),
    // const AddUserScreen(),
    const FaqsScreen(),
    const UserProfileScreen()
  ];
}
