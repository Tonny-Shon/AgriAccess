import 'package:agriaccess/models/faq_model/faq_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FaqRepository extends GetxController {
  final _db = FirebaseFirestore.instance;

  Future<List<FAQModel>> getAllFaqs() async {
    try {
      final query = await _db.collection('FAQs').get();
      return query.docs.map((e) => FAQModel.fromMap(e)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
