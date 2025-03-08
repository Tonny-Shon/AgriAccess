import 'package:agriaccess/repositories/user_repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/appbar/appbar.dart';
import '../../../common/widgets/e_circular_image/t_circular_image.dart';
import '../../../common/widgets/texts/section_heading.dart';
import '../../../controllers/user_controller/user_controller.dart';
import '../../../features/authentication/controllers/onboarding/category_controller/category_controller.dart';
import '../../../models/category_model/category_model.dart';
import '../../../models/user_model/user_model.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/pop_ups/loaders.dart';
import '../../../utils/shimmer_effects/t_shimmer_effect/t_shimmer_effect.dart';
import '../../landing_navigation_screen/landing_navigation_menu.dart';

class UpdateUserCategory extends StatelessWidget {
  const UpdateUserCategory({super.key, required this.usermodel});

  final UserModel usermodel;

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final categoryController = Get.put(CategoryController());
    categoryController.fetchCategroryData(usermodel.role);
    Get.put(UserRepository());
    // categoryController.fetchCategroryData(user.role),
    // final deviceStorage = GetStorage();
    return Scaffold(
      appBar: TAppBar(
        actions: [
          IconButton(
            onPressed: () async {
              // await deviceStorage.remove('loggedInUserId');

              // Optional: Remove other user-related data if necessary
              // await deviceStorage.remove('loggedInUserToken');
              // await deviceStorage.remove('userPreferences');

              // Redirect to login screen
              Get.offAll(() => const LandingNavigationMenu());
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
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
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Obx(() {
                        final networkImage = usermodel.profilePic;
                        final image = networkImage.isNotEmpty
                            ? networkImage
                            : TImages.defaultPic;
                        return userController.imageLoading.value
                            ? const EShimmerEffect(width: 80, height: 80)
                            : TCircularImage(
                                image: image,
                                width: 80,
                                height: 80,
                                isNetworkImage: networkImage.isNotEmpty,
                              );
                      }),
                      Text(usermodel.fullname),
                      // TextButton(
                      //     onPressed: () =>
                      //         userController.uploadUserProfilePicture(),
                      //     child: const Text('Change Profile Picture'))
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
                  title: 'Update User Role',
                  showActionsButton: false,
                ),

                const SizedBox(height: TSizes.spaceBtwItems),

                Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Text(
                          'Category',
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        )),
                    Expanded(
                      flex: 5,
                      child: Obx(
                        () => DropdownButtonFormField<CategoryModel>(
                          decoration:
                              const InputDecoration(labelText: "Select Role"),
                          value: categoryController.selectedCategory.value,
                          items:
                              categoryController.allCategories.map((category) {
                            return DropdownMenuItem<CategoryModel>(
                              value: category,
                              child: Text(category.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            categoryController.selectedCategory.value = value!;
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: TSizes.spaceBtwSections * 2.5,
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (categoryController.selectedCategory.value != null) {
                          String selectedRole =
                              categoryController.selectedCategory.value!.id;

                          FirebaseFirestore.instance
                              .collection("Users")
                              .doc(usermodel.id)
                              .update({
                            'Role':
                                selectedRole, // Ensure it's a string or correct type
                          }).then((_) {
                            TLoaders.successSnackBar(
                              title: 'Success',
                              message: 'User role updated successfully',
                            );
                          }).catchError((error) {
                            TLoaders.erroSnackBar(
                              title: 'Error',
                              message: 'Failed to update user role: $error',
                            );
                          });
                        } else {
                          TLoaders.erroSnackBar(
                            title: 'Error',
                            message: 'Please select a role before updating',
                          );
                        }
                      },
                      child: const Text('Update')),
                )
              ],
            )),
      ),
    );
  }
}
