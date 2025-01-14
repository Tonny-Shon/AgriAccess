import 'package:agriaccess/common/primary_curved_widget/primary_curved_widget.dart';
import 'package:agriaccess/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:agriaccess/common/widgets/texts/section_heading.dart';
import 'package:agriaccess/controllers/product_controller/product_controller.dart';
import 'package:agriaccess/screens/products/products_more.dart';
import 'package:agriaccess/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/post_card/post_card.dart';
import '../../../../../common/widgets/products_cards/vertical_product_card.dart';
import '../../../../../controllers/post_controller/post_controller.dart';
import '../../../../../controllers/user_controller/user_controller.dart';
import '../../../../../models/category_model/category_model.dart';
import '../../../../../models/post_user_model/post_user_model.dart';
import '../../../../../models/product_model/product_model.dart';
import '../../../../../models/user_model/user_model.dart';
import '../../../../../navigation_menus/input_supplier_menu/widgets/add_product_screen.dart';
import '../../../../authentication/controllers/onboarding/category_controller/category_controller.dart';
import '../../../../authentication/screens/create_post/create_post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final userController = Get.put(UserController());
  final categoryController = Get.put(CategoryController());
  final postController = Get.put(PostController());
  final productController = Get.put(ProductController());

  late Future<UserModel> _userFuture;
  late Future<List<PostUserModel>> _postFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = userController.fetchUserRecord();
    _postFuture = _fetchPosts();
  }

  Future<List<PostUserModel>> _fetchPosts() async {
    final user = await userController.fetchUserRecord();
    return await postController.fetchPostWithUserDetails(user.role);
  }

  void _refreshPosts() {
    setState(() {
      _postFuture = _fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.message,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePic),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<UserModel>(
          future: _userFuture,
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (userSnapshot.hasError) {
              return Center(child: Text("Error: ${userSnapshot.error}"));
            }
            if (!userSnapshot.hasData || userSnapshot.data == null) {
              return const Center(child: Text("Failed to load user data"));
            }
            //final user = userSnapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  TPrimaryCurvedWidget(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: TSearchContainer(
                                text: 'Search products',
                                icon: Iconsax.search_normal,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Center(
                                child: IconButton(
                                  onPressed: _refreshPosts,
                                  icon: const Icon(
                                    Iconsax.refresh,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: TSizes.spaceBtwSections / 3,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: TSizes.defaultSpace),
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
                                        child: Text(
                                            "Error: ${productSnapshot.error}"));
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TSectionHeading(
                                            title: 'Products',
                                            showActionsButton: true,
                                            textColor: Colors.white,
                                            onPressed: () => Get.to(
                                                () => const ProductsMore()),
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
                                                  margin: const EdgeInsets
                                                      .symmetric(
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
                  const Divider(),
                  const SizedBox(height: 4.0),
                  FutureBuilder<List<PostUserModel>>(
                    future: _postFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }
                      if (!snapshot.hasData) {
                        return const Center(child: Text("No Posts available"));
                      }

                      final postWithUserDetails = snapshot.data!;
                      return Column(
                        children: postWithUserDetails.map((postWithUser) {
                          return PostCard(
                            post: postWithUser,
                          );
                        }).toList(),
                      );
                    },
                  )
                ],
              ),
            );
          }),

      floatingActionButton: FutureBuilder<UserModel>(
          future: _userFuture,
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
                return FloatingActionButton(
                  onPressed: () {
                    if (roleName.name == "Input Supplier") {
                      // Navigate to add product screen
                      Get.to(() => const AddProductScreen());
                    } else {
                      // Navigate to create post screen
                      Get.to(() => CreatePostScreen());
                    }
                  },
                  backgroundColor: Colors.green[600],
                  child: const Icon(
                    Icons.add,
                    size: 24,
                    color: Colors.white,
                  ),
                );
              },
            );
          }),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => Get.to(() => const CreatePostScreen()),
      //   backgroundColor: Colors.green[600],
      //   child: const Center(
      //     child: Icon(
      //       Icons.edit,
      //       size: 24,
      //     ),
      //   ),
      // ),
    );
    // });
  }
}
