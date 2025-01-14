// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class NetworkController extends GetxController {
//   var isConnected = true.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _checkInternetConnection();
//     _monitorInternetConnection();
//   }
//
//   void _checkInternetConnection() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     isConnected.value = connectivityResult != ConnectivityResult.none;
//   }
//
//   void _monitorInternetConnection() {
//     Connectivity().onConnectivityChanged.listen((connectivityResult) {
//       isConnected.value = connectivityResult != ConnectivityResult.none;
//       if (!isConnected.value) {
//         _showNoInternetDialog();
//       }
//     });
//   }
//
//   void _showNoInternetDialog() {
//     Get.defaultDialog(
//       title: "No Internet Connection",
//       middleText: "Please check your internet connection and try again.",
//       barrierDismissible: false,
//       actions: [
//         TextButton(
//           onPressed: () {
//             Get.back();
//             _checkInternetConnection();
//           },
//           child: const Text("Retry"),
//         ),
//       ],
//     );
//   }
// }
