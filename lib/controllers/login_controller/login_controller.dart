import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../navigation_menus/admin/admin_menu.dart';
import '../../navigation_menus/extension_officer/extension_officer_menu.dart';
import '../../navigation_menus/farmer_menu/farmer_navigation_menu.dart';
import '../../navigation_menus/input_supplier_menu/input_supplier_menu.dart';
import '../../navigation_menus/landing_navigation_screen/landing_navigation_menu.dart';
import '../../navigation_menus/production_officer/production_officer_menu.dart';
import '../../navigation_menus/research_innovation/research_innovation_officer.dart';
import '../../repositories/auth_repository/auth_repository.dart';

class LoginController extends GetxController {
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final isLoading = false.obs;
  final localStorage = GetStorage();
  final username = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginformKey = GlobalKey<FormState>();
  //final userController = Get.put(UserController());

  @override
  void onInit() {
    super.onInit();
    username.text = localStorage.read("REMEMBER_ME_NAME") ?? '';
    password.text = localStorage.read("REMEMBER_ME_PASSWORD") ?? '';
  }

  Future<void> loginuser() async {
    try {
      isLoading.value = true;
      if (!loginformKey.currentState!.validate()) return;

      if (rememberMe.value) {
        localStorage.read("REMEMBER_ME_NAME") ?? '';
        localStorage.read("REMEMBER_ME_PASSWORD") ?? '';
      }

      String? loginResult = await AuthRepository.instance
          .loginWithUsername(username.text.trim(), password.text.trim());

      if (loginResult != null) {
        // Handle login failure (e.g., incorrect credentials)
        Get.snackbar('Error', loginResult, snackPosition: SnackPosition.BOTTOM);
        return;
      }

      String? userId = GetStorage().read('loggedInUserId');

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        return;
      }

      String categoryId = userDoc['Role'];

      DocumentSnapshot categoryDoc = await FirebaseFirestore.instance
          .collection('Categories')
          .doc(categoryId)
          .get();

      if (!categoryDoc.exists) {
        return;
      }

      // Get the role from the category document
      String role = categoryDoc['Name'];

      Future.delayed(const Duration(seconds: 2), () {
// Redirect to the appropriate screen based on the user's role
        switch (role) {
          case 'Farmer':
            Get.offAll(() => const FarmerNavigationMenu());
            break;
          case 'Extension Officer':
            Get.offAll(() => const ExtensionOfficerMenu());
            break;
          case 'Input Supplier':
            Get.offAll(() => const InputSupplierMenu());
            break;
          case 'Production Officer':
            Get.offAll(() => const ProductionOfficerMenu());
            break;
          case 'Research Officer':
            Get.offAll(() => const ResearchInnovationOfficerMenu());
            break;
          case 'Admin':
            Get.offAll(() => const AdminMenu());
            break;

          default:
            Get.offAll(() => const LandingNavigationMenu());
            break;
        }
      });
      isLoading.value = false;
      //await LoggedInUser.saveSession(username.text.trim());
      //AuthRepository.instance.screenRedirect();
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
