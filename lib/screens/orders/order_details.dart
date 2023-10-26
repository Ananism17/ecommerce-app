import 'dart:convert';

import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/constants/app_constants.dart';
import 'package:ecommerce_app/providers/theme_provider.dart';
import 'package:ecommerce_app/providers/token_provider.dart';
import 'package:ecommerce_app/screens/orders/order_tracker.dart';
import 'package:ecommerce_app/services/currency_formatter.dart';
import 'package:ecommerce_app/services/date_formatter.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key, required this.id});

  final int id;

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  late Future<dynamic> fetchData;
  dynamic orderDetails = {};

  bool dataFetched = false;

  @override
  void initState() {
    super.initState();
    fetchData = fetchOrderDetails();
    fetchData.then((data) {
      setState(() {
        orderDetails = data;
        dataFetched = true;
      });
    });
  }

  Future<dynamic> fetchOrderDetails() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    String token = tokenProvider.getAccessToken;
    final url =
        Uri.parse('${AppConstants.baseUrl}api/v1/show-order/${widget.id}');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final jsonResponse = json.decode(response.body);

    final status = jsonResponse['status'];

    if (status) {
      final data = jsonResponse['orderDetails'];
      return data;
    } else {
      print(jsonResponse);
    }
    return [];
  }

  void _openTrackerOverlay() {
    showModalBottomSheet(
      // isScrollControlled: true,
      context: context,
      builder: (ctx) => const OrderTracker(),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              title: const TitleText(
                label: "Order Details",
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buroLogoGreen,
                              ),
                              onPressed: () {},
                              child: const Text("Receive Product"),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buroLogoOrange,
                                foregroundColor: Colors.black,
                              ),
                              onPressed: _openTrackerOverlay,
                              child: const Text("Track Order"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const TitleText(label: "Order Information"),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 5,
                        color: themeProvider.getIsDarkTheme
                            ? const Color.fromARGB(255, 3, 51, 90)
                            : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 2,
                                    child: TitleText(
                                      label: "Order No.:",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: TitleText(
                                      label: orderDetails
                                              .containsKey('order_number')
                                          ? orderDetails['order_number']
                                          : '',
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 2,
                                    child: TitleText(
                                      label: "Date:",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: TitleText(
                                      label: orderDetails
                                              .containsKey('created_at')
                                          ? formattedDateWidget(
                                              formatDate:
                                                  orderDetails['created_at'])
                                          : '',
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 2,
                                    child: TitleText(
                                      label: "Customer ID:",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: TitleText(
                                      label: orderDetails
                                              .containsKey('customer_id')
                                          ? orderDetails['customer_id']
                                          : '',
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 2,
                                    child: TitleText(
                                      label: "Address:",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: TitleText(
                                      label: orderDetails
                                              .containsKey('shipping_address')
                                          ? orderDetails['shipping_address']
                                          : '',
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const TitleText(label: "Shipping Information"),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 5,
                        color: themeProvider.getIsDarkTheme
                            ? const Color.fromARGB(255, 3, 51, 90)
                            : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 2,
                                    child: TitleText(
                                      label: "Name:",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: TitleText(
                                      label: orderDetails
                                              .containsKey('shipping_name')
                                          ? orderDetails['shipping_name']
                                          : '',
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 2,
                                    child: TitleText(
                                      label: "Email:",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: TitleText(
                                      label: orderDetails
                                              .containsKey('shipping_email')
                                          ? orderDetails['shipping_email']
                                          : '',
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 2,
                                    child: TitleText(
                                      label: "Phone:",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: TitleText(
                                      label: orderDetails
                                              .containsKey('shipping_phone')
                                          ? orderDetails['shipping_phone']
                                          : '',
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 2,
                                    child: TitleText(
                                      label: "Address:",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: TitleText(
                                      label: orderDetails
                                              .containsKey('shipping_address')
                                          ? orderDetails['shipping_address']
                                          : '',
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 2,
                                    child: TitleText(
                                      label: "Center:",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: TitleText(
                                      label: orderDetails['center']
                                              ?['center_name'] ??
                                          'N/A',
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const TitleText(label: "Payment Information"),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 5,
                        color: themeProvider.getIsDarkTheme
                            ? const Color.fromARGB(255, 3, 51, 90)
                            : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 2,
                                    child: TitleText(
                                      label: "Payment Status:",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: TitleText(
                                      label: orderDetails
                                              .containsKey('payment_status')
                                          ? orderDetails['payment_status']
                                          : '',
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 2,
                                    child: TitleText(
                                      label: "Payable Amount:",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: TitleText(
                                      label: orderDetails
                                              .containsKey('total_amount')
                                          ? "TK. ${formatCurrency(orderDetails['total_amount'].toDouble())}"
                                          : '',
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const TitleText(label: "Product Information"),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 5,
                        color: themeProvider.getIsDarkTheme
                            ? const Color.fromARGB(255, 3, 51, 90)
                            : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Image.network(
                                        "${AppConstants.baseUrl}storage/galleries/${orderDetails['order_items']?[0]['image']}"),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TitleText(
                                            label: orderDetails
                                                    .containsKey('order_items')
                                                ? orderDetails['order_items'][0]
                                                    ['name']
                                                : '',
                                            fontSize: 16,
                                            maxLines: 3,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TitleText(
                                            label: orderDetails
                                                    .containsKey('order_items')
                                                ? "TK. ${formatCurrency(orderDetails['order_items']?[0]['item_price'].toDouble())}"
                                                : '',
                                            fontSize: 16,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TitleText(
                                            label: orderDetails
                                                    .containsKey('order_items')
                                                ? "Quantity: ${orderDetails['order_items'][0]['qty']}"
                                                : '',
                                            fontSize: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
