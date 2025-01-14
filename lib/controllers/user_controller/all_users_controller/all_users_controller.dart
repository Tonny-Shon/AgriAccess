import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../models/user_model/user_model.dart';

class AllUsersController extends GetxController {
  static AllUsersController get instance => Get.find();

  final isLoading = false.obs;
  var users = <UserModel>[].obs;
  var categoryMap = <String, String>{}.obs;
  var categoryname = ''.obs;

  @override
  onInit() {
    super.onInit();

    fetchCategories();
  }

  Future<void> fetchAllUsers() async {
    try {
      isLoading.value = true;
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("Users").get();

      users.value = snapshot.docs.map((doc) {
        return UserModel.fromSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    } catch (e) {
      Get.snackbar("Error fetching users", e.toString());
      //print("Error fetching users: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCategories() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("Categories").get();
      categoryMap.value = {for (var doc in snapshot.docs) doc.id: doc['Name']};
      fetchAllUsers(); // Fetch users only after categories are loaded
    } catch (e) {
      Get.snackbar('Error fetching categories', e.toString());
      //print("Error fetching categories: ${e.toString()}");
    }
  }

  String getCategoryName(String categoryId) {
    categoryname.value = categoryMap[categoryId] ?? "Unknown Category";
    return categoryname.value;
  }
}
