import 'package:cloud_firestore/cloud_firestore.dart';

class FAQModel {
  final String id;
  final String question;
  final String answer;

  FAQModel({
    required this.id,
    required this.question,
    required this.answer,
  });

  // Convert the model to a map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Question': question,
      'Answer': answer,
    };
  }

  static FAQModel empty() => FAQModel(id: '', question: '', answer: '');

  // Create a model from a Firestore document
  factory FAQModel.fromMap(QueryDocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    if (document.data() != null) {
      return FAQModel(
        id: document.id,
        question: data['Question'] ?? '',
        answer: data['Answer'] ?? '',
      );
    }
    return FAQModel.empty();
  }
}
