import 'dart:convert';

import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/constants/app_constants.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/providers/theme_provider.dart';
import 'package:ecommerce_app/screens/login_screen.dart';
import 'package:ecommerce_app/screens/products/category_widget.dart';
import 'package:ecommerce_app/screens/products/latest_arrival.dart';
import 'package:ecommerce_app/screens/products/product_list.dart';
import 'package:ecommerce_app/providers/token_provider.dart';
import 'package:ecommerce_app/services/assets_manager.dart';
// import 'package:ecommerce_app/widgets/app_name_text.dart';
import 'package:ecommerce_app/widgets/subtitle_text.dart';
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
              final int type = item['category_id'] as int;
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
                type: type,
              );
            }).toList();

            categoryProducts['category_$i'] = products;
          }
        }

        return categoryProducts;
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => const LoginScreen(),
        ),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final themeProvider = Provider.of<ThemeProvider>(context);

    return loadProductList
        ? WillPopScope(
            onWillPop: () async {
              _navigateToSpecificPage();
              return false;
            },
            child: Scaffold(
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
                elevation: 5,
              ),
              body: ProductList(category: categoryUrl),
            ),
          )
        : WillPopScope(
            onWillPop: () async {
              bool exit = await _showExitConfirmationDialog(context) ?? false;
              return exit;
            },
            child: Scaffold(
                appBar: AppBar(
                  // leading: Padding(
                  //   padding: const EdgeInsets.all(4.0),
                  //   child: themeProvider.getIsDarkTheme
                  //       ? Image.asset(AssetManager.logoWhiteImagePath)
                  //       : Image.asset(AssetManager.logoImagePath),
                  // ),
                  title: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      AssetManager.fairImagePath,
                      fit: BoxFit.fill,
                    ),
                  ),
                  // actions: [
                  //   Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: themeProvider.getIsDarkTheme
                  //         ? Image.asset(AssetManager.buroWhiteImagePath)
                  //         : Image.asset(AssetManager.buroImagePath),
                  //   ),
                  // ],
                  elevation: 5,
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
                          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
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
                        children: List.generate(
                            AppConstants.categoryList.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                category =
                                    AppConstants.categoryList[index].name;
                                categoryUrl =
                                    AppConstants.categoryList[index].id;
                                loadProductList = true;
                              });
                            },
                            child: CategoryWidget(
                              image: AppConstants.categoryList[index].image,
                              imageDark:
                                  AppConstants.categoryList[index].imageDark,
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

                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: themeProvider.getIsDarkTheme
                                ? AppColors.darkScaffoldColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: themeProvider.getIsDarkTheme
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TitleText(
                                  label: "Mobiles",
                                  color: themeProvider.getIsDarkTheme
                                      ? AppColors.lightScaffoldColor
                                      : AppColors.darkScaffoldColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColors.lightScaffoldColor,
                                    elevation: 4,
                                    shadowColor: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      category = "Mobile";
                                      categoryUrl = "mobile";
                                      loadProductList = true;
                                    });
                                  },
                                  child: const SubtitleText(
                                      label: "View All",
                                      color: AppColors.darkScaffoldColor),
                                ),
                              ),
                            ],
                          ),
                        ),
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

                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: themeProvider.getIsDarkTheme
                                ? AppColors.darkScaffoldColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: themeProvider.getIsDarkTheme
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TitleText(
                                  label: "Televisions",
                                  color: themeProvider.getIsDarkTheme
                                      ? AppColors.lightScaffoldColor
                                      : AppColors.darkScaffoldColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColors.lightScaffoldColor,
                                    elevation: 4,
                                    shadowColor: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      category = "TV";
                                      categoryUrl = "tv";
                                      loadProductList = true;
                                    });
                                  },
                                  child: const SubtitleText(
                                      label: "View All",
                                      color: AppColors.darkScaffoldColor),
                                ),
                              ),
                            ],
                          ),
                        ),
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

                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: themeProvider.getIsDarkTheme
                                ? AppColors.darkScaffoldColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: themeProvider.getIsDarkTheme
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TitleText(
                                  label: "Refrigerators",
                                  color: themeProvider.getIsDarkTheme
                                      ? AppColors.lightScaffoldColor
                                      : AppColors.darkScaffoldColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColors.lightScaffoldColor,
                                    elevation: 4,
                                    shadowColor: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      category = "Refrigerator";
                                      categoryUrl = "refrigerator";
                                      loadProductList = true;
                                    });
                                  },
                                  child: const SubtitleText(
                                      label: "View All",
                                      color: AppColors.darkScaffoldColor),
                                ),
                              ),
                            ],
                          ),
                        ),
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

                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: themeProvider.getIsDarkTheme
                                ? AppColors.darkScaffoldColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: themeProvider.getIsDarkTheme
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TitleText(
                                  label: "Washing Machines",
                                  color: themeProvider.getIsDarkTheme
                                      ? AppColors.lightScaffoldColor
                                      : AppColors.darkScaffoldColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColors.lightScaffoldColor,
                                    elevation: 4,
                                    shadowColor: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      category = "Washing Machine";
                                      categoryUrl = "washing-machine";
                                      loadProductList = true;
                                    });
                                  },
                                  child: const SubtitleText(
                                      label: "View All",
                                      color: AppColors.darkScaffoldColor),
                                ),
                              ),
                            ],
                          ),
                        ),
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

                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: themeProvider.getIsDarkTheme
                                ? AppColors.darkScaffoldColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: themeProvider.getIsDarkTheme
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TitleText(
                                  label: "Air Conditioners",
                                  color: themeProvider.getIsDarkTheme
                                      ? AppColors.lightScaffoldColor
                                      : AppColors.darkScaffoldColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColors.lightScaffoldColor,
                                    elevation: 4,
                                    shadowColor: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      category = "AC";
                                      categoryUrl = "ac";
                                      loadProductList = true;
                                    });
                                  },
                                  child: const SubtitleText(
                                      label: "View All",
                                      color: AppColors.darkScaffoldColor),
                                ),
                              ),
                            ],
                          ),
                        ),
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

                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: themeProvider.getIsDarkTheme
                                ? AppColors.darkScaffoldColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: themeProvider.getIsDarkTheme
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TitleText(
                                  label: "Microwaves",
                                  color: themeProvider.getIsDarkTheme
                                      ? AppColors.lightScaffoldColor
                                      : AppColors.darkScaffoldColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColors.lightScaffoldColor,
                                    elevation: 4,
                                    shadowColor: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      category = "Microwave";
                                      categoryUrl = "microwave";
                                      loadProductList = true;
                                    });
                                  },
                                  child: const SubtitleText(
                                      label: "View All",
                                      color: AppColors.darkScaffoldColor),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                )),
          );
  }

  void _navigateToSpecificPage() {
    setState(() {
      loadProductList = false;
    });
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
