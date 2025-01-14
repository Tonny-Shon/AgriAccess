// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../common/video_player_widget/beta_player/local_video.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../controllers/post_controller/post_controller.dart';
import '../../../../controllers/user_controller/user_controller.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/onboarding/category_controller/category_controller.dart';

class CreatePostScreen extends StatelessWidget {
  CreatePostScreen({super.key});

  final ImagePicker picker = ImagePicker();

  // late String _videoPath;
  @override
  Widget build(BuildContext context) {
    final postController = Get.put(PostController());
    final userController = Get.put(UserController());
    final categoryController = Get.put(CategoryController());

    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text(
          'Create a post',
          style: TextStyle(color: Colors.white),
        ),
        // actions: [
        //   IconButton(
        //       onPressed: () => Get.to(() =>
        //           //MyHomePage()
        //           VideoPlayerFileCustom(
        //             looping: true,
        //           )),
        //       icon: Icon(Icons.arrow_forward))
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          controller: postController.descriptionController,
                          decoration: const InputDecoration(
                            hintText: 'Write a caption...',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 7,
                        ),
                      ),
                    ),
                    //MyHomePage(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: IconButton(
                            onPressed: () =>
                                postController.selectMedia(context),
                            icon: const Icon(
                              Icons.add_a_photo,
                              size: 30,
                            ),
                          ),
                        ),
                        // Center(
                        //   child: IconButton(
                        //     onPressed: () => postController.selectImage(context),
                        //     icon: const Icon(
                        //       Icons.video_library,
                        //       size: 30,
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(width: 5),

                        // Expanded(
                        //   child: VideoPlayerFileCustom(
                        //     looping: true,
                        //     videoPath: postController.imagePath.value
                        //     //   testPath,
                        //
                        //   ),
                        // ),
                        Obx(() {
                          if (postController.isVideo.value &&
                              postController.videoPath.value.isNotEmpty) {
                            // print(
                            //     "Video Path: ${postController.videoPath.value}");
                            // print(
                            //     "Video Path: ${postController.isVideo.value}");
                            // if (postController.isVideo.value) {

                            return Expanded(
                              child: SizedBox(
                                height: 200,
                                child: LocalVideoScreen(
                                  videoUrl: postController.videoPath.value,
                                ),
                                //child:
                                // VideoPlayerFileCustom(
                                //   looping: true,
                                //   //videoPath: postController.imagePath.value,
                                //   //   testPath,
                                // ),
                              ),
                              // Container(
                              //   decoration: BoxDecoration(
                              //     image: DecorationImage(
                              //       image: MemoryImage(
                              //           postController.imagefile.value!),
                              //       fit: BoxFit.cover,
                              //       alignment: FractionalOffset.topCenter,
                              //     ),
                              //   ),
                              // ),
                              //       ),
                              // ),
                            );
                          } else if (postController.imagefile.value != null) {
                            return Expanded(
                              child: SizedBox(
                                height: 200,
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: MemoryImage(
                                            postController.imagefile.value!),
                                        fit: BoxFit.cover,
                                        alignment: FractionalOffset.topCenter,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        })
                      ],
                    ),
                    const Divider(),
                    TRoundedContainer(
                      showBorder: true,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const TSectionHeading(
                              title: 'Choose who can view the post',
                              textColor: Colors.black,
                            ),
                            const Divider(),
                            SizedBox(
                              height: 250,
                              child: ListView.builder(
                                itemCount:
                                    categoryController.allCategories.length,
                                itemBuilder: (context, index) {
                                  final category =
                                      categoryController.allCategories[index];
                                  return Obx(
                                    () => CheckboxListTile(
                                      title: Text(category.name),
                                      value: categoryController
                                          .selectedCategories
                                          .contains(category),
                                      onChanged: (isSelected) {
                                        categoryController
                                            .toggleCategorySelection(category);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      final user = userController.user.value;
                      if (user == null) {
                        return const Center(
                          child: Text('Failed to load user data'),
                        );
                      }

                      final selectedCategoryIds = categoryController
                          .selectedCategories
                          .map((category) => category.id)
                          .toList();

                      return Column(
                        children: [
                          // Show LinearProgressIndicator if loading
                          // if (postController.isLoading.value)
                          //   const LinearProgressIndicator(),

                          Obx(
                            () => ElevatedButton(
                              onPressed: () async {
                                try {
                                  if (postController.isLoading.value) {
                                    const LinearProgressIndicator();
                                  }
                                  if (postController
                                          // ignore: duplicate_ignore
                                          // ignore: deprecated_member_use
                                          .descriptionController
                                          .text
                                          .isNotEmpty &&
                                      postController.imagefile.value.isNull) {
                                    postController.isLoading.value = true;
                                    postController.postText(
                                        user.id,
                                        user.username,
                                        user.profilePic,
                                        selectedCategoryIds,
                                        false);
                                    postController.isLoading.value = false;
                                    Get.snackbar(
                                      'Success',
                                      backgroundColor: Colors.green,
                                      'Post uploaded successfully',
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  }
                                  if (postController
                                          // ignore: duplicate_ignore
                                          // ignore: deprecated_member_use
                                          .descriptionController
                                          .text
                                          .isNotEmpty &&
                                      postController.imagefile.value != null) {
                                    if (postController.isVideo.value) {
                                      postController.isLoading.value = true;
                                      postController.postImage(
                                          user.id,
                                          user.username,
                                          user.profilePic,
                                          selectedCategoryIds,
                                          true);
                                      postController.isLoading.value = false;
                                      Get.snackbar(
                                        'Success',
                                        backgroundColor: Colors.green,
                                        'Post uploaded successfully',
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    } else {
                                      postController.isLoading.value = true;
                                      postController.postImage(
                                          user.id,
                                          user.username,
                                          user.profilePic,
                                          selectedCategoryIds,
                                          false);
                                      postController.isLoading.value = false;
                                      Get.snackbar(
                                        'Success',
                                        backgroundColor: Colors.green,
                                        'Post uploaded successfully',
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    }
                                  }
                                } catch (e) {
                                  Get.snackbar('Error', e.toString());
                                } finally {
                                  postController.isLoading.value = false;
                                  postController.descriptionController.clear();
                                  postController.imagefile.value = null;
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[800],
                                side:
                                    const BorderSide(color: Colors.transparent),
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: Center(
                                  child: postController.isLoading.value
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Text(
                                          'Post',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
