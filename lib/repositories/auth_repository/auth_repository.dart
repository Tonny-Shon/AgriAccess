import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../models/user_model/user_model.dart';
import '../../navigation_menus/extension_officer/extension_officer_menu.dart';
import '../../navigation_menus/farmer_menu/farmer_navigation_menu.dart';
import '../../navigation_menus/input_supplier_menu/input_supplier_menu.dart';
import '../../navigation_menus/landing_navigation_screen/landing_navigation_menu.dart';
import '../../navigation_menus/production_officer/production_officer_menu.dart';
import '../../navigation_menus/research_innovation/research_innovation_officer.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();

  final deviceStorage = GetStorage();

  @override
  void onReady() {
    //Remove the splash screen
    FlutterNativeSplash.remove();
    super.onReady();
    screenRedirect();
  }

  screenRedirect() async {
    try {
      String? userId = deviceStorage.read('loggedInUserId');
      if (userId != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .get();

        if (!userDoc.exists) {
          return "Username does not exist";
        }

        String categoryId = userDoc['Role'];

        DocumentSnapshot categoryDoc = await FirebaseFirestore.instance
            .collection('Categories')
            .doc(categoryId)
            .get();

        if (!categoryDoc.exists) {
          return "Category does not exist";
        }

        // Get the role from the category document
        String role = categoryDoc['Name'];
        //GetStorage.init(userId);
        await GetStorage.init(userId);
        //print('Role retrieved from Firestore: $role');

        // Redirect to the appropriate screen based on the user's role
        // Use a switch statement to handle role-based navigation
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
          default:
            Get.offAll(() => const LandingNavigationMenu());
            break;
        }
      } else {
        deviceStorage.writeIfNull("IsFirstTime", true);
        deviceStorage.read('IsFirstTime') != true
            ? Get.offAll(() async {
                DocumentSnapshot userDoc = await FirebaseFirestore.instance
                    .collection('Users')
                    .doc(userId)
                    .get();

                if (!userDoc.exists) {
                  return "Username does not exist";
                }

                String categoryId = userDoc['Role'];

                DocumentSnapshot categoryDoc = await FirebaseFirestore.instance
                    .collection('Categories')
                    .doc(categoryId)
                    .get();

                if (!categoryDoc.exists) {
                  return "Category does not exist";
                }
                String role = categoryDoc['Name'];

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
                  default:
                    Get.offAll(() => const LandingNavigationMenu());
                    break;
                }
              })
            : Get.offAll(() => const LandingNavigationMenu());
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  handleRolebasedNavigation() async {
    try {
      String? userId = deviceStorage.read('loggedInUserId');

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        return "Username does not exist";
      }

      String categoryId = userDoc['Role'];

      DocumentSnapshot categoryDoc = await FirebaseFirestore.instance
          .collection('Categories')
          .doc(categoryId)
          .get();

      if (!categoryDoc.exists) {
        return "Category does not exist";
      }

      // Get the role from the category document
      String role = categoryDoc['Name'];

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
        default:
          Get.offAll(() => const LandingNavigationMenu());
          break;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String?> loginWithUsername(String username, String password) async {
    try {
      // Query to fetch user by username
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection("Users")
              .where("UserName", isEqualTo: username)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first result (assuming username is unique)
        UserModel user = UserModel.fromSnapshot(querySnapshot.docs.first);

        // Hash the input password and compare with the stored hashed password
        String hashedPassword = hashPassword(password);

        if (user.password == hashedPassword) {
          // Success, password matches
          deviceStorage.write('loggedInUserId', user.id);
          return null; // No error
        } else {
          // Incorrect password
          return 'Incorrect password';
        }
      } else {
        // Username not found
        return 'Username does not exist';
      }
    } catch (e) {
      return 'Error during login: ${e.toString()}';
    }
  }

  String hashPassword(String password) {
    final bytes = utf8.encode(password); // Convert to bytes
    final digest = sha256.convert(bytes); // Hash using SHA-256
    return digest.toString(); // Return hashed password
  }
}
