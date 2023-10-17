import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:ecommerce_app/products/product_widget.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: DynamicHeightGridView(
              // mainAxisSpacing: 12,
              // crossAxisSpacing: 12,
              builder: (context, index) {
                return const ProductWidget();
              },
              itemCount: 7,
              crossAxisCount: 2,
            ),
          ),
        ],
      ),
    );
  }
}
