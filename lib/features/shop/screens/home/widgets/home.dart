import 'package:agriaccess/common/primary_curved_widget/primary_curved_widget.dart';
import 'package:agriaccess/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:agriaccess/common/widgets/texts/section_heading.dart';
import 'package:agriaccess/controllers/product_controller/product_controller.dart';
import 'package:agriaccess/screens/products/products_more.dart';
import 'package:agriaccess/utils/constants/image_strings.dart';
import 'package:agriaccess/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/post_card/post_card.dart';
import '../../../../../common/widgets/products_cards/vertical_product_card.dart';
import '../../../../../controllers/post_controller/post_controller.dart';
import '../../../../../controllers/user_controller/user_controller.dart';
import '../../../../../models/category_model/category_model.dart';
import '../../../../../models/product_model/product_model.dart';
import '../../../../../models/user_model/user_model.dart';
import '../../../../../navigation_menus/admin/screens/add_faqs.dart';
import '../../../../../screens/filter_posts/filter_posts.dart';
import '../../../../authentication/controllers/onboarding/category_controller/category_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());

    final categoryController = Get.put(CategoryController());

    final postController = Get.put(PostController());

    final productController = Get.put(ProductController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        centerTitle: false,
        title: const Text(
          'AgriAccess',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        actions: [
          Obx(
            () {
              if (userController.user.value == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final user = userController.user.value;
              categoryController.fetchCategroryData(user!.role);
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: const Icon(
                  //     Icons.notifications,
                  //     color: Colors.white,
                  //     size: 30,
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: user.profilePic.isNotEmpty
                          ? NetworkImage(user.profilePic)
                          : const AssetImage(TImages.defaultPic),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryCurvedWidget(
              child: Column(
                children: [
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TSearchContainer(
                          onTap: () => Get.to(() => const ESearchScreen()),
                          text: 'Search products',
                          icon: Iconsax.search_normal,
                        ),
                      ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(100)),
                      //   child: Center(
                      //     child: IconButton(
                      //       onPressed: _refreshPosts,
                      //       icon: const Icon(
                      //         Iconsax.refresh,
                      //         color: Colors.green,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(
                    height: 3,
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
                                      title: 'Products',
                                      showActionsButton: true,
                                      textColor: Colors.black,
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
                                                horizontal: 4.0),
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
            Obx(
              () => postController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : postController.errorMessage.value.isNotEmpty
                      ? Center(child: Text(postController.errorMessage.value))
                      : postController.posts.isEmpty
                          ? const Center(child: Text("No Posts available"))
                          : Column(
                              children:
                                  postController.posts.map((postWithUser) {
                                return PostCard(post: postWithUser);
                              }).toList(),
                            ),
            )
          ],
        ),
      ),
      floatingActionButton: FutureBuilder<UserModel>(
          future: userController.fetchUserRecord(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return const SizedBox();
            }
            if (!snapshot.hasData) {
              return const SizedBox();
            }

            final user = snapshot.data!;

            return FutureBuilder<CategoryModel>(
              future: categoryController.fetchCategroryData(user.role),
              builder: (context, categorySnapshot) {
                if (categorySnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (categorySnapshot.hasError) {
                  return Center(
                      child: Text("Error: ${categorySnapshot.error}"));
                }
                if (!categorySnapshot.hasData) {
                  return const Center(child: Text("Category not found"));
                }
                final roleName = categorySnapshot.data!;
                return roleName.name == 'Admin'
                    ? FloatingActionButton(
                        onPressed: () {
                          // if (roleName.name == "Admin") {
                          // Navigate to add product screen
                          Get.to(() => const AddFAQScreen());
                        },
                        backgroundColor: Colors.green[600],
                        child: const Text(
                          "Add Faqs",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : const SizedBox.shrink();
              },
            );
          }),
    );
  }
}
