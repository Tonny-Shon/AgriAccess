import 'package:agriaccess/controllers/product_category_controller/product_category_controller.dart';
import 'package:get/get.dart';

import '../controllers/user_controller/user_controller.dart';
import '../features/shop/controllers/image_controller/image_controller.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImageController>(() => ImageController());
    Get.lazyPut(() => UserController());
    Get.lazyPut<ProductCategoryController>(() => ProductCategoryController());
  }
}
