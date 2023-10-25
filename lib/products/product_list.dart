import 'dart:convert';

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/constants/app_constants.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/products/product_widget.dart';
import 'package:ecommerce_app/providers/theme_provider.dart';
import 'package:ecommerce_app/providers/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class ProductList extends StatefulWidget {
  const ProductList({super.key, required this.category});

  final String category;

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late Future<List<Product>> fetchData;
  bool dataFetched = false;

  final List<Product> productList = <Product>[];

  @override
  void initState() {
    super.initState();
    fetchData = fetchProducts();
    fetchData.then((data) {
      setState(() {
        productList.addAll(data);
      });
    });
  }

  Future<List<Product>> fetchProducts() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    String token = tokenProvider.getAccessToken;

    final category = widget.category;
    final url = Uri.parse('${AppConstants.baseUrl}api/v1/category/$category');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final jsonResponse = json.decode(response.body);

    final status = jsonResponse['status'];

    if (status) {
      final data = jsonResponse['data'];
      final dataArray = data?['products']?['data'] as List<dynamic>?;
      if (dataArray != null) {
        final List<Product> products = dataArray.map((item) {
          final int id = item['id'] as int;
          final String slug = item['slug'] as String;
          final String title = item['title'] as String;
          final String photo = item['photo'] as String;
          final int? stock = item['id'] != null ? (item['id'] as int) : null;

          final double? price = item['companies'][0]['pivot']['price'] != null
          ? (item['companies'][0]['pivot']['discount_price'] as num).toDouble()
          : null;

          return Product(
            id: id,
            slug: slug,
            title: title,
            price: price ?? 0.0,
            photo: photo,
            stock: stock ?? 0,
          );
        }).toList();

        setState(() {
          dataFetched = true;
        });

        return products;
      }
      // print(productList);
    } else {
      print(jsonResponse);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return dataFetched
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: DynamicHeightGridView(
                    // mainAxisSpacing: 12,
                    // crossAxisSpacing: 12,
                    builder: (context, index) {
                      return ProductWidget(
                        product: productList[index],
                      );
                    },
                    itemCount: productList.length,
                    crossAxisCount: 2,
                  ),
                ),
              ],
            ),
          )
        : Center(
            child: LoadingAnimationWidget.discreteCircle(
              color: themeProvider.getIsDarkTheme
                  ? Colors.white
                  : Colors.lightBlue,
              size: 60,
              secondRingColor: AppColors.buroLogoGreen,
              thirdRingColor: AppColors.buroLogoOrange,
            ),
          );
  }
}
