import 'package:agriaccess/models/product_model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../common/widgets/e_circular_image/t_circular_image.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../controllers/user_controller/user_controller.dart';
import '../../../../utils/constants/sizes.dart';

class TProductMetaData extends StatelessWidget {
  const TProductMetaData({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    //final darkMode = EHelperFunctions.isDarkMode(context);
    final userController = Get.put(UserController());
    userController.fetchUserData(product.ownerId);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: TSizes.spaceBtwItems / 1.5,
        ),

        // Owner details status
        Obx(() {
          final user = userController.user.value;

          return Column(
            children: [
              //Location
              TRoundedContainer(
                borderColor: Colors.green,
                showBorder: true,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.green[700],
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 15.0),
                                  child: TSectionHeading(
                                    title: "Owner contact",
                                    textColor: Colors.white,
                                    showActionsButton: false,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15.0),
                                          child: Row(
                                            children: [
                                              TCircularImage(
                                                image: user!.profilePic,
                                                //controller.user.value.profilePicture,
                                                isNetworkImage: true,
                                                width: 60,
                                                height: 60,
                                                padding: 0,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      user.fullname,
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      user.phoneNumber,
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white),
                                            child: Center(
                                              child: IconButton(
                                                color: Colors.green,
                                                icon: const Icon(Icons.call),
                                                onPressed: () {},
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
        const SizedBox(
          height: TSizes.spaceBtwItems,
        ),
      ],
    );
  }
}
