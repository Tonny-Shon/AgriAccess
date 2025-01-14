import 'package:agriaccess/controllers/user_controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import '../../common/widgets/texts/section_heading.dart';
import '../../controllers/product_category_controller/product_category_controller.dart';
import '../../models/product_model/product_model.dart';
import '../../utils/constants/sizes.dart';
import 'widgets/product_image_slider/product_image_slider.dart';
import 'widgets/product_metadata/product_metadata.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(ProductCategoryController());
    categoryController.fetchCategoryData(product.categoryId!);

    final userController = Get.put(UserController());
    userController.fetchUserData(product.ownerId);
    return Scaffold(
      // bottomNavigationBar: BottomAddToCart(
      //   product: product,
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Product image Slider
            TProductImageSlider(product: product),

            //product details
            Padding(
              padding: const EdgeInsets.only(
                  right: TSizes.defaultSpace,
                  left: TSizes.defaultSpace,
                  bottom: TSizes.defaultSpace),
              child: Column(
                children: [
                  //title
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        const Text(
                          'Product Category:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Obx(() {
                          final category = categoryController.catId.value;
                          return TSectionHeading(
                            title: category.name,
                            showActionsButton: false,
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  const TSectionHeading(
                    title: 'Description',
                    showActionsButton: false,
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    // child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       '${product.description}',
                    //       maxLines: 3,
                    //     ),
                    //   ],
                    // ),
                    child: ReadMoreText(
                      product.description ?? '',
                      trimLines: 2,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'show more',
                      trimExpandedText: ' show less',
                      moreStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                      lessStyle: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),

                  TProductMetaData(
                    product: product,
                  ),

                  // const SizedBox(
                  //   height: 15,
                  // ),

                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
