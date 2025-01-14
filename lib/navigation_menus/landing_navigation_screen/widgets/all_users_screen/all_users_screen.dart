import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../common/widgets/e_circular_image/t_circular_image.dart';
import '../../../../controllers/user_controller/all_users_controller/all_users_controller.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/shimmer_effects/t_shimmer_effect/t_shimmer_effect.dart';

class AllUsersScreen extends StatelessWidget {
  const AllUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usersController = Get.put(AllUsersController());
    //final categoryController = Get.put(CategoryController());
    return Scaffold(
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
            child: ListView.separated(
                itemCount: usersController.users.length,
                itemBuilder: (context, index) {
                  final user = usersController.users[index];
                  final profileImage = user.profilePic.isNotEmpty
                      ? user.profilePic
                      : TImages.defaultPic;

                  return TRoundedContainer(
                    padding: const EdgeInsets.all(TSizes.md),
                    showBorder: true,
                    backgroundColor: Colors.green,
                    child: Row(
                      children: [
                        Obx(() {
                          return usersController.isLoading.value
                              ? const EShimmerEffect(width: 80, height: 80)
                              : TCircularImage(
                                  padding: 0,
                                  image: profileImage,
                                  width: 45,
                                  height: 45,
                                  isNetworkImage: user.profilePic.isNotEmpty,
                                );
                        }),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.fullname,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            Text(usersController.getCategoryName(user.role),
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(
                      height: 12,
                    )),
          );
        }
      }),
    );
  }
}
