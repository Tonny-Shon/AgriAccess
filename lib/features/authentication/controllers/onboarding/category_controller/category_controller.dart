import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../../../models/category_model/category_model.dart';
import '../../../../../repositories/category_repository/category_repository.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  final CategoryRepository _categoryRepository = Get.put(CategoryRepository());
  final isLoading = true.obs;

  final RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  Rx<CategoryModel?> catId = CategoryModel.empty().obs;
  final Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);
  final selectedCategories = <CategoryModel>[].obs;
  var categoryCache = <String, String>{}.obs; // Cache for category names

  final category = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final categories = await _categoryRepository.getAllCategories();
      allCategories.assignAll(categories);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle selection of a category
  void toggleCategorySelection(CategoryModel category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
  }

  Future<String> getFarmerCategoryId() async {
    try {
      isLoading.value = true;
      return _categoryRepository.getFarmerCategoryId();
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return '';
    } finally {
      isLoading.value = false;
    }
  }

  Future<CategoryModel> fetchCategroryData(String categoryId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('Categories')
          .doc(categoryId)
          .get();

      return CategoryModel.fromSnapshot(doc);
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return CategoryModel.empty();
    }
  }

  /// Fetch category from Firestore or return from cache
  Future<String> getCategoryName(String categoryId) async {
    if (categoryCache.containsKey(categoryId)) {
      return categoryCache[categoryId]!; // Return cached category
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('Categories')
          .doc(categoryId)
          .get();

      if (doc.exists) {
        final category = CategoryModel.fromSnapshot(doc);
        categoryCache[categoryId] = category.name; // Store in cache
        return category.name;
      } else {
        return "Unknown";
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return "Unknown";
    }
  }

  Future<String> fetchUserCategroryData(String categoryId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Categories')
          .doc(categoryId)
          .get();
      return 'Category';
      // return CategoryModel.fromSnapshot(doc.);
    } catch (e) {
      Get.snackbar('Error', e.toString());
      //return CategoryModel.empty();
      return 'Unknown Category';
    }
  }
}
