import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/product_model/product_model.dart';

class ImageController extends GetxController {
  static ImageController get instance => Get.find();

  //variables
  RxString selectedProductImage = ''.obs;

  //Get all Images from product and variations
  List<String> getAllProductImages(ProductModel product) {
    Set<String> images = {};

    images.add(product.thumbnail);

    //assign Thumbnail as selected image
    selectedProductImage.value = product.thumbnail;

    //Get all images from the Product Model if not null
    if (product.images != null) {
      images.addAll(product.images!);
    }
    return images.toList();
  }

  ////Show image popup
  void showLargeImage(String image) {
    Get.to(
      fullscreenDialog: true,
      () => Scaffold(
        body: Stack(
          children: [
            // Fullscreen image
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.contain,
              ),
            ),
            // Close icon at the top-left corner
            Positioned(
              top: 20.0, // Adjust for spacing from the top
              left: 20.0, // Adjust for spacing from the left
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => Get.back(),
                tooltip: 'Close',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
