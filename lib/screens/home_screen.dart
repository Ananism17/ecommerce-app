import 'dart:convert';

import 'package:ecommerce_app/constants/app_constants.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/providers/theme_provider.dart';
import 'package:ecommerce_app/screens/products/category_widget.dart';
import 'package:ecommerce_app/screens/products/latest_arrival.dart';
import 'package:ecommerce_app/screens/products/product_list.dart';
import 'package:ecommerce_app/providers/token_provider.dart';
import 'package:ecommerce_app/services/assets_manager.dart';
import 'package:ecommerce_app/widgets/app_name_text.dart';
import 'package:ecommerce_app/widgets/title_text.dart';

import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loadProductList = false;

  String category = "";
  String categoryUrl = "";

  late Future<Map<String, List<Product>>?> fetchData;
  final List<Product> mobileList = <Product>[];
  final List<Product> tvList = <Product>[];
  final List<Product> refrigeratorList = <Product>[];
  final List<Product> washingMachineList = <Product>[];
  final List<Product> acList = <Product>[];
  final List<Product> microwaveList = <Product>[];

  @override
  void initState() {
    super.initState();
    fetchData = fetchProducts();
    fetchData.then((data) {
      if (data != null) {
        List<Product> productsOfFirstCategory =
            (data['category_0'] as List<Product>);
        List<Product> productsOfSecondCategory =
            (data['category_1'] as List<Product>);
        List<Product> productsOfThirdCategory =
            (data['category_2'] as List<Product>);
        List<Product> productsOfFourthCategory =
            (data['category_3'] as List<Product>);
        List<Product> productsOfFifthCategory =
            (data['category_4'] as List<Product>);
        List<Product> productsOfSixthCategory =
            (data['category_5'] as List<Product>);

        setState(() {
          mobileList.addAll(productsOfFirstCategory);
          tvList.addAll(productsOfSecondCategory);
          refrigeratorList.addAll(productsOfThirdCategory);
          washingMachineList.addAll(productsOfFourthCategory);
          acList.addAll(productsOfFifthCategory);
          microwaveList.addAll(productsOfSixthCategory);
        });
      }
    });
  }

  Future<Map<String, List<Product>>?> fetchProducts() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    String token = tokenProvider.getAccessToken;

    final url = Uri.parse('${AppConstants.baseUrl}api/v1/home');

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
      final categories = data?['categories'] as List<dynamic>?;

      if (categories != null) {
        final Map<String, List<Product>> categoryProducts = {};

        for (int i = 0; i < categories.length; i++) {
          final categoryData = categories[i]['products'] as List<dynamic>?;
          if (categoryData != null) {
            final List<Product> products = categoryData.map((item) {
              final int id = item['id'] as int;
              final String slug = item['slug'] as String;
              final String title = item['title'] as String;
              final String photo = item['photo'] as String;
              final int? stock = item['companies'][0]['pivot']['stock'] != null
                  ? (item['companies'][0]['pivot']['stock'] as int)
                  : null;
              final double? price =
                  item['companies'][0]['pivot']['price'] != null
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
              );
            }).toList();

            categoryProducts['category_$i'] = products;
          }
        }

        return categoryProducts;
      }
    } else {
      print(jsonResponse);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final themeProvider = Provider.of<ThemeProvider>(context);

    return loadProductList
        ? Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      loadProductList = false;
                    });
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_sharp,
                  ),
                ),
              ),
              title: TitleText(label: category),
            ),
            body: ProductList(category: categoryUrl),
          )
        : Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(4.0),
                child: themeProvider.getIsDarkTheme
                    ? Image.asset(AssetManager.logoWhiteImagePath)
                    : Image.asset(AssetManager.logoImagePath),
              ),
              title: const AppNameText(),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: size.height * 0.25,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Swiper(
                          autoplay: true,
                          itemCount: AppConstants.bannersImage.length,
                          itemBuilder: (context, index) {
                            return Image.asset(
                              AppConstants.bannersImage[index],
                              fit: BoxFit.fill,
                            );
                          },
                          pagination: const SwiperPagination(
                              builder: DotSwiperPaginationBuilder(
                            activeColor: Colors.red,
                            color: Colors.white,
                          )),
                          // control: const SwiperControl(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // ===========================================
                  // ============ CATEGORY SECTION =============
                  // ===========================================

                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: TitleText(label: "Categories"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    children: List.generate(AppConstants.categoryList.length,
                        (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            category = AppConstants.categoryList[index].name;
                            categoryUrl = AppConstants.categoryList[index].id;
                            loadProductList = true;
                          });
                        },
                        child: CategoryWidget(
                          image: AppConstants.categoryList[index].image,
                          imageDark: AppConstants.categoryList[index].imageDark,
                          name: AppConstants.categoryList[index].name,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // ===========================================
                  // ============= MOBILE SECTION ==============
                  // ===========================================

                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: TitleText(label: "Mobiles"),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      height: size.height * 0.14,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return LatestArrival(
                            product: mobileList[index],
                          );
                        },
                        itemCount: mobileList.length,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  // ===========================================
                  // =============== TV SECTION ================
                  // ===========================================

                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: TitleText(label: "Televisions"),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      height: size.height * 0.14,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return LatestArrival(
                            product: tvList[index],
                          );
                        },
                        itemCount: tvList.length,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  // ==============================================
                  // =========== REFRIGERATORS SECTION ============
                  // ==============================================

                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: TitleText(label: "Refrigerators"),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      height: size.height * 0.14,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return LatestArrival(
                            product: refrigeratorList[index],
                          );
                        },
                        itemCount: refrigeratorList.length,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  // =================================================
                  // ============ WASHING MACHINE SECTION ============
                  // =================================================

                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: TitleText(label: "Washing Machines"),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      height: size.height * 0.14,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return LatestArrival(
                            product: washingMachineList[index],
                          );
                        },
                        itemCount: washingMachineList.length,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  // ===========================================
                  // ============== AC SECTION =================
                  // ===========================================

                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: TitleText(label: "Air Conditioners"),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      height: size.height * 0.14,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return LatestArrival(
                            product: acList[index],
                          );
                        },
                        itemCount: acList.length,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  // ===========================================
                  // ============ MICROWAVE SECTION ============
                  // ===========================================

                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: TitleText(label: "Microwaves"),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      height: size.height * 0.14,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return LatestArrival(
                            product: microwaveList[index],
                          );
                        },
                        itemCount: microwaveList.length,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ));
  }
}
