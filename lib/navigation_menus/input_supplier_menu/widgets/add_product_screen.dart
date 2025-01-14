import 'dart:typed_data';

import 'package:agriaccess/controllers/product_category_controller/product_category_controller.dart';
import 'package:agriaccess/models/product_category/product_category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/image_placeholder/image_placeholder.dart';
import '../../../common/widgets/appbar/appbar.dart';
import '../../../controllers/add_product_controller/add_product_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addPropertyController = Get.put(AddPropertyController());
    final productCategory = Get.put(ProductCategoryController());
    //final categoryController = Get.put(CategoryController());
    //final locationController = Get.put(PropertyLocationController());
    return Scaffold(
      backgroundColor: TColors.grey,
      appBar: TAppBar(
        title: Text(
          'Add Product',
          style: Theme.of(context).textTheme.headlineMedium!.apply(
                color: TColors.white,
              ),
        ),
        showBackArrow: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 10, left: TSizes.defaultSpace, right: TSizes.defaultSpace),
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 200,
                  child: InkWell(
                    onTap: addPropertyController.pickImage,
                    child: addPropertyController.imageFile.value == null
                        ? Container(
                            color: TColors.white,
                            child: const ImagePlaceholder(label: 'Main image'))
                        : Image.memory(
                            addPropertyController.imageFile.value!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: addPropertyController.pickImage2,
                      child: Container(
                        color: TColors.white,
                        width: 100,
                        height: 100,
                        //color: Colors.grey[300],
                        child: const Icon(Icons.add),
                      ),
                    ),
                    // Obx(
                    //   () =>
                    Expanded(
                      child: SizedBox(
                        height: 110,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: addPropertyController.imageFiles.length,
                          itemBuilder: (context, index) {
                            Uint8List imageData =
                                addPropertyController.imageFiles[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.memory(
                                imageData,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    //),
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                const SelectCategory(),
                const SizedBox(
                  height: 16.0,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: TColors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    controller: addPropertyController.productName,
                    decoration:
                        const InputDecoration(labelText: 'Product Name'),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: TColors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                      controller: addPropertyController.productDescription,
                      decoration: const InputDecoration(
                          labelText: 'Product Description'),
                      maxLines: null,
                      keyboardType: TextInputType.multiline),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: TColors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    controller: addPropertyController.productPrice,
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () => addPropertyController.saveProduct(
                      productCategory.selectedCategory.value!,
                    ),
                    child: const Text(
                      'Add Product',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SelectCategory extends StatelessWidget {
  const SelectCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(ProductCategoryController());
    return Obx(() {
      if (categoryController.allCategories.isEmpty) {
        return const Center(
          child: Text('No categories available.'),
        );
      } else {
        return Container(
          decoration: BoxDecoration(
              color: TColors.white, borderRadius: BorderRadius.circular(15)),
          child: DropdownButtonFormField<ProductCategoryModel>(
              decoration: const InputDecoration(labelText: 'Select Category'),
              value: categoryController.selectedCategory.value != null &&
                      categoryController.allCategories
                          .contains(categoryController.selectedCategory.value)
                  ? categoryController.selectedCategory.value
                  : null,
              items: categoryController.allCategories
                  .map(
                    (option) => DropdownMenuItem<ProductCategoryModel>(
                      value: option,
                      child: Text(option.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                categoryController.selectedCategory(value!);
              }),
        );
      }
    });
  }
}
