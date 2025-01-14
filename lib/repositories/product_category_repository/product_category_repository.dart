import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../models/product_category/product_category_model.dart';

class ProductCategoryRepository extends GetxController {
  static ProductCategoryRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  var imageFile = Rx<Uint8List?>(null);

  Future<String> uploadImage(Uint8List imageData, String filename) async {
    try {
      final storageRef = _storage.ref().child('Product_Images/$filename');
      final UploadTask uploadTask = storageRef.putData(imageData);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  Future<void> saveProduct(ProductCategoryModel product) async {
    try {
      await FirebaseFirestore.instance
          .collection('ProductCategory')
          .doc(product.id)
          .set(product.toJson());
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    } on PlatformException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //Get all Categories
  Future<List<ProductCategoryModel>> getAllCategories() async {
    try {
      final snapshot = await _db.collection('ProductCategory').get();
      final list = snapshot.docs
          .map((e) => ProductCategoryModel.fromSnapshoot(e))
          .toList();
      return list;
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    } on PlatformException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //Get sub categories
  Future<List<ProductCategoryModel>> getSubCategories(String categoryId) async {
    try {
      final snapshot = await _db
          .collection('ProductCategory')
          .where('ParentId', isEqualTo: categoryId)
          .get();

      final result = snapshot.docs
          .map((e) => ProductCategoryModel.fromSnapshoot(e))
          .toList();

      return result;
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    } on PlatformException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
