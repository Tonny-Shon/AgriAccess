import 'dart:convert';

import 'package:agriaccess/features/authentication/screens/login/login.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../features/authentication/controllers/onboarding/category_controller/category_controller.dart';
import '../../models/category_model/category_model.dart';
import '../../models/user_model/user_model.dart';
import '../../repositories/user_repository/user_repository.dart';
import '../../utils/pop_ups/loaders.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  final _categoryController = Get.put(CategoryController());

  final selectedRole = ''.obs;
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final selectedCategory = Rx<CategoryModel?>(null);
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final username = TextEditingController();
  final phoneNumber = TextEditingController();
  final password = TextEditingController();
  final isLoading = false.obs;
  GlobalKey<FormState> signupFormkey = GlobalKey<FormState>();
  GlobalKey<FormState> signupFormkey1 = GlobalKey<FormState>();

  String hashPassword(String password) {
    var bytes = utf8.encode(password); // data being hashed
    var digest = sha256.convert(bytes); // using sha256
    return digest.toString();
  }

  Future<void> signupuser() async {
    try {
      if (!signupFormkey1.currentState!.validate()) return;
      // if (!privacyPolicy.value) {
      //   TLoaders.warningSnackBar(
      //       title: "Accept Privacy Policy",
      //       message:
      //           "In order to create an account, you must have to read and accept the privacy policy and terms of use.");
      //   return;
      // }
      isLoading.value = true;
      String selectedCategoryId =
          await _categoryController.getFarmerCategoryId();

      String hashedpassword = hashPassword(password.text.trim());
      final newUser = UserModel(
          id: UniqueKey().toString(),
          firstname: firstname.text.trim(),
          lastname: lastname.text.trim(),
          username: username.text.trim(),
          password: hashedpassword,
          phoneNumber: phoneNumber.text.trim(),
          profilePic: '',
          role: selectedCategoryId
          //selectedRole.value

          );

      final userRepository = Get.put(UserRepository());

      // Ensure it's not null

      await userRepository.saveUserRecord(newUser);

      //success message
      TLoaders.successSnackBar(
          title: 'Congratulations',
          message: 'Your account has been created! Login to continue.');

      Get.offAll(() => const LoginScreen());

      firstname.clear();
      lastname.clear();
      username.clear();
      password.clear();
      phoneNumber.clear();

      selectedRole.value = "";
      isLoading.value = false;
    } catch (e) {
      TLoaders.erroSnackBar(title: "Error", message: e.toString());
    }
  }

  //admin creating a user account
  Future<void> createUserAccount(CategoryModel category) async {
    try {
      if (!signupFormkey.currentState!.validate()) return;
      // if (!privacyPolicy.value) {
      //   TLoaders.warningSnackBar(
      //       title: "Accept Privacy Policy",
      //       message:
      //           "In order to create an account, you must have to read and accept the privacy policy and terms of use.");
      //   return;
      // }
      // String selectedCategoryId =
      //     await _categoryController.getFarmerCategoryId();
      isLoading.value = true;
      String hashedpassword = hashPassword(password.text.trim());
      final newUser = UserModel(
          id: const Uuid().v1(),
          firstname: firstname.text.trim(),
          lastname: lastname.text.trim(),
          username: username.text.trim(),
          password: hashedpassword,
          phoneNumber: phoneNumber.text.trim(),
          profilePic: '',
          role: category.id
          //selectedRole.value

          );

      final userRepository = Get.put(UserRepository());

      // Ensure it's not null

      await userRepository.saveUserRecord(newUser);

      //success message
      TLoaders.successSnackBar(
          title: 'Congratulations',
          message:
              'Your account has been successfully created! Continue to login.');

      firstname.clear();
      lastname.clear();
      username.clear();
      password.clear();
      phoneNumber.clear();

      selectedRole.value = "";
      isLoading.value = false;
    } catch (e) {
      TLoaders.erroSnackBar(title: "Error", message: e.toString());
    }
  }
}
