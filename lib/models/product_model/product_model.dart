import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String id;
  double price;
  String title;
  DateTime? date;
  String thumbnail;
  bool? isAvailable;
  String? description;
  String? categoryId;
  List<String>? images;
  String ownerId;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
    this.date,
    this.images,
    this.categoryId,
    this.description,
    required this.ownerId,
  });

  static ProductModel empty() =>
      ProductModel(id: '', title: '', price: 0, thumbnail: '', ownerId: '');

  factory ProductModel.fromJson(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (data == null) {
      return ProductModel.empty();
    }

    return ProductModel(
      id: document.id,
      title: data['Title'] ?? '',
      price: double.parse((data['Price'] ?? 0.0).toString()),
      thumbnail: data['Thumbnail'] ?? '',
      categoryId: data['CategoryId'] ?? '',
      description: data['Description'] ?? '',
      ownerId: data['OwnerId'],

      //date: data['Date'] ?? null,
      images: data['Images'] != null ? List<String>.from(data['Images']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Title': title,
      'Price': price,
      'Images': images ?? [],
      'Thumbnail': thumbnail,
      'CategoryId': categoryId,
      'Description': description,
      'OwnerId': ownerId,
    };
  }

  // Map JSON oriented query document snapshot from Firestore to model
  factory ProductModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    return ProductModel(
      id: document.id,
      title: data['Title'] ?? '',
      ownerId: data['OwnerId'] ?? '',
      price: double.parse((data['Price'] ?? 0.0).toString()),
      thumbnail: data['Thumbnail'] ?? '',
      categoryId: data['CategoryId'] ?? '',
      description: data['Description'] ?? '',
      images: data['Images'] != null ? List<String>.from(data['Images']) : [],
    );
  }
}
