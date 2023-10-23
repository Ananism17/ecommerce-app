import 'dart:convert';

import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/constants/app_constants.dart';
import 'package:ecommerce_app/models/product.dart';
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

      final String slug = data['slug'] as String;
      final String title = data['title'] as String;
      final String photo = data['photo'] as String;
      final double? price = data['companies'][0]['pivot']['price'] != null
          ? (data['companies'][0]['pivot']['price'] as num).toDouble()
          : null;

      for (var item in data['specifications_json']) {
        specifications.add(Specification.fromJson(item));
      }

      setState(() {
        dataFetched = true;
      });
      return Product(
        slug: slug,
        title: title,
        price: price ?? 0.0,
        photo: photo,
      );
    }
    // print(productList);
    else {
      // print(jsonResponse);
    }
    return Product(
      slug: "",
      title: "",
      price: 0.0,
      photo: "",
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);

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
                                onPressed: () {},
                                icon: const Icon(Icons.add_shopping_cart),
                                label: const Text(
                                  "Add to Cart",
                                ),
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