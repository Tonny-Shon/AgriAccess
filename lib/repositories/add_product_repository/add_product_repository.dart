import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../models/product_model/product_model.dart';

class AddProductRepository extends GetxController {
  static AddProductRepository get instance => Get.find();

  @override
  void onInit() {
    super.onInit();
    getAllProducts();
  }

  //final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  var imageFile = Rx<Uint8List?>(null);
  var imageFile2 = Rx<Uint8List?>(null);
  var imageFile3 = Rx<Uint8List?>(null);
  var imageFile4 = Rx<Uint8List?>(null);

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

  Future<void> saveProduct(ProductModel property) async {
    try {
      await FirebaseFirestore.instance
          .collection('Products')
          .doc(property.id)
          .set(property.toJson());
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    } on PlatformException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  final _db = FirebaseFirestore.instance;

  Future<List<ProductModel>> getAllProducts() async {
    try {
      final query = await _db.collection('Products').get();
      return query.docs.map((e) => ProductModel.fromQuerySnapshot(e)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //get all the products for a specific user
  Future<List<ProductModel>> getAllProductsForUser(String userId) async {
    try {
      final query = await _db.collection('Products').get();
      return query.docs.map((e) => ProductModel.fromQuerySnapshot(e)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //get limited featured products
  Future<List<ProductModel>> getFeaturedProducts() async {
    try {
      final querySnapshot = await _db
          .collection('Products')
          .where('IsFeatured', isEqualTo: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return ProductModel.fromJson(
            doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //get limited featured products
  Future<List<ProductModel>> getAllFeaturedProducts() async {
    try {
      final querySnapshot = await _db
          .collection('Products')
          .where('IsFeatured', isEqualTo: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return ProductModel.fromJson(
            doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    } on PlatformException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception('Something went wrong. Please try again');
    }
  }

  //get products based on the brand
  Future<List<ProductModel>> featuredProductsByQuery(Query query) async {
    try {
      final querySnapshot = await query.get();
      //print('Fetched documents; ${querySnapshot.docs.length}');
      final List<ProductModel> productList = querySnapshot.docs
          .map((doc) => ProductModel.fromQuerySnapshot(doc))
          .toList();

      return productList;
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    } on PlatformException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception('Something went wrong. Please try again');
    }
  }

  Future<List<ProductModel>> getFavoriteProducts(
      List<String> productIds) async {
    try {
      final snapshot = await _db
          .collection('Products')
          .where(FieldPath.documentId, whereIn: productIds)
          .get();
      return snapshot.docs
          .map((querySnapshot) => ProductModel.fromJson(
              querySnapshot as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    } on PlatformException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception('Something went wrong. Please try again');
    }
  }

  //Get category or sub category data
  Future<List<ProductModel>> getProductsForCategory(
      {required String categoryId, int limit = -1}) async {
    QuerySnapshot productCategoryQuery = limit == -1
        ? await _db
            .collection('ProductCategory')
            .where('CategoryId', isEqualTo: categoryId)
            .get()
        : await _db
            .collection('ProductCategory')
            .where('CategoryId', isEqualTo: categoryId)
            .limit(limit)
            .get();

    //Extract productIds from the document
    List<String> productIds = productCategoryQuery.docs
        .map((doc) => doc['ProductId'] as String)
        .toList();

    //Query to get all documents where the brandIs is in the list of brandIds, FieldPath.documentId to query documents in collection
    final productsQuery = await _db
        .collection('Products')
        .where(FieldPath.documentId, whereIn: productIds)
        .get();

    //Extract brand names or other relevant data from the documents
    List<ProductModel> products = productsQuery.docs
        .map((doc) => ProductModel.fromQuerySnapshot(doc))
        .toList();

    return products;
  }

  //Get category or sub category data
  // Future<List<ProductModel>> getProductsForCategoryForUser(
  //     {required String categoryId, int limit = -1}) async {
  //   String ownerId = AuthenticationRepository.instance.authUser!.uid;
  //   QuerySnapshot productCategoryQuery = limit == -1
  //       ? await _db
  //           .collection('ProductCategory')
  //           .where('CategoryId', isEqualTo: categoryId)
  //           .get()
  //       : await _db
  //           .collection('ProductCategory')
  //           .where('CategoryId', isEqualTo: categoryId)
  //           .limit(limit)
  //           .get();

  //   //Extract productIds from the document
  //   List<String> productIds = productCategoryQuery.docs
  //       .map((doc) => doc['ProductId'] as String)
  //       .toList();

  //   //Query to get all documents where the brandIs is in the list of brandIds, FieldPath.documentId to query documents in collection
  //   final productsQuery = await _db
  //       .collection('Products')
  //       .where(FieldPath.documentId, whereIn: productIds)
  //       .where('OwnerId', isEqualTo: ownerId)
  //       .get();

  //   //Extract brand names or other relevant data from the documents
  //   List<ProductModel> products = productsQuery.docs
  //       .map((doc) => ProductModel.fromQuerySnapshot(doc))
  //       .toList();

  //   return products;
  // }

  //searching for products in the system
  Future<List<ProductModel>> searchProducts(String searchTerm) async {
    try {
      final query = _db
          .collection('Products')
          .where('name', isGreaterThanOrEqualTo: searchTerm)
          .where('name', isLessThanOrEqualTo: '$searchTerm\uf8ff')
          .get();

      final result = (await query)
          .docs
          .map((e) => ProductModel.fromQuerySnapshot(e))
          .toList();
      return result;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> fetchCategoryDetails(String categoryId) async {
    try {
      // Assuming you have a 'categories' collection
      //DocumentSnapshot categorySnapshot =
      await FirebaseFirestore.instance
          .collection('Categories')
          .doc(categoryId)
          .get();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Future<List<ProductModel>> getPropertiesByOwner() async {
  //   try {
  //     String ownerId = FirebaseAuth.instance.currentUser!.uid;
  //     QuerySnapshot snapshot = await _db
  //         .collection('Products')
  //         .where('OwnerId', isEqualTo: ownerId)
  //         .get();
  //     final result = (snapshot)
  //         .docs
  //         .map((e) => ProductModel.fromQuerySnapshot(e))
  //         .toList();
  //     return result;
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   }
  // }
}
