// ignore: file_names
import 'dart:typed_data';
import 'package:agriaccess/models/product_category/product_category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/product_model/product_model.dart';
import '../../repositories/add_product_repository/add_product_repository.dart';

class AddPropertyController extends GetxController {
  static AddPropertyController get instance => Get.find();
  final _dashBoardRepository = Get.put(AddProductRepository());

  final isLoading = false.obs;

  //var isBooked = false.obs;
  var imageFile = Rx<Uint8List?>(null);
  var imageFiles = <Uint8List>[].obs;
  var productName = TextEditingController();
  var productPrice = TextEditingController();

  var productDescription = TextEditingController();

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

  // Future<void> updateProperty(String propertyId, bool isBooked) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('Products')
  //         .doc(propertyId)
  //         .update({
  //       'IsBooked': isBooked,
  //     });
  //     TLoaders.successSnackBar(
  //         title: 'Success', message: 'Property updated successfully!');
  //   } catch (e) {
  //     TLoaders.erroSnackBar(
  //         title: 'Error', message: 'Failed to update property.');
  //   }
  // }

  Future<void> pickImage2() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        //imageFile2.value = await image.readAsBytes();
        Uint8List imageData = await image.readAsBytes();
        imageFiles.add(imageData);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  Future<void> saveProduct(ProductCategoryModel selectedCategory) async {
    if (productName.text.isEmpty ||
        productPrice.text.isEmpty ||
        productDescription.text.isEmpty ||
        imageFile.value == null) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }
    isLoading.value = true;

    try {
      String userId = GetStorage().read('loggedInUserId');

      final productId =
          FirebaseFirestore.instance.collection('Products').doc().id;
      var images = await _uploadImages();
      var thumbNail = await _uploadMainImage();
      var productData = ProductModel(
        id: productId,
        title: productName.text,
        description: productDescription.text,
        // isBooked: isBooked.value,
        categoryId: selectedCategory.id,
        images: images,
        ownerId: userId,
        price: double.parse(productPrice.text),
        thumbnail: thumbNail,
      );

      //create productData
      await _dashBoardRepository.saveProduct(productData);

      // Save product category data
      var productCategoryData = {
        'CategoryId': selectedCategory.id,
        'ProductId': productId,
      };
      await FirebaseFirestore.instance
          .collection('ProductWithCategory')
          .add(productCategoryData);

      Get.snackbar(
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          'Success',
          'Product added successfully');
      productName.clear();
      productDescription.clear();
      productPrice.clear();
      imageFile.value = null;

      images = [];
    } catch (e) {
      Get.snackbar(
          backgroundColor: Colors.red,
          colorText: Colors.white,
          'Error',
          'Failed to add Product: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<String>> _uploadImages() async {
    // List<Uint8List?> images = [
    //   imageFile2.value,
    //   imageFile3.value,
    //   imageFile4.value
    // ];
    List<String> imageUrls = [];

    for (var image in imageFiles) {
      var imageUrl = await _dashBoardRepository.uploadImage(
          image, 'Product_Image_${DateTime.now().microsecondsSinceEpoch}.png');
      imageUrls.add(imageUrl);
    }
    return imageUrls;
  }

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
}
