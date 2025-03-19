import 'package:agriaccess/features/authentication/controllers/onboarding/category_controller/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../common/profile_menu/t_profile_menu.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../../common/widgets/e_circular_image/t_circular_image.dart';
import '../../common/widgets/texts/section_heading.dart';
import '../../controllers/user_controller/user_controller.dart';
import '../../models/category_model/category_model.dart';
import '../../models/user_model/user_model.dart';
import '../../navigation_menus/landing_navigation_screen/landing_navigation_menu.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/shimmer_effects/t_shimmer_effect/t_shimmer_effect.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final categoryController = Get.put(CategoryController());
    final deviceStorage = GetStorage();
    return Scaffold(
      appBar: TAppBar(
        actions: [
          TextButton(
            onPressed: () async {
              await deviceStorage.remove('loggedInUserId');

              // Optional: Remove other user-related data if necessary
              // await deviceStorage.remove('loggedInUserToken');
              // await deviceStorage.remove('userPreferences');

              // Redirect to login screen
              Get.offAll(() => const LandingNavigationMenu());
            },
            child: const Row(
              children: [
                Text(
                  'Logout',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  width: 4,
                ),
                Icon(
                  Icons.logout,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ],
        showBackArrow: false,
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: FutureBuilder<UserModel>(
                future: userController.fetchUserRecord(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                        child: Text("Failed to load user data"));
                  }

                  final user = snapshot.data!;
                  return FutureBuilder<CategoryModel>(
                      future: categoryController.fetchCategroryData(user.role),
                      builder: (context, categorySnapshot) {
                        if (categorySnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (categorySnapshot.hasError) {
                          return Center(
                              child: Text("Error: ${categorySnapshot.error}"));
                        }
                        if (!categorySnapshot.hasData) {
                          return const Center(
                              child: Text("Category not found"));
                        }
                        var category = categorySnapshot.data!;
                        return Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Obx(() {
                                    final networkImage = user.profilePic;
                                    final image = networkImage.isNotEmpty
                                        ? networkImage
                                        : TImages.defaultPic;
                                    return userController.imageLoading.value
                                        ? const EShimmerEffect(
                                            width: 80, height: 80)
                                        : TCircularImage(
                                            image: image,
                                            width: 80,
                                            height: 80,
                                            isNetworkImage:
                                                networkImage.isNotEmpty,
                                          );
                                  }),
                                  TextButton(
                                      onPressed: () => userController
                                          .uploadUserProfilePicture(),
                                      child:
                                          const Text('Change Profile Picture'))
                                ],
                              ),
                            ),

                            //details
                            const SizedBox(
                              height: TSizes.spaceBtwItems / 2,
                            ),
                            const Divider(),
                            const SizedBox(height: TSizes.spaceBtwItems),

                            const TSectionHeading(
                              title: 'Profile Information',
                              showActionsButton: false,
                            ),

                            const SizedBox(height: TSizes.spaceBtwItems),

                            TProfileMenu(
                              onPressed: () {},
                              //=> Get.to(() => const ChangeName()),
                              title: 'Name',
                              value: user.fullname,
                            ),
                            TProfileMenu(
                              onPressed: () {},
                              title: 'Username',
                              value: user.username,
                            ),
                            TProfileMenu(
                                onPressed: () {},
                                title: 'Category',
                                value: category.name),

                            const SizedBox(height: TSizes.spaceBtwItems),
                            const Divider(),
                            const SizedBox(height: TSizes.spaceBtwItems),

                            const TSectionHeading(
                              title: 'Personal Information',
                              showActionsButton: false,
                            ),
                            const SizedBox(height: TSizes.spaceBtwItems),

                            // EProfileMenu(
                            //   onPressed: () {},
                            //   title: 'User Id',
                            //   value: controller.user.value.id,
                            // ),
                            TProfileMenu(
                              onPressed: () {},
                              title: 'Phone',
                              value: user.phoneNumber,
                            ),

                            const SizedBox(height: TSizes.spaceBtwItems),
                            const Divider(),

                            const SizedBox(
                              height: TSizes.spaceBtwSections * 2.5,
                            ),
                          ],
                        );
                      });
                })),
      ),
    );
  }
}
