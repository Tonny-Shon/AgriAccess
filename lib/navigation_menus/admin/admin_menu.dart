import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import '../../features/authentication/screens/create_post/create_post.dart';
import '../../features/shop/screens/home/widgets/home.dart';
import '../../navigation_screens/profile_screen.dart/profile_screen.dart';
import '../../utils/constants/colors.dart';
import '../../utils/helpers/helper_functions.dart';
import 'screens/all_users.dart';

class AdminMenu extends StatelessWidget {
  const AdminMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminMenuNavigationController());
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
          indicatorColor: darkMode ? Colors.green[200] : Colors.green[200],
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(icon: Icon(Iconsax.people), label: 'Users'),
            NavigationDestination(
                icon: Icon(Iconsax.add_circle), label: 'Post'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class AdminMenuNavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    const AdminAllUsersScreen(),
    CreatePostScreen(),
    const UserProfileScreen()
  ];
}
