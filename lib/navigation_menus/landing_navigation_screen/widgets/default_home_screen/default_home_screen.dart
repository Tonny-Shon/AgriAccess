import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../controllers/post_controller/post_controller.dart';
import '../../../../common/post_card/post_card.dart';
import '../../../../common/primary_curved_widget/primary_curved_widget.dart';
import '../../../../common/widgets/custom_shapes/containers/search_container.dart';
import '../../../../common/widgets/products_cards/vertical_product_card.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../controllers/product_controller/product_controller.dart';
import '../../../../models/post_user_model/post_user_model.dart';
import '../../../../models/product_model/product_model.dart';
import '../../../../screens/filter_posts/filter_posts.dart';
import '../../../../screens/products/products_more.dart';
import '../../../../utils/constants/sizes.dart';

class DefaultHomeScreen extends StatelessWidget {
  const DefaultHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postController = Get.put(PostController());
    final productController = Get.put(ProductController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        centerTitle: false,
        title: const Text(
          'AgriAccess',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryCurvedWidget(
              child: Column(
                children: [
                  TSearchContainer(
                    onTap: () => Get.to(() => const ESearchScreen()),
                    text: 'Search products',
                    icon: Iconsax.search_normal,
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections / 3,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: TSizes.defaultSpace),
                    child: Column(
                      children: [
                        //THomeCategories()
                        FutureBuilder<List<ProductModel>>(
                          future: productController.fetchAllProducts(),
                          builder: (context, productSnapshot) {
                            if (productSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (productSnapshot.hasError) {
                              return Center(
                                  child:
                                      Text("Error: ${productSnapshot.error}"));
                            }
                            if (!productSnapshot.hasData ||
                                productSnapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text("No products available"));
                            }

                            final products = productSnapshot.data!;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 250,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TSectionHeading(
                                      title: 'Popular crops',
                                      showActionsButton: true,
                                      textColor: Colors.white,
                                      onPressed: () =>
                                          Get.to(() => const ProductsMore()),
                                    ),
                                    const SizedBox(height: 0.0),
                                    SizedBox(
                                      height: 200,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: products.length,
                                        itemBuilder: (_, index) {
                                          final product = products[index];
                                          return Container(
                                            width: 150,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: TProductCardVertical(
                                              product: product,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<PostUserModel>>(
                future: postController.fetchPostWithUserDetails1(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No posts available"));
                  }

                  final postWithUserDetails = snapshot.data!;

                  // Set a fixed height for the list if needed, or wrap it in another SingleChildScrollView
                  return ListView.builder(
                    shrinkWrap: true, // Important to allow list to wrap content
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: postWithUserDetails.length,
                    itemBuilder: (context, index) {
                      final postWithUser = postWithUserDetails[index];
                      return PostCard(
                        post: postWithUser,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
