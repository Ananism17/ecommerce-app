import 'dart:convert';

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:ecommerce_app/screens/products/product_widget.dart';
import 'package:ecommerce_app/constants/app_constants.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/providers/token_provider.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;

  final List<Product> productList = <Product>[];
  

  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  Future<void> fetchProducts() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    String token = tokenProvider.getAccessToken;

    final searchText = searchTextController.text;

    if (searchText.isEmpty) {
      setState(() {
        productList.clear();
      });
      return;
    }

    final url =
        Uri.parse('${AppConstants.baseUrl}api/v1/product/search/$searchText');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    final jsonResponse = json.decode(response.body);

    final status = jsonResponse['status'];

    if (status) {
      final dataArray = jsonResponse['products']?['data'] as List<dynamic>?;
      if (dataArray != null) {
        final List<Product> products = dataArray.map((item) {
          final int id = item['id'] as int;
          final String slug = item['slug'] as String;
          final String title = item['title'] as String;
          final int type = item['category_id'] as int;
          final String photo = item['photo'] as String;
          final int? stock = item['companies'][0]['pivot']['stock'] != null
              ? (item['companies'][0]['pivot']['stock'] as int)
              : null;

          final double? price = item['companies'][0]['pivot']['price'] != null
              ? (item['companies'][0]['pivot']['discount_price'] as num)
                  .toDouble()
              : null;

          return Product(
            id: id,
            slug: slug,
            title: title,
            price: price ?? 0.0,
            photo: photo,
            stock: stock ?? 0,
            type: type,
          );
        }).toList();

        setState(() {
          productList.clear();
          productList.addAll(products);
        });

        return;
      }
      // print(productList);
    } else {
      print(jsonResponse);
    }
    return;
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show an alert dialog when the back button is pressed
        bool exit = await _showExitConfirmationDialog(context) ?? false;
        return exit;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            leading: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.search,
              ),
            ),
            title: const TitleText(label: "Search Products"),
            elevation: 5,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: searchTextController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          searchTextController.clear();
                          productList.clear();
                          FocusScope.of(context).unfocus();
                        });
                      },
                      child: const Icon(
                        Icons.clear,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    fetchProducts();
                  },
                  onSubmitted: (value) {},
                ),
                const SizedBox(
                  height: 30,
                ),
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
          ),
        ),
      ),
    );
  }

  Future<bool?> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit?'),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('No'),
            onPressed: () {
              // Navigator.pop returns false to WillPopScope
              Navigator.pop(context, false);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Yes'),
            onPressed: () {
              // Navigator.pop returns true to WillPopScope
              Navigator.pop(context, true);
            },
          ),
        ],
      ),
    );
  }
}
