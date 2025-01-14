import 'package:agriaccess/controllers/product_category_controller/product_category_controller.dart';
import 'package:agriaccess/screens/product_details/product_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../features/authentication/screens/login/login.dart';
import '../../../models/product_model/product_model.dart';

import '../../../repositories/auth_repository/auth_repository.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

import '../../styles/shadows.dart';
import '../custom_shapes/containers/rounded_container.dart';

class TProductCardVertical extends StatelessWidget {
  const TProductCardVertical(
      {super.key, this.height = 117, required this.product});
  final double height;
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final categoryController =
        Get.put(ProductCategoryController(), tag: product.categoryId);
    Future.microtask(
        () => categoryController.fetchCategoryData(product.categoryId!));

    return GestureDetector(
      onTap: () async {
        if (GetStorage().read('loggedInUserId') == null) {
          Get.snackbar(
              backgroundColor: Colors.green[800],
              colorText: Colors.white,
              'Sigin error',
              'You must be logged in to view product details');
          final result = await Get.to(() => const LoginScreen());
          if (result == true) {
            await AuthRepository.instance.handleRolebasedNavigation();
            Get.to(() => ProductDetails(product: product));
          }
        } else {
          Get.to(() => ProductDetails(product: product));
        }
      },
      child: Container(
        width: 200,
        height: height,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
            boxShadow: [TShadowStyle.verticalProductShadow],
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(TSizes.productImageRadius),
            color: dark ? TColors.darkGrey : Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //thumbnail
            TRoundedContainer(
              width: MediaQuery.of(context).size.width,
              height: height,
              padding: const EdgeInsets.all(0),
              backgroundColor: dark ? TColors.dark : TColors.light,
              child: Stack(
                children: [
                  //image thumbnail
                  Center(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(8), // Apply image radius
                      child: Image.network(
                        product.thumbnail,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.error, // Show error icon when image fails
                            size: 50,
                            color: Colors.red,
                          );
                        },
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                // Show loading indicator while loading
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: TSizes.spaceBtwItems / 2,
            ),
            //Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Text(
                      product.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Obx(() {
                          final category = categoryController.catId.value;
                          return Text(category.name);
                        }),
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),
                    //Price
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        'Ugx ${product.price.toString()}',
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
