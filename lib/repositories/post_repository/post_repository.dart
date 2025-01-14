import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../models/post_model/post_model.dart';

class PostRepository extends GetxController {
  static PostRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<void> createPost(Post post) async {
    try {
      await _db.collection('Posts').doc(post.postId).set(post.toJson());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<List<Post>> getPosts() {
    return _db.collection('Posts').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Post.fromSnap(doc)).toList();
    });
  }

  // Future<List<Post>> fetchPostsForCategory(String userCategoryId) async {
  //   final posts = await FirebaseFirestore.instance
  //       .collection('posts')
  //       .where('categoryIds', arrayContains: userCategoryId)
  //       .get();

  //   return posts.docs.map((doc) => Post.fromSnap(doc)).toList();
  // }

  Stream<List<Post>> streamPostsForCategory(String userCategoryId) {
    try {
      return _db
          .collection('Posts')
          .where('CategoryIds', arrayContains: userCategoryId)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Post.fromSnap(doc)).toList());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<List<Post>> streamPosts() {
    try {
      return _db
          .collection('Posts')
          //.where('CategoryIds', arrayContains: userCategoryId)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Post.fromSnap(doc)).toList());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  fetchCommentLen(String postId) async {
    try {
      await _db.collection('Posts').doc(postId).collection('Comments').get();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = 'Some error occured';
    try {
      if (likes.contains(uid)) {
        _db.collection('Posts').doc(postId).update({
          'Likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _db.collection('Posts').doc(postId).update({
          'Likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'Success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        _db
            .collection('Posts')
            .doc(postId)
            .collection('Comments')
            .doc(commentId)
            .set({
          'ProfilePic': profilePic,
          'Username': name,
          'Uid': uid,
          'Text': text,
          'CommentId': commentId,
          'DatePublished': DateTime.now()
        });
        res = 'Success';
      } else {
        res = "Please enter text";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _db.collection('Posts').doc(postId).delete();
      res = 'Success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
