import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/faq_controller/faq_controller.dart';

class AddFAQScreen extends StatelessWidget {
  const AddFAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FAQController faqController = Get.put(FAQController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add FAQ'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: faqController.questionController,
                decoration: const InputDecoration(
                  labelText: 'Question',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: faqController.answerController,
                decoration: const InputDecoration(
                  labelText: 'Answer',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: faqController.isLoading.value
                            ? null // Disable the button when loading
                            : () async {
                                await faqController.addFAQ();
                              },
                        style: ElevatedButton.styleFrom(
                            side: const BorderSide(color: Colors.transparent),
                            backgroundColor: Colors.green[800]),
                        child: faqController.isLoading.value
                            ? const CircularProgressIndicator(
                                color:
                                    Colors.white) // Show a loader when loading
                            : const Text('Submit'),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 10,
              ),
              Obx(() => SizedBox(
                    height: 400,
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
                                  color: Colors.black),
                            ),
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8.0, 4, 4, 8),
                                child: Text(faq.answer),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
