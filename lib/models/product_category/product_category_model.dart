import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCategoryModel {
  String id;
  String name;
  String image;
  String parentId;

  ProductCategoryModel({
    required this.id,
    required this.name,
    required this.image,
    this.parentId = '',
  });

  //Empty helper function
  static ProductCategoryModel empty() =>
      ProductCategoryModel(id: '', name: '', image: '');

  //conver model to json to be stored in firebase
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'Image': image,
      'ParentId': parentId,
    };
  }

  //map json oriented document snapshot from firebase to userModel
  factory ProductCategoryModel.fromSnapshoot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data();

      //map Json record to the model
      return ProductCategoryModel(
        id: document.id,
        name: data!['Name'] ?? '',
        image: data['Image'] ?? '',
        parentId: data['ParentId'] ?? '',
      );
    } else {
      return ProductCategoryModel.empty();
    }
  }
}
