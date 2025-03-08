import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/profile_menu/t_profile_menu.dart';
import '../../../common/widgets/appbar/appbar.dart';
import '../../../common/widgets/e_circular_image/t_circular_image.dart';
import '../../../common/widgets/texts/section_heading.dart';
import '../../../controllers/user_controller/user_controller.dart';
import '../../../features/authentication/controllers/onboarding/category_controller/category_controller.dart';
import '../../../models/category_model/category_model.dart';
import '../../../models/user_model/user_model.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/shimmer_effects/t_shimmer_effect/t_shimmer_effect.dart';
import 'update_user_category.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({super.key, required this.usermodel});
  final UserModel usermodel;

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final categoryController = Get.put(CategoryController());
    categoryController.fetchCategroryData(usermodel.role);
    // categoryController.fetchCategroryData(user.role),
    // final deviceStorage = GetStorage();
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          usermodel.fullname,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: FutureBuilder<CategoryModel>(
                future: categoryController.fetchCategroryData(usermodel.role),
                builder: (context, categorySnapshot) {
                  if (categorySnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (categorySnapshot.hasError) {
                    return Center(
                        child: Text("Error: ${categorySnapshot.error}"));
                  }
                  if (!categorySnapshot.hasData) {
                    return const Center(child: Text("Category not found"));
                  }
                  var category = categorySnapshot.data!;
                  return Column(
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
                        title: 'Profile Information',
                        showActionsButton: false,
                      ),

                      const SizedBox(height: TSizes.spaceBtwItems),

                      TProfileMenu(
                        onPressed: () {},
                        //=> Get.to(() => const ChangeName()),
                        title: 'Name',
                        value: usermodel.fullname,
                      ),
                      TProfileMenu(
                        onPressed: () {},
                        title: 'Username',
                        value: usermodel.username,
                      ),
                      TProfileMenu(
                          onPressed: () => Get.to(() => UpdateUserCategory(
                                usermodel: usermodel,
                              )),
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
                        value: usermodel.phoneNumber,
                      ),

                      const SizedBox(height: TSizes.spaceBtwItems),
                      const Divider(),
                      // Center(
                      //   child: TextButton(
                      //     onPressed: () {},
                      //     //=> controller.deleteAccountWarningPopup(),
                      //     child: const Text(
                      //       'Close Account',
                      //       style: TextStyle(color: Colors.red),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   width: double.infinity,
                      //   child: OutlinedButton(
                      //     style: OutlinedButton.styleFrom(
                      //         side: const BorderSide(color: Colors.green)),
                      //     onPressed: () {},
                      //     //AuthenticationRepository.instance.logout(),
                      //     child: const Text('Logout'),
                      //   ),
                      // ),
                      const SizedBox(
                        height: TSizes.spaceBtwSections * 2.5,
                      ),
                    ],
                  );
                })),
      ),
    );
  }
}
