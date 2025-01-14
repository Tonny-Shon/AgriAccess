import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';

import '../../features/authentication/screens/login/login.dart';
import '../../utils/constants/colors.dart';
import '../../utils/helpers/helper_functions.dart';
import 'widgets/all_users_screen/all_users_screen.dart' as landing_menu;
import 'widgets/default_home_screen/default_home_screen.dart';

class LandingNavigationMenu extends StatelessWidget {
  const LandingNavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LandingNavigationController());
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
            NavigationDestination(
                icon: Icon(
                  Iconsax.home,
                  color: Colors.green,
                ),
                label: 'Home'),
            NavigationDestination(
              icon: Icon(
                Iconsax.people,
                color: Colors.green,
              ),
              label: 'My Network',
            ),
            NavigationDestination(
                icon: Icon(
                  Iconsax.user,
                  color: Colors.green,
                ),
                label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class LandingNavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const DefaultHomeScreen(),
    const landing_menu.AllUsersScreen(),
    const LoginScreen(),
    //const UserProfileScreen()
  ];
}
