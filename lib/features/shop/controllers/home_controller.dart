import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  // ignore: non_constant_identifier_names
  final CarouselCurrentIndex = 0.obs;

  void updatePageIndicator(index) {
    CarouselCurrentIndex.value = index;
  }
}
