import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../models/user_model/user_model.dart';

class AllUsersController extends GetxController {
  static AllUsersController get instance => Get.find();

  final isLoading = false.obs;
  var users = <UserModel>[].obs;
  var roleCounts = <String, int>{}.obs;
  var categoryMap = <String, String>{}.obs;
  var categoryname = ''.obs;

  @override
  onInit() {
    super.onInit();
    fetchAllUsers();
    fetchCategories();
  }

  Future<void> fetchAllUsers() async {
    try {
      isLoading.value = true;
      FirebaseFirestore.instance.collection("Users").snapshots().listen(
          (querySnapshoot) {
        var userList = querySnapshoot.docs.map((doc) {
          return UserModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>);
        }).toList();
        users.value = userList;
        _calculateRoleCounts(userList);
        isLoading.value = false;
      }, onError: (error) {
        print("Error fetching users: $error");
        isLoading.value = false;
      });
    } catch (e) {
      Get.snackbar("Error fetching users", e.toString());
      //print("Error fetching users: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateRoleCounts(List<UserModel> userList) {
    var roleMap = <String, int>{};
    for (var user in userList) {
      roleMap[user.role] = (roleMap[user.role] ?? 0) + 1;
    }
    roleCounts.value = roleMap;
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
