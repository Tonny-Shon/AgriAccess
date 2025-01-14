import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../features/authentication/controllers/onboarding/category_controller/category_controller.dart';
import '../../models/post_model/post_model.dart';
import '../../models/post_user_model/post_user_model.dart';
import '../../models/user_model/user_model.dart';
import '../../repositories/post_repository/post_repository.dart';
import '../../utils/constants/storage_methods.dart';

class PostController extends GetxController {
  static PostController get instance => Get.find();

  final postRepository = Get.put(PostRepository());
  final storageMethods = Get.put(StorageMethods());
  final categoryController = Get.put(CategoryController());
  final isLoading = false.obs;
  final commentLen = 0.obs;
  final isVideo = false.obs;
  final videoPath = ''.obs;
  final imagePath = ''.obs;
  //var posts = <PostUserModel>[].obs;
  var postUserDetailsList = <PostUserModel>[].obs;

  final descriptionController = TextEditingController();
  //Uint8List? imagefile;
  Rxn<Uint8List> imagefile = Rxn<Uint8List>();
  final _db = FirebaseFirestore.instance;

  //final posts = <Post>[].obs;

  Future<List<PostUserModel>> fetchPostWithUserDetails(
      String requiredRole) async {
    isLoading.value = true;
    postUserDetailsList.clear();
    List<PostUserModel> postUserDetails = [];
    try {
      final postSnapshots = await _db
          .collection("Posts")
          .where("CategoryIds",
              arrayContains:
                  requiredRole) // Filter posts by categoryId matching user role
          .get();
      List<Post> posts =
          postSnapshots.docs.map((doc) => Post.fromSnap(doc)).toList();

      for (var post in posts) {
        final userSnapshot = await _db.collection("Users").doc(post.uid).get();
        if (userSnapshot.exists) {
          UserModel user = UserModel.fromSnapshot(userSnapshot);

          postUserDetails.add(PostUserModel(post: post, user: user));
        }
      }
      postUserDetailsList.assignAll(postUserDetails);
      return postUserDetailsList;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  // refreshing the posts
  Future<List<PostUserModel>> refreshPosts(String requiredRole) async {
    isLoading.value = true;
    postUserDetailsList.clear();
    //List<PostUserModel> postUserDetailsList = [];
    try {
      // final postSnapshots = await _db.collection("Posts").get();
      // List<Post> posts =
      //     postSnapshots.docs.map((doc) => Post.fromSnap(doc)).toList();
      final postSnapshots = await _db
          .collection("Posts")
          .where("CategoryIds",
              arrayContains:
                  requiredRole) // Filter posts by categoryId matching user role
          .get();

      List<Post> posts =
          postSnapshots.docs.map((doc) => Post.fromSnap(doc)).toList();

      //List<PostUserModel> postUserDetailsList = [];
      for (var post in posts) {
        final userSnapshot = await _db.collection("Users").doc(post.uid).get();
        if (userSnapshot.exists) {
          UserModel user = UserModel.fromSnapshot(userSnapshot);
          // if (user.role == requiredRole) {
          //   postUserDetailsList.add(PostUserModel(post: post, user: user));
          // }
          postUserDetailsList.add(PostUserModel(post: post, user: user));
        }
      }
      return postUserDetailsList;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> fetchFarmerCategoryId() async {
    try {
      final querySnapshot = await _db
          .collection("Categories")
          .where('Name', isEqualTo: 'Farmer')
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<PostUserModel>> fetchPostWithUserDetails1() async {
    isLoading.value = true;
    List<PostUserModel> postUserDetailsList = [];
    try {
      String? farmerCategoryId = await fetchFarmerCategoryId();
      if (farmerCategoryId == null) {
        throw Exception('Farmer category ID not found');
      }
      final postSnapshots = await _db
          .collection("Posts")
          .where('CategoryIds', arrayContains: farmerCategoryId)
          .get();
      List<Post> posts =
          postSnapshots.docs.map((doc) => Post.fromSnap(doc)).toList();

      for (var post in posts) {
        final userSnapshot = await _db.collection("Users").doc(post.uid).get();
        if (userSnapshot.exists) {
          UserModel user = UserModel.fromSnapshot(userSnapshot);

          postUserDetailsList.add(PostUserModel(post: post, user: user));
        }
      }
      return postUserDetailsList;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  void postImage(String uid, String username, String profileImage,
      List<String> selectedCategories, bool isVideo) async {
    try {
      isLoading.value = true;
      await uploadImagePost(descriptionController.text, imagefile.value!, uid,
          username, profileImage, selectedCategories, isVideo);

      isLoading.value = false;
      descriptionController.text = "";
      imagefile.value = null;
      selectedCategories.clear();
      Get.snackbar("Success", "Post successful");
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void postText(String uid, String username, String profileImage,
      List<String> selectedCategories, bool isVideo) async {
    try {
      isLoading.value = true;
      await uploadTextPost(descriptionController.text, uid, username,
          profileImage, selectedCategories, isVideo);
      isLoading.value = false;
      descriptionController.text = "";
      imagefile.value = null;
      selectedCategories.clear();

      Get.snackbar("Success", "Post successful");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> uploadTextPost(String description, String uid, String username,
      String profImage, List<String> selectedCategoryIds, bool isVideo) async {
    try {
      isLoading.value = true;
      String postId = const Uuid().v1();
      DateTime datePublished = DateTime.now();
      if (selectedCategoryIds.isEmpty) {
        await categoryController.fetchCategories();
        selectedCategoryIds =
            categoryController.allCategories.map((cat) => cat.id).toList();
      }
      // final selectedCategoryIds =
      //     categoryController.selectedCategories.map((cat) => cat.id).toList();
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          likes: [],
          postId: postId,
          datePublished: datePublished,
          postUrl: '',
          profImage: profImage,
          categoryIds: selectedCategoryIds,
          isVideo: isVideo);
      postRepository.createPost(post);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
    return 'Error';
  }

  Future<String> uploadImagePost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
    List<String> selectedCategoryIds,
    bool isVideo,
  ) async {
    try {
      String postId = const Uuid().v1();
      DateTime datePublished = DateTime.now();
      String photoUrl = await storageMethods.uploadImageToStorage(
          isVideo ? 'Videos' : 'Posts', file, true);
      if (selectedCategoryIds.isEmpty) {
        await categoryController.fetchCategories();
        selectedCategoryIds =
            categoryController.allCategories.map((cat) => cat.id).toList();
      }
      // final selectedCategoryIds =
      //     categoryController.selectedCategories.map((cat) => cat.id).toList();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: datePublished,
        postUrl: photoUrl,
        profImage: profImage,
        categoryIds: selectedCategoryIds,
        isVideo: isVideo,
      );

      postRepository.createPost(post);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
    return 'Error';
  }

  selectMedia(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Select image'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Get.back();

                  var file = await pickImage(ImageSource.camera, false);
                  if (file != null) {
                    imagefile.value = file['bytes'];
                    imagePath.value = file['path'];
                    isVideo.value = false;
                  }
                  //imagefile.value = file;
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose image from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  var file = await pickImage(ImageSource.gallery, false);
                  if (file != null) {
                    imagefile.value = file['bytes'];
                    imagePath.value = file['path'];
                    isVideo.value = false;
                  }
                  //imagefile.value = file;
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose Video from Gallery'),
                onPressed: () async {
                  Get.back();
                  var filePath = await pickImage(ImageSource.gallery, true);
                  if (filePath != null) {
                    videoPath.value = filePath['path'];
                    imagefile.value = filePath['bytes'];
                    isVideo.value = true;
                  }
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () async {
                  Get.back();
                },
              )
            ],
          );
        });
  }

  pickImage(ImageSource source, bool isVideo) async {
    final imagePicker = ImagePicker();
    XFile? file;
    if (isVideo) {
      file = await imagePicker.pickVideo(source: source);
    } else {
      file = await imagePicker.pickImage(source: source);
    }

    if (file != null) {
      return {'bytes': await file.readAsBytes(), 'path': file.path};
    }
  }

  Future<int> fetchCommentLen(String postId) async {
    try {
      final snap = await postRepository.fetchCommentLen(postId);
      final length = snap.docs.length;
      commentLen.value = length;

      return length;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
    return 0;
  }

  Stream<List<Post>> getPosts(String userCategoryId) {
    try {
      return postRepository.streamPostsForCategory(userCategoryId);
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return const Stream<List<Post>>.empty();
    }
  }

  Stream<List<Post>> getDefaultPosts() {
    try {
      return postRepository.streamPosts();
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return const Stream<List<Post>>.empty();
    }
  }

//dialog for deleting a post
  void showDeleteConfirmationDialog(
    BuildContext context,
    String postId,
  ) {
    Get.defaultDialog(
      title: "Delete Post",
      middleText: "Are you sure you want to delete this post?",
      textCancel: "Cancel",
      textConfirm: "Delete",
      confirmTextColor: Colors.white,
      buttonColor: Colors.green,
      onCancel: () => Get.back(),
      onConfirm: () async {
        try {
          // Delete the post from Firebase
          await FirebaseFirestore.instance
              .collection('Posts')
              .doc(postId)
              .delete();
          Get.back(); // Close the dialog
          Get.snackbar(
            "Success",
            "Post deleted successfully.",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } catch (e) {
          Get.snackbar(
            "Error",
            "Failed to delete post: $e",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
    );
  }
}
