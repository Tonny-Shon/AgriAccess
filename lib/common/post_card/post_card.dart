import 'package:agriaccess/controllers/post_controller/post_controller.dart';
import 'package:agriaccess/controllers/user_controller/user_controller.dart';
import 'package:agriaccess/features/authentication/controllers/onboarding/category_controller/category_controller.dart';
import 'package:agriaccess/features/shop/controllers/image_controller/image_controller.dart';
import 'package:agriaccess/models/category_model/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import '../../features/authentication/screens/comment_screen/comments_screen.dart';
import '../../features/authentication/screens/login/login.dart';
import '../../models/post_user_model/post_user_model.dart';
import '../../repositories/auth_repository/auth_repository.dart';
import '../../utils/constants/image_strings.dart';
import '../video_player_widget/beta_player/network_video.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
  });

  final PostUserModel post;

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());
    final usercontroller = Get.put(UserController());
    final controller = Get.put(ImageController());
    final postcontroller = Get.put(PostController());
    final deviceStorage = GetStorage();
    final userId = deviceStorage.read('loggedInUserId');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InkWell(
                  onLongPress: () async {
                    if (userId == null) {
                      Get.snackbar(
                          backgroundColor: Colors.green[800],
                          colorText: Colors.white,
                          'Sigin error',
                          'You must be logged in to use this feature');
                      final result = await Get.to(() => const LoginScreen());
                      if (result == true) {
                        await AuthRepository.instance
                            .handleRolebasedNavigation();
                      }
                    } else {
                      final user = await usercontroller.fetchUserData(userId);
                      final category = await categoryController
                          .fetchCategroryData(user.role);
                      if (userId == post.user.id || category.name == 'Admin') {
                        postcontroller
                            .showDeleteConfirmationDialog(post.post.postId);
                        postcontroller.fetchPostWithUserDetails(post.user.role);
                      }
                    }
                  },
                  child: InkWell(
                    onTap: () async {
                      if (GetStorage().read('loggedInUserId') == null) {
                        Get.snackbar(
                            backgroundColor: Colors.green[800],
                            colorText: Colors.white,
                            'Sigin error',
                            'You must be logged in to comment on the posts');
                        final result = await Get.to(() => const LoginScreen());
                        if (result == true) {
                          await AuthRepository.instance
                              .handleRolebasedNavigation();
                          Get.to(
                            () => CommentsScreen(post: post.post),
                          );
                        }
                      } else {
                        Get.to(
                          () => CommentsScreen(post: post.post),
                        );
                      }
                    },
                    child: Card(
                      shadowColor: Colors.green,
                      color: Colors.white,
                      elevation: 10,
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundImage: post
                                          .user.profilePic.isNotEmpty
                                      ? NetworkImage(post.user.profilePic)
                                      : const AssetImage(TImages.defaultPic),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          post.user.fullname,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          DateFormat.yMMMd().format(
                                            (post.post
                                                .datePublished), // Convert Timestamp to DateTime
                                          ),
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    FutureBuilder<CategoryModel>(
                                      future: categoryController
                                          .fetchCategroryData(post.user.role),
                                      builder: (ctx, categorySnapshot) {
                                        if (categorySnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child: Text('Loading...'));
                                        }
                                        if (categorySnapshot.hasError) {
                                          return const Center(
                                              child: Text(
                                                  "Error loading category data"));
                                        }
                                        if (!categorySnapshot.hasData) {
                                          return const Center(
                                              child:
                                                  Text("Category not found"));
                                        }

                                        final postCategory =
                                            categorySnapshot.data!;

                                        return Text(
                                          postCategory.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[500]),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),

                          //const SizedBox(height: 8.0),
                          if (post.post.postUrl.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 3.0, 8, 0),
                              child: GestureDetector(
                                onTap: () {
                                  if (post.post.isVideo) {
                                    return;
                                  } else {
                                    controller
                                        .showLargeImage(post.post.postUrl);
                                  }
                                },
                                child: Container(
                                  height:
                                      250, // Set a fixed height for consistency
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: post.post.isVideo
                                      ? NetworkVideoScreen(
                                          videoUrl: post.post.postUrl,
                                        )
                                      : post.post.postUrl.isEmpty
                                          ? const SizedBox.shrink()
                                          : Image.network(
                                              post.post.postUrl,
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child; // The image has finished loading
                                                }
                                                // Show a CircularProgressIndicator while the image loads
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                        : null,
                                                  ),
                                                );
                                              },
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                // Display an error message if the image fails to load
                                                return const Center(
                                                  child: Icon(Icons.error,
                                                      color: Colors.red),
                                                );
                                              },
                                            ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 8.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ReadMoreText(
                              post.post.description,
                              trimLines: 3,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'read more',
                              trimExpandedText: ' show less',
                              moreStyle: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                              lessStyle: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ),

                          const SizedBox(height: 8.0), // Adding space here

                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                          icon: const Icon(
                                            Icons.favorite_outline,
                                            color: Colors.green,
                                          ),
                                          onPressed: () async {}),
                                      const Text(
                                        '0',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                          icon: const Icon(
                                            Icons.comment_outlined,
                                            color: Colors.green,
                                          ),
                                          onPressed: () async {
                                            if (GetStorage()
                                                    .read('loggedInUserId') ==
                                                null) {
                                              Get.snackbar(
                                                  backgroundColor:
                                                      Colors.green[800],
                                                  colorText: Colors.white,
                                                  'Sigin error',
                                                  'You must be logged in to comment on the posts');
                                              final result = await Get.to(
                                                  () => const LoginScreen());
                                              if (result == true) {
                                                await AuthRepository.instance
                                                    .handleRolebasedNavigation();
                                                Get.to(
                                                  () => CommentsScreen(
                                                      post: post.post),
                                                );
                                              }
                                            } else {
                                              Get.to(
                                                () => CommentsScreen(
                                                    post: post.post),
                                              );
                                            }
                                          }),
                                      StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('Posts')
                                              .doc(post.post.postId)
                                              .collection('Comments')
                                              .snapshots(),
                                          builder: (ctx, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Text(
                                                '0',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              );
                                            }
                                            int commentCount =
                                                snapshot.data?.docs.length ?? 0;
                                            return Text(
                                              '$commentCount',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            );
                                          })
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
