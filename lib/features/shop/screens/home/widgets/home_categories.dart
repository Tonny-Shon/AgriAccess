import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/image_texts_widgets/vertical_image_text.dart';
import '../../../../../controllers/product_category_controller/product_category_controller.dart';

class THomeCategories extends StatelessWidget {
  const THomeCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(ProductCategoryController());
    return Obx(() {
      // Show a loading indicator while categories are loading
      if (categoryController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      // If no categories are available, show a placeholder text
      if (categoryController.allCategories.isEmpty) {
        return const Center(child: Text("No categories available"));
      }

      // Display the categories in a horizontal ListView
      return SizedBox(
        height: 80,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: categoryController.allCategories.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            final category = categoryController.allCategories[index];
            return TVerticalImageText(
              image: category.image,
              title: category.name,
              onTap: () {
                // Define what happens when a category is tapped
              },
            );
          },
        ),
      );
    });
  }
}
