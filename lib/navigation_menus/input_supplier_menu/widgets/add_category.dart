import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/image_placeholder/image_placeholder.dart';
import '../../../common/widgets/appbar/appbar.dart';
import '../../../controllers/product_category_controller/product_category_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class AddProductCategory extends StatelessWidget {
  const AddProductCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final productCategoryController = Get.put(ProductCategoryController());

    return Scaffold(
      backgroundColor: TColors.grey,
      appBar: TAppBar(
        title: Text(
          'Add Category',
          style: Theme.of(context).textTheme.headlineMedium!.apply(
                color: TColors.white,
              ),
        ),
        showBackArrow: false,
        backgroundColor: Colors.green,
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.only(
              top: 10, left: TSizes.defaultSpace, right: TSizes.defaultSpace),
          child: SingleChildScrollView(
            child:
                // Obx(
                //   () =>
                Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 200,
                  child: InkWell(
                    onTap: productCategoryController.pickImage,
                    child: productCategoryController.imageFile.value == null
                        ? Container(
                            color: TColors.white,
                            child:
                                const ImagePlaceholder(label: 'Category image'))
                        : Image.memory(
                            productCategoryController.imageFile.value!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
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
                      controller: productCategoryController.productName,
                      decoration:
                          const InputDecoration(labelText: 'Category Name'),
                      maxLines: null,
                      keyboardType: TextInputType.multiline),
                ),
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () => productCategoryController.saveProduct(),
                    child: const Text(
                      'Add Category',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
            // ),
          ),
        ),
      ),
    );
  }
}
