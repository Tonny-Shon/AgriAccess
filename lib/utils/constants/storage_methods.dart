import 'dart:typed_data';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods extends GetxController {
  static StorageMethods get instance => Get.find();
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final deviceStorage = GetStorage();

  // adding image to firebase storage
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    // creating location to our firebase storage
    String? userId = deviceStorage.read('loggedInUserId');
    Reference ref = _storage.ref().child(childName).child(userId!);
    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // adding image to firebase storage
  Future<String> uploadVideoToStorage(
      String childName, Uint8List file, bool isPost) async {
    // creating location to our firebase storage
    String? userId = deviceStorage.read('loggedInUserId');
    Reference ref = _storage.ref().child(childName).child(userId!);
    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadTextToStorage(
      String childName, String text, bool isPost) async {
    // Create a reference to the desired location in Firebase Cloud Storage

    String? userId = deviceStorage.read('loggedInUserId');
    Reference ref = _storage.ref().child(childName).child(userId!);
    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    // Convert the text to bytes (UTF-8 encoding) and put it in Uint8List format
    Uint8List textBytes = Uint8List.fromList(utf8.encode(text));

    // Upload the text as a file to Firebase Cloud Storage
    UploadTask uploadTask = ref.putData(textBytes);

    // Wait for the upload to complete and get the download URL
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
