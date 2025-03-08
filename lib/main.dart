import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app.dart';
import 'repositories/auth_repository/auth_repository.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // if (kIsWeb) {
  //   await Firebase.initializeApp(
  //       options: const FirebaseOptions(
//           apiKey: "AIzaSyAjIRZDoR8rVj6CJeBBXYLTR6sAE1aXM",
  //           authDomain: "agri-access-app-7f1d8.firebaseapp.com",
  //           projectId: "agri-access-app-7f1d8",
  //           storageBucket: "agri-access-app-7f1d8.appspot.com",
  //           messagingSenderId: "257128199275",
  //           appId: "1:257128199275:web:c6649b02776a0d227aed2e"));
  // } else {
  await Firebase.initializeApp(
          //options: DefaultFirebaseOptions.curretPlatform,
          )
      .then((FirebaseApp value) => Get.put((AuthRepository())));
  //}

  runApp(const App());
}
