import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import '../../features/shop/screens/home/widgets/home.dart';
import '../../navigation_screens/profile_screen.dart/profile_screen.dart';
import '../../utils/constants/colors.dart';
import '../../utils/helpers/helper_functions.dart';
import '../landing_navigation_screen/widgets/all_users_screen/all_users_screen.dart';
import 'widgets/add_category.dart';

class InputSupplierMenu extends StatelessWidget {
  const InputSupplierMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InputSupplierNavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
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
            NavigationDestination(icon: Icon(Iconsax.shop), label: 'Category'),
            NavigationDestination(icon: Icon(Iconsax.people), label: 'Users'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class InputSupplierNavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    const AddProductCategory(),
    const AllUsersScreen(),
    const UserProfileScreen()
  ];
}
