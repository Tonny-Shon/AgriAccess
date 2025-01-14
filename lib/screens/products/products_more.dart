import 'package:agriaccess/common/widgets/appbar/appbar.dart';
import 'package:agriaccess/controllers/grid_layout/t_grid_layout.dart';
import 'package:agriaccess/controllers/product_controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/products_cards/vertical_product_card.dart';
import '../../models/product_model/product_model.dart';

class ProductsMore extends StatelessWidget {
  const ProductsMore({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.put(ProductController());
    return Scaffold(
      appBar: const TAppBar(
        title: Text(
          'All Products',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<ProductModel>>(
            future: productController.fetchAllProducts(),
            builder: (context, productSnapshot) {
              if (productSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (productSnapshot.hasError) {
                return Center(child: Text("Error: ${productSnapshot.error}"));
              }
              if (!productSnapshot.hasData || productSnapshot.data!.isEmpty) {
                return const Center(child: Text("No products available"));
              }

              final products = productSnapshot.data!;
              return TGridLayout(
                  itemCount: products.length,
                  itemBuilder: (ctx, index) {
                    return Container(
                      width: 150,
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TProductCardVertical(
                        product: products[index],
                      ),
                    );
                  });
            },
          ),
        ),
      ),
    );
  }
}
