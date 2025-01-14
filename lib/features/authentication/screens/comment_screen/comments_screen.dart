import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shapes/containers/comment_card/comment_card.dart';
import '../../../../common/widgets/images/t_round_image.dart';
import '../../../../controllers/comment_controller/comments_controller.dart';
import '../../../../controllers/post_controller/post_controller.dart';
import '../../../../controllers/user_controller/user_controller.dart';
import '../../../../models/post_model/post_model.dart';
import '../../../../models/post_user_model/post_user_model.dart';
import '../../../../models/user_model/user_model.dart';
import '../../../../utils/constants/image_strings.dart';

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
          'Comments',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Posts')
            .doc(post.postId)
            .collection('Comments')
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                            child: const Text(
                              'Post',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
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
