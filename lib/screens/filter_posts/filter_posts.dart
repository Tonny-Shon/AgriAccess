import 'package:agriaccess/common/post_card/post_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/appbar/appbar.dart';
import '../../controllers/post_controller/post_controller.dart';
import '../../models/post_user_model/post_user_model.dart';

class ESearchScreen extends StatelessWidget {
  const ESearchScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final postController = Get.put(PostController());
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: TextField(
          style: TextStyle(color: Colors.white),
          controller: postController.searchController,
          decoration: const InputDecoration(
            hintText: 'Search',
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
          ),
          onChanged: (value) => postController.filterPosts(value),
        ),
      ),
      body: Obx(
        () => postController.searchResults.isEmpty
            ? const Center(child: Text('No Posts Available'))
            : ListView.builder(
                itemCount: postController.searchResults.length,
                itemBuilder: (context, index) {
                  final PostUserModel postUser =
                      postController.searchResults[index];
                  return PostCard(post: postUser);
                },
              ),
      ),
    );
  }
}
