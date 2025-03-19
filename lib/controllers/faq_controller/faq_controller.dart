import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/faq_model/faq_model.dart';
import '../../repositories/faq_repository/faq_repository.dart';
import '../../utils/pop_ups/loaders.dart';

class FAQController extends GetxController {
  final _db = FirebaseFirestore.instance;

  // Text editing controllers for the question and answer fields
  final questionController = TextEditingController();
  final answerController = TextEditingController();

  // Observable variable to track loading state
  final isLoading = false.obs;
  final faqs = <FAQModel>[].obs;
  final faqRepository = Get.put(FaqRepository());

  @override
  onInit() {
    super.onInit();
    fetchFAQs();
  }

  // Fetch FAQs from Firestore
  Future<List<FAQModel>> fetchFAQs() async {
    try {
      final querySnapshot = await faqRepository.getAllFaqs();
      faqs.assignAll(querySnapshot);
      return faqs;
    } catch (e) {
      TLoaders.erroSnackBar(
        title: 'Error',
        message: 'Failed to fetch FAQs. Please try again.',
      );
      return [];
    }
  }

  // Add a FAQ to Firestore
  Future<void> addFAQ() async {
    try {
      isLoading.value = true; // Start loading

      // Validate the input
      if (questionController.text.isEmpty || answerController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Please fill in both the question and answer.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Create a FAQModel object
      final faq = FAQModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID
        question: questionController.text.trim(),
        answer: answerController.text.trim(),
      );

      // Upload the FAQ to Firestore
      await _db.collection('FAQs').doc(faq.id).set(faq.toJson());

      // Show a success message
      TLoaders.successSnackBar(
        title: 'Success',
        message: 'FAQ added successfully!',
      );

      // Clear the text fields
      questionController.clear();
      answerController.clear();
    } catch (e) {
      TLoaders.erroSnackBar(
        title: 'Error',
        message: 'Failed to add FAQ. Please try again.',
      );
    } finally {
      isLoading.value = false; // Stop loading
    }
  }
}
