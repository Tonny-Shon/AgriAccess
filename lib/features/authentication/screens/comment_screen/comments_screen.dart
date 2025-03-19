import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../common/video_player_widget/beta_player/network_video.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shapes/containers/comment_card/comment_card.dart';
import '../../../../common/widgets/e_circular_image/t_circular_image.dart';
import '../../../../common/widgets/images/t_round_image.dart';
import '../../../../controllers/comment_controller/comments_controller.dart';
import '../../../../controllers/post_controller/post_controller.dart';
import '../../../../controllers/user_controller/user_controller.dart';
import '../../../../models/post_model/post_model.dart';
import '../../../../models/post_user_model/post_user_model.dart';
import '../../../../models/user_model/user_model.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/shimmer_effects/t_shimmer_effect/t_shimmer_effect.dart';

class CommentsScreen extends StatelessWidget {
  final Post post;
  const CommentsScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final commentController = Get.put(CommentsController());
    final postController = Get.put(PostController());
    final userController = Get.put(UserController());

    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text(
          'Post Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 4, left: 8, right: 8, bottom: 6),
              child: FutureBuilder(
                future: userController.fetchUserData(post.uid),
                builder: (_, snapshot) {
                  final user = snapshot.data;

                  final networkImage = user?.profilePic;
                  final image =
                      (networkImage != null && networkImage.isNotEmpty)
                          ? networkImage
                          : TImages.defaultPic;
                  return Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        // => Get.to(() => ProfileScreen(
                        //       userModel: post.user,
                        //     )),

                        child: userController.imageLoading.value
                            ? const EShimmerEffect(width: 80, height: 80)
                            : TCircularImage(
                                padding: 1.0,
                                image: image,
                                width: 60,
                                height: 60,
                                //fit: BoxFit.contain,
                                isNetworkImage: true,
                              ),

                        // const ECircularImage(
                        //   image: 'assets/images/default_profile_pic.jpeg',
                        //   isNetworkImage: false,
                        // ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                user?.fullname ?? 'Unknown User',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                DateFormat.yMMMd().format(post.datePublished),
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            user?.username ?? 'Unknown User',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      )
                    ],
                  );
                },
              ),
            ),

            // const SizedBox(
            //   height: 8.0,
            // ),
            if (post.postUrl.isNotEmpty)
              Padding(
                  padding: const EdgeInsets.fromLTRB(8, 3.0, 8, 0),
                  child: Container(
                    height: 250,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: post.isVideo
                        ? NetworkVideoScreen(videoUrl: post.postUrl)
                        : CachedNetworkImage(
                            imageUrl: post.postUrl,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Center(
                              child: Icon(Icons.error, color: Colors.red),
                            ),
                          ),
                  )),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                post.description,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Posts')
                  .doc(post.postId)
                  .collection('Comments')
                  .orderBy('DatePublished', descending: true)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No Comments Available',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  );
                }

                final comments = snapshot.data!.docs;

                // Define height to avoid unbounded error
                return ListView.builder(
                  shrinkWrap: true, // Inner ListView shrinkWrap
                  itemCount: comments.length,
                  itemBuilder: (ctx, index) {
                    final commentData = comments[index].data();
                    final image = commentData['ProfilePic']?.isNotEmpty == true
                        ? commentData['ProfilePic']
                        : TImages.defaultPic;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CommentCard(
                        image: image,
                        username: commentData['Username'] ?? '',
                        commentText: commentData['Text'] ?? '',
                        datePublished: commentData['DatePublished'] != null
                            ? commentData['DatePublished'] as Timestamp
                            : Timestamp.now(),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: FutureBuilder<UserModel>(
          future: userController.fetchUserRecord(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading user data'));
            }
            final user = snapshot.data!;

            return FutureBuilder<List<PostUserModel>>(
              future: postController.fetchPostWithUserDetails(user.role),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading data'));
                }

                //final postUserData = snapshot.data!;
                final imageUrl = user.profilePic.isNotEmpty
                    ? user.profilePic
                    : TImages.defaultPic;
                // 'assets/images/default_profile_pic.jpeg';

                final isNetworkImage = user.profilePic.isNotEmpty;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: kToolbarHeight,
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: Row(
                      children: [
                        TRoundedImage(
                          width: 45,
                          height: 45,
                          isNetworkImage: isNetworkImage,
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 8),
                            child: TextField(
                              controller:
                                  commentController.commentEditingController,
                              decoration: const InputDecoration(
                                hintText: 'Comment',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => commentController.postComment(
                            post.postId,
                            post.uid,
                            user.username,
                            user.profilePic,
                          ),
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              child: const Icon(
                                Icons.send,
                                color: Colors.green,
                              )),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
