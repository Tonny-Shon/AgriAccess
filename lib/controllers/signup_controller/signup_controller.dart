import 'dart:convert';

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

  final userRepository = Get.put(UserRepository());

  String hashPassword(String password) {
    var bytes = utf8.encode(password); // data being hashed
    var digest = sha256.convert(bytes); // using sha256
    return digest.toString();
  }

  Future<void> signupuser() async {
    try {
      if (!signupFormkey1.currentState!.validate()) return;

      final phoneNo = phoneNumber.text.trim();

      final isPhoneUnique =
          await UserRepository.instance.isPhoneNumberUnique(phoneNo);

      if (!isPhoneUnique) {
        TLoaders.warningSnackBar(
          title: "Phone Number Already Exists",
          message:
              "The phone number is already associated with another account.",
        );
        return;
      }
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
          phoneNumber: phoneNo,
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

      Get.back();

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

      final phoneNo = phoneNumber.text.trim();

      final isPhoneUnique =
          await UserRepository.instance.isPhoneNumberUnique(phoneNo);

      if (!isPhoneUnique) {
        TLoaders.warningSnackBar(
          title: "Phone Number Already Exists",
          message:
              "The phone number is already associated with another account.",
        );
        return;
      }

      isLoading.value = true;
      String hashedpassword = hashPassword(password.text.trim());
      final newUser = UserModel(
          id: const Uuid().v1(),
          firstname: firstname.text.trim(),
          lastname: lastname.text.trim(),
          username: username.text.trim(),
          password: hashedpassword,
          phoneNumber: phoneNo,
          profilePic: '',
          role: category.id
          //selectedRole.value

          );

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

  Future<bool> isPhoneNumberUnique(String phoneNumber) async {
    try {
      // Access the 'users' collection in Firestore
      await userRepository.isPhoneNumberUnique(phoneNumber);

      return true;
    } catch (error) {
      throw Exception("An error occurred: $error");
    }
  }
}
