import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/appbar/appbar.dart';
import '../../controllers/faq_controller/faq_controller.dart';

class FaqsScreen extends StatelessWidget {
  const FaqsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqController = Get.put(FAQController());
    return Scaffold(
      appBar: const TAppBar(
        title: Text(
          'FAQs',
          style: TextStyle(color: Colors.white),
        ),
        showBackArrow: false,
      ),
      body: Obx(
        () {
          if (faqController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (faqController.faqs.isEmpty) {
            return const Center(child: Text('No FAQs available'));
          }
          return Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 2, 8.0, 0),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: faqController.faqs.length,
              itemBuilder: (context, index) {
                final faq = faqController.faqs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  child: ExpansionTile(
                    title: Text(
                      faq.question,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 4, 4, 8),
                        child: Text(faq.answer),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
