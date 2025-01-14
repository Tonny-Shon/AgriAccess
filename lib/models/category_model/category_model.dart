import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String id;
  String name;

  CategoryModel({required this.id, required this.name});

  static CategoryModel empty() => CategoryModel(id: '', name: '');

  Map<String, dynamic> toJson() {
    return {
      "Name": name,
    };
  }

  factory CategoryModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data();

      return CategoryModel(id: document.id, name: data!['Name'] ?? '');
    } else {
      return CategoryModel.empty();
    }
  }
}
