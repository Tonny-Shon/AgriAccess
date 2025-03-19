import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/user_model/user_model.dart';
import '../../repositories/user_repository/user_repository.dart';
import '../../utils/pop_ups/loaders.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final profileLoading = false.obs;
  Rx<UserModel?> user = Rx<UserModel?>(null);
  final userRepository = Get.put(UserRepository());
  final deviceStorage = GetStorage();

  final imageLoading = false.obs;
  final hidePassword = false.obs;

  // UserModel? _userModel;

  // UserModel? get getUser => _userModel;

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchUserRecord();
  // }

  Future<UserModel> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      String userId = deviceStorage.read('loggedInUserId');
      final fetchUser = await userRepository.fetchUserDetails(userId);
      user.value = fetchUser;
      return fetchUser;
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      profileLoading.value = false;
    }
  }

  Future<void> saveUserRecord(UserModel? userCredentials) async {
    try {
      await fetchUserRecord();
      if (user.value!.id.isEmpty) {
        if (userCredentials != null) {
          final nameParts = UserModel.nameParts(userCredentials.fullname);

          final username = UserModel.generateUsername(userCredentials.fullname);

          final userPassword = hashPassword(userCredentials.password);

          final user = UserModel(
              id: userCredentials.id,
              firstname: nameParts[0],
              lastname:
                  nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
              username: username,
              password: userPassword,
              phoneNumber: userCredentials.phoneNumber,
              profilePic: userCredentials.profilePic,
              role: userCredentials.role);

          await userRepository.saveUserRecord(user);
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  uploadUserProfilePicture() async {
    try {
      // final isConnected = await NetworkManager.instance.isConnected();
      // if (!isConnected) {
      //   NetworkManager.instance.showNoConnectionDialog();
      // }
      imageLoading.value = true;
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 70,
          maxHeight: 512,
          maxWidth: 512);

      if (image != null) {
        final imageUrl =
            await userRepository.uploadImage('Users/Images/Profile', image);

        //update user image
        Map<String, dynamic> json = {'ProfilePic': imageUrl};
        await userRepository.updateSingleField(json);

        user.value!.profilePic = imageUrl;
        user.refresh();

        Get.snackbar("Success", 'Profile Picture has been updated!.');
        TLoaders.successSnackBar(
            title: "Congs", message: 'Profile Picture has been updated!.');
      }
    } catch (e) {
      //throw Exception(e.toString());
      TLoaders.erroSnackBar(title: "Oops", message: 'Something went wrong.');
    } finally {
      imageLoading.value = false;
    }
  }

  Future<UserModel> fetchUserData(String userId) async {
    try {
      // final isConnected = await NetworkManager.instance.isConnected();
      // if (!isConnected) {
      //   NetworkManager.instance.showNoConnectionDialog();
      // }
      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();
      if (doc.exists) {
        user.value = UserModel.fromSnapshot(
            doc); // Set the user data in the Rxn variable
      }
      return UserModel.fromSnapshot(doc);
    } catch (e) {
      //throw Exception(e.toString());
      TLoaders.erroSnackBar(title: 'Error', message: e.toString());
      return UserModel.empty();
    }
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password); // data being hashed
    var digest = sha256.convert(bytes); // using sha256
    return digest.toString();
  }
}
