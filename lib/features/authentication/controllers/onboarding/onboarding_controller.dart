import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../../../navigation_menus/landing_navigation_screen/landing_navigation_menu.dart';

// ignore: camel_case_types
class onBoardingController extends GetxController {
  static onBoardingController get instance => Get.find();

  // Variables
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

//update current index when page scroll
  void updatePageIndicator(int index) {
    currentPageIndex.value = index;
  }

  //Jump to the specific dot selected page
  void dotNavigationClick(int index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }

  //update current index and jump to next page
  void nextPage() {
    if (currentPageIndex.value < 2) {
      //Go.to(LoginScreen());
      int nextPageIndex = currentPageIndex.value + 1;
      pageController.animateToPage(
        nextPageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      updatePageIndicator(nextPageIndex); // Update the current index
    } else {
      Get.offAll(const LandingNavigationMenu());
    }
  }

  //update current index and jump to the last page
  void skipPage() {
    int lastPageIndex = 2;
    pageController.animateToPage(
      lastPageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    updatePageIndicator(lastPageIndex); // Update the current index
  }
}
