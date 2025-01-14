import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/primary_curved_widget/primary_curved_widget.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/images/t_round_image.dart';
import '../../../../controllers/user_controller/user_controller.dart';
import '../../../../features/shop/controllers/image_controller/image_controller.dart';
import '../../../../models/product_model/product_model.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';

class TProductImageSlider extends StatelessWidget {
  const TProductImageSlider({
    super.key,
    required this.product,
  });
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ImageController());
    final images = controller.getAllProductImages(product);
    final dark = THelperFunctions.isDarkMode(context);
    final userController = Get.put(UserController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userController.fetchUserData(product.ownerId);
    });
    //userController.fetchUserData(product.ownerId);
    //final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    //final bool isOwner = userId == product.ownerId;
    //final favoriteController = Get.put(FavoriteController());

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          TPrimaryCurvedWidget(
              child: Container(
            color: Colors.green,
            //dark ? TColors.darkerGrey : TColors.light,
            child: Stack(
              children: [
                //Main Image
                SizedBox(
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Center(
                      child: Obx(
                        () {
                          final image = controller.selectedProductImage.value;
                          return GestureDetector(
                            onTap: () {},
                            //=> controller.showLargeImage(image),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: image,
                              progressIndicatorBuilder:
                                  (_, __, downloadProgress) =>
                                      CircularProgressIndicator(
                                value: downloadProgress.progress,
                                color: TColors.primary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                //App bar
                const TAppBar(
                  backgroundColor: Colors.transparent,
                  showBackArrow: true,
                ),
              ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.only(left: TSizes.defaultSpace),
            child: SizedBox(
              height: 80,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (_, imdex) => const SizedBox(
                  width: TSizes.spaceBtwItems,
                ),
                itemBuilder: (_, index) => Obx(() {
                  final imageSelected =
                      controller.selectedProductImage.value == images[index];
                  return TRoundedImage(
                      isNetworkImage: true,
                      width: 80,
                      backgroundColor: dark ? TColors.dark : TColors.white,
                      onPressed: () =>
                          controller.selectedProductImage.value = images[index],
                      border: Border.all(
                          color: imageSelected
                              ? TColors.primary
                              : Colors.transparent),
                      padding: const EdgeInsets.all(TSizes.sm),
                      imageUrl: images[index]);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
