import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user_model/user_model.dart';
import '../../utils/logged_in_user/logged_in_user.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final deviceStorage = GetStorage();

  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).set(user.toJson());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserModel> fetchUserDetails(String userId) async {
    try {
      String? userId = deviceStorage.read('loggedInUserId');
      final documentSnapshot = await _db.collection("Users").doc(userId).get();

      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> isPhoneNumberUnique(String phoneNumber) async {
    try {
      // Query Firestore to check if the phone number already exists
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('PhoneNumber', isEqualTo: phoneNumber)
          .get();

      // If the query returns any documents, the phone number is not unique
      return querySnapshot.docs.isEmpty;
    } catch (e) {
      return false; // Assume the phone number is not unique in case of an error
    }
  }

  Future<void> updateUserDetails(UserModel updateUser) async {
    try {
      String? id = await LoggedInUser.getLoggedInUser();
      await _db.collection("Users").doc(id).update(updateUser.toJson());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> removeUserRecord(String userId) async {
    try {
      await _db.collection("Users").doc(userId).delete();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      String? userId = deviceStorage.read('loggedInUserId');
      await _db.collection("Users").doc(userId).update(json);
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
      //ELoaders.erroSnackBar(title: 'Oops', message: e.toString());
    } catch (e) {
      throw "Something went wrong. Please try again";
    }
  }

  Future<void> fetchAllUsers() async {
    try {
      QuerySnapshot snapshot = await _db.collection("Users").get();
      snapshot.docs.map((doc) {
        return UserModel.fromSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    } catch (e) {
      throw Exception(e.toString());
      //print("Error fetching users: ${e.toString()}");
    } finally {}
  }
}
