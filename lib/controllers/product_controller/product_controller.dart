import 'package:agriaccess/models/product_model/product_model.dart';
import 'package:get/get.dart';

import '../../repositories/add_product_repository/add_product_repository.dart';
import '../../utils/pop_ups/loaders.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  final isLoading = false.obs;
  final productRepository = Get.put(AddProductRepository());
  RxList<ProductModel> allProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();
  }

  Future<List<ProductModel>> fetchAllProducts() async {
    try {
      isLoading.value = true;
      final products = await productRepository.getAllProducts();
      allProducts.assignAll(products);

      return allProducts;
      // searchResults.assignAll(products);
    } catch (e) {
      TLoaders.erroSnackBar(title: 'Ooops', message: e.toString());
      allProducts.clear();
      //searchResults.clear();
      return [];
    } finally {
      isLoading.value = false;
    }
  }
}
