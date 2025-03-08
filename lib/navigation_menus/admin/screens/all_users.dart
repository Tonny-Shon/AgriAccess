import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../common/widgets/e_circular_image/t_circular_image.dart';
import '../../../../controllers/user_controller/all_users_controller/all_users_controller.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/shimmer_effects/t_shimmer_effect/t_shimmer_effect.dart';
import '../../../common/widgets/texts/section_heading.dart';
import '../../../features/authentication/controllers/onboarding/category_controller/category_controller.dart';
import '../../../utils/constants/colors.dart';
import 'user_details_screen.dart';

class AdminAllUsersScreen extends StatelessWidget {
  const AdminAllUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usersController = Get.put(AllUsersController());
    final categoryController = Get.put(CategoryController());

    //final categoryController = Get.put(CategoryController());
    return Scaffold(
      backgroundColor: TColors.softGrey,
      appBar: const TAppBar(
        showBackArrow: false,
        title: Text(
          "Agriaccess Users",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Obx(() {
        if (usersController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (usersController.users.isEmpty) {
          return const Center(child: Text("No users available"));
        } else {
          return Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  child: Column(
                    children: [
                      const TSectionHeading(
                        title: 'Categories summary',
                      ),
                      const SizedBox(
                        height: TSizes.sm,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:
                              usersController.roleCounts.entries.map((entry) {
                            return FutureBuilder(
                                future: categoryController
                                    .getCategoryName(entry.key),
                                builder: (context, snapshot) {
                                  String categoryName =
                                      snapshot.data ?? 'Loading ...';
                                  return _buildRoleContainer(
                                      categoryName, entry.value);
                                });
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                      itemCount: usersController.users.length,
                      itemBuilder: (context, index) {
                        final user = usersController.users[index];
                        final profileImage = user.profilePic.isNotEmpty
                            ? user.profilePic
                            : TImages.defaultPic;

                        return InkWell(
                          onTap: () => Get.to(() => UserDetailsScreen(
                                usermodel: user,
                              )),
                          child: TRoundedContainer(
                            padding: const EdgeInsets.all(TSizes.md),
                            showBorder: true,
                            backgroundColor: Colors.white,
                            radius: 10,
                            child: Row(
                              children: [
                                Obx(() {
                                  return usersController.isLoading.value
                                      ? const EShimmerEffect(
                                          width: 80, height: 80)
                                      : TCircularImage(
                                          padding: 0,
                                          image: profileImage,
                                          width: 45,
                                          height: 45,
                                          isNetworkImage:
                                              user.profilePic.isNotEmpty,
                                        );
                                }),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user.fullname,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        usersController
                                            .getCategoryName(user.role),
                                        style: const TextStyle(
                                            fontSize: 15, color: Colors.black)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(
                            height: 12,
                          )),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}

/// **Helper Method to Create Role Containers**
Widget _buildRoleContainer(String role, int count) {
  return Container(
    width: 200,
    margin: const EdgeInsets.symmetric(horizontal: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${role}s",
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 5),
        Text(
          count.toString(),
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    ),
  );
}
