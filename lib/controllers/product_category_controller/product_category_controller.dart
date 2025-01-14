import 'dart:typed_data';

import 'package:agriaccess/repositories/add_product_repository/add_product_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/product_category/product_category_model.dart';
import '../../models/product_model/product_model.dart';
import '../../repositories/product_category_repository/product_category_repository.dart';
import '../../utils/pop_ups/loaders.dart';

class ProductCategoryController extends GetxController {
  static ProductCategoryController get instance => Get.find();

//this section is for the categories for the products
  var imageFile = Rx<Uint8List?>(null);
  var productName = TextEditingController();

  final isLoading = true.obs;
  final _productRepository = Get.put(ProductCategoryRepository());
  final _addProductRepository = Get.put(AddProductRepository());

  final RxList<ProductCategoryModel> allCategories =
      <ProductCategoryModel>[].obs;

  final Rx<ProductCategoryModel?> selectedCategory =
      Rx<ProductCategoryModel?>(null);
  final RxList<ProductCategoryModel> featuredCategories =
      <ProductCategoryModel>[].obs;
  Rx<ProductCategoryModel> catId = ProductCategoryModel.empty().obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

//Picking the category image
  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        imageFile.value = await image.readAsBytes();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  //saving the products category to the database
  Future<void> saveProduct() async {
    isLoading.value = true;

    try {
      //final ownerId = FirebaseAuth.instance.currentUser?.uid ?? '';
      final productId =
          FirebaseFirestore.instance.collection('Products').doc().id;

      var thumbNail = await _uploadMainImage();
      var productData = ProductCategoryModel(
        id: productId,
        name: productName.text,
        image: thumbNail,
      );

      //create productData
      await _productRepository.saveProduct(productData);

      Get.snackbar(
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          'Success',
          'Cateogry added successfully');
      imageFile.value = null;

      productName.clear();
    } catch (e) {
      Get.snackbar(
          backgroundColor: Colors.red,
          colorText: Colors.white,
          'Error',
          'Failed to add Category: $e');
    } finally {
      isLoading.value = false;
    }
  }

  //uploading the main image
  Future<String> _uploadMainImage() async {
    try {
      final storage = FirebaseStorage.instance;
      final storageRef = storage
          .ref()
          .child('Product_Images/${DateTime.now().microsecondsSinceEpoch}.png');
      final UploadTask uploadTask = storageRef.putData(imageFile.value!);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  //Load category data
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;

      //Fetch Categories from data source (Firestore or API)
      final categories = await _productRepository.getAllCategories();

      //update the categories list
      allCategories.assignAll(categories);

      //filter featured categories
      // featuredCategories.assignAll(allCategories
      //     .where(
      //         (category) => category.isFeatured && category.parentId.isNotEmpty)
      //     .take(8)
      //     .toList());
    } catch (e) {
      TLoaders.erroSnackBar(title: 'Ooops', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //load selected category data
  Future<List<ProductCategoryModel>> getSubCategories({
    required categoryId,
  }) async {
    try {
      final subCategories =
          await _productRepository.getSubCategories(categoryId);
      return subCategories;
    } catch (e) {
      TLoaders.erroSnackBar(title: 'Ooops', message: e.toString());
      return [];
    }
  }

  //Get category or sub category products
  Future<List<ProductModel>> getCategoryProducts({
    required categoryId,
  }) async {
    try {
      //fetch limited products against each subcategory;
      final products = await _addProductRepository.getProductsForCategory(
          categoryId: categoryId, limit: 4);
      return products;
    } catch (e) {
      TLoaders.erroSnackBar(title: 'Ooops', message: e.toString());
      return [];
    }
  }

  Future<void> fetchCategoryData(String categoryId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('ProductCategory')
          .doc(categoryId)
          .get();
      if (doc.exists) {
        catId.value = ProductCategoryModel.fromSnapshoot(
            doc); // Set the category data in the Rxn variable
      } else {
        TLoaders.erroSnackBar(
            title: 'Category Error', message: "Category not found");
      }
    } catch (e) {
      TLoaders.erroSnackBar(title: 'Error', message: e.toString());
    }
  }
}
