import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../models/category_model/category_model.dart';

class CategoryRepository extends GetxController {
  static CategoryRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  //Save categories
  Future<void> saveCategory(CategoryModel category) async {
    try {
      // Save category details to Firestore

      await FirebaseFirestore.instance
          .collection('Categories')
          .add(category.toJson());
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    } on PlatformException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final result = await _db.collection('Categories').get();
      return result.docs.map((doc) => CategoryModel.fromSnapshot(doc)).toList();
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    } on PlatformException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> getFarmerCategoryId() async {
    try {
      // Query to find the "farmer" category
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Categories')
          .where('Name', isEqualTo: 'Farmer')
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Return the first matched category's ID
        return snapshot.docs.first.id;
      } else {
        //print("Farmer category not found.");
        return "Farmer";
      }
    } catch (e) {
      //print("Error fetching farmer category: $e");
      return "Farmer";
    }
  }

  Future<CategoryModel> fetchCategoryById(String categoryId) async {
    var categorySnap = await _db.collection('Categories').doc(categoryId).get();
    return CategoryModel.fromSnapshot(
        categorySnap); // Convert snapshot to CategoryModel
  }
}
