import 'dart:convert';

import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/constants/app_constants.dart';
import 'package:ecommerce_app/providers/theme_provider.dart';
import 'package:ecommerce_app/providers/token_provider.dart';
import 'package:ecommerce_app/screens/orders/order_card.dart';
import 'package:ecommerce_app/widgets/subtitle_text.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  late Future<List<dynamic>> fetchData;
  final List<dynamic> orderList = <dynamic>[];

  bool dataFetched = false;
  int currentPage = 1;
  int totalPage = 1;

  @override
  void initState() {
    super.initState();
    fetchData = fetchOrders(currentPage);
    fetchData.then((data) {
      setState(() {
        orderList.addAll(data);
      });
    });
  }

  Future<void> loadMoreData() async {
    setState(() {
      currentPage++; // Increment the page number
    });

    final newOrders = await fetchOrders(currentPage);

    setState(() {
      if (newOrders.isNotEmpty) {
        orderList.addAll(newOrders); // Add new orders to the existing list
      }
    });
  }

  Future<List<dynamic>> fetchOrders(int page) async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    String token = tokenProvider.getAccessToken;
    final url =
        Uri.parse('${AppConstants.baseUrl}api/v1/order-list?page=$page');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final jsonResponse = json.decode(response.body);

    final status = jsonResponse['status'];

    if (status) {
      final data = jsonResponse['orders'];
      setState(() {
        totalPage = data['last_page'] as int;
        dataFetched = true;
      });
      final dataArray = data?['data'] as List<dynamic>;
      return dataArray;
    } else {
      print(jsonResponse);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return dataFetched
        ? orderList.isEmpty
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
                  title: const TitleText(
                    label: "Order List",
                  ),
                  elevation: 5,
                ),
                body: const Center(
                  child: TitleText(
                    label: "List is Empty!",
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
                  title: const TitleText(
                    label: "Order List",
                  ),
                  elevation: 5,
                ),
                body: ListView.builder(
                  itemCount: orderList.length + 1,
                  itemBuilder: (context, index) {
                    if (index == orderList.length) {
                      return Column(
                        children: [
                          currentPage == totalPage
                              ? const SubtitleText(
                                  label: "All Orders loaded!",
                                )
                              : ElevatedButton(
                                  onPressed: loadMoreData,
                                  child: const Text("Load More Orders"),
                                ),
                          const SizedBox(
                            height: 20,
                          )
                        ],
                      );
                    }
                    Map<String, dynamic> order = orderList[index];
                    return OrderCard(order: order);
                  },
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
              title: const TitleText(
                label: "Order List",
              ),
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
