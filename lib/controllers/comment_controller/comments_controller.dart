import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../repositories/post_repository/post_repository.dart';

class CommentsController extends GetxController {
  static CommentsController get instance => Get.find();

  final commentEditingController = TextEditingController();
  final dataLoaded = false.obs;
  final commentLen = 0.obs;

  final postRepository = Get.put(PostRepository());


  void postComment(
      String postId, String uid, String name, String profilePic) async {
    try {
      String res = await postRepository.postComment(
          postId, commentEditingController.text, uid, name, profilePic);

      if (res == 'Success') {
        Get.snackbar('Success', res);
        commentEditingController.clear();
      } else {
        Get.snackbar('Error', res);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void fetchCommentLen(String postId) {
    try {
      //QuerySnapshot snap = await
      FirebaseFirestore.instance
          .collection('Posts')
          .doc(postId)
          .collection('Comments')
          .snapshots()
          .listen((snapshot) {
        commentLen.value = snapshot.docs.length;
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
