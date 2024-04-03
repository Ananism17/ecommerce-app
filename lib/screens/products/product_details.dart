import 'dart:convert';

import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/constants/app_constants.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/providers/theme_provider.dart';
import 'package:ecommerce_app/providers/token_provider.dart';
import 'package:ecommerce_app/services/currency_formatter.dart';
import 'package:ecommerce_app/widgets/subtitle_text.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    super.key,
    required this.productSlug,
  });

  final String productSlug;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late Future<Product> fetchData;
  bool dataFetched = false;

  late final Product _product;

  final List<Specification> specifications = [];

  @override
  void initState() {
    super.initState();
    fetchData = fetchProduct();
    fetchData.then((data) {
      setState(() {
        _product = data;
      });
    });
  }

  Future<Product> fetchProduct() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    String token = tokenProvider.getAccessToken;

    final slug = widget.productSlug;
    final url = Uri.parse('${AppConstants.baseUrl}api/v1/product/$slug');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final jsonResponse = json.decode(response.body);

    final status = jsonResponse['status'];

    if (status) {
      final data = jsonResponse['product'];

      final int id = data['id'] as int;
      final String slug = data['slug'] as String;
      final String title = data['title'] as String;
      int type = 0;
      if (data['product_tpe'] == "DEVICE") {
        type = 1;
      } else {
        type = 2;
      }
      final String photo = data['photo'] as String;
      final int? stock = data['companies'][0]['pivot']['stock'] != null
          ? (data['companies'][0]['pivot']['stock'] as int)
          : null;
      final double? price = data['companies'][0]['pivot']['price'] != null
          ? (data['companies'][0]['pivot']['discount_price'] as num).toDouble()
          : null;

      for (var item in data['specifications_json']) {
        specifications.add(Specification.fromJson(item));
      }

      setState(() {
        dataFetched = true;
      });
      return Product(
        id: id,
        slug: slug,
        title: title,
        price: price ?? 0.0,
        photo: photo,
        stock: stock ?? 0,
        type: type,
      );
    }
    // print(productList);
    else {
      // print(jsonResponse);
    }
    return Product(
      id: 0,
      slug: "",
      title: "",
      price: 0.0,
      photo: "",
      stock: 0,
      type: 0,
    );
  }

  void showAddToCartAlert(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
        content: Text(
          "Product added to Cart!",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void showAlreadyInCartAlert(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
        content: Text(
          "Product already in Cart!",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void showStockOutAlert(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
        content: Text(
          "Product out of Stock!",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void showCartFullAlert(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
        content: Text(
          "You can't order multiple products!",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    List<Product> productList = cartProvider.items;

    return dataFetched
        ? Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios_sharp,
                ),
              ),
              title: const TitleText(label: "Product Details"),
              elevation: 5,
            ),
            body: Center(
              child: Column(
                children: [
                  FancyShimmerImage(
                    imageUrl:
                        "${AppConstants.baseUrl}storage/thumbnails/${_product.photo}",
                    height: size.height * 0.4,
                    width: double.infinity,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TitleText(
                                    label: _product.title,
                                    maxLines: 2,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.buroLogoGreen,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "৳ ${formatCurrency(_product.price)}",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TitleText(
                                    label:
                                        "Stock Available - ${_product.stock}",
                                    maxLines: 2,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: specifications.isNotEmpty
                                  ? specifications.length
                                  : 1,
                              itemBuilder: (context, index) {
                                if (specifications.isEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: SubtitleText(
                                            label: "",
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  final spec = specifications[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: SubtitleText(
                                            label: spec.key,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: SubtitleText(
                                            label: spec.value,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.buroLogoGreen,
                                ),
                                onPressed: () {
                                  if (cartProvider.isInCart(_product.slug)) {
                                    showAlreadyInCartAlert(context);
                                  } else if (_product.stock == 0) {
                                    showStockOutAlert(context);
                                  }
                                  // else if (productList.length == 1) {
                                  //   showCartFullAlert(context);
                                  // }
                                  else {
                                    cartProvider.addItem(_product);
                                    showAddToCartAlert(context);
                                    Navigator.pop(context);
                                  }
                                },
                                icon: cartProvider.isInCart(_product.slug)
                                    ? const Icon(Icons.check_circle)
                                    : const Icon(Icons.add_shopping_cart),
                                label: cartProvider.isInCart(_product.slug)
                                    ? const Text("Already in Cart!")
                                    : const Text("Add to Cart"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios_sharp,
                ),
              ),
              title: const TitleText(label: "Product Details"),
              elevation: 5,
            ),
            body: Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: themeProvider.getIsDarkTheme
                    ? Colors.white
                    : Colors.lightBlue,
                size: 60,
                secondRingColor: AppColors.buroLogoGreen,
                thirdRingColor: AppColors.buroLogoOrange,
              ),
            ),
          );
  }
}

class Specification {
  final String key;
  final String value;

  Specification(this.key, this.value);

  // Create a factory constructor to parse the JSON data
  factory Specification.fromJson(Map<String, dynamic> json) {
    return Specification(
      json['key'],
      json['value'],
    );
  }
}
